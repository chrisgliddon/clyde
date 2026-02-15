---
title: "Index Register Select"
reference_url: https://sneslab.net/wiki/Index_Register_Select
categories:
  - "65c816_additions"
downloaded_at: 2026-02-14T13:26:15-08:00
cleaned_at: 2026-02-14T17:52:06-08:00
---

**Index Register Select** (X) is a flag in the processor status register (bit 4) of the 65c816. It indicates how wide the [index registers](/mw/index.php?title=index_register&action=edit&redlink=1 "index register (page does not exist)") are:

- When clear, both index registers are 16 bits wide. It can only be clear in native mode.
- When set or in emulation mode, both index registers are 8 bits wide and the high bytes are forced to zero.

It is not possible to control the width of the two index registers individually.

It can be affected by:

- REP (clears it if bit 4 of operand is set)
- SEP (sets it if bit 4 of operand is set)
- PLP (pops it off the stack)
- RTI

It affects the behavior of (possibly incomplete list):

- LDX
- LDY
- STX
- STY
- CPX
- CPY
- PHX
- PHY
- PLX
- PLY
- INX
- INY
- DEX
- DEY
- TXY
- TYX
- TXS
- TSX

In emulation mode, the x flag becomes the break flag.

There are no BXS or BXC instructions that examine this flag.

### See Also

- Memory/Accumulator Select
- X Index Register
- Y Index Register

### References

- Eyes & Lichty, [page 422](https://archive.org/details/0893037893ProgrammingThe65816/page/422), Table 18.2. 65x Flags.
- 65c816 datasheet paragraph 2.7
