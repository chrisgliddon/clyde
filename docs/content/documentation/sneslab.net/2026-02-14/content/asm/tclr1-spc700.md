---
title: "TCLR1 (SPC700)"
reference_url: https://sneslab.net/wiki/TCLR1_(SPC700)
categories:
  - "Three-byte_Instructions"
downloaded_at: 2026-02-14T16:57:43-08:00
cleaned_at: 2026-02-14T17:53:28-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 4E 3 bytes 6 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**TCLR1** is an SPC700 instruction that tests and clears memory bits using the accumulator. For every set bit in the accumulator, TCLR1 clears the corresponding memory bit.

#### Syntax

```
TCLR1 !abs
```

Where abs is any address in the whole 64K bank of ARAM.

### See Also

- TSET1
- CLR1
- TRB

### External Links

1. Official Nintendo documentation on TCLR1: Table C-18 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
2. subparagraph 8.2.3.2 of [page 3-8-8](https://archive.org/details/SNESDevManual/book1/page/n186), lbid.
3. anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L606](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L606)
