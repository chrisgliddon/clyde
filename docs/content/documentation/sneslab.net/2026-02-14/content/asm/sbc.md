---
title: "SBC"
reference_url: https://sneslab.net/wiki/SBC
categories:
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T16:18:23-08:00
cleaned_at: 2026-02-14T17:53:03-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate E9 2/3 bytes 2 cycles* Absolute ED 3 bytes 4 cycles* Absolute Long EF 4 bytes 5 cycles* Direct Page E5 2 bytes 3 cycles* Direct Page Indirect F2 2 bytes 5 cycles* Direct Page Indirect Long E7 2 bytes 6 cycles* Absolute Indexed by X FD 3 bytes 4 cycles* Absolute Long Indexed by X FF 4 bytes 5 cycles* Absolute Indexed by Y F9 3 bytes 4 cycles* Direct Page Indexed by X F5 2 bytes 4 cycles* Direct Page Indexed Indirect by X E1 2 bytes 6 cycles* Direct Page Indirect Indexed by Y F1 2 bytes 5 cycles* Direct Page Indirect Long Indexed by Y F7 2 bytes 6 cycles* Stack Relative E3 2 bytes 4 cycles* Stack Relative Indirect Indexed by Y F3 2 bytes 7 cycles*

Flags Affected N V M X D I Z C N V . . . . Z C

**SBC** (Subtract with Carry/Borrow) is the main 65x subtraction instruction. The accumulator serves as both the minuend and where the difference is stored. The operand serves as the subtrahend. For example, SBC #6 does "a minus 6" but there is this caveat about the carry flag:

If the carry flag (aka borrow flag) is clear, one more is subtracted. As there is no subtract-without-carry instruction, SEC should be run beforehand or the carry flag should otherwise be ensured to be set, otherwise the difference may be one greater than expected.

If the difference is negative, the carry flag will be cleared, otherwise it will be set.

If the decimal flag is set, then binary coded decimal subtraction is performed, otherwise binary subtraction.

#### Syntax

```
SBC #const
SBC addr
SBC long
SBC dp
SBC (dp)
SBC [dp]
SBC addr, X
SBC long, X
SBC addr, Y
SBC dp, X
SBC (dp, X)
SBC (dp), Y
SBC [dp], Y
SBC sr, S
SBC (sr, S), Y
```

#### Cycle Penalties

SBC takes an extra cycle for each of the following:

- if the accumulator is 16 bits wide, in all addressing modes
- when utilizing the direct register, if the low byte of the direct register is nonzero
- in certain addressing modes if adding an index crosses a page boundary

If you only need to subtract one, consider DEC instead. Unlike the 65c02, the 65c816 does not have a cycle penalty when subtracting in decimal mode.

In Eyes & Lichty on page 498, opcode F5 has a "0" superscript typo on the # of cycles column.

### See Also

- ADC
- SBC (SPC700)
- SUB (Super FX)
- DEX
- DEY

### External Links

- Eyes & Lichty, [page 497](https://archive.org/details/0893037893ProgrammingThe65816/page/497) on SBC
- Labiak, [page 179](https://archive.org/details/Programming_the_65816/page/n189) on SBC
- 2.2.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 14](https://archive.org/details/mos_microcomputers_programming_manual/page/n29) on SBC
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 271](https://archive.org/details/6502UsersManual/page/n284) on SBC
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-91](https://archive.org/details/6502-assembly-language-programming/page/n140) on SBC
- snes9x implementation of SBC: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1133](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1133)
- undisbeliever on SBC: [https://undisbeliever.net/snesdev/65816-opcodes.html#sbc-subtract-with-borrow-from-accumulator](https://undisbeliever.net/snesdev/65816-opcodes.html#sbc-subtract-with-borrow-from-accumulator)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#SBC](http://www.6502.org/tutorials/6502opcodes.html#SBC)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.1](http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.1)
