---
title: "Absolute Long Indexed, X Addressing"
reference_url: https://sneslab.net/wiki/Absolute_Long_Indexed,_X_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "Complex_Admodes"
  - "65c816_additions"
downloaded_at: 2026-02-14T10:53:57-08:00
cleaned_at: 2026-02-14T17:50:59-08:00
---

**Absolute Long Indexed, X Addressing** is supported by eight instructions:

- ADC (opcode 7F)
- AND (opcode 3F)
- CMP (opcode DF)
- EOR (opcode 5F)
- LDA (opcode BF)
- ORA (opcode 1F)
- SBC (opcode FF)
- STA (opcode 9F)

These opcodes replaced the 65c02's BBR and BBS.

#### Syntax

```
LDA long, X
```

### See Also

- Absolute Long Addressing

### References

- Eyes & Lichty, [page 386](https://archive.org/details/0893037893ProgrammingThe65816/page/386)
- section 3.5.6 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.17](http://www.6502.org/tutorials/65c816opcodes.html#5.17)
