---
title: "BCS"
reference_url: https://sneslab.net/wiki/BCS
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Conditional_Branches"
  - "Two-byte_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:00:33-08:00
cleaned_at: 2026-02-14T17:51:13-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative B0 2 bytes 2 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**BCS** (Branch if Carry Set) is a 65x instruction that performs a jump if the carry flag is set. An alternate mnemonic is "BGE."

If carry is clear, control simply falls through to the next instruction.

No flags are affected.

#### Syntax

```
BCS nearlabel
BGE nearlabel
```

#### Cycle Penalties

- BCS takes one additional cycle if the branch is taken
- BCS takes another extra cycle in emulation mode if that branch taken crosses a page boundary.

### See Also

- BCC
- BVC
- BVS
- XCE
- BCS (Super FX)
- BGE (Super FX)

### External Links

- Eyes & Lichty, [page 429](https://archive.org/details/0893037893ProgrammingThe65816/page/429) on BCS
- Labiak, [page 119](https://archive.org/details/Programming_the_65816/page/n129) on BCS
- 4.1.2.4 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 40](https://archive.org/details/mos_microcomputers_programming_manual/page/n55) on BCS
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 248](https://archive.org/details/6502UsersManual/page/n261) on BCS
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-44](https://archive.org/details/6502-assembly-language-programming/page/n93) on BCS
- snes9x implementation of BCS: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1365](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1365)
