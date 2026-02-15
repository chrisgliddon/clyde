---
title: "Direct Page Indirect Long Addressing"
reference_url: https://sneslab.net/wiki/Direct_Page_Indirect_Long_Addressing
categories:
  - "ASM"
downloaded_at: 2026-02-14T11:48:23-08:00
cleaned_at: 2026-02-14T17:50:54-08:00
---

**Direct Page Indirect Long Addressing** is supported by eight instructions:

- ADC (opcode 67)
- AND (opcode 27)
- CMP (opcode C7)
- EOR (opcode 47)
- LDA (opcode A7)
- ORA (opcode 07)
- SBC (opcode E7)
- STA (opcode 87)

The **indirect address** is located in the direct page.

#### Syntax

```
LDA [dp]
```

### See Also

- Direct Page Indirect Addressing
- Direct Page Addressing

### References

- Eyes & Lichty, [page 394](https://archive.org/details/0893037893ProgrammingThe65816/page/394)
- section 3.5.15 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
