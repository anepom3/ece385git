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

/** KeyExpansion
	* Takes the Cipher Key and performs a Key Expansion to generate a series
	* of Round Keys (4-Word matrix) and store them into Key Schedule.
	*
	* Input: int key_in[4]		- original 4-word key
	*
	* Output: int key_out[44] - 11 4-word keys
  */
int[44] KeyExpansion(int key_in[4]) {
		int key_out[44]; // 11 4-word keys
		int i=0;
		int temp=0;
		// First key is the original key
		for(i=0;i<4;i++) {
				key_out[i] = key[i];
		}

		// Make 10 other keys
		for(i=4;i<44;i++) {
				temp = key_out[i-1];

				if((i % 4) == 0) {
						temp = (temp << 8) | (temp >> 24); // Rotate Word {0,1,2,3} --> {1,2,3,0}
						temp = SubBytes(temp); // Substitute bytes if words using table
						temp ^= Rcon[i/4]; // xor with Round-key constant
				}

				key_out[i] = key_out[i-4] ^ temp;
		}

		return key_out;
}

/** AddRoundKey
	* A Round Key of 4-Word matrix is applied to the
	* updating State through a simple XOR operation in every round
	*
	* Input: int state_in[4] 	 - original 4-word key
	*				 int round_key[4]	 - round key to use for operation
	*
	* Output: int ret_state[4] - new state after operation occurs
  */
int[4] AddRoundKey(int state_in[4], int round_key[4]) {
		int ret_state[4];
		int i=0;
		for(i=0;i<4;i++) {
				ret_state[i] = state_in[i] ^ round_key[i];
		}
		return ret_state;
}

/** SubBytes
	* Each Byte of the updating State is non-linearly transformed by
	* taking the multiplicative inverse in Rijndael’s finite field
	* The process is usually simplified into applying a lookup table
	* called the Rijndael S-box (substitution box).
	*
	* Input: int word_in 	- original word to substitute bytes for
	*
	* Output: int ret_word - substituted bytes of word
  */
int SubBytes(int word_in) {
		int ret_word;

		// TO-DO:
		// Do operation of separarting bytes and applying substitutions

		return ret_word;
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

		char input_string[32]; // Plaintext
		int state[4]; // State
		// int key_schedule[44]; // Key Schedule from Key Expansion (11 keys, 4 words each)

		input_string = *(msg_ascii); // Get Plaintext in ASCII
		// key_schedule = KeyExpansion(*key); // I don't think that is the right way to generate the Key Expansion...???

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
