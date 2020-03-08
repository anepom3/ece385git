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
	volatile unsigned int *LED_PIO = (unsigned int*)0x00000040; //make a pointer to access the PIO block

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		add_button_state = 0;//???
		// check if ready to add
		if((!add_button_state) && (add_button_state != prev_add_button_state)) {
				// Perform addition
				// get value to add from swtiches
				val = 0;//???

				// add to running led total
				if(led_val + val >= 256) {led_val = 256 - led_val + val;}
				else {led_val += val;}

				// display the new value on the LEDs
				led_vec = 0; // how to set LED's as on or off
				*LED_PIO = led_vec;// write new LED values
		}


		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB

		prev_add_button_state = add_button_state;
	}
	return 1; //never gets here
}
