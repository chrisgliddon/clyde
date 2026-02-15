---
title: "CLI"
reference_url: https://sneslab.net/wiki/CLI
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:20:49-08:00
cleaned_at: 2026-02-14T17:51:32-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) 58 1 byte 2 cycles

Flags Affected N V M X D I Z C . . . . . 0 . .

**CLI** is a 65x instruction that clears the interrupt disable flag, which enables maskable interrupts. To handle nested interrupts, a CLI is required.

No other flags are affected.

#### Syntax

```
CLI
```

The first machine cycle is to load the opcode byte, and the second is the internal cycle.

### See Also

- SEI
- EI
- DI
- IRQ
- RTI
- REP

### External Links

- Eyes & Lichty, [page 443](https://archive.org/details/0893037893ProgrammingThe65816/page/443) on CLI
- Labiak, [page 132](https://archive.org/details/Programming_the_65816/page/n142) on CLI
- 3.2.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 26](https://archive.org/details/mos_microcomputers_programming_manual/page/n41) on CLI
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 254](https://archive.org/details/6502UsersManual/page/n267) on CLI
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-54](https://archive.org/details/6502-assembly-language-programming/page/n103) on CLI
- snes9x implementation of CLI: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1434](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1434)
