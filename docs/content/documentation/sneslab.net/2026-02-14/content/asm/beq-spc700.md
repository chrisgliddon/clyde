---
title: "BEQ (SPC700)"
reference_url: https://sneslab.net/wiki/BEQ_(SPC700)
categories:
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:01:22-08:00
cleaned_at: 2026-02-14T17:51:14-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative F0 2 bytes when condition false: 2 cycles

when condition true: 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BEQ** is an SPC700 instruction that performs a branch when the zero flag is set. If the zero flag is clear, control simply falls through BEQ to the next instruction.

No flags are affected.

#### Syntax

```
BEQ rel
```

Where rel is a two's complement offset.

### See Also

- BEQ
- BNE (SPC700)

### External Links

- Official Super Nintendo development manual on BEQ: Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L360](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L360)
