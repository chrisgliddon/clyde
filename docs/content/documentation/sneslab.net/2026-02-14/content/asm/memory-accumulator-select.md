---
title: "Memory/Accumulator Select"
reference_url: https://sneslab.net/wiki/Memory/Accumulator_Select
categories:
  - "ASM"
  - "Flags"
  - "65c816_additions"
downloaded_at: 2026-02-14T15:31:27-08:00
cleaned_at: 2026-02-14T17:52:22-08:00
---

The **Memory/Accumulator Select** (M) flag is bit 5 of the 65c816's processor status register. It indicates whether the accumulator is 8 or 16 bits wide:

- When clear, the accumulator is 16 bits wide. It can only be clear in native mode.
- When set, the accumulator is 8 bits wide, but the high byte (B) is still retained. This is the case after reset because the processor is in emulation mode.

It can be affected by:

- REP (clears it if bit 5 of operand is set)
- SEP (sets it if bit 5 of operand is set)
- PLP (pops it off the stack)
- RTI

It affects the behavior of (possibly incomplete list):

- LDA
- STA
- STZ
- ADC
- SBC
- BIT
- CMP
- PHA
- PLA
- LSR
- ASL
- ROR
- ROL
- ORA
- AND
- EOR
- INC
- DEC
- TSB
- TRB

But it does not affect XBA, TDC, TCD, TCS, or TSC.

There are no BMS or BMC instructions that examine this flag. Eyes & Lichty has a table which seems to imply that the M flag does not exist in emulation mode\[1], but the datasheet clearly states that the M flag is always equal to one in emulation mode.\[2]

### See Also

- Index Register Select

### References

1. Eyes & Lichty, [page 422](https://archive.org/details/0893037893ProgrammingThe65816/page/422), Table 18.2. 65x Flags.
2. section 2.8 "Processor Status Register (P)" of 65c816 datasheet, 2024 edition
