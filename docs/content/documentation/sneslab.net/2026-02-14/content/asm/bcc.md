---
title: "BCC"
reference_url: https://sneslab.net/wiki/BCC
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Conditional_Branches"
  - "Two-byte_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:00:04-08:00
cleaned_at: 2026-02-14T17:51:12-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 90 2 bytes 2 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**BCC** (Branch if Carry Clear) is a 65x instruction that performs a jump if the carry flag is clear. An alternate mnemonic is "BLT."

If carry is set, control simply falls through to the next instruction.

No flags are affected.

#### Syntax

```
BCC nearlabel
BLT nearlabel
```

#### Cycle Penalties

- BCC takes one additional cycle if the branch is taken
- BCC takes another extra cycle in emulation mode if that branch taken crosses a page boundary.

### See Also

- BCS
- XCE
- BCC (Super FX)
- BLT (Super FX)

### External Links

- Eyes & Lichty, [page 428](https://archive.org/details/0893037893ProgrammingThe65816/page/428) on BCC
- Labiak, [page 118](https://archive.org/details/Programming_the_65816/page/n128) on BCC
- 4.1.2.3 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 40](https://archive.org/details/mos_microcomputers_programming_manual/page/n55) on BCC
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 248](https://archive.org/details/6502UsersManual/page/n261) on BCC
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-43](https://archive.org/details/6502-assembly-language-programming/page/n92) on BCC
- snes9x implementation of BCC: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1360](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1360)
