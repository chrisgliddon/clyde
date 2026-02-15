---
title: "TAX"
reference_url: https://sneslab.net/wiki/TAX
categories:
  - "Inherited_from_6502"
  - "Transfer_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T16:57:03-08:00
cleaned_at: 2026-02-14T17:53:25-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) AA 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**TAX** is a 65x instruction that transfers the value of the accumulator to the X index register. The size of the X index register determines how many bytes are transferred. TAX does not care how wide the accumulator is. TAX always takes two cycles, regardless of whether one or two bytes are transferred.

Instruction Behavior **8-bit accumulator (m=1)** **16-bit accumulator (m=0)** **8-bit index registers (x=1)** 8 bits are transferred 8 bits are transferred (low byte of accumulator) **16-bit index registers (x=0)** 16 bits are transferred (including hidden upper byte) 16 bits are transferred (full C accumulator)

#### Syntax

```
TAX
```

### See Also

- TAY
- TXA
- TCD
- TCS

### External Links

- Eyes & Lichty, [page 508](https://archive.org/details/0893037893ProgrammingThe65816/page/508) on TAX
- Labiak, [page 189](https://archive.org/details/Programming_the_65816/page/n199) on TAX
- 7.11 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 100](https://archive.org/details/mos_microcomputers_programming_manual/page/n118) on TAX
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 275](https://archive.org/details/6502UsersManual/page/n288) on TAX
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-99](https://archive.org/details/6502-assembly-language-programming/page/n148) on TAX
- snes9x implementation of TAX: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2258](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2258)
