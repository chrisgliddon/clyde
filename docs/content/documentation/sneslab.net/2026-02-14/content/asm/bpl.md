---
title: "BPL"
reference_url: https://sneslab.net/wiki/BPL
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Conditional_Branches"
  - "Two-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:04:21-08:00
cleaned_at: 2026-02-14T17:51:21-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 10 2 bytes 2 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**BPL** (Branch if PLus) is a 65x instruction that performs a jump if the negative flag is clear. Note that zero is considered positive in the 65x architecture, so this instruction's behavior might be more accurately be described as "branch if non-negative."

The signed displacement of the target address can range from -128 to 127.

If the negative flag is set, control simply falls through to the instruction following BPL.

No flags are affected.

#### Syntax

```
BPL nearlabel
```

#### Cycle Penalties

- BPL takes one additional cycle if the branch is taken
- BPL takes another extra cycle if that branch taken crosses a page boundary in emulation mode.

### See Also

- BMI
- BNE
- BPL (SPC700)
- BPL (Super FX)

### External Links

- Eyes & Lichty, [page 434](https://archive.org/details/0893037893ProgrammingThe65816/page/434) on BPL
- Labiak, [page 124](https://archive.org/details/Programming_the_65816/page/n134) on BPL
- 4.1.2.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 40](https://archive.org/details/mos_microcomputers_programming_manual/page/n55) on BPL
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 251](https://archive.org/details/6502UsersManual/page/n264) on BPL
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-48](https://archive.org/details/6502-assembly-language-programming/page/n97) on BPL
- snes9x implementation of BPL: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1385](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1385)
