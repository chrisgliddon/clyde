---
title: "NOT1 (SPC700)"
reference_url: https://sneslab.net/wiki/NOT1_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Bit_Operation_Commands"
  - "Three-byte_Instructions"
downloaded_at: 2026-02-14T15:41:22-08:00
cleaned_at: 2026-02-14T17:52:34-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute Boolean Bit EA 3 bytes 5 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**NOT1** is an SPC700 instruction that flips a bit. The low 13 bits of the operand specify an absolute address. The high 3 bits of the operand specify which bit at that absolute address. The bit flipped can live at any ARAM address from 0000h to 1fffh.

No flags are affected.

#### Syntax

```
NOT1 mem. bit
```

### See Also

- NOTC
- OR1
- AND1
- EOR1
- MOV1

### External Links

- Official Nintendo documentation on NOT1: Table C-18 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
- subparagraph 8.2.3.3 of [page 3-8-8](https://archive.org/details/SNESDevManual/book1/page/n186), lbid.
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L514](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L514)
