---
title: "Absolute Indirect Addressing"
reference_url: https://sneslab.net/wiki/Absolute_Indirect_Addressing
categories:
  - "ASM"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T10:53:34-08:00
cleaned_at: 2026-02-14T17:50:51-08:00
---

**Absolute Indirect Addressing** is supported only by JMP (opcode 6C).

The **indirect address** is located in bank 0. It is concatenated to the program bank register to form the 24-bit **effective address**.

#### Syntax

```
 JMP (addr)
```

### See Also

- Absolute Indirect Long Addressing
- Absolute Addressing

### References

- Eyes & Lichty, [page 383](https://archive.org/details/0893037893ProgrammingThe65816/page/383)
- section 3.5.5 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.4](http://www.6502.org/tutorials/65c816opcodes.html#5.4)
