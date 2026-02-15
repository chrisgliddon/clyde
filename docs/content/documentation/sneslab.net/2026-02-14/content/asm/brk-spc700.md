---
title: "BRK (SPC700)"
reference_url: https://sneslab.net/wiki/BRK_(SPC700)
categories:
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T11:05:26-08:00
cleaned_at: 2026-02-14T17:51:23-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack / Interrupt 0F 1 byte 8 cycles

Flags Affected N V P B H I Z C . . . 1 . 0 . .

**BRK** is an SPC700 instruction that triggers a software interrupt. The program counter and program status word are pushed to the stack. The program counter then jumps to the address stored at $FFDE.

#### Syntax

```
BRK
```

BRK very well could be the only interrupt source on the S-SMP. It is the only instruction to unconditionally set the break flag.

According to fullsnes, EI and DI have no effect other than toggling the interrupt enable flag, so the SPC700's BRK seems to be non-maskable like the 65c816's BRK.

To return from the interrupt handler, use RETI.

### See Also

- BRK (65c816)
- SLEEP
- STOP

### References

- Table C-16 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234) of the official Super Nintendo development manual
- [anomie's SPC700 doc](https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L368)
