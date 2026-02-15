---
title: "PLP"
reference_url: https://sneslab.net/wiki/PLP
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Pull_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T15:52:54-08:00
cleaned_at: 2026-02-14T17:52:46-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Pull) 28 1 byte 4 cycles

Flags Affected N V M X / B D I Z C 65c816 native mode N V M X D I Z C 6502 emulation mode N V . B D I Z C

**PLP** (PulL status flags) is a 65x instruction that pulls the 8-bit value at the top of the stack into the status register. The stack pointer is incremented before the byte is pulled.

The emulation mode bit is not on the stack so it does not get pulled.

#### Syntax

```
PLP
```

### See Also

- PHP
- PLB
- PLD
- PLX
- PLY
- BRK
- RTI
- REP
- SEP

### External Links

- Eyes & Lichty, [page 486](https://archive.org/details/0893037893ProgrammingThe65816/page/486) on PLP
- Labiak, [page 170](https://archive.org/details/Programming_the_65816/page/n180) on PLP
- 8.12 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 123](https://archive.org/details/mos_microcomputers_programming_manual/page/n142) on PLP
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 268](https://archive.org/details/6502UsersManual/page/n281) on PLP
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-84](https://archive.org/details/6502-assembly-language-programming/page/n133) on PLP
- snes9x implementation of PLP: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2099](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2099)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.8.3](http://www.6502.org/tutorials/65c816opcodes.html#6.8.3)
