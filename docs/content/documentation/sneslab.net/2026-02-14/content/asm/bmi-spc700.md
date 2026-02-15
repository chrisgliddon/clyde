---
title: "BMI (SPC700)"
reference_url: https://sneslab.net/wiki/BMI_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
downloaded_at: 2026-02-14T11:03:58-08:00
cleaned_at: 2026-02-14T17:51:18-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 30 2 bytes when condition is false: 2 cycles

when condition is true: 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BMI** is an SPC700 instruction that performs a branch when the negative flag is set.

No flags are affected.

#### Syntax

```
BMI rel
```

Where rel is a two's complement offset.

### See Also

- BPL (SPC700)
- BMI

### External Links

- Official Super Nintendo development manual on BMI: Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L361](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L361)
