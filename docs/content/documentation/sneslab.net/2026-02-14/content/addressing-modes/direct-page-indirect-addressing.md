---
title: "Direct Page Indirect Addressing"
reference_url: https://sneslab.net/wiki/Direct_Page_Indirect_Addressing
categories:
  - "ASM"
downloaded_at: 2026-02-14T11:48:00-08:00
cleaned_at: 2026-02-14T17:50:53-08:00
---

**Direct Page Indirect Addressing** is supported by eight instructions:

- ADC (opcode 72)
- AND (opcode 32)
- CMP (opcode D2)
- EOR (opcode 52)
- LDA (opcode B2)
- ORA (opcode 12)
- SBC (opcode F2)
- STA (opcode 92)

#### Syntax

```
LDA (dp)
```

In the above example, the 16-bit address stored at location dp of the direct page is fetched, and then the accumulator is loaded with the byte that lives at that address.

In emulation mode, the 16-bit pointer can't straddle a page boundary.\[4]

### See Also

- Direct Page Indirect Long Addressing
- Direct Page Addressing

### References

1. Eyes & Lichty, [page 393](https://archive.org/details/0893037893ProgrammingThe65816/page/393)
2. [page 128](https://archive.org/details/0893037893ProgrammingThe65816/page/128), lbid
3. section 3.5.16 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
4. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.9](http://www.6502.org/tutorials/65c816opcodes.html#5.9)
