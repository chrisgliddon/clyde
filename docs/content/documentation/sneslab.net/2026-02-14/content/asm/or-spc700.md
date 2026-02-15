---
title: "OR (SPC700)"
reference_url: https://sneslab.net/wiki/OR_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "8-bit_Logic_Operation_Commands"
  - "Read-Modify-Write_Instructions"
downloaded_at: 2026-02-14T15:45:58-08:00
cleaned_at: 2026-02-14T17:52:36-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 08 2 bytes 2 cycles Implied (type 1) 06 1 byte 3 cycles Direct Page 04 2 bytes 3 cycles Direct Page Indexed by X 14 2 bytes 4 cycles Absolute 05 3 bytes 4 cycles Absolute Indexed by X 15 3 bytes 5 cycles Absolute Indexed by Y 16 3 bytes 5 cycles Direct Page Indexed by X 07 2 bytes 6 cycles Direct Page Indirect Indexed by Y 17 2 bytes 6 cycles Implied Indirect (type 1) 19 1 bytes 5 cycles Direct Page 09 3 bytes 6 cycles Direct Page Immediate 18 3 bytes 5 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**OR** is an SPC700 instruction that performs a logical or.

The operands are stored in the instruction stream in the opposite order they appear in the assembler source. In the assembler source, the operand on the right is the source and the operand on the left is the destination.

#### Syntax

```
OR A, #imm
OR A, (X)
OR A, dp
OR A, dp+X
OR A, !abs
OR A, !abs+X
OR A, !abs+Y
OR A, [dp+X]
OR A, [dp]+Y
OR (X), (Y)
OR dp<d>, dp<s>
OR dp, #imm
```

### See Also

- OR1
- AND (SPC700)
- EOR (SPC700)
- OR (Super FX)

### External Links

- Official Super Nintendo development manual on OR: Table C-8 in [Appendix C-6 of Book I](https://archive.org/details/SNESDevManual/book1/page/n231)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L518](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L518)
