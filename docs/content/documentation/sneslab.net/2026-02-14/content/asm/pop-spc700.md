---
title: "POP (SPC700)"
reference_url: https://sneslab.net/wiki/POP_(SPC700)
categories:
  - "Stack_Operation_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T15:53:25-08:00
cleaned_at: 2026-02-14T17:52:48-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator AE 1 byte 4 cycles Stack - X CE 1 byte 4 cycles Stack - Y EE 1 byte 4 cycles Stack - PSW 8E 1 byte 4 cycles

Flags Affected Operand is the PSW? N V P B H I Z C yes N V P B H I Z C no . . . . . . . .

**POP** is an SPC700 command that pops a byte from the stack, pulling it into a register. The target register can be:

- the accumulator
- the X Index Register
- the Y Index Register
- the program status word

The stack pointer is incremented by one before the value is pulled.

When the program status word is the operand, all the flags are naturally affected as that is the register they live in. Otherwise, no flags are affected.

#### Syntax

```
POP A
POP X
POP Y
POP PSW
```

### See Also

- PUSH
- PLA
- PLX
- PLY
- PLP

### References

- Table C-17 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234) of the official Super Nintendo development manual
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L536](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L536)
