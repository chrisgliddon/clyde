---
title: "AND (SPC700)"
reference_url: https://sneslab.net/wiki/AND_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "8-bit_Logic_Operation_Commands"
downloaded_at: 2026-02-14T10:49:08-08:00
cleaned_at: 2026-02-14T17:51:05-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 28 2 bytes 2 cycles Implied Indirect (type 1) 26 1 byte 3 cycles Direct Page 24 2 bytes 3 cycles Direct Page Indexed by X 34 2 bytes 4 cycles Absolute 25 3 bytes 4 cycles Absolute Indexed by X 35 3 bytes 5 cycles Absolute Indexed by Y 36 3 bytes 5 cycles Direct Page Indexed by X 27 2 bytes 6 cycles Direct Page Indirect Indexed by Y 37 2 bytes 6 cycles Implied Indirect (type 1) 39 1 bytes 5 cycles Direct Page 29 3 bytes 6 cycles Direct Page Immediate 38 3 bytes 5 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**AND** is an SPC700 instruction that performs a logical conjunction.

The operands are stored in the instruction stream in the opposite order they appear in the assembler source. In the assembler source, the operand on the right is the source and the operand on the left is the destination.

#### Syntax

```
AND A, #imm
AND A, (X)
AND A, dp
AND A, dp+X
AND A, !abs
AND A, !abs+X
AND A, !abs+Y
AND A, [dp+X]
AND A, [dp]+Y
AND (X), (Y)
AND dp<d>, dp<s>
AND dp, #imm
```

### See Also

- AND1
- OR (SPC700)
- EOR (SPC700)
- AND
- AND (Super FX)

### External Links

- Official Super Nintendo development manual on AND: Table C-8 in [Appendix C-6 of Book I](https://archive.org/details/SNESDevManual/book1/page/n231)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L319](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L319)
