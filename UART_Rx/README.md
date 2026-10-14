## Objective
Create a UART receiver that can receive a byte (8 bits) from the computer and display it on the 7-segment-display.
This project will require the implementation of a state machine in order to keep track of the bits received and the order in which they are received.
Since the UART is asynchronous, the parameters that can be set must be matching on the receiver and transmitter, otherwise data corruption will occur.
```
I will set the parameters in this project as follows:
Baud Rate:        115200
No. of Data Bits: 8
Parity Bit:       off
Stop Bits:        1
Flow Control:     None 
```
## Development board
I am using the Nandland Go board with a Lattice iCE40 FPGA.
