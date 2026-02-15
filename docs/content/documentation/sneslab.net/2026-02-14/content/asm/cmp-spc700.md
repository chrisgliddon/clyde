---
title: "CMP (SPC700)"
reference_url: https://sneslab.net/wiki/CMP_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "8-bit_Arithmetic_Operation_Commands"
downloaded_at: 2026-02-14T11:22:53-08:00
cleaned_at: 2026-02-14T17:51:37-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 68 2 bytes 2 cycles Implied Indirect (type 1) 66 1 bytes 3 cycles Direct Page 64 2 bytes 3 cycles Direct Page Indexed by X 74 2 bytes 4 cycles Absolute 65 3 bytes 4 cycles Absolute Indexed by X 75 3 bytes 5 cycles Absolute Indexed by Y 76 3 bytes 5 cycles Direct Page Indexed Indirect by X 67 2 byte 6 cycles Direct Page Indirect Indexed by Y 77 2 bytes 6 cycles Implied Indirect (type 1) 79 1 bytes 5 cycles Direct Page 69 3 bytes 6 cycles Direct Page Immediate 78 3 bytes 5 cycles Immediate C8 2 bytes 2 cycles Direct Page 3E 2 bytes 3 cycles Absolute 1E 3 bytes 4 cycles Immediate AD 2 bytes 2 cycles Direct Page 7E 2 bytes 3 cycles Absolute 5E 3 bytes 4 cycles

Flags Affected N V P B H I Z C N . . . . . Z C

**CMP** is an SPC700 instruction that compares two operands. The right operand is subtracted from the left operand, but the difference is discarded - the side effect is the N, Z, and C flags being modified.

The operands are stored in the instruction stream in the opposite order they appear in the assembler source. In the assembler source, the operand on the right is the source and the operand on the left is the destination.

#### Syntax

```
CMP A, #imm
CMP A, (X)
CMP A, dp
CMP A, dp+X
CMP A, !abs
CMP A, !abs+X
CMP A, !abs+Y
CMP A, [dp+X]
CMP A, [dp]+Y
CMP (X), (Y)
CMP dp<d>, dp<s>
CMP dp, #imm
CMP X, dp
CMP X, !abs
CMP Y, #imm
CMP Y, dp
CMP Y, !abs
```

### See Also

- CMPW
- CMP
- CMP (Super FX)

### External Links

- Official Super Nintendo development manual on CMP: Table C-7 in [Appendix C-5 of Book I](https://archive.org/details/SNESDevManual/book1/page/n230)
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L388](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L388)
