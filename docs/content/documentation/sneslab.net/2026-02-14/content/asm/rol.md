---
title: "ROL"
reference_url: https://sneslab.net/wiki/ROL
categories:
  - "ASM"
  - "Group_Two_Instructions"
  - "Read-Modify-Write_Instructions"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T16:08:12-08:00
cleaned_at: 2026-02-14T17:52:55-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 2A 1 byte 2 cycles Absolute 2E 3 bytes 6 cycles* Direct Page 26 2 bytes 5 cycles* Absolute Indexed by X 3E 3 bytes 7 cycles* Direct Page Indexed by X 36 2 bytes 6 cycles*

Flags Affected N V M X D I Z C N . . . . . Z C

**ROL** (Rotate Left) is a 65x instruction that rotates a value and the carry flag left one bit. The most significant bit is shifted into the carry flag. The carry flag is shifted into the least significant bit.

- When the accumulator is 8 bits wide, 9 bits are rotated.
- When the accumulator is 16 bits wide, 17 bits are rotated.

#### Syntax

```
ROL
ROL A
ROL addr
ROL dp
ROL addr, X
ROL dp, X
```

#### Cycle Penalties

- Except in accumulator addressing, ROL takes two extra cycles when the accumulator is 16 bits wide.
- In direct page addressing modes, ROL takes another extra cycle if the low byte of the direct page register is nonzero.

The arrow in the Carr textbook diagram does not circle back around.

### See Also

- ROR
- ASL
- ROL (SPC700)
- ROL (Super FX)

### External Links

- Eyes & Lichty, [page 490](https://archive.org/details/0893037893ProgrammingThe65816/page/490) on ROL
- lbid [page 190](https://archive.org/details/0893037893ProgrammingThe65816/page/190) before & after diagram of ROL
- Labiak, [page 174](https://archive.org/details/Programming_the_65816/page/n184) on ROL
- 10.3 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 149](https://archive.org/details/mos_microcomputers_programming_manual/page/n170) on ROL
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 269](https://archive.org/details/6502UsersManual/page/n282) on ROL
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-85](https://archive.org/details/6502-assembly-language-programming/page/n134) on ROL
- snes9x implementation of ROL: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1011](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1011)
- undisbeliever on ROL: [https://undisbeliever.net/snesdev/65816-opcodes.html#rol-rotate-left](https://undisbeliever.net/snesdev/65816-opcodes.html#rol-rotate-left)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#ROL](http://www.6502.org/tutorials/6502opcodes.html#ROL)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.3](http://www.6502.org/tutorials/65c816opcodes.html#6.1.3)
