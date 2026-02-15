---
title: "DEC"
reference_url: https://sneslab.net/wiki/DEC
categories:
  - "ASM"
  - "Group_Two_Instructions"
  - "Read-Modify-Write_Instructions"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T11:34:38-08:00
cleaned_at: 2026-02-14T17:51:43-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 3A 1 byte 2 cycles Absolute CE 3 bytes 6 cycles* Direct Page C6 2 bytes 5 cycles* Absolute Indexed by X DE 3 bytes 7 cycles* Direct Page Indexed by X D6 2 bytes 6 cycles*

Flags Affected N V M X D I Z C N . . . . . Z .

**DEC** (Decrement) is a 65x instruction that decrements the value in the location specified by the operand by one. The size of the accumulator determines whether this is an 8 or 16 bit operation. An alternate mnemonic when the operand is the accumulator is "DEA."

DEC ignores the decimal mode flag and the carry flag.

#### Syntax

```
DEC
DEC A
DEA
DEC addr
DEC dp
DEC addr, X
DEC dp, X
```

If you need to subtract two or more from the accumulator, consider SBC instead.

#### Cycle Penalties

- Except in accumulator addressing, DEC takes two extra cycles when the accumulator is 16 bits wide.
- In direct page addressing modes, DEC takes an extra cycle when the low byte of the direct page register is nonzero

Although the NMOS 6502 does have DEC, it does not work on the accumulator. The NES CPU is one such system that lacks that addressing mode for DEC. When porting code to the 65c816, utilizing DEC more often instead of SBC can make code smaller and faster.

### See Also

- INC
- DEX
- DEY
- DEC (SPC700)
- DEC (Super FX)

### External Links

- Eyes & Lichty, [page 451](https://archive.org/details/0893037893ProgrammingThe65816/page/451) on DEC
- Labiak, [page 138](https://archive.org/details/Programming_the_65816/page/n148) on DEC
- 10.8 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 155](https://archive.org/details/mos_microcomputers_programming_manual/page/n176) on DEC
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 257](https://archive.org/details/6502UsersManual/page/n270) on DEC
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-60](https://archive.org/details/6502-assembly-language-programming/page/n109) on DEC
- snes9x implementation of DEC: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L482](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L482)
- undisbeliever on DEC: [https://undisbeliever.net/snesdev/65816-opcodes.html#dec-decrement](https://undisbeliever.net/snesdev/65816-opcodes.html#dec-decrement)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#DEC](http://www.6502.org/tutorials/6502opcodes.html#DEC)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.3](http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.3)
