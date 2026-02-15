---
title: "PLA"
reference_url: https://sneslab.net/wiki/PLA
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Pull_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T15:52:09-08:00
cleaned_at: 2026-02-14T17:52:44-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Pull) 68 1 byte 4 cycles*

Flags Affected N V M X D I Z C N . . . . . Z .

**PLA** (PulL Accumulator) is a 65x instruction that pulls the value at the top of the stack into the accumulator. PLA increments the stack pointer before the pull by the number of bytes pulled. If the accumulator is 16 bits wide, the low byte is pulled and then the high byte is pulled.

The Eyes & Lichty page on PLA has a typo that says the 65x pull instructions "set" the zero and negative flags; it should say "affect."

The negative flag will then match the most significant bit of the pulled value. The zero flag will indicate whether the pulled value is zero.

#### Syntax

```
PLA
```

#### Cycle Penalty

- PLA takes one extra cycle if the accumulator is 16 bits wide.

### See Also

- PLX
- PLY
- PHA

### External Links

- Eyes & Lichty, [page 483](https://archive.org/details/0893037893ProgrammingThe65816/page/483) on PLA
- Labiak, [page 167](https://archive.org/details/Programming_the_65816/page/n177) on PLA
- 8.6 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 118](https://archive.org/details/mos_microcomputers_programming_manual/page/n137) on PLA
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 268](https://archive.org/details/6502UsersManual/page/n281) on PLA
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-83](https://archive.org/details/6502-assembly-language-programming/page/n132) on PLA
- snes9x implementation of [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1982](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1982)
