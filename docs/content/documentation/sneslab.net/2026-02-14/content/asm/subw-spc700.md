---
title: "SUBW (SPC700)"
reference_url: https://sneslab.net/wiki/SUBW_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "16-bit_Operation_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T16:40:38-08:00
cleaned_at: 2026-02-14T17:53:23-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page 9A 2 bytes 5 cycles

Flags Affected N V P B H I Z C N V . . H . Z C

**SUBW** (Subtract Word) is an SPC700 command that subtracts a 16-bit direct page word from YA. The difference is stored in YA.

#### Syntax

```
SUBW YA, dp
```

### See Also

- ADDW
- CMPW
- MOVW
- SBC (SPC700)

### External Links

- Official Super Nintendo development manual on SUBW: Table C-12 in [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L587](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L587)
