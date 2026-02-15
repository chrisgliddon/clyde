---
title: "Stack Pointer"
reference_url: https://sneslab.net/wiki/Stack_Pointer
categories:
  - "ASM"
  - "Registers"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T16:49:10-08:00
cleaned_at: 2026-02-14T17:53:12-08:00
---

The **Stack Pointer** (SP) points to the next stack location available for pushing to. In stack addressing modes it is used for the effective address. Also called the **stack register**, the low byte is called **SL** and the high byte is called **SH**.

On the SPC700 it is 16-bit, but the upper byte is fixed by the hardware to be 0x01. The low byte is $EF upon entry into the first user code.\[5]

On the 65c816 it is also 16-bit, and the only two instructions that modify the stack pointer (S) directly are TCS and TXS.\[4] Its value can be examined with TSX or TSC. It is only fixed to be in page one in emulation mode on the '816.

1FFh is a common value to initialize the stack pointer to.

Pushing things onto the stack decrements the stack pointer and pulling things increments it.

### See Also

- PUSH
- POP
- RET
- Program Counter

### References

1. subparagraph 8.1.5 of [page 3-8-4 of Book I](https://archive.org/details/SNESDevManual/book1/page/n182) of the official Super Nintendo development manual
2. diversified activities: [page 3-8-5 of Book I](https://archive.org/details/SNESDevManual/book1/page/n183), lbid.
3. Eyes & Lichty, [page 31](https://archive.org/details/0893037893ProgrammingThe65816/page/31) on The Stack Pointer
4. Eyes & Lichty, [page 511](https://archive.org/details/0893037893ProgrammingThe65816/page/511) on TCS
5. anomie: [https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L73](https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L73)
