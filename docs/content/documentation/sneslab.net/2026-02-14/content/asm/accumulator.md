---
title: "Accumulator"
reference_url: https://sneslab.net/wiki/Accumulator
categories:
  - "ASM"
  - "SNES_Hardware"
  - "Registers"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T10:54:15-08:00
cleaned_at: 2026-02-14T17:51:00-08:00
---

An **Accumulator** is a very fast register inside a processor that acts as a mathematical scratch pad.

The 65c816's accumulator can be either 8 or 16 bits in size, as configured by the m flag. Labiak calls this 16-bit memory mode. When the direct page is coincident with the zero page, TDC is a good way to zero it.

The high byte ("B") is still retained even when the accumulator is 8 bits wide and can be accessed with XBA.

It can be stored to and from an effective address with LDA and STA.

Unlike both index registers, arbitrary integers can be added to/from the accumulator with ADC and SBC.

It can be freely transferred to/from both the X index register (see TAX and TXA) and the Y index register (see TAY and TYA) and also the stack (see PHA and PLA).

It is not specified to have any particular value after reset.

The S-SMP's accumulator is always 8 bits wide and it is zero upon entry into the first user code.\[3]

### See Also

- Accumulator Addressing

### References

1. Eyes & Lichty, [page 27](https://archive.org/details/0893037893ProgrammingThe65816/page/27)
2. subparagraph 8.1.1 A Register on [page 3-8-4 of Book II](https://archive.org/details/SNESDevManual/book1/page/n182) of the official Super Nintendo development manual
3. anomie: [https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L73](https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L73)
