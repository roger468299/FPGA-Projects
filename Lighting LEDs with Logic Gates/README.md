## Objective
Create an AND gate to light up LED_1 using Switch_1 and Switch_2.

Create an OR gate for LED_2 using Switch_3 and Switch_4.

## Development board
I am using the Nandland Go board with a Lattice iCE40 FPGA.

## Success

https://github.com/user-attachments/assets/4f3ca5ce-1023-4f4e-82e1-b1faf7996d2d

The code is working as expected.
LED_1 only lights up when switch_1 and switch_2 are pressed.
LED_2 only light up when switch_3 or switch_4 are pressed.
The counter values for each LED had to be halved because it has a 50% duty cycle.
