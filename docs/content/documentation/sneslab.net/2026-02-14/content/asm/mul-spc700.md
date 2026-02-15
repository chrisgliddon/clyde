---
title: "MUL (SPC700)"
reference_url: https://sneslab.net/wiki/MUL_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Multiplication_and_Division_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T14:56:59-08:00
cleaned_at: 2026-02-14T17:52:28-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) CF 1 byte 9 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**MUL** is an SPC700 instruction that multiplies the value in the Y index register by the value in the accumulator and stores the product in YA. The high byte of the product is stored in Y and the low byte is stored in A.\[2]

#### Syntax

```
MUL
```

### See Also

- DIV
- ADC (SPC700)
- SBC (SPC700)
- MULT
- UMULT

### External Links

1. Official Super Nintendo development manual on MUL: Table C-13, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
2. [https://forums.nesdev.org/viewtopic.php?p=141221#p141221](https://forums.nesdev.org/viewtopic.php?p=141221#p141221)
3. [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L510](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L510)
