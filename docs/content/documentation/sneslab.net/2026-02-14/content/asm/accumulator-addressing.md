---
title: "Accumulator Addressing"
reference_url: https://sneslab.net/wiki/Accumulator_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "Simple_Admodes"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T10:54:20-08:00
cleaned_at: 2026-02-14T17:50:59-08:00
---

The 65c816 has six instructions that support **Accumulator Addressing**:

- ASL (opcode 0A)
- DEC (opcode 3A)
- INC (opcode 1A)
- LSR (opcode 4A)
- ROL (opcode 2A)
- ROR (opcode 6A)

They all are one byte long. None of them write to or read from external memory. They are all read-modify-write instructions.

In this admode, the accumulator is the operand.\[3] In native mode when the m flag is clear, the accumulator is 16 bits wide. Otherwise it is 8 bit (when m is set or in emulation mode).

#### Syntax

```
ROR
RORA
ROR A
```

Interestingly, XBA is not considered to use accumulator addressing, perhaps because when the high B byte is hidden it is not a proper accumulator and other instructions do not operate on it. Less surprisingly, neither are the transfer instructions which include the accumulator as an operand. But XCN on the SPC700 is considered to use accumulator addressing; it does not operate on any other data.

### See Also

- Implied Addressing
- Immediate Addressing

### References

1. Eyes & Lichty, [page 387](https://archive.org/details/0893037893ProgrammingThe65816/page/387)
2. [page 126](https://archive.org/details/0893037893ProgrammingThe65816/page/126), lbid
3. section 3.5.8 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
4. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.6](http://www.6502.org/tutorials/65c816opcodes.html#5.6)
