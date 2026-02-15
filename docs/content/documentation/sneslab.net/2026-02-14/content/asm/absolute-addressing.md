---
title: "Absolute Addressing"
reference_url: https://sneslab.net/wiki/Absolute_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "Simple_Admodes"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T10:52:30-08:00
cleaned_at: 2026-02-14T17:50:56-08:00
---

**Absolute addressing** wraps within bank 0.\[4] The effective addresses generated are 16-bit.

#### Syntax

```
LDA addr
```

Twenty six instructions support **absolute addressing**:

- ADC (opcode 6D)
- AND (opcode 2D)
- ASL (opcode 0E)
- BIT (opcode 2C)
- CMP (opcode CD)
- CPX (opcode EC)
- CPY (opcode CC)
- DEC (opcode CE)
- EOR (opcode 4D)
- INC (opcode EE)
- LDA (opcode AD)
- LDX (opcode AE)
- LDY (opcode AC)
- LSR (opcode 4E)
- ORA (opcode 0D)
- ROL (opcode 2E)
- ROR (opcode 6E)
- SBC (opcode ED)
- STA (opcode 8D)
- STX (opcode 8E)
- STY (opcode 8C)
- STZ (opcode 9C)
- TRB (opcode 1C)
- TSB (opcode 0C)
- JMP (opcode 4C)
- JSR (opcode 20)

On the SPC700, operands which use absolute addressing are prefixed with an exclamation point (!).

The [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)") 6502 textbook also refers to absolute addressing as "direct", but this usage is discouraged on the 65c816 to avoid confusion with direct page addressing.

There is no syntax to differentiate between absolute and [relative addressing](/mw/index.php?title=relative_addressing&action=edit&redlink=1 "relative addressing (page does not exist)").\[5]

### See Also

- Absolute Long Addressing
- Absolute Indirect Addressing

### References

1. Eyes & Lichty, [page 379](https://archive.org/details/0893037893ProgrammingThe65816/page/379)
2. lbid, [page 111](https://archive.org/details/0893037893ProgrammingThe65816/page/111)
3. section 3.5.1 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
4. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.1.2](http://www.6502.org/tutorials/65c816opcodes.html#5.1.2)
5. lbid, [http://www.6502.org/tutorials/65c816opcodes.html#6.8.1](http://www.6502.org/tutorials/65c816opcodes.html#6.8.1)
