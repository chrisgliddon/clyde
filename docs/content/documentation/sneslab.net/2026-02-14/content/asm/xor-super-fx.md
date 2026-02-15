---
title: "XOR (Super FX)"
reference_url: https://sneslab.net/wiki/XOR_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Logical_Operation_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T17:21:00-08:00
cleaned_at: 2026-02-14T17:53:45-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 3FCn 2 bytes Implied (type 1) 3DCn 2 bytes

Flags Affected B ALT1 ALT2 O/V S CY Z 0? 0? 0? .? ? .? ?

**XOR** is a poorly documented (XOR is mentioned on [page 2-2-7 of Book II](https://archive.org/details/SNESDevManual/book2/page/n101) of the Nintendo documentation and in the index) Super FX instruction that performs an exculsive or.

In this article, we assume the information in \[1] is correct. Snes9x has a file that denotes that XOR does, in fact, occupy the opcode space between C1 and CF.\[4]

It probably restores the ALT0 state like OR. The speeds are probably the same as two byte OR as well.

The low nybble of the opcode specifies either the immediate value or which general register to use, like OR. We can deduce this by contradiction because if it were the high nybble instead, RPIX would have the same opcode as XOR R4 making them indistinguishable.

HIB's opcode is C0 and it appears to not care whether ALT1/ALT2 are set. If that is the case, then we can conclude that like OR, R0 is not available as XOR's operand and neither can zero be the immediate value. (But R0 can still be the source register.)

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
XOR Rn
XOR #n
```

### See Also

- AND (Super FX)
- OR (Super FX)
- NOT
- EOR
- OR (SPC700)

### References

1. [https://en.wikibooks.org/wiki/Super\_NES\_Programming/Super\_FX\_tutorial#Instruction\_Set\_Table](https://en.wikibooks.org/wiki/Super_NES_Programming/Super_FX_tutorial#Instruction_Set_Table)
2. Example 3 on [page 2-8-10 of Book II](https://archive.org/details/SNESDevManual/book2/page/n149) of the official Super Nintendo development manual
3. [Index page 7 of 7 of Book II](https://archive.org/details/SNESDevManual/book2/page/n412), lbid.
4. [https://github.com/snes9xgit/snes9x/blob/master/fxdbg.cpp#L1126](https://github.com/snes9xgit/snes9x/blob/master/fxdbg.cpp#L1126)
