---
title: "BVC (SPC700)"
reference_url: https://sneslab.net/wiki/BVC_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:06:19-08:00
cleaned_at: 2026-02-14T17:51:25-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 50 2 bytes when condition false: 2 cycles

when condition true: 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BVC** is an SPC700 instruction that performs a branch when the overflow flag is clear.

No flags are affected.

#### Syntax

```
BVC rel
```

Where rel is a two's complement offset.

### See Also

- BVS (SPC700)
- BVC
- CLRV

### External Links

- Official Super Nintendo development manual on BVC: Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L364](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L364)
