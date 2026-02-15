---
title: "Y Index Register"
reference_url: https://sneslab.net/wiki/Y_Index_Register
categories:
  - "SNES_Hardware"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T17:23:35-08:00
cleaned_at: 2026-02-14T17:54:44-08:00
---

The [Y Index Register]() on 65x processors often holds the current index when iterating over things. It can be incremented or decremented by one with INY or DEY, but there is no instruction to add or subtract more than one. Although INY and DEY can affect the negative flag, the indexed addressing modes always interpret the bit pattern in the Y index register as a non-negative integer.

It can be loaded with LDY and stored to memory with STY.

On the S-SMP it is always 8 bits wide and is called a universal register.\[2] It is zero upon entry into the first user code.\[3] On the 65c816, it may be 8 or 16 bits wide:

- When the index register select flag is clear, Y is 16 bit
- When the index register select flag is set, Y is 8 bit (the high byte is hidden and forced to zero)

In emulation mode it is always 8 bits wide.

Unlike the X index register, there are no instructions to transfer value of the stack pointer to/from Y.

It is not specified to have any particular value after reset.

It can be pushed to the stack with PHY and pulled with PLY. It can be copied to the accumulator with TYA and made to reflect the accumulator with TAY. It can be copied to X with TYX and made to reflect x with TXY.

CPY can compare it to something.

### References

1. subparagraph 8.1.3 of [page 3-8-4 of Book I](https://archive.org/details/SNESDevManual/book1/page/n182) of the official Super Nintendo development manual
2. paragraph 8.1 CPU Registers on [page 3-8-3](https://archive.org/details/SNESDevManual/book1/page/n181), lbid.
3. anomie: [https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L73](https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L73)
