# Simple RISC Machine

This is an ongoing project that implements a Reduced Instruction Set Computer (RISC) using Verilog and can be tested using the Intel DE1-SoC development board.
The RISC machine can execute a small set of instructions from the ARMv7 Instruction Set Architecture (ISA). 

This project was done in collaboration with my lab partner, Jackson Rockford, for CPEN 211: Introduction to Microcomputers.

Currently, the datapath is fully functional and a finite state machine controller is in development.

Important: viewers should be mindful of the Academic Integrity Policy for CPEN 211 and UBC ECE.

## Elements of the Datapath
* Register file containing eight 16-bit registers with read/write functionality
* Arithmetic Logic Unit capable of addition, subtraction, and logical operations AND and NOT
* Shifter that can optionally perform shifting of binary numbers 1 bit to the left or right; supports sign-extended shifting

## Datapath Specification
![Datapath Specification](https://github.com/thomasafroo/RISCMachine/blob/main/Datapathspec.png?raw=true)
