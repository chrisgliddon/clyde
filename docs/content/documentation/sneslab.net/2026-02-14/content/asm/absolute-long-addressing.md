---
title: "Absolute Long Addressing"
reference_url: https://sneslab.net/wiki/Absolute_Long_Addressing
categories:
  - "ASM"
downloaded_at: 2026-02-14T10:53:53-08:00
cleaned_at: 2026-02-14T17:50:59-08:00
---

**Absolute Long Addressing** is supported by ten instructions:

- ADC (opcode 6F)
- SBC (opcode EF)
- AND (opcode 2F)
- ORA (opcode 0F)
- LDA (opcode AF)
- STA (opcode 8F)
- EOR (opcode 4F)
- CMP (opcode CF)
- JMP / JML (opcode 5C)
- JSR / JSL (opcode 22)

All are four bytes long. This is what the various operand bytes represent:

1. low byte of absolute address (byte within page)
2. high byte of absolute address (page number)
3. bank number

#### Syntax

```
LDA long
```

### See Also

- Absolute Addressing
- Absolute Indirect Long Addressing

### References

- Eyes & Lichty, [page 385](https://archive.org/details/0893037893ProgrammingThe65816/page/385)
- section 3.5.7 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.16](http://www.6502.org/tutorials/65c816opcodes.html#5.16)
