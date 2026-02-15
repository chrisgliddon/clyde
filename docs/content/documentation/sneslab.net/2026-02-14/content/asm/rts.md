---
title: "RTS"
reference_url: https://sneslab.net/wiki/RTS
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Unconditional_Branches"
  - "One-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T16:10:36-08:00
cleaned_at: 2026-02-14T17:53:01-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (RTS) 60 1 byte 6 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**RTS** (Return from Subroutine) is a 65x instruction used to return control from a subroutine that was called from the same bank.

RTS pulls the return address from the stack, but increments the value by one before loading it into the program counter. In other words, RTS unwinds what JSR did to the stack. The stack pointer is incremented twice: during cycle 3 and cycle 4.

No flags are affected.

#### Syntax

```
RTS
```

Forgetting to RTS can cause derailment as control falls through the end of the subroutine into the next one or garbage.

### See Also

- RTI
- RTL
- RET
- RETI

### External Links

- Eyes & Lichty, [page 496](https://archive.org/details/0893037893ProgrammingThe65816/page/496) on RTS
- Labiak, [page 178](https://archive.org/details/Programming_the_65816/page/n188) on RTS
- 8.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 108](https://archive.org/details/mos_microcomputers_programming_manual/page/n127) on RTS
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 271](https://archive.org/details/6502UsersManual/page/n284) on RTS
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-90](https://archive.org/details/6502-assembly-language-programming/page/n139) on RTS
- snes9x implementation of RTS: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2982](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2982)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#RTS](http://www.6502.org/tutorials/6502opcodes.html#RTS)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.2.2.2](http://www.6502.org/tutorials/65c816opcodes.html#6.2.2.2)
- [https://archive.org/details/mos\_microcomputers\_programming\_manual/page/n128](https://archive.org/details/mos_microcomputers_programming_manual/page/n128)
