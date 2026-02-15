---
title: "Absolute Indirect Long Addressing"
reference_url: https://sneslab.net/wiki/Absolute_Indirect_Long_Addressing
categories:
  - "65c816_additions"
downloaded_at: 2026-02-14T10:53:44-08:00
cleaned_at: 2026-02-14T17:50:58-08:00
---

**Absolute Indirect Long Addressing** is supported only by JMP / JML (opcode DC).

The indirect address is located in bank 0.

#### Syntax

```
JMP [addr]
JML [addr]
JML (addr)
```

### See Also

- Absolute Indirect Addressing
- Absolute Addressing

### References

- Eyes & Lichty, [page 384](https://archive.org/details/0893037893ProgrammingThe65816/page/384)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.4](http://www.6502.org/tutorials/65c816opcodes.html#5.4)
