---
title: "MOV1 (SPC700)"
reference_url: https://sneslab.net/wiki/MOV1_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Bit_Operation_Commands"
  - "Three-byte_Instructions"
downloaded_at: 2026-02-14T13:48:04-08:00
cleaned_at: 2026-02-14T17:52:24-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute Boolean Bit AA 3 bytes 4 cycles Absolute Boolean Bit CA 3 bytes 6 cycles

Flags Affected Direction N V P B H I Z C to carry . . . . . . . C from carry . . . . . . . .

**MOV1** is an SPC700 command that moves a memory bit to or from the carry flag. The low 13 bits of the operand byte specify an absolute address. The high 3 bits of the operand byte specify which bit at that absolute address.

The operands are stored in the instruction stream in the opposite order they appear in the assembler source. In the assembler source, the operand on the right is the source and the operand on the left is the destination.

No flags are affected except when moving to the carry flag.

#### Syntax

```
MOV1 C, mem. bit
MOV1 mem. bit, C
```

### See Also

- MOVW
- MOV
- AND1
- OR1
- EOR1
- NOT1

### External Links

- Official Super Nintendo development manual on MOV1: Table C-18 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
- subparagraph 8.2.3.3 of [page 3-8-8](https://archive.org/details/SNESDevManual/book1/page/n186), lbid.
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L504](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L504)
