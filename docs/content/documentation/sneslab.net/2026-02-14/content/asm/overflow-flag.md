---
title: "Overflow Flag"
reference_url: https://sneslab.net/wiki/Overflow_Flag
categories:
  - "ASM"
  - "Flags"
  - "Inherited_from_6502"
  - "Condition_Codes"
downloaded_at: 2026-02-14T15:48:17-08:00
cleaned_at: 2026-02-14T17:52:38-08:00
---

The **Overflow Flag** (V) is bit 6 of the status register. It is affected only by the following eight instructions:

- ADC (indicates signed sum overflowed)
- SBC (indicates signed difference underflowed)
- CLV (always clears it)
- BIT (becomes bit 6 or bit 14 of operand except in immediate addressing)
- PLP (pulls it off the stack)
- RTI (pulls it off the stack)
- SEP (might set it)
- REP (might clear it)

Here is how it behaves:

- When the accumulator is 8 bits wide, V indicates whether the sum/difference of ADC/SBC is outside the range of -128 to 127.
- When the accumulator is 16 bits wide, V indicates whether the result of ADC/SBC is outside the range of -32768 to 32767.

In other words, the overflow flag is set when an arithmetic operation causes the most significant bit of the accumulator to change and is cleared if the bit is unchanged. Adding a positive and negative integer together never sets the overflow flag because the sum has a smaller magnitude than either addend.

It may be the most misunderstood flag of the 65c816 and the 6502.\[2]\[3]

There is no SEV instruction to directly set the overflow flag, but the 6502 and 65c02 do have a hardware signal to set it. Unfortunately this hardware signal was removed on the 65c816 (or fortunately, as now it can no longer get set by accident.)

On the SPC700 it can be cleared with CLRV and is set whenever the half-carry flag is set.

BVC and BVS both examine the overflow flag to decide whether or not to branch.

The overflow flag is invalid in decimal mode on the NMOS 6502, but it is valid in the 65c816's decimal mode.

### See Also

- BVC (SPC700)
- BVS (SPC700)
- O/V
- Carry Flag
- Zero Flag

### References

1. Eyes & Lichty, [page 439](https://archive.org/details/0893037893ProgrammingThe65816/page/439)
2. lbid, "Branching Based on the Overflow Flag" on [page 150](https://archive.org/details/0893037893ProgrammingThe65816/page/150)
3. Clark, Bruce. [http://www.6502.org/tutorials/vflag.html](http://www.6502.org/tutorials/vflag.html)
4. Shirriff, Ken. The 6502 overflow flag explained mathematically. [https://www.righto.com/2012/12/the-6502-overflow-flag-explained.html](https://www.righto.com/2012/12/the-6502-overflow-flag-explained.html)
5. lbid. [https://www.righto.com/2013/01/a-small-part-of-6502-chip-explained.html](https://www.righto.com/2013/01/a-small-part-of-6502-chip-explained.html)
6. Labiak, William. [Page 108.](https://archive.org/details/Programming_the_65816/page/n118)
7. Pickens, John. NMOS 6502 Opcodes. [http://www.6502.org/tutorials/6502opcodes.html#VFLAG](http://www.6502.org/tutorials/6502opcodes.html#VFLAG)
8. [https://forums.nesdev.org/viewtopic.php?t=6331](https://forums.nesdev.org/viewtopic.php?t=6331)
9. Table 7-1 Caveats of 65c816 datasheet
