---
title: "Immediate Addressing"
reference_url: https://sneslab.net/wiki/Immediate_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "Simple_Admodes"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T13:25:40-08:00
cleaned_at: 2026-02-14T17:52:03-08:00
---

**Immediate Addressing** is when the data to be operated on directly follows the opcode in the instruction steam. The immediate data is generally preceded by a # in the assembler source.\[7]

Supported by the following 65c816 instructions:

- ADC (opcode 69)
- SBC (opcode E9)
- EOR (opcode 49)
- AND (opcode 29)
- ORA (opcode 09)
- LDA (opcode A9)
- LDX (opcode A2)
- LDY (opcode A0)
- CMP (opcode C9)
- CPX (opcode E0)
- CPY (opcode C0)
- BIT (opcode 89)
- SEP (opcode E2)
- REP (opcode C2)

They are all either 2 or 3 bytes long.

The Super FX supports immediate addressing too:

- ADC
- ADD
- AND
- BIC
- SUB
- OR
- MULT
- IWT
- IBT
- LINK
- and presumably UMULT too

On the SPC700, "imm" means "8-bit immediate data."\[4] These commands support immediate data:

- MOV (Group 1)
- ADC
- SBC
- CMP
- AND
- OR
- EOR

#### Syntax

```
LDA #const
```

### See Also

- Implied Addressing
- Accumulator Addressing
- PEA

### References

1. Eyes & Lichty, [page 397](https://archive.org/details/0893037893ProgrammingThe65816/page/397)
2. lbid, [page 108](https://archive.org/details/0893037893ProgrammingThe65816/page/108)
3. Labiak, [page 209](https://archive.org/details/Programming_the_65816/page/n219)
4. [Appendix C-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n226) of the official Super Nintendo development manual
5. section 3.5.18 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
6. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.14](http://www.6502.org/tutorials/65c816opcodes.html#5.14)
7. [B-2](https://archive.org/details/mos_microcomputers_programming_manual/page/n203)
