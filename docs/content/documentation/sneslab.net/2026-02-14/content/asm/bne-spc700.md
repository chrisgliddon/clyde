---
title: "BNE (SPC700)"
reference_url: https://sneslab.net/wiki/BNE_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:04:10-08:00
cleaned_at: 2026-02-14T17:51:19-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative D0 2 bytes when condition false: 2 cycles

when condition true: 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BNE** is an SPC700 instruction that performs a branch when the zero flag is clear. When the zero flag is set, nothing happens.

No flags are affected.

#### Syntax

```
BNE rel
```

Where rel is a two's complement offset.

### See Also

- BNE
- BEQ (SPC700)

### External Links

- Official Super Nintendo development manual on BNE: Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L362](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L362)
