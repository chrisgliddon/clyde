---
title: "INC"
reference_url: https://sneslab.net/wiki/INC
categories:
  - "ASM"
  - "Group_Two_Instructions"
  - "Read-Modify-Write_Instructions"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T13:22:27-08:00
cleaned_at: 2026-02-14T17:52:05-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 1A 1 byte 2 cycles Absolute EE 3 bytes 6 cycles* Direct Page E6 2 bytes 5 cycles* Absolute Indexed by X FE 3 bytes 7 cycles* Direct Page Indexed by X F6 2 bytes 6 cycles*

Flags Affected N V M X D I Z C N . . . . . Z .

**INC** (Increment) is a 65x instruction that increments the value in the location specified by one. The size of the accumulator determines whether this is an 8 or 16 bit operation. An alternate mnemonic when the operand is the accumulator is "INA."

INC ignores the decimal mode flag and the carry flag.

#### Syntax

```
INC
INC A
INA
INC addr
INC dp
INC addr, X
INC dp, X
```

To test for wraparound, examine the zero flag. If you need to add two or more to the accumulator, consider ADC instead of INC.

#### Cycle Penalties

- Except in accumulator addressing, INC takes two extra cycles when the accumulator is 16 bits wide.
- In direct page addressing modes, INC takes an extra cycle if the low byte of the direct page register is nonzero.

Although the NMOS 6502 does have INC, it does not work on the accumulator. The NES CPU is one such system that lacks that addressing mode for INC. When porting code to the 65c816, utilizing INC more often instead of ADC can make code smaller and faster.

### See Also

- INX
- INY
- DEC
- INC (SPC700)
- INC (Super FX)

### External Links

- Eyes & Lichty, [page 456](https://archive.org/details/0893037893ProgrammingThe65816/page/456) on INC
- Labiak, [page 142](https://archive.org/details/Programming_the_65816/page/n152) on INC
- 10.7 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 155](https://archive.org/details/mos_microcomputers_programming_manual/page/n176) on INC
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 260](https://archive.org/details/6502UsersManual/page/n273) on INC
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-65](https://archive.org/details/6502-assembly-language-programming/page/n114) on INC
- snes9x implementation of INC: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L627](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L627)
- undisbeliever on INC: [https://undisbeliever.net/snesdev/65816-opcodes.html#inc-increment](https://undisbeliever.net/snesdev/65816-opcodes.html#inc-increment)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#INC](http://www.6502.org/tutorials/6502opcodes.html#INC)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.3](http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.3)
