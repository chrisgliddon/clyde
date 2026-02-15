---
title: "EOR"
reference_url: https://sneslab.net/wiki/EOR
categories:
  - "ASM"
  - "Group_One_Instructions"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T11:54:06-08:00
cleaned_at: 2026-02-14T17:51:53-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 49 2/3 bytes 2 cycles* Absolute 4D 3 bytes 4 cycles* Absolute Long 4F 4 bytes 5 cycles* Direct Page 45 2 bytes 3 cycles* Direct Page Indirect 52 2 bytes 5 cycles* Direct Page Indirect Long 47 2 bytes 6 cycles* Absolute Indexed by X 5D 3 bytes 4 cycles* Absolute Long Indexed by X 5F 4 bytes 5 cycles* Absolute Indexed by Y 59 3 bytes 4 cycles* Direct Page Indexed by X 55 2 bytes 4 cycles* Direct Page Indexed Indirect by X 41 2 bytes 6 cycles* Direct Page Indirect Indexed by Y 51 2 bytes 5 cycles* Direct Page Indirect Long Indexed by Y 57 2 bytes 6 cycles* Stack Relative 43 2 bytes 4 cycles* Stack Relative Indirect Indexed by Y 53 2 bytes 7 cycles*

Flags Affected N V M X D I Z C N . . . . . Z .

**EOR** is a 65x instruction that performs a bitwise [exclusive or](https://mathworld.wolfram.com/XOR.html) between its operand and the accumulator. The sum is stored in the accumulator. The size of the accumulator determines whether 8 or 16 bits are EORed together with it.

#### Syntax

```
EOR #const
EOR addr
EOR long
EOR dp
EOR (dp)
EOR [dp]
EOR addr, X
EOR long, X
EOR addr, Y
EOR dp, X
EOR (dp, X)
EOR (dp), Y
EOR [dp], Y
EOR sr, S
EOR (sr, S), Y
```

One example usage of EOR is to flip all the bits of the accumulator:\[10]

```
EOR #$FFFF
```

#### Cycle Penalties

- In all addressing modes, EOR takes one extra cycle when the accumulator is 16 bits wide.
- In direct page addressing modes, EOR takes one additional cycle if the low byte of the direct page register is nonzero.
- In both Absolute Indexed and DP Indirect Indexed, Y admodes, EOR takes an extra cycle if adding the index crosses a page boundary.

### See Also

- ORA
- AND
- EOR (SPC700)
- OR (SPC700)
- XOR (Super FX)

### External Links

01. Eyes & Lichty, [page 454](https://archive.org/details/0893037893ProgrammingThe65816/page/454) on EOR
02. Labiak, [page 141](https://archive.org/details/Programming_the_65816/page/n151) on EOR
03. 2.2.4.3 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 21](https://archive.org/details/mos_microcomputers_programming_manual/page/n36) on EOR
04. [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 259](https://archive.org/details/6502UsersManual/page/n272) on EOR
05. [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-63](https://archive.org/details/6502-assembly-language-programming/page/n112) on EOR
06. snes9x implementation of EOR: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L533](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L533)
07. undisbeliever on EOR: [https://undisbeliever.net/snesdev/65816-opcodes.html#eor-exclusive-or-accumulator-with-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#eor-exclusive-or-accumulator-with-memory)
08. Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#EOR](http://www.6502.org/tutorials/6502opcodes.html#EOR)
09. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.2.1](http://www.6502.org/tutorials/65c816opcodes.html#6.1.2.1)
10. Carr, [page 260](https://archive.org/details/6502UsersManual/page/n273)
