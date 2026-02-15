---
title: "BPL (SPC700)"
reference_url: https://sneslab.net/wiki/BPL_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
downloaded_at: 2026-02-14T11:04:29-08:00
cleaned_at: 2026-02-14T17:51:21-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 10 2 bytes when condition is false: 2 cycles

when condition is true: 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BPL** (Branch Plus) is an SPC700 instruction that performs a branch when the negative flag is clear. Note that zero is considered positive.

No flags are affected.

#### Syntax

```
BPL rel
```

Where rel is a two's complement offset.

### See Also

- BMI (SPC700)
- BPL

### References

- Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233) of the official Super Nintendo development manual
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L363](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L363)
