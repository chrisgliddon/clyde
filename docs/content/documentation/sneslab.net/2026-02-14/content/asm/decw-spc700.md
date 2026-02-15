---
title: "DECW (SPC700)"
reference_url: https://sneslab.net/wiki/DECW_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "16-bit_Operation_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:34:50-08:00
cleaned_at: 2026-02-14T17:51:45-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page 1A 2 bytes 6 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**DECW** is an SPC700 command that decrements a 16-bit word of the direct page.

#### Syntax

```
DECW dp
```

### See Also

- INCW
- MOVW
- DEC (SPC700)
- DEC
- Memory Pair

### External Links

- Official Super Nintendo development manual on DECW: Table C-12 in [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L422](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L422)
