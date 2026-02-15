---
title: "INX"
reference_url: https://sneslab.net/wiki/INX
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T13:22:59-08:00
cleaned_at: 2026-02-14T17:52:08-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) E8 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**INX** is a 65x instruction that increments the X index register by one. The state of the decimal flag has no effect on the behavior of INX. Unlike ADC, INX never affects the carry flag.

#### Syntax

```
INX
```

### See Also

- DEX
- INY
- INC
- INC (SPC700)
- INC (Super FX)

### External Links

- Eyes & Lichty, [page 457](https://archive.org/details/0893037893ProgrammingThe65816/page/457) on INX
- Labiak, [page 143](https://archive.org/details/Programming_the_65816/page/n153) on INX
- 7.4 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 97](https://archive.org/details/mos_microcomputers_programming_manual/page/n115) on INX
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 260](https://archive.org/details/6502UsersManual/page/n273) on INX
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-67](https://archive.org/details/6502-assembly-language-programming/page/n116) on INX
- snes9x implementation of INX: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1546](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1546)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.3](http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.3)
