---
title: "INY"
reference_url: https://sneslab.net/wiki/INY
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T13:23:12-08:00
cleaned_at: 2026-02-14T17:52:09-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) C8 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**INY** is a 65x instruction that increments the Y index register by one. The state of the decimal flag has no effect on the behavior of INY. Unlike ADC, INY never affects the carry flag.

#### Syntax

```
INY
```

### See Also

- DEY
- INX
- INC
- INC (SPC700)
- INC (Super FX)

### External Links

- Eyes & Lichty, [page 458](https://archive.org/details/0893037893ProgrammingThe65816/page/458) on INY
- Labiak, [page 144](https://archive.org/details/Programming_the_65816/page/n154) on INY
- 7.5 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 97](https://archive.org/details/mos_microcomputers_programming_manual/page/n115) on INY
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 261](https://archive.org/details/6502UsersManual/page/n274) on INY
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-68](https://archive.org/details/6502-assembly-language-programming/page/n117) on INY
- snes9x implementation of INY: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1576](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1576)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.3](http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.3)
