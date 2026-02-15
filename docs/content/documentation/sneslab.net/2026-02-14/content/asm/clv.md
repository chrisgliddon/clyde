---
title: "CLV"
reference_url: https://sneslab.net/wiki/CLV
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:21:55-08:00
cleaned_at: 2026-02-14T17:51:35-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) B8 1 byte 2 cycles

Flags Affected N V M X D I Z C . 0 . . . . . .

**CLV** is a 65x instruction that clears the overflow flag.

No other flags are affected.

#### Syntax

```
CLV
```

#### Example

Before BRA was invented on the 65c02, this was a common way to always branch on the original 6502:

```
CLV
BVC nearlabel
```

To clear another flag at the same time as V, use REP.

### See Also

- CLC
- CLRV
- BIT
- BVC
- SEV

### External Links

- Eyes & Lichty, [page 444](https://archive.org/details/0893037893ProgrammingThe65816/page/444) on CLV
- Labiak, [page 133](https://archive.org/details/Programming_the_65816/page/n143) on CLV
- 3.6.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 28](https://archive.org/details/mos_microcomputers_programming_manual/page/n43) on CLV
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 254](https://archive.org/details/6502UsersManual/page/n267) on CLV
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-55](https://archive.org/details/6502-assembly-language-programming/page/n104) on CLV
- snes9x implementation of CLV: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1434](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1434)
