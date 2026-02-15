---
title: "Indirect Addressing"
reference_url: https://sneslab.net/wiki/Indirect_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "SPC700"
downloaded_at: 2026-02-14T13:26:27-08:00
cleaned_at: 2026-02-14T17:52:06-08:00
---

**Indirect Addressing** is used by some one-byte SPC700 instructions. Usually, the accumulator appears as the first operand in the assembler source, with the other operand being the X index register, which is interpreted as a pointer. These eight opcodes use indirect addressing:

- MOV (opcodes E6 and C6)
- AND (opcode 26)
- OR (opcode 06)
- EOR (opcode 46)
- ADC (opcode 86)
- SBC (opcode A6)
- CMP (opcode 66)

In the above list, MOV is the only mnemonic that can take the accumulator as the second operand.

Some of the above mnemonics have an opcode where both operands utilize indirect addressing, in which case the whole instruction is considered to use [Indirect Page to I.P. Addressing](/mw/index.php?title=Indirect_Page_to_I.P._Addressing&action=edit&redlink=1 "Indirect Page to I.P. Addressing (page does not exist)").

#### Symbol

```
(X)
```

### See Also

- Absolute Indirect Addressing
- Absolute Indirect Long Addressing
- Direct Page Indirect Addressing
- Direct Page Indirect Indexed, Y Addressing
- Direct Page Indirect Long Addressing
- Direct Page Indirect Long Indexed, Y Addressing

### References

- Figure 3-8-3 Memory Access Addressing Effective Address on [page 3-8-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n187) of the official Super Nintendo development manual
- Eyes & Lichty, [page 37](https://archive.org/details/0893037893ProgrammingThe65816/page/37)
