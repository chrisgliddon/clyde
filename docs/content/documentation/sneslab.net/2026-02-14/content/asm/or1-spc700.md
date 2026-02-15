---
title: "OR1 (SPC700)"
reference_url: https://sneslab.net/wiki/OR1_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Bit_Operation_Commands"
  - "Three-byte_Instructions"
downloaded_at: 2026-02-14T15:45:39-08:00
cleaned_at: 2026-02-14T17:52:37-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute Boolean Bit 0A 3 bytes 5 cycles Absolute Boolean Bit 2A 3 bytes 5 cycles

Flags Affected N V P B H I Z C . . . . . . . C

**OR1** is an SPC700 instruction that performs a logical or between a memory bit and the carry flag, then stores the disjunction in the carry flag. The low 13 bits of the operand byte specify an absolute address. The high 3 bits of the operand byte specify which bit at that absolute address.

The bit reversal operator may be prefixed to the memory bit address, in which case opcode 2A is assembled.

#### Syntax

```
OR1 C, mem. bit
OR1 C, /mem. bit
```

### See Also

- OR (SPC700)
- AND1
- EOR1
- MOV1
- NOT1

### External Links

- Official Super Nintendo development manual on OR1: [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
- subparagraph 8.2.3.3 of [page 3-8-8](https://archive.org/details/SNESDevManual/book1/page/n186), lbid.
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L531](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L531)
