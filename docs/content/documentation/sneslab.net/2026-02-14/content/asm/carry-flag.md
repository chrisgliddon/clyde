---
title: "Carry Flag"
reference_url: https://sneslab.net/wiki/Carry_Flag
categories:
  - "Inherited_from_6502"
  - "Condition_Codes"
downloaded_at: 2026-02-14T11:27:07-08:00
cleaned_at: 2026-02-14T17:51:30-08:00
---

The **Carry Flag** (C) is bit 0 of the 65c816's status register.

It can be set with SEC and cleared with CLC. Or, SEP and REP can be used.

The following other 10 instructions have side effects that directly affect the carry flag, which includes all arithmetic instructions (except those that can only increment/decrement by one) and all shift/rotate instructions:

- ADC (becomes set when an addition overflows)
- ASL (becomes whatever the most significant bit was)
- CMP (set if no borrow required, cleared otherwise)
- CPX (set if no borrow required, cleared otherwise)
- CPY (set if no borrow required, cleared otherwise)
- LSR (becomes whatever bit 0 was)
- ROL (becomes whatever the most significant bit was)
- ROR (becomes whatever bit 0 was)
- SBC (where it is often called the "borrow flag" instead)
- XCE (becomes whatever the e flag was)

The following two instructions indirectly affect the carry flag by loading the status register:

- PLP
- RTI

The carry flag influences whether BCS and BCC branch or not.

As mentioned above, none of INC, DEC, INX, DEX, INY nor DEY modify the carry flag.

### See Also

- CY, the Super FX's carry flag
- Negative Flag
- Overflow Flag

### References

- Labiak, William. [Page 108.](https://archive.org/details/Programming_the_65816/page/n118)
- Eyes & Lichty, "Branching Based on the Carry Flag" on [page 147](https://archive.org/details/0893037893ProgrammingThe65816/page/147)
