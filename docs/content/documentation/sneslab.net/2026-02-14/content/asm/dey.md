---
title: "DEY"
reference_url: https://sneslab.net/wiki/DEY
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:35:18-08:00
cleaned_at: 2026-02-14T17:51:46-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 88 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**DEY** is a 65x instruction that decrements the Y index register by one. DEY ignores the decimal flag. Unlike SBC, DEY never affects the carry flag.

#### Syntax

```
DEY
```

### See Also

- DEC
- DEX
- INX
- INY
- DEC (SPC700)
- DEC (Super FX)

### External Links

- Eyes & Lichty, [page 453](https://archive.org/details/0893037893ProgrammingThe65816/page/453) on DEY
- Labiak, [page 140](https://archive.org/details/Programming_the_65816/page/n150) on DEY
- 7.7 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 98](https://archive.org/details/mos_microcomputers_programming_manual/page/n116) on DEY
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 258](https://archive.org/details/6502UsersManual/page/n271) on DEY
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-62](https://archive.org/details/6502-assembly-language-programming/page/n111) on DEY
- snes9x implementation of DEY: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1514](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1514)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.3](http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.3)
