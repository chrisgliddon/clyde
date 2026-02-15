---
title: "AND1 (SPC700)"
reference_url: https://sneslab.net/wiki/AND1_(SPC700)
categories:
  - "Three-byte_Instructions"
  - "Bit_Operation_Commands"
downloaded_at: 2026-02-14T10:48:57-08:00
cleaned_at: 2026-02-14T17:51:07-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute Boolean Bit 4A 3 bytes 4 cycles Absolute Boolean Bit 6A 3 bytes 4 cycles

Flags Affected N V P B H I Z C . . . . . . . C

**AND1** is an SPC700 instruction that performs a logical AND between a memory bit and the carry flag, then stores the conjunction in the carry flag. The low 13 bits of the operand specify an absolute address. The high 3 bits of the operand specify which bit at that absolute address.

The bit reversal operator may be prefixed to the memory bit address, in which case opcode 6A is assembled.

#### Syntax

```
AND1 C, mem. bit
AND1 C, /mem. bit
```

### See Also

- AND (SPC700)
- OR1
- EOR1
- MOV1
- NOT1

### External Links

- Official Nintendo documentation on AND1: Table C-18 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
- subparagraph 8.2.3.3 of [page 3-8-8](https://archive.org/details/SNESDevManual/book1/page/n186), lbid.
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L332](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L332)
