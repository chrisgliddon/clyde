---
title: "SED"
reference_url: https://sneslab.net/wiki/SED
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T16:20:52-08:00
cleaned_at: 2026-02-14T17:53:05-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) F8 1 byte 2 cycles

Flags Affected N V M X D I Z C . . . . 1 . . .

**SED** is a 65x instruction that sets the decimal mode flag so that ADC and SBC will operate on binary coded decimal data properly. Hexadecimal digits A through F will not appear in sums/differences because the result will be automatically adjusted to decimal.

No other flags are affected.

#### Syntax

```
SED
```

### See Also

- CLD
- BCD
- SEP

### External Links

- Eyes & Lichty, [page 500](https://archive.org/details/0893037893ProgrammingThe65816/page/500) on SED
- Labiak, [page 181](https://archive.org/details/Programming_the_65816/page/n191) on SED
- 3.3.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 26](https://archive.org/details/mos_microcomputers_programming_manual/page/n41) on SED
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 273](https://archive.org/details/6502UsersManual/page/n286) on SED
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-94](https://archive.org/details/6502-assembly-language-programming/page/n143) on SED
- snes9x implementation of SED: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1434](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1434)
