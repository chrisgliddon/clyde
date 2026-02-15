---
title: "SEI"
reference_url: https://sneslab.net/wiki/SEI
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T16:21:04-08:00
cleaned_at: 2026-02-14T17:53:05-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) 78 1 byte 2 cycles

Flags Affected N V M X D I Z C . . . . . 1 . .

**SEI** (SEt Interrupt) is a 65c816 instruction that disables maskable interrupts by setting the interrupt disable flag.

SEI is recommened by some tutorials to be one of the first instructions run after the SNES comes out of reset so a game can boot properly without interruption.

No other flags are affected.

#### Syntax

```
SEI
```

### See Also

- CLI
- SEP
- EI
- DI
- IRQ
- RTI

### External Links

- Eyes & Lichty, [page 501](https://archive.org/details/0893037893ProgrammingThe65816/page/501) on SEI
- Labiak, [page 182](https://archive.org/details/Programming_the_65816/page/n192) on SEI
- 3.2.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 26](https://archive.org/details/mos_microcomputers_programming_manual/page/n41) on SEI
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 273](https://archive.org/details/6502UsersManual/page/n286) on SEI
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-95](https://archive.org/details/6502-assembly-language-programming/page/n144) on SEI
- snes9x implementation of SEI: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1434](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1434)
