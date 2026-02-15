---
title: "BVC"
reference_url: https://sneslab.net/wiki/BVC
categories:
  - "Conditional_Branches"
  - "Two-byte_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:06:12-08:00
cleaned_at: 2026-02-14T17:51:26-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 50 2 bytes 2 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**BVC** is a 65x instruction that performs a branch if the overflow flag is clear. If the overflow flag is set, control simply falls through to the next instruction.

No flags are affected.

#### Syntax

```
BVC nearlabel
```

#### Cycle Penalties

- BVC takes one extra cycle if the branch is taken
- BVC takes another extra cycle if that branch taken crosses a page boundary in emulation mode.

### See Also

- BVS
- BVC (SPC700)
- CLV
- BRA

### External Links

- Eyes & Lichty, [page 439](https://archive.org/details/0893037893ProgrammingThe65816/page/439) on BVC
- Labiak, [page 128](https://archive.org/details/Programming_the_65816/page/n138) on BVC
- 4.1.2.8 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 41](https://archive.org/details/mos_microcomputers_programming_manual/page/n56) on BVC
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 252](https://archive.org/details/6502UsersManual/page/n265) on BVC
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-51](https://archive.org/details/6502-assembly-language-programming/page/n100) on BVC
- snes9x implementation of BVC: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1395](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1395)
