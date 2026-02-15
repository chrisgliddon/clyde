---
title: "EOR1 (SPC700)"
reference_url: https://sneslab.net/wiki/EOR1_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Bit_Operation_Commands"
  - "Three-byte_Instructions"
downloaded_at: 2026-02-14T11:54:17-08:00
cleaned_at: 2026-02-14T17:51:54-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute Boolean Bit 8A 3 bytes 5 cycles

Flags Affected N V P B H I Z C . . . . . . . C

**EOR1** is an SPC700 instruction that performs an exclusive or between a memory bit and the carry flag and stores the sum in the carry flag. The low 13 bits of the operand specify an absolute address. The high 3 bits of the operand specify which bit at that absolute address.

#### Syntax

```
EOR1 C, mem. bit
```

### See Also

- AND1
- OR1
- NOT1
- MOV1
- EOR

### External Links

- Official Super Nintendo development manual on EOR1: Table C-18 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
- subparagraph 8.2.3.3 of [page 3-8-8](https://archive.org/details/SNESDevManual/book1/page/n186), lbid.
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L443](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L443)
