// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	int add_button_state = 1; // I am assuming that this button is active low!!!
	int prev_add_button_state = 1;
	int led_vals = 0;
	int val = 0;
	int but_vec = 3; // 3 active-low initialized to inactive [accumulate, reset]
	volatile unsigned int *LED_PIO = (unsigned int*)0x00000050; //make a pointer to access the LED PIO block
	volatile unsigned int *SW_PIO = (unsigned int*)0x00000030; //make a pointer to access the SW PIO block
	volatile unsigned int *BUT_PIO = (unsigned int*)0x00000020; //make a pointer to access the buttons

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		/// get current state of the buttons
		but_vec = *BUT_PIO & 0x3;
		reset_button = but_vec & 0x1;
		add_button_state = (but_vec >> 1) & 0x1;

		// check if ready to add
		if((!add_button_state) && (add_button_state != prev_add_button_state)) {
				// Perform addition
				// get value to add from swtiches
				val = *SW_PIO & 0xFF; // 8-bit value from switches

				// add to running led total
				if(led_val + val >= 256) {led_val = 256 - led_val + val;}
				else {led_val += val;}

				// display the new value on the LEDs
				*LED_PIO = led_val; // write new LED values
		}

		prev_add_button_state = add_button_state;
	}
	return 1; //never gets here
}
