---
title: "Super NES Programming/Introduction to assembly"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/Introduction_to_assembly
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:17:14-08:00
---

It would be convenient if this Wikibook could assume that you have learned some other form of assembly language. This tutorial will try to introduce you to the practice of programming the SNES at the lowest level possible.

## Registers

*Registers* are at the core of any processor, and are basically locations in memory which serve a special purpose. All instructions have an effect on one or more of these registers. Even the *nop* instruction, which does nothing, increments the Program Counter register.

General Purpose Registers Accumulator (A) Handles all arithmetic and logic. The essential core of the 65816. Index (X & Y) Index Registers with limited Capabilities Special Purpose Registers Processor Status (P) Processor Flags, holds the results of tests and 65816 processing states. Stack (S) Stack Pointer Direct Page (DP) Allows the 65816 to access memory in direct addressing modes Program Bank (PB) Holds the memory bank address of the current CPU instruction Program Counter (PC) Holds the memory address of the current CPU instruction Data Bank (DB) Holds the memory bank address of the data the CPU is accessing

All of the SNES registers are either 8 bits or 16 bits. Registers A, X, Y may be set to be either 8 or 16 bits.

## Hexadecimal notation

In low-level programming, it is common for programmers to type numbers in hexadecimal notation. This means that values can have a base of 16. In other words, each digit can have 16 possible values: 0-9, A,B,C,D,E,F. This makes it easy to represent and manipulate individual bits.

In SNES assembly, hex values are specified with the **$** prefix.

Examples Decimal Hex binary 18 $12 %00010010 122 $7A %01111010

## Instructions

**Instructions** are a breakdown of machine code. For the SNES, they consist of a 1-byte *opcode* followed by a 0-3 byte operand. Full instructions may be known as *words*. For example, the instruction "ADC $3a" occupies 2 bytes in memory, and if assembled, it would be stored as "E6 3A".

Most instructions that are at least 2 bytes long have more than one **addressing mode**. Addressing modes are put in place so basic instructions may be interpreted correctly given a wide range of operands. The SNES addressing modes may be found at the end of the [65c816\_reference](/wiki/Super_NES_Programming/65c816_reference#Addressing_modes "Super NES Programming/65c816 reference")

### Arithmetic/logical instructions

Most arithmetic instructions perform an arithmetic operation on A (the accumulator) and another value and store the result back in A. Addition, for instance, is represented by "ADC".

ADC, SBC (subtraction), AND, ORA (bitwise OR), EOR (bitwise XOR) are the most basic arithmetic instructions. The most common addressing modes for these are:

Immediate ADC #$01ff Adds $01ff to A. Absolute SBC $80fb subtracts value at the address 80fb in the bank specified by DB Absolute indexed AND $a0c0, X same as absolute, but add X to the address And much more!

See also [65c816 Reference: Addressing Modes](/wiki/Super_NES_Programming/65c816_reference#Addressing_modes "Super NES Programming/65c816 reference")
