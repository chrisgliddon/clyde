---
title: "LSR"
reference_url: https://sneslab.net/wiki/LSR
categories:
  - "ASM"
  - "Group_Two_Instructions"
  - "Read-Modify-Write_Instructions"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T13:37:14-08:00
cleaned_at: 2026-02-14T17:52:22-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 4A 1 byte 2 cycles Absolute 4E 3 bytes 6 cycles* Direct Page 46 2 bytes 5 cycles* Absolute Indexed by X 5E 3 bytes 7 cycles* Direct Page Indexed by X 56 2 bytes 6 cycles*

Flags Affected N V M X D I Z C 0 . . . . . Z C

**LSR** (Logical Shift Right) is a 65x instruction that shifts every bit of a value one bit to the right (division by two). The most significant bit and negative flag are cleared. The least significant bit is shifted into the carry flag. The previous value of the carry flag is lost (unlike with ROR).

The size of the accumulator determines how many bits are shifted (8 or 16) not including the clearing zero and carry flag.

#### Syntax

```
LSR
LSR A
LSR addr
LSR dp
LSR addr, X
LSR dp, X
```

#### Cycle Penalties

- Except in accumulator addressing, LSR takes an extra two cycles when the accumulator is 16 bits wide
- In direct page addressing modes, LSR takes another extra cycle if the low byte of the direct page register is nonzero.

### See Also

- ASL
- LSR (SPC700)
- LSR (Super FX)
- DIV2

### External Links

- Eyes & Lichty, [page 465](https://archive.org/details/0893037893ProgrammingThe65816/page/465) on LSR
- lbid [page 191](https://archive.org/details/0893037893ProgrammingThe65816/page/191), before & after diagram of LSR
- Labiak, [page 152](https://archive.org/details/Programming_the_65816/page/n162) on LSR
- 10.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 148](https://archive.org/details/mos_microcomputers_programming_manual/page/n169) on LSR
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 265](https://archive.org/details/6502UsersManual/page/n278) on LSR
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-76](https://archive.org/details/6502-assembly-language-programming/page/n125) on LSR
- snes9x implementation of LSR: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L862](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L862)
- undisbeliever on LSR: [https://undisbeliever.net/snesdev/65816-opcodes.html#lsr-logical-shift-right](https://undisbeliever.net/snesdev/65816-opcodes.html#lsr-logical-shift-right)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#LSR](http://www.6502.org/tutorials/6502opcodes.html#LSR)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.3](http://www.6502.org/tutorials/65c816opcodes.html#6.1.3)
