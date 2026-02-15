---
title: "TYA"
reference_url: https://sneslab.net/wiki/TYA
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Transfer_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T17:00:54-08:00
cleaned_at: 2026-02-14T17:53:37-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 98 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**TYA** is a 65x instruction that transfers the value of the Y index register to the accumulator. The size of the accumulator determines whether this is an 8 or 16 bit operation. TYA always takes two cycles, regardless of whether one or two bytes are transferred.

Instruction Behavior **8-bit accumulator (m=1)** **16-bit accumulator (m=0)** **8-bit index registers (x=1)** 8 bits are transferred 8 bits are transferred to the low byte of accumulator and high byte of the accumulator is zeroed **16-bit index registers (x=0)** 8 bits (the low byte of the index register) are transferred and the hidden byte of the B accumulator is unaffected 16 bits are transferred

#### Syntax

```
TYA
```

### See Also

- TXA
- TAY
- TYX
- STY

### External Links

- Eyes & Lichty, [page 520](https://archive.org/details/0893037893ProgrammingThe65816/page/520) on TYA
- Labiak, [page 201](https://archive.org/details/Programming_the_65816/page/n211) on TYA
- 7.14 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 101](https://archive.org/details/mos_microcomputers_programming_manual/page/n119) on TYA
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 275](https://archive.org/details/6502UsersManual/page/n288) on TYA
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-104](https://archive.org/details/6502-assembly-language-programming/page/n153) on TYA
- snes9x implementation of TYA: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2455](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2455)
