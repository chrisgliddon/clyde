---
title: "SEC"
reference_url: https://sneslab.net/wiki/SEC
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T16:20:46-08:00
cleaned_at: 2026-02-14T17:53:04-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) 38 1 byte 2 cycles

Flags Affected N V M X D I Z C . . . . . . . 1

**SEC** is a 65x instruction that sets the carry flag.

Similar to doing a CLC before an ADC, it is recommended to run SEC (or otherwise make sure the carry flag is set) before running a SBC so that the difference is correct.

No other flags are affected.

#### Syntax

```
SEC
```

### See Also

- CLC
- XCE
- SED
- SEI
- SEP

### External Links

- Eyes & Lichty, [page 499](https://archive.org/details/0893037893ProgrammingThe65816/page/499) on SEC
- Labiak, [page 180](https://archive.org/details/Programming_the_65816/page/n190) on SEC
- 3.0.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 24](https://archive.org/details/mos_microcomputers_programming_manual/page/n39) on SEC
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 272](https://archive.org/details/6502UsersManual/page/n285) on SEC
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-93](https://archive.org/details/6502-assembly-language-programming/page/n142) on SEC
- snes9x implementation of SEC: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1427](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1427)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.4.1](http://www.6502.org/tutorials/65c816opcodes.html#6.4.1)
