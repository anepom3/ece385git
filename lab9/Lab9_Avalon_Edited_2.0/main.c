/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000100;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

/** StatePrint
	* Print the passed in state to the console in row-major order
	*
	* Inputs : unsigned int * state_in - 4 x 32bit state to be printed
	*/
void StatePrint(unsigned char * state_in) {
		printf("\n");
		printf("[%02x, %02x, %02x, %02x]\n",state_in[0],state_in[4],state_in[8],state_in[12]);
		printf("[%02x, %02x, %02x, %02x]\n",state_in[1],state_in[5],state_in[9],state_in[13]);
		printf("[%02x, %02x, %02x, %02x]\n",state_in[2],state_in[6],state_in[10],state_in[14]);
		printf("[%02x, %02x, %02x, %02x]\n\n",state_in[3],state_in[7],state_in[11],state_in[15]);
}

/** KeyExpansion
	* Takes the Cipher Key and performs a Key Expansion to generate a series
	* of Round Keys (4-Word matrix) and store them into Key Schedule.
	*
	* Input: unsigned char * key_in				 - 16 x 8bit original key
	*
	* Output: unsigned char * key_schedule - 11 4-word keys for schcedule split into 8bit chars
  */
void KeyExpansion(unsigned char * key_in, unsigned char * key_schedule) {
		unsigned int key_schedule[176]; // 11 4-word keys
		int i=0;
		unsigned char temp[4];
		unsigned char temp_sub[4];
		unsigned char temp_char;

		// First key is the original key
		for(i=0;i<16;i++) {
				key_schedule[i] = key_in[i];
		}

		// Make 10 other keys
		for(i=4;i<44;i++) { // 4-44 is the 40 words of the other 10 keys
				// set temp word
				temp[0] = key_schedule[(4*i)-16];
				temp[1] = key_schedule[(4*i)-16+1];
				temp[2] = key_schedule[(4*i)-16+2];
				temp[3] = key_schedule[(4*i)-16+3];

				if((i % 4) == 0) { // every 4th key, re-randomize
						// Rotate Word {0,1,2,3} --> {1,2,3,0}
						temp_sub[0] = temp[1];
						temp_sub[1] = temp[2];
						temp_sub[2] = temp[3];
						temp_sub[3] = temp[0];
						// Substitute bytes if words using table
						temp = SubBytes(temp_sub);
						// xor with Round-key constant
						temp[0] ^= (unsigned char)(Rcon[i/4] & 0xFF);
						temp[1] ^= (unsigned char)((Rcon[i/4] >> 8) & 0xFF);
						temp[2] ^= (unsigned char)((Rcon[i/4] >> 16) & 0xFF);
						temp[3] ^= (unsigned char)((Rcon[i/4] >> 24) & 0xFF);
				}

				key_schedule[4*i] = key_schedule[i-16] ^ temp[0];
				key_schedule[(4*i)+1] = key_schedule[i-16] ^ temp[1];
				key_schedule[(4*i)+2] = key_schedule[i-16] ^ temp[2];
				key_schedule[(4*i)+3] = key_schedule[i-16] ^ temp[3];
		}
}

/** AddRoundKey
	* A Round Key of 4-Word matrix is applied to the
	* updating State through a simple XOR operation in every round
	*
	* Input: unsigned char * state_in 	 - original 4-word state split into bytes
	*				 unsigned char * round_key	 - round key to use for operation in bytes
	*
	* Output: unsigned char * ret_state - new state after operation occurs in bytes
  */
void AddRoundKey(unsigned char * state_in, unsigned char * round_key, unsigned char * ret_state) {
		int i=0;
		for(i=0;i<16;i++) {
				ret_state[i] = state_in[i] ^ round_key[i];
		}
}

/** SubBytes
	* Each Byte of the updating State is non-linearly transformed by
	* taking the multiplicative inverse in Rijndael’s finite field
	* The process is usually simplified into applying a lookup table
	* called the Rijndael S-box (substitution box).
	*
	* Input: unsigned char * word_in 	- original word to substitute bytes for
	*
	* Output: unsigned char * ret_word - substituted bytes of word
  */
void SubBytes(unsigned char * word_in, unsigned char * word_out) {
		word_out[0] = aes_sbox[word_in[0]];
		word_out[1] = aes_sbox[word_in[1]];
		word_out[2] = aes_sbox[word_in[2]];
		word_out[3] = aes_sbox[word_in[3]];
}

/** ShiftRows
	* Each row in the updating State is shifted by some offsets
	*
	* Input: unsigned char * state_in 	 - original 4-word state in bytes
	*
	* Output: unsigned char * ret_state - new state after operation occurs in bytes
	*
	* [0, 4, 8,  12]	 			[0, 4, 8, 12]
	* [1, 5, 9,  12]	---\	[5, 9, 13, 1]
	* [2, 6, 10, 12]	---/  [10, 14, 2, 6]
	* [3, 7, 11, 12]	 			[15, 3, 7, 11]
  */
void ShiftRows(unsigned char * state_in, unsigned char * ret_state) {
		ret_state[0] = state_in[0];
		ret_state[1] = state_in[5];
		ret_state[2] = state_in[10];
		ret_state[3] = state_in[15];
		ret_state[4] = state_in[4];
		ret_state[5] = state_in[9];
		ret_state[6] = state_in[14];
		ret_state[7] = state_in[3];
		ret_state[8] = state_in[8];
		ret_state[9] = state_in[13];
		ret_state[10] = state_in[2];
		ret_state[11] = state_in[7];
		ret_state[12] = state_in[12];
		ret_state[13] = state_in[1];
		ret_state[14] = state_in[6];
		ret_state[15] = state_in[11];
}

/** MixColumns
	* Each of the four Words in the updating State undergoes separate
	* invertible linear transformations over GF such that the four Bytes
	* of each Word are linearly combined to form a new Word
	*
	* Input: unsigned char * state_in 	 - original 4-word key in bytes
	*
	* Output: unsigned char * ret_state - new state after operation occurs in bytes
	*
	* b[0] = a[0]    [1 1 1 1]		b[0] = ({2} x a[0]) + ({3} x a[1]) + 				a[2]  + 			 a[3]
	* b[1] = a[1] \/ [1 1 1 1]		b[0] =  			a[0]	+ ({2} x a[1]) + ({3} x a[2]) + 			 a[3]
	* b[2] = a[2] /\ [1 1 1 1]		b[0] =  			a[0]	+ 			 a[1]  + ({2} x a[2]) + ({3} x a[3])
	* b[3] = a[3]    [1 1 1 1]		b[0] = ({3} x a[0]) + 			 a[1]  + 				a[2]  + ({2} x a[3])
  */
void MixColumns(unsigned char * state_in) {
		int i=0;

		for(i=0;i<4;i++) {

		}
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
		// Implement this function
		int i=0;
		unsigned char msg_bytes[16];
		unsigned char key_bytes[16];
		unsinged char key_schedule[176]; // key-schedule
		unsigned char temp_round_key = key_bytes; // round key to add
		unsigned char msg_state_in[16] = msg_bytes; // state of message to pass into helper functions
		unsigned char msg_state_out[16]; // state of message that is returned from functions
		unsigned char temp_sub_word_in[4]; // temp holder for words of state for input of SubBytes
		unsigned char temp_sub_word_out[4]; // temp holder for words of state for output of SubBytes

		// Convert input message and key into hex
		for(i=0;i<16;i++) {
				msg_bytes[i] = charsToHex(msg_ascii[2*i], msg_ascii[(2*i)+1]);
				key_bytes[i] = charsToHex(msg_ascii[2*i], key_ascii[(2*i)+1]);
		}
		printf("Input Msg (Row-Major Order):");
		StatePrint(msg_bytes);
		printf("Input Key (Row-Major Order):");
		StatePrint(key_bytes);

		// TO-DO : Fill in the actual algorithm after unit testing each helper function
		// Add original key
		AddRoundKey(msg_state_in, temp_round_key, msg_state_out);
		msg_state_in = msg_state_out;

		for(i=1;i<10;i++) { // 9 rounds (keys 2-10)
				// set next round key
				temp_round_key = {key_schedule[(16*i)+1],key_schedule[(16*i)+1],key_schedule[(16*i)+1],key_schedule[(16*i)+1],
													key_schedule[(16*i)+1],key_schedule[(16*i)+1],key_schedule[(16*i)+1],key_schedule[(16*i)+1],
													key_schedule[(16*i)+1],key_schedule[(16*i)+1],key_schedule[(16*i)+1],key_schedule[(16*i)+1],
													key_schedule[(16*i)+1],key_schedule[(16*i)+1],key_schedule[(16*i)+1],key_schedule[(16*i)+1],
													};

				// SubBytes
				for(j=0;j<4;j++) {
						temp_sub_word_in = {msg_state_in[j*4],msg_state_in[(j*4)+1],msg_state_in[(j*4)+2],msg_state_in[(j*4)+3]}; // take each word of the current message state
						SubBytes(temp_sub_word_in, temp_sub_word_out); // Substitute bytes
						msg_state_in[j*4] = temp_sub_word_out[0]; // set replaced bytes back into state
						msg_state_in[(j*4)+1] = temp_sub_word_out[1];
						msg_state_in[(j*4)+2] = temp_sub_word_out[2];
						msg_state_in[(j*4)+3] = temp_sub_word_out[3];
				}

				// ShiftRows
				ShiftRows(msg_state_in, msg_state_out);
				msg_state_in = msg_state_out;

				// MixColumns
				// TO-DO

				// AddRoundKey
				AddRoundKey(msg_state_in, temp_round_key, msg_state_out);
				msg_state_in = msg_state_out;
		}

		// Last Round
		// SubBytes
		for(j=0;j<4;j++) {
				temp_sub_word_in = {msg_state_in[j*4],msg_state_in[(j*4)+1],msg_state_in[(j*4)+2],msg_state_in[(j*4)+3]}; // take each word of the current message state
				SubBytes(temp_sub_word_in, temp_sub_word_out); // Substitute bytes
				msg_state_in[j*4] = temp_sub_word_out[0]; // set replaced bytes back into state
				msg_state_in[(j*4)+1] = temp_sub_word_out[1];
				msg_state_in[(j*4)+2] = temp_sub_word_out[2];
				msg_state_in[(j*4)+3] = temp_sub_word_out[3];
		}

		// ShiftRows
		ShiftRows(msg_state_in, msg_state_out);
		msg_state_in = msg_state_out;

		// AddRoundKey
		// set last round key
		temp_round_key = {key_schedule[160],key_schedule[161],key_schedule[162],key_schedule[163],
											key_schedule[164],key_schedule[165],key_schedule[166],key_schedule[167],
											key_schedule[168],key_schedule[169],key_schedule[170],key_schedule[171],
											key_schedule[172],key_schedule[173],key_schedule[174],key_schedule[175],
											};
		AddRoundKey(msg_state_in, temp_round_key, msg_state_out);
		msg_state_in = msg_state_out;

		// NOTE : At this point, msg_state_out should be the fully encrypted Ciphertext

		// Set msg_enc to take values from msg_state_out

		// Convert encrypted messgage back from hex into character string
		for(i=0;i<16;i++) {
				// msg_enc[2*i] = charToHex();
				// msg_enc[(2*i)+1] = charToHex();
		}
}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
