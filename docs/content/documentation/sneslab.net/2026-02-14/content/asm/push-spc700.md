---
title: "PUSH (SPC700)"
reference_url: https://sneslab.net/wiki/PUSH_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Stack_Operation_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T15:55:17-08:00
cleaned_at: 2026-02-14T17:52:50-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 2D 1 byte 4 cycles Stack - X 4D 1 byte 4 cycles Stack - Y 6D 1 byte 4 cycles Stack

\- PSW

0D 1 byte 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**PUSH** is an SPC700 command that pushes the value of a register to the stack. The register can be:

- the accumulator
- the X index register
- the Y index register
- the program status word

The stack pointer is decremented by one after the value is transferred. No flags are affected.

#### Syntax

```
PUSH A
PUSH X
PUSH Y
PUSH PSW
```

### See Also

- POP
- PHA
- PHX
- PHY
- PHP

### References

- Table C-17 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234) of the official Super Nintendo development manual
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L541](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L541)
