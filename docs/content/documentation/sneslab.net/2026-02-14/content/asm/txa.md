---
title: "TXA"
reference_url: https://sneslab.net/wiki/TXA
categories:
  - "Inherited_from_6502"
  - "Transfer_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T17:00:34-08:00
cleaned_at: 2026-02-14T17:53:34-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 8A 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**TXA** is a 65x instruction that transfers the value of the X index register to the accumulator. The size of the accumulator determines whether this is an 8 or 16 bit operation. TXA always takes two cycles, regardless of whether one or two bytes are transferred.

Instruction Behavior **8-bit accumulator (m=1)** **16-bit accumulator (m=0)** **8-bit index registers (x=1)** 8 bits are transferred 8 bits are transferred to the low byte of accumulator and high byte of the accumulator is zeroed **16-bit index registers (x=0)** 8 bits are transferred 16 bits are transferred

#### Syntax

```
TXA
```

### See Also

- TYA
- TAX
- TXY
- STX
- TXS

### External Links

- Eyes & Lichty, [page 517](https://archive.org/details/0893037893ProgrammingThe65816/page/517) on TXA
- Labiak, [page 198](https://archive.org/details/Programming_the_65816/page/n208) on TXA
- 7.12 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 100](https://archive.org/details/mos_microcomputers_programming_manual/page/n118) on TXA
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 276](https://archive.org/details/6502UsersManual/page/n289) on TXA
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-102](https://archive.org/details/6502-assembly-language-programming/page/n151) on TXA
- snes9x implementation of TXA: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2384](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2384)
