---
title: "PHA"
reference_url: https://sneslab.net/wiki/PHA
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Push_Instructions"
  - "One-byte_Instructions"
  - "Three-cycle_Instructions"
downloaded_at: 2026-02-14T15:51:12-08:00
cleaned_at: 2026-02-14T17:52:40-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Push) 48 1 byte 3 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**PHA** (PusH Accumulator) is a 65x instruction that pushes the value in the accumulator to the stack. If the accumulator is 16 bits wide, the high byte is pushed first. The stack pointer is decremented by the number of bytes pushed.

No flags are affected.

#### Syntax

```
PHA
```

#### Cycle Penalty

- PHA takes one extra cycle if the accumulator is 16 bits wide.

### See Also

- PLA
- PHP
- PHX
- PHY
- PHB
- PHK

### External Links

- Eyes & Lichty, [page 476](https://archive.org/details/0893037893ProgrammingThe65816/page/476) on PHA
- Labiak, [page 160](https://archive.org/details/Programming_the_65816/page/n170) on PHA
- 8.5 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 117](https://archive.org/details/mos_microcomputers_programming_manual/page/n136) on PHA
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 267](https://archive.org/details/6502UsersManual/page/n280) on PHA
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-81](https://archive.org/details/6502-assembly-language-programming/page/n130) on PHA
