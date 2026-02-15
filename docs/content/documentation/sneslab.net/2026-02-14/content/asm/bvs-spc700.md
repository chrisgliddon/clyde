---
title: "BVS (SPC700)"
reference_url: https://sneslab.net/wiki/BVS_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:06:35-08:00
cleaned_at: 2026-02-14T17:51:27-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 70 2 byte when condition false: 2 cycles

when condition true: 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BVS** is an SPC700 instruction that performs a branch when the overflow flag is set.

No flags are affected.

#### Syntax

```
BVS rel
```

Where rel is a two's complement offset.

### See Also

- BVS
- BVC (SPC700)

### External Links

- Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233) of the official Super Nintendo development manual
