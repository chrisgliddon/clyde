---
title: "BNE"
reference_url: https://sneslab.net/wiki/BNE
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Conditional_Branches"
  - "Two-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:04:06-08:00
cleaned_at: 2026-02-14T17:51:20-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative D0 2 bytes 2 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**BNE** (Branch if Not Equal) is a 65x instruction that performs a jump if the zero flag is clear. The displacement may be -128 to 127.

If the zero flag is set, control simply falls through to the instruction following BNE.

No flags are affected.

#### Syntax

```
BNE nearlabel
```

#### Cycle Penalties

- BNE takes one additional cycle if the branch is taken
- BNE takes another extra cycle if that branch taken crosses a page boundary in emulation mode.

### See Also

- BPL
- BNE (SPC700)
- BNE (Super FX)

### External Links

- Eyes & Lichty, [page 433](https://archive.org/details/0893037893ProgrammingThe65816/page/433) on BNE
- Labiak, [page 123](https://archive.org/details/Programming_the_65816/page/n133) on BNE
- 4.1.2.6 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 41](https://archive.org/details/mos_microcomputers_programming_manual/page/n56) on BNE
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 251](https://archive.org/details/6502UsersManual/page/n264) on BNE
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-47](https://archive.org/details/6502-assembly-language-programming/page/n96) on BNE
- snes9x implementation of BNE: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1380](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1380)
