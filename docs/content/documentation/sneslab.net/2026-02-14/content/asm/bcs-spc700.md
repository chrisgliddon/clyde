---
title: "BCS (SPC700)"
reference_url: https://sneslab.net/wiki/BCS_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:00:36-08:00
cleaned_at: 2026-02-14T17:51:13-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative B0 2 bytes when condition false: 2 cycles

when condition true: 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BCS** is an SPC700 instruction that performs a branch when the carry flag is set. If the carry flag is clear, control simply falls through BCS to the next instruction.

No flags are affected.

#### Syntax

```
BCS rel
```

Where rel is a two's complement offset.

### See Also

- BCS
- BCC (SPC700)

### External Links

- Official Super Nintendo development manual on BCS: Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L359](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L359)
