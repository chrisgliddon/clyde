---
title: "BVS"
reference_url: https://sneslab.net/wiki/BVS
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Conditional_Branches"
  - "Two-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:06:30-08:00
cleaned_at: 2026-02-14T17:51:27-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 70 2 bytes 2 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**BVS** is a 65x instruction that performs a branch if the overflow flag is set.

If the overflow flag is clear, control simply falls through to the next instruction.

No flags are affected.

#### Syntax

```
BVS nearlabel
```

#### Cycle Penalties

- BVS takes one extra cycle if the branch is taken
- BVS takes another extra cycle if that branch taken crosses a page boundary in emulation mode.

### See Also

- BVC
- BVS (SPC700)
- BRA
- CLV

### External Links

- Eyes & Lichty, [page 440](https://archive.org/details/0893037893ProgrammingThe65816/page/440) on BVS
- Labiak, [page 129](https://archive.org/details/Programming_the_65816/page/n139) on BVS
- 4.1.2.7 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 41](https://archive.org/details/mos_microcomputers_programming_manual/page/n56) on BVS
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 253](https://archive.org/details/6502UsersManual/page/n266) on BVS
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-51](https://archive.org/details/6502-assembly-language-programming/page/n100) on BVS
- snes9x implementation of BVS: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1400](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1400)
