---
title: "Implied Addressing"
reference_url: https://sneslab.net/wiki/Implied_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "Simple_Admodes"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T13:25:58-08:00
cleaned_at: 2026-02-14T17:52:03-08:00
---

There are three types of **Implied Addressing** on the 65c816:

**Type 1** - The register(s) to be operated on are implied in the mnemonic: (17 instructions)

- DEX (opcode CA)
- DEY (opcode 88)
- INX (opcode E8)
- INY (opcode C8)
- TAX (opcode AA)
- TAY (opcode A8)
- TCD (opcode 5B)
- TSC (opcode 3B)
- TDC (opcode 7B)
- TSC (opcode 3B)
- TSX (opcode BA)
- TXA (opcode 8A)
- TXS (opcode 9A)
- TXY (opcode 9B)
- TYA (opcode 98)
- TYX (opcode BB)
- XBA (opcode EB)

**Type 2** - The flag(s) to be operated on are implied in the mnemonic: (8 instructions)

- CLC (opcode 18)
- CLD (opcode D8)
- CLI (opcode 58)
- CLV (opcode B8)
- SEC (opcode 38)
- SED (opcode F8)
- SEI (opcode 78)
- XCE (opcode FB)

**Type 3** - Neither flags nor registers operated on: (4 instructions)

- NOP (opcode EA)
- STP (opcode DB)
- WAI (opcode CB)
- WDM (opcode 42)

All implied instructions on the 65c816 except for WDM are one byte long. They also all only have one addressing mode.

#### Syntax

```
CLC
```

### See Also

- Accumulator Addressing
- Immediate Addressing

### References

- Eyes & Lichty, [page 398](https://archive.org/details/0893037893ProgrammingThe65816/page/398)
- [page 127](https://archive.org/details/0893037893ProgrammingThe65816/page/127), lbid
- section 3.5.19 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.15](http://www.6502.org/tutorials/65c816opcodes.html#5.15)
