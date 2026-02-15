---
title: "Absolute Indexed, X Addressing"
reference_url: https://sneslab.net/wiki/Absolute_Indexed,_X_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "Complex_Admodes"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T10:52:53-08:00
cleaned_at: 2026-02-14T17:50:58-08:00
---

**Absolute Indexed, X Addressing** is supported by 17 instructions:

- ADC (opcode 7D)
- AND (opcode 3D)
- ASL (opcode 1E)
- BIT (opcode 3C)
- CMP (opcode DD)
- DEC (opcode DE)
- EOR (opcode 5D)
- INC (opcode FE)
- LDA (opcode BD)
- LDY (opcode BC)
- LSR (opcode 5E)
- ORA (opcode 1D)
- ROL (opcode 3E)
- ROR (opcode 7E)
- SBC (opcode FD)
- STA (opcode 9D)
- STZ (opcode 9E)

#### Syntax

```
LDA addr, X
```

### See Also

- Absolute Indexed, Y Addressing
- Absolute Addressing

### References

- Eyes & Lichty, [page 380](https://archive.org/details/0893037893ProgrammingThe65816/page/380)
- section 3.5.3 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.3](http://www.6502.org/tutorials/65c816opcodes.html#5.3)
