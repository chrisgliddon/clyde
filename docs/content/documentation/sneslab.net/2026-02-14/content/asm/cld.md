---
title: "CLD"
reference_url: https://sneslab.net/wiki/CLD
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:20:36-08:00
cleaned_at: 2026-02-14T17:51:32-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) D8 1 byte 2 cycles

Flags Affected N V M X D I Z C . . . . 0 . . .

**CLD** is a 65x instruction that clears the decimal mode flag, switching the processor back into binary mode so ADC and SBC will operate normally. Hexadecimal digits A through F may appear in sums/differences.

No other flags are affected.

#### Syntax

```
CLD
```

BRK handlers do not need CLD because BRK also clears the decimal flag.

To clear more than one flag at the same time, use REP.

### See Also

- SED
- CLC
- CLV
- Binary Coded Decimal

### External Links

- Eyes & Lichty, [page 442](https://archive.org/details/0893037893ProgrammingThe65816/page/442) on CLD
- Labiak, [page 131](https://archive.org/details/Programming_the_65816/page/n141) on CLD
- 3.3.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 27](https://archive.org/details/mos_microcomputers_programming_manual/page/n42) on CLD
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 254](https://archive.org/details/6502UsersManual/page/n267) on CLD
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-53](https://archive.org/details/6502-assembly-language-programming/page/n102) on CLD
- snes9x implementation of CLD: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1434](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1434)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.4.1](http://www.6502.org/tutorials/65c816opcodes.html#6.4.1)
