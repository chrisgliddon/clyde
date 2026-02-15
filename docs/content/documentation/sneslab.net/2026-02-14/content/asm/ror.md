---
title: "ROR"
reference_url: https://sneslab.net/wiki/ROR
categories:
  - "ASM"
  - "Group_Two_Instructions"
  - "Read-Modify-Write_Instructions"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T16:09:42-08:00
cleaned_at: 2026-02-14T17:52:57-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 6A 1 byte 2 cycles Absolute 6E 3 bytes 6 cycles* Direct Page 66 2 bytes 5 cycles* Absolute Indexed by X 7E 3 bytes 7 cycles* Direct Page Indexed by X 76 2 bytes 6 cycles*

Flags Affected N V M X D I Z C N . . . . . Z C

**ROR** (Rotate Right) is a 65x instruction that rotates a value and the carry flag right one bit. The least significant bit is shifted into the carry flag. The carry flag is shifted into the most significant bit.

- When the accumulator is 8 bits wide, 9 bits are rotated.
- When the accumulator is 16 bits wide, 17 bits are rotated.

#### Syntax

```
ROR
ROR A
ROR addr
ROR dp
ROR addr, X
ROR dp, X
```

#### Cycle Penalties

- Except in accumulator addressing, ROR takes two extra cycles when the accumulator is 16 bits wide.
- In direct page addressing modes, ROR takes another extra cycle if the low byte of the direct page register is nonzero.

It has been commonly said that ROR was originally broken and so was left out of the earliest 6502 datasheets before it was fixed, but newer research suggests it was simply a missing feature. It is available on 65x processors manufactured after June 1976.

The arrow in the Carr textbook diagram does not circle back around.

### See Also

- ROL
- LSR
- ROR (SPC700)
- ROR (Super FX)

### External Links

- Eyes & Lichty, [page 491](https://archive.org/details/0893037893ProgrammingThe65816/page/491) on ROR
- lbid, [page 191](https://archive.org/details/0893037893ProgrammingThe65816/page/191), before & after diagram on ROR
- Labiak, [page 175](https://archive.org/details/Programming_the_65816/page/n185) on ROR
- 10.4 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 150](https://archive.org/details/mos_microcomputers_programming_manual/page/n171) on ROR
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 269](https://archive.org/details/6502UsersManual/page/n282) on ROR
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-87](https://archive.org/details/6502-assembly-language-programming/page/n136) on ROR
- snes9x implementation of ROR: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1070](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1070)
- undisbeliever on ROR: [https://undisbeliever.net/snesdev/65816-opcodes.html#ror-rotate-right](https://undisbeliever.net/snesdev/65816-opcodes.html#ror-rotate-right)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#ROR](http://www.6502.org/tutorials/6502opcodes.html#ROR)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.3](http://www.6502.org/tutorials/65c816opcodes.html#6.1.3)
- The 6502 Rotate Right Myth, [https://youtu.be/Uk\_QC1eU0Fg](https://youtu.be/Uk_QC1eU0Fg)
