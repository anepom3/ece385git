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
volatile unsigned int * msg_enc_global;
volatile unsigned int * msg_dec_global;
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

void CleanUpState(unsigned char * state_in, unsigned char * state_out) {
		int i=0;
		for(i=0;i<16;i++) {
				state_out[i] = state_in[i];
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
		word_out[0] = (unsigned char)aes_sbox[word_in[0]];
		word_out[1] = (unsigned char)aes_sbox[word_in[1]];
		word_out[2] = (unsigned char)aes_sbox[word_in[2]];
		word_out[3] = (unsigned char)aes_sbox[word_in[3]];
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
			int i=0;
			unsigned char temp[4];
			unsigned char temp_sub[4];


			// First key is the original key
			for(i=0;i<16;i++) {
					key_schedule[i] = key_in[i];
			}

			// for(i=0;i<4;i++) {
			// 	printf("Key_word[%02d]:\t[%02x, %02x, %02x, %02x]\n",i,key_schedule[4*i],key_schedule[(4*i)+1],key_schedule[(4*i)+2],key_schedule[(4*i)+3]);
			// }

			// Make 10 other keys
			for(i=4;i<44;i++) { // 4-44 is the 40 words of the other 10 keys
				// printf("\tMaking Key[%02d]\n",i);
					// set temp word to previous word
					temp[0] = key_schedule[(4*i)-4];
					temp[1] = key_schedule[(4*i)-4+1];
					temp[2] = key_schedule[(4*i)-4+2];
					temp[3] = key_schedule[(4*i)-4+3];
					// printf("\t\tInitial Word: [%02x, %02x, %02x, %02x]\n", temp[0],temp[1], temp[2], temp[3]);


					if((i % 4) == 0) { // every 4th key, re-randomize
							// Rotate Word {0,1,2,3} --> {1,2,3,0}
							temp_sub[0] = temp[1];
							temp_sub[1] = temp[2];
							temp_sub[2] = temp[3];
							temp_sub[3] = temp[0];
							// printf("\t\tAfter RotWord: [%02x, %02x, %02x, %02x]\n", temp_sub[0],temp_sub[1], temp_sub[2], temp_sub[3]);
							// Substitute bytes if words using table
							SubBytes(temp_sub, temp);
							// printf("\t\tAfter SubBytes: [%02x, %02x, %02x, %02x]\n", temp[0],temp[1], temp[2], temp[3]);
							// xor with Round-key constant
							temp[3] ^= (unsigned char)(Rcon[i/4] & 0xFF);
							temp[2] ^= (unsigned char)((Rcon[i/4] >> 8) & 0xFF);
							temp[1] ^= (unsigned char)((Rcon[i/4] >> 16) & 0xFF);
							temp[0] ^= (unsigned char)((Rcon[i/4] >> 24) & 0xFF);
							// printf("\t\tRCon: [%02x, %02x, %02x, %02x]\n",(unsigned char)((Rcon[i/4] >> 24) & 0xFF),(unsigned char)((Rcon[i/4] >> 16) & 0xFF),(unsigned char)((Rcon[i/4] >> 8) & 0xFF),(unsigned char)(Rcon[i/4] & 0xFF));
							// printf("\t\tAfter RCon: [%02x, %02x, %02x, %02x]\n", temp[0],temp[1], temp[2], temp[3]);

					}

					// printf("\t\tXOR Word    : [%02x, %02x, %02x, %02x]\n", key_schedule[(4*i)-16],key_schedule[(4*i)-16+1],key_schedule[(4*i)-16+2],key_schedule[(4*i)-16+3]);

					key_schedule[4*i] = key_schedule[(4*i)-16] ^ temp[0];
					key_schedule[(4*i)+1] = key_schedule[(4*i)-16+1] ^ temp[1];
					key_schedule[(4*i)+2] = key_schedule[(4*i)-16+2] ^ temp[2];
					key_schedule[(4*i)+3] = key_schedule[(4*i)-16+3] ^ temp[3];

					// printf("Key_word[%02d]:\t[%02x, %02x, %02x, %02x]\n",i,key_schedule[4*i],key_schedule[(4*i)+1],key_schedule[(4*i)+2],key_schedule[(4*i)+3]);
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
	* b[0] = a[0]    [2 3 1 1]		b[0] = ({2} x a[0]) + ({3} x a[1]) + 				a[2]  + 			 a[3]
	* b[1] = a[1] \/ [1 2 3 1]		b[0] =  			a[0]	+ ({2} x a[1]) + ({3} x a[2]) + 			 a[3]
	* b[2] = a[2] /\ [1 1 2 3]		b[0] =  			a[0]	+ 			 a[1]  + ({2} x a[2]) + ({3} x a[3])
	* b[3] = a[3]    [3 1 1 2]		b[0] = ({3} x a[0]) + 			 a[1]  + 				a[2]  + ({2} x a[3])
  */
void MixColumns(unsigned char * state_in , unsigned char * ret_state) {
		int i=0;
		unsigned char a,b,c,d;

		for(i=0;i<4;i++) {
				a = state_in[4*i];
				b = state_in[(4*i)+1];
				c = state_in[(4*i)+2];
				d = state_in[(4*i)+3];
				ret_state[4*i] 		 = (gf_mul[a][0]) ^ (gf_mul[b][1]) ^ (c) ^ (d);
				ret_state[(4*i)+1] = (a) ^ (gf_mul[b][0]) ^ (gf_mul[c][1]) ^ (d);
				ret_state[(4*i)+2] = (a) ^ (b) ^ (gf_mul[c][0]) ^ (gf_mul[d][1]);
				ret_state[(4*i)+3] = (gf_mul[a][1]) ^ (b) ^ (c) ^ (gf_mul[d][0]);
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
unsigned int encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc , unsigned int * key)
{
		// Implement this function
		int i=0;
		int j=0;
		unsigned char msg_bytes[16];
		unsigned char key_bytes[16];
		unsigned char key_schedule[176]; // key-schedule
		unsigned char temp_round_key[16]; // round key to add
		unsigned char msg_state_in[16]; // state of message to pass into helper functions
		unsigned char msg_state_out[16]; // state of message that is returned from functions
		unsigned char temp_sub_word_in[4]; // temp holder for words of state for input of SubBytes
		unsigned char temp_sub_word_out[4]; // temp holder for words of state for output of SubBytes

//		printf("\n Within encryption function, msg_enc_PTR = %08x --> 0x%08x\n\n",&(msg_enc[0]), *(msg_enc));

		// Convert input message and key into hex
		for(i=0;i<16;i++) {
				msg_bytes[i] = charsToHex(msg_ascii[2*i], msg_ascii[(2*i)+1]);
				key_bytes[i] = charsToHex(key_ascii[2*i], key_ascii[(2*i)+1]);
				temp_round_key[i] = key_bytes[i];
				msg_state_in[i] = msg_bytes[i];
		}
//		printf("Input Msg:");
//		StatePrint(msg_bytes);
//		printf("Input Key:");
//		StatePrint(key_bytes);

		// Perform Key Key Expansion
		KeyExpansion(key_bytes,key_schedule);

		// Add original key
		AddRoundKey(msg_state_in, temp_round_key, msg_state_out);
		CleanUpState(msg_state_out, msg_state_in);

		for(i=1;i<10;i++) { // 9 rounds (keys 2-10)
				// set next round key
				temp_round_key[0] = key_schedule[16*i];
				temp_round_key[1] = key_schedule[(16*i)+1];
				temp_round_key[2] = key_schedule[(16*i)+2];
				temp_round_key[3] = key_schedule[(16*i)+3];
				temp_round_key[4] = key_schedule[(16*i)+4];
				temp_round_key[5] = key_schedule[(16*i)+5];
				temp_round_key[6] = key_schedule[(16*i)+6];
				temp_round_key[7] = key_schedule[(16*i)+7];
				temp_round_key[8] = key_schedule[(16*i)+8];
				temp_round_key[9] = key_schedule[(16*i)+9];
				temp_round_key[10] = key_schedule[(16*i)+10];
				temp_round_key[11] = key_schedule[(16*i)+11];
				temp_round_key[12] = key_schedule[(16*i)+12];
				temp_round_key[13] = key_schedule[(16*i)+13];
				temp_round_key[14] = key_schedule[(16*i)+14];
				temp_round_key[15] = key_schedule[(16*i)+15];

				// printf("State at start of round %d:",i);
				// StatePrint(msg_state_in);

				// SubBytes
				for(j=0;j<4;j++) {
						temp_sub_word_in[0] = msg_state_in[j*4]; // take each word of the current message state
						temp_sub_word_in[1] = msg_state_in[(j*4)+1];
						temp_sub_word_in[2] = msg_state_in[(j*4)+2];
						temp_sub_word_in[3] = msg_state_in[(j*4)+3];
						SubBytes(temp_sub_word_in, temp_sub_word_out); // Substitute bytes
						msg_state_in[j*4] = temp_sub_word_out[0]; // set replaced bytes back into state
						msg_state_in[(j*4)+1] = temp_sub_word_out[1];
						msg_state_in[(j*4)+2] = temp_sub_word_out[2];
						msg_state_in[(j*4)+3] = temp_sub_word_out[3];
				}

				// printf("After SubBytes:");
				// StatePrint(msg_state_in);

				// ShiftRows
				ShiftRows(msg_state_in, msg_state_out);
				CleanUpState(msg_state_out, msg_state_in);

				// printf("After ShiftRows:");
				// StatePrint(msg_state_in);

				// MixColumns
				for(j=0;j<4;j++) {
						temp_sub_word_in[0] = msg_state_in[j*4]; // take each word of the current message state
						temp_sub_word_in[1] = msg_state_in[(j*4)+1];
						temp_sub_word_in[2] = msg_state_in[(j*4)+2];
						temp_sub_word_in[3] = msg_state_in[(j*4)+3];
						MixColumns(temp_sub_word_in, temp_sub_word_out); // Substitute bytes
						msg_state_in[j*4] = temp_sub_word_out[0]; // set replaced bytes back into state
						msg_state_in[(j*4)+1] = temp_sub_word_out[1];
						msg_state_in[(j*4)+2] = temp_sub_word_out[2];
						msg_state_in[(j*4)+3] = temp_sub_word_out[3];
				}

				// printf("After MixColumns:");
				// StatePrint(msg_state_in);

				// printf("Round Key[%d]:",i);
				// StatePrint(temp_round_key);

				// AddRoundKey
				AddRoundKey(msg_state_in, temp_round_key, msg_state_out);
				CleanUpState(msg_state_out, msg_state_in);
		}

//		printf("State at start of final round %d:",i);
//		StatePrint(msg_state_in);

		// Last Round
		// SubBytes
		for(j=0;j<4;j++) {
				temp_sub_word_in[0] = msg_state_in[j*4]; // take each word of the current message state
				temp_sub_word_in[1] = msg_state_in[(j*4)+1];
				temp_sub_word_in[2] = msg_state_in[(j*4)+2];
				temp_sub_word_in[3] = msg_state_in[(j*4)+3];
				SubBytes(temp_sub_word_in, temp_sub_word_out); // Substitute bytes
				msg_state_in[j*4] = temp_sub_word_out[0]; // set replaced bytes back into state
				msg_state_in[(j*4)+1] = temp_sub_word_out[1];
				msg_state_in[(j*4)+2] = temp_sub_word_out[2];
				msg_state_in[(j*4)+3] = temp_sub_word_out[3];
		}

//		printf("After SubBytes:");
//		StatePrint(msg_state_in);

		// ShiftRows
		ShiftRows(msg_state_in, msg_state_out);
		CleanUpState(msg_state_out, msg_state_in);

//		printf("After ShiftRows:");
//		StatePrint(msg_state_in);

		// AddRoundKey
		// set last round key
		temp_round_key[0] = key_schedule[160];
		temp_round_key[1] = key_schedule[161];
		temp_round_key[2] = key_schedule[162];
		temp_round_key[3] = key_schedule[163];
		temp_round_key[4] = key_schedule[164];
		temp_round_key[5] = key_schedule[165];
		temp_round_key[6] = key_schedule[166];
		temp_round_key[7] = key_schedule[167];
		temp_round_key[8] = key_schedule[168];
		temp_round_key[9] = key_schedule[169];
		temp_round_key[10] = key_schedule[170];
		temp_round_key[11] = key_schedule[171];
		temp_round_key[12] = key_schedule[172];
		temp_round_key[13] = key_schedule[173];
		temp_round_key[14] = key_schedule[174];
		temp_round_key[15] = key_schedule[175];

//		printf("Round Key[10]:");
//		StatePrint(temp_round_key);

		AddRoundKey(msg_state_in, temp_round_key, msg_state_out);
		CleanUpState(msg_state_out, msg_state_in); // msg_state_out now holds the encrypted text

//		printf("Encrypted Msg:");
//		StatePrint(msg_state_out);

		// Set key
		key[0] = ((unsigned int)(key_schedule[0]) << 24) | ((unsigned int)(key_schedule[1]) << 16) | ((unsigned int)(key_schedule[2]) << 8) | ((unsigned int)(key_schedule[3]));
		key[1] = ((unsigned int)(key_schedule[4]) << 24) | ((unsigned int)(key_schedule[5]) << 16) | ((unsigned int)(key_schedule[6]) << 8) | ((unsigned int)(key_schedule[7]));
		key[2] = ((unsigned int)(key_schedule[8]) << 24) | ((unsigned int)(key_schedule[9]) << 16) | ((unsigned int)(key_schedule[10]) << 8) | ((unsigned int)(key_schedule[11]));
		key[3] = ((unsigned int)(key_schedule[12]) << 24) | ((unsigned int)(key_schedule[13]) << 16) | ((unsigned int)(key_schedule[14]) << 8) | ((unsigned int)(key_schedule[15]));

		AES_PTR[0] = key[0];
		AES_PTR[1] = key[1];
		AES_PTR[2] = key[2];
		AES_PTR[3] = key[3];

//		for (i = 0; i < 4; i++){
//			printf("key[%d]: 0x%08x\n", i,key[i]);
//		}


		// Set encrypted message
//		printf("\n Test to see what Encrpted message is before assignment: \n");
//						for(i = 0; i < 4; i++){
//							printf("%08x", msg_enc[i]);
//						}
//		printf("\n");


		msg_enc[0] = ((unsigned int)(msg_state_out[0]) << 24) + ((unsigned int)(msg_state_out[1]) << 16) + ((unsigned int)(msg_state_out[2]) << 8) + ((unsigned int)(msg_state_out[3]));
		msg_enc[1] = ((unsigned int)(msg_state_out[4]) << 24) + ((unsigned int)(msg_state_out[5]) << 16) + ((unsigned int)(msg_state_out[6]) << 8) + ((unsigned int)(msg_state_out[7]));
		msg_enc[2] = ((unsigned int)(msg_state_out[8]) << 24) + ((unsigned int)(msg_state_out[9]) << 16) + ((unsigned int)(msg_state_out[10]) << 8) + ((unsigned int)(msg_state_out[11]));
		msg_enc[3] = ((unsigned int)(msg_state_out[12]) << 24) + ((unsigned int)(msg_state_out[13]) << 16) + ((unsigned int)(msg_state_out[14]) << 8) + ((unsigned int)(msg_state_out[15]));

		msg_enc_global[0] = ((unsigned int)(msg_state_out[0]) << 24) + ((unsigned int)(msg_state_out[1]) << 16) + ((unsigned int)(msg_state_out[2]) << 8) + ((unsigned int)(msg_state_out[3]));
		msg_enc_global[1] = ((unsigned int)(msg_state_out[4]) << 24) + ((unsigned int)(msg_state_out[5]) << 16) + ((unsigned int)(msg_state_out[6]) << 8) + ((unsigned int)(msg_state_out[7]));
		msg_enc_global[2] = ((unsigned int)(msg_state_out[8]) << 24) + ((unsigned int)(msg_state_out[9]) << 16) + ((unsigned int)(msg_state_out[10]) << 8) + ((unsigned int)(msg_state_out[11]));
		msg_enc_global[3] = ((unsigned int)(msg_state_out[12]) << 24) + ((unsigned int)(msg_state_out[13]) << 16) + ((unsigned int)(msg_state_out[14]) << 8) + ((unsigned int)(msg_state_out[15]));

		AES_PTR[4] = msg_enc[0];
		AES_PTR[5] = msg_enc[1];
		AES_PTR[6] = msg_enc[2];
		AES_PTR[7] = msg_enc[3];

//		printf("Encrypted Msg: %08x%08x%08x%08x",msg_enc[0],msg_enc[1],msg_enc[2],msg_enc[3]);
//		printf("\n");
//		printf("\n Within encryption function, msg_enc_PTR = %08x --> 0x%08x\n\n",&(msg_enc[0]), *(msg_enc));
//		printf("\n Within encryption function, msg_enc_global_PTR = %08x --> 0x%08x\n\n",&(msg_enc_global[0]), *(msg_enc_global));

//
//		printf("Register File: AES_PTR = %08x --> 0x%08x\n\n",AES_PTR, *(AES_PTR));
//		for (i = 0; i < 16; i++){
//			printf("REG%d = Hexadecimal: 0x%08x\n", i, AES_PTR[i]);
//		}
//		printf("\n");
//		printf("\nEncrpted message is: \n");
//			for(i = 0; i < 4; i++){
//				printf("%08x", msg_enc[i]);
//			}
//		printf("\n");
		return msg_enc[0];
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
	AES_PTR[15] = 0x0000000000000000;
		AES_PTR[14] = 0x0000000000000001;
		while(1){
			if(AES_PTR[15] == 0x0000000000000001)
				break;
		}
	AES_PTR[14] = 0x0000000000000000;
//	for (int i = 0; i < 16; i++){
//				printf("REG%d = Hexadecimal: 0x%08x\n", i, AES_PTR[i]);
//			}
//	printf("\n");

	msg_dec_global[0] = AES_PTR[8];
	msg_dec_global[1] = AES_PTR[9];
	msg_dec_global[2] = AES_PTR[10];
	msg_dec_global[3] = AES_PTR[11];
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
//Encrypted Message
//
//daec3055df058e1c39e814ea76f6747e
//
//Key
//
//000102030405060708090a0b0c0d0e0f
//
//Last Expanded Round Key
//
//13111d7fe3944a17f307a78b4d2b30c5
//
//Decrypted Message
//
//ece298dcece298dcece298dcece298dc
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];
	msg_enc_global = & (msg_enc[0]);
	msg_dec_global = & (msg_dec[0]);
	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
//			printf("Register File: AES_PTR = %08x --> 0x%08x\n",AES_PTR, *(AES_PTR));
//			for (i = 0; i < 16; i++){
//				printf("REG%d = 0x%08x\n", i, AES_PTR[i]);
//			}
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");

//			printf("Before encryption function, msg_enc_PTR = %08x --> 0x%08x\n\n",&(msg_enc[0]), *(msg_enc));
			msg_enc[0] = encrypt(msg_ascii, key_ascii, msg_enc, key);
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
