---
title: "Negative Flag"
reference_url: https://sneslab.net/wiki/Negative_Flag
categories:
  - "ASM"
  - "Flags"
  - "Inherited_from_6502"
  - "Condition_Codes"
downloaded_at: 2026-02-14T15:42:27-08:00
cleaned_at: 2026-02-14T17:52:31-08:00
---

The **Negative Flag** (N) is bit 7 of the 65c816's status register. It is set or cleared to reflect the most significant bit of arithmetic/logical results or pulled/loaded/transferred values. The S-SMP also has a negative flag in its program status word. Although there are no dedicated SEN or CLN instructions to set or clear it, it can be set with SEP and cleared with REP:

```
SEP #$80
REP #$80
```

These instructions also affect the negative flag (this bulleted list being 38 long):

- ADC
- AND
- ASL
- BIT
- CMP
- CPX
- CPY
- DEC
- DEX
- DEY
- EOR
- INC
- INX
- INY
- LDA
- LDX
- LDY
- ORA
- PLA
- PLB
- PLD
- PLP (missing from the Labiak textbook's list)
- PLX
- PLY
- ROL
- ROR
- SBC
- TAX
- TAY
- TCD
- TDC
- TSC
- TSX
- TXA
- TXY
- TYA
- TYX
- XBA

Also, LSR always clears the negative flag because it also shifts a zero into the operand's most significant bit, making it non-negative. Push instructions do not affect the negative flag.

BPL and BMI examine the negative flag to decide whether or not to branch.

The negative flag is invalid in decimal mode on the NMOS 6502, but it is valid in the 65c816's decimal mode.

### See Also

- Zero Flag
- Overflow Flag
- Carry Flag
- Sign Flag

### References

- Labiak, Willam. [Page 109](https://archive.org/details/Programming_the_65816/page/n119)
- Eyes & Lichty, "Branching Based on the Negative Flag" on [page 148](https://archive.org/details/0893037893ProgrammingThe65816/page/148)
- Table 7-1 Caveats of 65c816 datasheet
