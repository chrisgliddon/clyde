---
title: "TSET1 (SPC700)"
reference_url: https://sneslab.net/wiki/TSET1_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Bit_Operation_Commands"
  - "Three-byte_Instructions"
downloaded_at: 2026-02-14T17:00:01-08:00
cleaned_at: 2026-02-14T17:53:33-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 0E 3 bytes 6 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**TSET1** is an SPC700 instruction that tests and sets memory bits using the accumulator. For every set bit in the accumulator, TSET1 sets the corresponding memory bit. In other words, a logical OR is performed.

#### Syntax

```
TSET1 !abs
```

Where abs is any address in the whole 64K bank of ARAM.

### See Also

- TCLR1
- SET1
- TSB

### External Links

1. Official Super Nintendo development manual on TSET1: Table C-18 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
2. subparagraph 8.2.3.2 of [page 3-8-8](https://archive.org/details/SNESDevManual/book1/page/n186), lbid.
3. anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L607](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L607)
