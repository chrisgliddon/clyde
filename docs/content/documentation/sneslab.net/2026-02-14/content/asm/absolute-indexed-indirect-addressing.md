---
title: "Absolute Indexed Indirect Addressing"
reference_url: https://sneslab.net/wiki/Absolute_Indexed_Indirect_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "Complex_Admodes"
  - "65c02_additions"
downloaded_at: 2026-02-14T10:53:16-08:00
cleaned_at: 2026-02-14T17:50:57-08:00
---

**Absolute Indexed Indirect Addressing** is supported by two instructions:

- JMP (opcode 7C)
- JSR (opcode FC)

#### Syntax

```
JMP (addr, X)
JSR (addr, X)
```

### See Also

- Absolute Addressing

### References

- Eyes & Lichty, [page 382](https://archive.org/details/0893037893ProgrammingThe65816/page/382)
- section 3.5.2 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
