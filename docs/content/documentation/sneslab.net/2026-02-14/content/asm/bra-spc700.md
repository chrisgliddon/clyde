---
title: "BRA (SPC700)"
reference_url: https://sneslab.net/wiki/BRA_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:05:05-08:00
cleaned_at: 2026-02-14T17:51:22-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 2F 2 bytes 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BRA** is an SPC700 instruction that performs an unconditional branch.

No flags are affected.

#### Syntax

```
BRA rel
```

Where rel is a two's complement offset.

### See Also

- BRA
- JMP (SPC700)

### External Links

- Official Super Nintendo development manual on BRA: Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L366](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L366)
