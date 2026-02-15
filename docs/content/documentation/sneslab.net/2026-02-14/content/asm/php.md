---
title: "PHP"
reference_url: https://sneslab.net/wiki/PHP
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Push_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T15:51:42-08:00
cleaned_at: 2026-02-14T17:52:43-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Push) 08 1 byte 3 cycles

Flags Affected N V M X D I Z C . . . .? . . . .

**PHP** is a 65x instruction that pushes the value of the processor status register onto the stack. The e bit is omitted from this operation. PHP always pushes a single byte.

The stack pointer will then point directly below the byte pushed.

No flags are affected according to Eyes & Lichty. But fullsnes claims that PHP always writes a one into the break flag.

#### Syntax

```
PHP
```

### See Also

- PLP
- PHA
- PHX
- PHY
- PHB
- PHK

### External Links

- Eyes & Lichty, [page 480](https://archive.org/details/0893037893ProgrammingThe65816/page/480) on PHP
- Labiak, [page 164](https://archive.org/details/Programming_the_65816/page/n174) on PHP
- 8.11 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 122](https://archive.org/details/mos_microcomputers_programming_manual/page/n141) on PHP
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 267](https://archive.org/details/6502UsersManual/page/n280) on PHP
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-82](https://archive.org/details/6502-assembly-language-programming/page/n131) on PHP
- snes9x implementation of PHP: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1844](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1844)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.8.3](http://www.6502.org/tutorials/65c816opcodes.html#6.8.3)
