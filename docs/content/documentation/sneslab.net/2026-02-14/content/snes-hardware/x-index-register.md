---
title: "X Index Register"
reference_url: https://sneslab.net/wiki/X_Index_Register
categories:
  - "SNES_Hardware"
  - "ASM"
  - "Registers"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T17:21:57-08:00
cleaned_at: 2026-02-14T17:54:43-08:00
---

The **X Index Register** on 65x processors often holds the current index when iterating over things. It can be incremented or decremented by one with INX or DEX, but there is no instruction to add or subtract more than one. Although INX and DEX can affect the negative flag, the indexed addressing modes always interpret the bit pattern in the X index register as a non-negative integer.

It can be loaded with LDX and stored to memory with STX.

On the S-SMP it is always 8 bits wide and is zero upon entry into the first user code.\[3] It is the divisor for division commands.\[2]

On the 65c816, it may be 8 or 16 bits wide:

- When the index register select flag is clear, X is 16 bit
- When the index register select flag is set, X is 8 bit (the high byte is hidden and forced to zero)

Indexing may cross bank boundaries.\[1] In emulation mode it is always 8 bits wide.

Unlike the Y index register, the value of the stack pointer can be transferred to/from X with TXS and TSX.

It is not specified to have any particular value after reset.

It can be pushed to the stack with PHX and pulled with PLX.

It can be transferred to the accumulator with TXA or to Y with TXY. Conversely, it can be made to reflect the accumulator with TAX or Y with TYX.

CPX can compare it to something.

### References

1. [https://wilsonminesco.com/816myths](https://wilsonminesco.com/816myths)
2. 8.1.2 of [page 3-8-4 of Book I](https://archive.org/details/SNESDevManual/book1/page/n182) of the official Super Nintendo development manual
3. anomie: [https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L73](https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L73)
