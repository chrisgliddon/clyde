---
title: "Program Counter"
reference_url: https://sneslab.net/wiki/Program_Counter
categories:
  - "ASM"
  - "Registers"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T16:00:28-08:00
cleaned_at: 2026-02-14T17:52:49-08:00
---

The **Program Counter** (PC) points to the next instruction byte to fetch. On both the 65c816 and S-SMP it is 16 bits wide. The low byte is called PCL and the high byte is called PCH.

If incremented past FFFFh, it wraps around to zero.\[E&L, page 34]

The 6502 had 16-bit absolute addressing but only an 8-bit adder, so in emulation mode branches that cross a page boundary incur a one cycle penalty. 65c816 native mode has no such penalty because the full 16-bit adder is used.

### See Also

- Program Bank Register
- Stack Pointer
- Super\_FX#Program\_Counter\_(R15)
- BRA
- JMP
- RTS
- RTL

### References

- Eyes & Lichty, [page 33](https://archive.org/details/0893037893ProgrammingThe65816/page/33)
- subparagraph 8.1.4 on [page 3-8-4 of Book I](https://archive.org/details/SNESDevManual/book1/page/n182) of the official Super Nintendo development manual
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#PC](http://www.6502.org/tutorials/6502opcodes.html#PC)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.2.1.1](http://www.6502.org/tutorials/65c816opcodes.html#6.2.1.1)
