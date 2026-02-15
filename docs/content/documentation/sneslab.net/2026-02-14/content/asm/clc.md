---
title: "CLC"
reference_url: https://sneslab.net/wiki/CLC
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:20:29-08:00
cleaned_at: 2026-02-14T17:51:31-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) 18 1 byte 2 cycles

Flags Affected N V M X D I Z C . . . . . . . 0

**CLC** is a 65x instruction that clears the carry flag.

The 6502 lacks an add-without-carry instruction, so it is important to make sure the carry flag is clear before doing an ADC or else the sum will be one too great.

No other flags are affected.

#### Syntax

```
CLC
```

One of the first instructions a SNES game runs after coming out of reset is often a CLC so that XCE can switch to native mode.

To clear more than one flag at the same time, use REP.

### See Also

- SEC
- CLV
- CLD
- CLI
- CLRC

### External Links

- Eyes & Lichty, [page 441](https://archive.org/details/0893037893ProgrammingThe65816/page/441) on CLC
- Labiak, [page 130](https://archive.org/details/Programming_the_65816/page/n140) on CLC
- 3.0.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 25](https://archive.org/details/mos_microcomputers_programming_manual/page/n40) on CLC
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 253](https://archive.org/details/6502UsersManual/page/n266) on CLC
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-52](https://archive.org/details/6502-assembly-language-programming/page/n101) on CLC
- snes9x implementation of CLC: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1420](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1420)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.4.1](http://www.6502.org/tutorials/65c816opcodes.html#6.4.1)
