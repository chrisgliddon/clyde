---
title: "BEQ"
reference_url: https://sneslab.net/wiki/BEQ
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Conditional_Branches"
  - "Two-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:01:17-08:00
cleaned_at: 2026-02-14T17:51:14-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative F0 2 bytes 2 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**BEQ** (Branch if Equal) is a 65x instruction that performs a jump if the zero flag is set. If the zero flag is clear, control simply falls through to the instruction following BEQ.

No flags are affected.

#### Syntax

```
BEQ nearlabel
```

#### Cycle Penalties

- BEQ takes an extra cycle if the branch is taken
- BEQ takes another extra cycle if the branch taken crosses a page boundary in emulation mode

### See Also

- BNE
- BEQ (Super FX)

### External Links

- Eyes & Lichty, [page 430](https://archive.org/details/0893037893ProgrammingThe65816/page/430) on BEQ
- Labiak, [page 120](https://archive.org/details/Programming_the_65816/page/n130) on BEQ
- 4.1.2.5 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 41](https://archive.org/details/mos_microcomputers_programming_manual/page/n56) on BEQ
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 249](https://archive.org/details/6502UsersManual/page/n262) on BEQ
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-44](https://archive.org/details/6502-assembly-language-programming/page/n93) on BEQ
- snes9x implementation of BEQ: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1370](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1370)
