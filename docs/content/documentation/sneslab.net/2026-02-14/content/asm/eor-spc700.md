---
title: "EOR (SPC700)"
reference_url: https://sneslab.net/wiki/EOR_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "8-bit_Logic_Operation_Commands"
downloaded_at: 2026-02-14T11:54:23-08:00
cleaned_at: 2026-02-14T17:51:53-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 48 2 bytes 2 cycles Implied Indirect (type 2) 46 1 byte 3 cycles Direct Page 44 2 bytes 3 cycles Direct Page Indexed by X 54 2 bytes 4 cycles Absolute 45 3 bytes 4 cycles Absolute Indexed by X 55 3 bytes 5 cycles Absolute Indexed by Y 56 3 bytes 5 cycles Direct Page Indexed Indirect by X 47 2 bytes 6 cycles Direct Page Indirect Indexed by Y 57 2 bytes 6 cycles Implied Indirect (type 1) 59 1 bytes 5 cycles Direct Page 49 3 bytes 6 cycles Direct Page Immediate 58 3 bytes 5 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**EOR** is an SPC700 instruction that performs an exclusive or.

The operands are stored in the instruction stream in the opposite order they appear in the assembler source. In the assembler source, the operand on the right is the source and the operand on the left is the destination.

#### Syntax

```
EOR A, #imm
EOR A, (X)
EOR A, dp
EOR A, dp+X
EOR A, !abs
EOR A, !abs+X
EOR A, !abs+Y
EOR A, [dp+X]
EOR A, [dp]+Y
EOR (X), (Y)
EOR dp<d>, dp<s>
EOR dp, #imm
```

### See Also

- EOR1
- AND (SPC700)
- OR (SPC700)
- EOR

### External Links

- Official Super Nintendo development manual on EOR: [Appendix C-6 of Book I](https://archive.org/details/SNESDevManual/book1/page/n231)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L430](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L430)
