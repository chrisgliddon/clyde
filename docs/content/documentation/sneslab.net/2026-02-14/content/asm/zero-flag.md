---
title: "Zero Flag"
reference_url: https://sneslab.net/wiki/Zero_Flag
categories:
  - "Inherited_from_6502"
  - "Condition_Codes"
downloaded_at: 2026-02-14T17:24:54-08:00
cleaned_at: 2026-02-14T17:53:46-08:00
---

The **Zero Flag** (Z) is bit 1 of the 65c816's status register. It indicates whether the last value computed, transferred, or pulled is zero: set if it is and clear if not. Although there are no dedicated SEZ or CLZ instructions to set or clear it, it can be directly set with SEP and cleared with REP:

```
SEP #$02
REP #$02
```

It is also affected by these 41 instructions:

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
- LSR
- ORA
- PLA
- PLB
- PLD
- PLX
- PLY
- ROL
- ROR
- SBC
- TAX
- TAY
- TCD
- TCS
- TDC
- TRB
- TSB
- TSC
- TSX
- TXA
- TXY
- TYA
- TYX
- XBA

The BEQ and BNE instructions examine the zero flag to decide whether or not to branch. Push instructions do not affect the zero flag.

The SPC700 and Super FX chips also have a zero flag.

The zero flag is invalid in decimal mode on the NMOS 6502, but it is valid in the 65c816's decimal mode.

### See Also

- Negative Flag
- Carry Flag
- Overflow Flag

### References

- Labiak, [page 108](https://archive.org/details/Programming_the_65816/page/n118)
- Eyes & Lichty, "Branching Based on the Zero Flag" on [page 146](https://archive.org/details/0893037893ProgrammingThe65816/page/146)
- Table 7-1 Caveats of 65c816 datasheet
