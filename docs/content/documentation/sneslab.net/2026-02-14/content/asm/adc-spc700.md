---
title: "ADC (SPC700)"
reference_url: https://sneslab.net/wiki/ADC_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "8-bit_Arithmetic_Operation_Commands"
downloaded_at: 2026-02-14T10:46:43-08:00
cleaned_at: 2026-02-14T17:51:01-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 88 2 bytes 2 cycles Implied (type 1) 86 1 byte 3 cycles Direct Page 84 2 bytes 3 cycles Direct Page Indexed by X 94 2 bytes 3 cycles Absolute 85 3 bytes 4 cycles Absolute Indexed by X 95 3 bytes 5 cycles Absolute Indexed by Y 96 3 bytes 5 cycles Direct Page Indexed by X 87 2 bytes 6 cycles Direct Page Indirect Indexed by Y 97 2 bytes 6 cycles Implied (type 1) 99 1 byte 5 cycles Direct Page 89 3 bytes 6 cycles Direct Page Immediate 98 3 bytes 5 cycles

Flags Affected N V P B H I Z C N V . . H . Z C

**ADC** (Add with Carry) is an SPC700 instruction that adds the value of the two operands together (along with the carry flag) and stores the sum in the left operand. Often, the left operand is the accumulator.

The operands are stored in the instruction stream in the opposite order they appear in the assembler source. In the assembler source, the operand on the right is the source and the operand on the left is the destination.

#### Syntax

```
ADC A, #imm
ADC A, (X)
ADC A, dp
ADC A, dp+X
ADC A, !abs
ADC A, !abs+X
ADC A, !abs+Y
ADC A, [dp+X]
ADC A, [dp]+Y
ADC (X), (Y)
ADC dp<d>, dp<s>
ADC dp, #imm
```

Unlike the 65c816, the SPC700 has no decimal mode, so the addition is always done in binary/hexadecimal. Use DAA after adding BCD-encoded data to repair it back to BCD.

### See Also

- SBC (SPC700)
- CLRC
- ADDW
- ADC

### External Links

- Official Super Nintendo development manual on ADC: Table C-7 in [Appendix C-5 of Book I](https://archive.org/details/SNESDevManual/book1/page/n230)
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L304](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L304)
