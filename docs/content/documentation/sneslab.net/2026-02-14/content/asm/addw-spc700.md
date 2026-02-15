---
title: "ADDW (SPC700)"
reference_url: https://sneslab.net/wiki/ADDW_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "16-bit_Operation_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T10:47:10-08:00
cleaned_at: 2026-02-14T17:51:03-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page 7A 2 bytes 5 cycles

Flags Affected N V P B H I Z C N V . . H . Z C

**ADDW** (Add Word) is an SPC700 command that adds a 16-bit direct page value to YA. The sum is stored in YA.

#### Syntax

```
ADDW YA, dp
```

### See Also

- SUBW
- CMPW
- MOVW
- ADC (SPC700)

### External Links

- Official Super Nintendo development manual on ADDW: Table C-12 in [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L317](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L317)
