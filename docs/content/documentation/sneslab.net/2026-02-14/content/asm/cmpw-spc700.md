---
title: "CMPW (SPC700)"
reference_url: https://sneslab.net/wiki/CMPW_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "16-bit_Operation_Commands"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:22:46-08:00
cleaned_at: 2026-02-14T17:51:38-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page 5A 2 bytes 4 cycles

Flags Affected N V P B H I Z C N . . . . . Z C

**CMPW** (Compare Word) is an SPC700 command that performs a comparsion between YA and a 16-bit word in the direct page. Internally, this is done by the ALU subtracting the direct page word from YA, but the difference is not stored anywhere - the side effect is the N, Z, and C flags being modified.

#### Syntax

```
CMPW YA, dp
```

### See Also

- CMP (SPC700)
- ADDW
- SUBW
- MOVW

### External Links

- Official Nintendo documentation on CMPW: Table C-12 in [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L407](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L407)
