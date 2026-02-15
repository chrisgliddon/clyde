---
title: "RTI"
reference_url: https://sneslab.net/wiki/RTI
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Unconditional_Branches"
  - "One-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T16:10:23-08:00
cleaned_at: 2026-02-14T17:52:58-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (RTI) 40 1 byte 7 cycles*

Flags Affected N V M X D I Z C 65c816 native mode N V M X D I Z C 6502 emulation mode N V . . D I Z C

**RTI** (ReTurn from Interrupt) is a 65x instruction used to return control from an interrupt handler. It does this by first pulling the status flags off of the stack and then the program counter (low byte before high byte) too. In native mode, the program bank register is pulled after that for a total of 4 bytes. In emulation mode, 3 bytes are pulled.

#### Syntax

```
RTI
```

Figure 18.10 on [page 493](https://archive.org/details/0893037893ProgrammingThe65816/page/493) of Eyes & Lichty has the old status register diagrammed as being four bytes deeper than the top of the stack before RTI, but the text on the previous page (and the bsnes source code) have the status register being pulled first.

#### Pitfalls

- RTI should only be run when the e flag is in the same state as when the interrupt fired
- RTI cannot even tell whether the interrupt actually occurred or not
- RTI does not increment the program counter after pulling it like RTS and RTL do

#### Cycle Skipped

RTI takes one fewer cycle in emulation mode as the program bank register doesn't need to be pulled from the stack.

### See Also

- BRK
- RTS
- RTL
- RETI
- PLP

### External Links

- Eyes & Lichty, [page 492](https://archive.org/details/0893037893ProgrammingThe65816/page/492) on RTI
- Labiak, [page 176](https://archive.org/details/Programming_the_65816/page/n186) on RTI
- 9.6 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 132](https://archive.org/details/mos_microcomputers_programming_manual/page/n152) on RTI
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 270](https://archive.org/details/6502UsersManual/page/n283) on RTI
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-89](https://archive.org/details/6502-assembly-language-programming/page/n138) on RTI
- snes9x implementation of RTI: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3272](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3272)
- undisbeliever on RTI: [https://undisbeliever.net/snesdev/65816-opcodes.html#rti-return-from-interrupt](https://undisbeliever.net/snesdev/65816-opcodes.html#rti-return-from-interrupt)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#RTI](http://www.6502.org/tutorials/6502opcodes.html#RTI)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.3.2](http://www.6502.org/tutorials/65c816opcodes.html#6.3.2)
- lbid, APPENDIX: EMULATION MODE, [http://www.6502.org/tutorials/65c816opcodes.html#APPENDIX](http://www.6502.org/tutorials/65c816opcodes.html#APPENDIX):
