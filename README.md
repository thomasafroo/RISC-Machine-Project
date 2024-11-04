# Simple RISC Machine

This is an ongoing project that implements a simple RISC Machine using Verilog and can be tested using the Intel DE1-SoC development board.
Currently, the datapath is fully functional. This project was done in collaboration with my lab partner, Jackson Rockford.

## Elements of the Datapath
* Register file containing eight 16-bit registers with read/write functionality
* Arithmetic Logic Unit capable of addition, subtraction, and logical operations AND and NOT
* Shifter that can optionally perform shifting of binary numbers 1 bit to the left or right; supports sign-extended shifting as well
