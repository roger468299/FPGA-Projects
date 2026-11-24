## Objective
Make a digital clock counter in VHDL. The design should count seconds, minutes and hours (24-hour format) by counting clock cycles.

## Success
The program is working as intended. When the seconds reach 59 the following tick resets it to 0 and increments the minutes to 1.
When the minutes reach 59 minutes and seconds reach 59 seconds, the following tick increments hours to 1 and resets the others back to 0. 