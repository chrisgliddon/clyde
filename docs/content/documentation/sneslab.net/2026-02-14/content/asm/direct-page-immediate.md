---
title: "Direct Page Immediate"
reference_url: https://sneslab.net/wiki/Direct_Page_Immediate
categories:
  - "ASM"
  - "SPC700"
  - "Addressing_Modes"
  - "Scene_Slang"
downloaded_at: 2026-02-14T11:47:08-08:00
cleaned_at: 2026-02-14T17:51:49-08:00
---

Some SPC700 opcodes use both **Direct Page** and **Immediate** addressing.

As it appears in assembler source, the left operand is an index into the direct page, and the right operand is an immediate value.

The following opcodes support direct page immediate addressing:

- ADC (SPC700) (opcode 98h)
- AND (SPC700) (opcode 38h)
- SBC (SPC700) (opcode B8h)
- OR (SPC700) (opcode 18h)
- EOR (SPC700) (opcode 58h)
- CMP (SPC700) (opcode 78h)
- MOV (opcode 8Fh)

#### Syntax

```
ADC dp, #imm
AND dp, #imm
SBC dp, #imm
OR dp, #imm
EOR dp, #imm
CMP dp, #imm
MOV dp, #imm
```

### See Also

- Direct Page Addressing
- Direct Page Bit Addressing
- Direct Page Bit Relative Addressing

### Reference

- Figure 3-8-3 Memory Access Addressing Effective Address on [page 3-8-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n187) of the official Super Nintendo development manual
