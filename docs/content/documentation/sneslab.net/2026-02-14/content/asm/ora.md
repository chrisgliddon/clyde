---
title: "ORA"
reference_url: https://sneslab.net/wiki/ORA
categories:
  - "ASM"
  - "Group_One_Instructions"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T15:45:46-08:00
cleaned_at: 2026-02-14T17:52:37-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 09 2/3 bytes 2 cycles* Absolute 0D 3 bytes 4 cycles* Absolute Long 0F 4 bytes 5 cycles* Direct Page 05 2 bytes 3 cycles* Direct Page Indirect 12 2 bytes 5 cycles* Direct Page Indirect Long 07 2 bytes 6 cycles* Absolute Indexed by X 1D 3 bytes 4 cycles* Absolute Long Indexed by X 1F 4 bytes 5 cycles* Absolute Indexed by Y 19 3 bytes 4 cycles* Direct Page Indexed by X 15 2 bytes 4 cycles* Direct Page Indexed Indirect by X 01 2 bytes 6 cycles* Direct Page Indirect Indexed by Y 11 2 bytes 5 cycles* Direct Page Indirect Long Indexed by Y 17 2 bytes 6 cycles* Stack Relative 03 2 bytes 4 cycles* Stack Relative Indirect Indexed by Y 13 2 bytes 7 cycles*

Flags Affected N V M X D I Z C N . . . . . Z .

**ORA** is a 65x instruction that performs a logical OR between the datum at the effective address and the accumulator and stores the disjunction in the accumulator. The size of the accumulator determines whether 8 or 16 bits are ORed together with it.

#### Syntax

```
ORA #const
ORA addr
ORA long
ORA dp
ORA (dp)
ORA [dp]
ORA addr, X
ORA long, X
ORA addr, Y
ORA dp, X
ORA (dp, X)
ORA (dp), Y
ORA [dp], Y
ORA sr, S
ORA (sr, S), Y
```

#### Cycle Penalties

- In all addressing modes, ORA takes one extra cycle when the accumulator is 16 bits wide.
- In direct page addressing modes, ORA takes another extra cycle if the low byte of the direct page register is nonzero.

### See Also

- AND
- EOR
- OR (Super FX)
- XOR (Super FX)

### External Links

- Eyes & Lichty, [page 471](https://archive.org/details/0893037893ProgrammingThe65816/page/471) on ORA
- Labiak, [page 156](https://archive.org/details/Programming_the_65816/page/n166) on ORA
- 2.2.4.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 21](https://archive.org/details/mos_microcomputers_programming_manual/page/n36) on ORA
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 266](https://archive.org/details/6502UsersManual/page/n279) on ORA
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-79](https://archive.org/details/6502-assembly-language-programming/page/n128) on ORA
- snes9x implementation of ORA: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L917](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L917)
- undisbeliever on ORA: [https://undisbeliever.net/snesdev/65816-opcodes.html#ora-or-accumulator-with-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#ora-or-accumulator-with-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#ORA](http://www.6502.org/tutorials/6502opcodes.html#ORA)
- Bruce, Clark. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.2.1](http://www.6502.org/tutorials/65c816opcodes.html#6.1.2.1)
