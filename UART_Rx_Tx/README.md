## Objective
Create a loopback of data sent by the computer. This project should allow the Go board to receive UART data from the computer, display it onto the 7-segment display and then transmit the received data back to the computer.
Since the UART is asynchronous, the parameters that can be set must be matching on the receiver and transmitter, otherwise data corruption will occur.
```
I will set the parameters in this project as follows:
Baud Rate:        115200
No. of Data Bits: 8
Parity Bit:       off
Stop Bits:        1
Flow Control:     None 
```

## Success

https://github.com/user-attachments/assets/217d477c-1649-44d3-bcbd-ba57ba460cf7

The program is working as expected. The data that is being sent to the Go board from the computer is being relayed back to the computer.
