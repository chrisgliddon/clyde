---
title: "BCC (SPC700)"
reference_url: https://sneslab.net/wiki/BCC_(SPC700)
categories:
  - "Branching_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:00:11-08:00
cleaned_at: 2026-02-14T17:51:12-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 90 2 bytes when condition false: 2 cycles

when condition true: 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BCC** is an SPC700 instruction that performs a branch when the carry flag is clear. If the carry flag is set, control simply falls through BCC to the next instruction.

No flags are affected.

#### Syntax

```
BCC rel
```

Where rel is a two's complement offset.

### See Also

- BCC
- BCS (SPC700)

### External Links

- Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233) of the official Super Nintendo development manual
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L358](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L358)
