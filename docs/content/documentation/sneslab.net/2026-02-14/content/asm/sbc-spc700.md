---
title: "SBC (SPC700)"
reference_url: https://sneslab.net/wiki/SBC_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "8-bit_Arithmetic_Operation_Commands"
downloaded_at: 2026-02-14T16:18:27-08:00
cleaned_at: 2026-02-14T17:53:01-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate A8 2 bytes 2 cycles Implied Indirect (type 1) A6 1 byte 3 cycles Direct Page A4 2 bytes 3 cycles Direct Page Indexed by X B4 2 bytes 4 cycles Absolute A5 3 bytes 4 cycles Absolute Indexed by X B5 3 bytes 5 cycles Absolute Indexed by Y B6 3 bytes 5 cycles Direct Page Indexed by X A7 2 bytes 6 cycles Direct Page Indirect Indexed by Y B7 2 bytes 6 cycles Implied Indirect (type 1) B9 1 byte 5 cycles Direct Page A9 3 bytes 6 cycles Direct Page Immediate B8 3 bytes 5 cycles

Flags Affected N V P B H I Z C N V . . H . Z C

**SBC** (Subtract) is an SPC700 instruction that subtracts the right operand and the inverse of the carry flag from the left operand. Often, the left operand is the accumulator.

The operands are stored in the instruction stream in the opposite order they appear in the assembler source. In the assembler source, the operand on the right is the source and the operand on the left is the destination.

#### Syntax

```
SBC A, #imm
SBC A, (X)
SBC A, dp
SBC A, dp+X
SBC A, !abs
SBC A, !abs+X
SBC A, !abs+Y
SBC A, [dp+X]
SBC A, [dp]+Y
SBC (X), (Y)
SBC dp<d>, dp<s>
SBC dp, #imm
```

Unlike the 65c816, the SPC700 has no decimal mode, so the subtraction is always done in binary/hexadecimal. Use DAS after subtracting BCD-encoded data to repair it back to BCD.

### See Also

- ADC (SPC700)
- SBC
- SUBW

### External Links

- Official Super Nintendo development manual on SBC: Table C-7 in [Appendix C-5 of Book I](https://archive.org/details/SNESDevManual/book1/page/n230)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L559](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L559)
