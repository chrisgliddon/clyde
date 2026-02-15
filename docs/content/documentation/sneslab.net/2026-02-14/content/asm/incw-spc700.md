---
title: "INCW (SPC700)"
reference_url: https://sneslab.net/wiki/INCW_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "16-bit_Operation_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T13:22:40-08:00
cleaned_at: 2026-02-14T17:52:05-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page 3A 2 bytes 6 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**INCW** is an SPC700 command that increments a 16-bit word of the direct page.

#### Syntax

```
INCW dp
```

### See Also

- DECW
- MOVW
- INC (SPC700)
- INC
- Memory Pair

### External Links

- Official Super Nintendo development manual on INCW: Table C-12 in [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L452](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L452)
