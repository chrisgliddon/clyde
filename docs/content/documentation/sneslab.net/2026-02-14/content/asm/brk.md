---
title: "BRK"
reference_url: https://sneslab.net/wiki/BRK
categories:
  - "Inherited_from_6502"
  - "Two-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:05:20-08:00
cleaned_at: 2026-02-14T17:51:24-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Interrupt) 00 2 bytes 8 cycles*

Flags Affected N V M X / B D I Z C 65c816 native mode . . . . 0 1 . . 6502 emulation mode . . . 1 0 1 . .

**BRK** (Break) is a 65x instruction that triggers a non-maskable software interrupt (NMI). The byte following the opcode is called the signature byte. The state of the interrupt disable flag has no effect on the behavior of BRK although it will be set after BRK runs.

In native mode the program bank register is pushed to the stack. Then the program counter is incremented by two and then pushed to the stack. Then the status register (with the break flag set, if in emulation mode) is pushed to the stack. Then the interrupt disable flag is set. In native mode, the program bank register is then cleared.

Control is routed to the BRK handler, whose address is stored at the BRK vector:

- In native mode, this vector is at $00:FFE6.
- In emulation mode, this vector is at $FFFE.

#### Syntax

```
BRK
BRK sig
```

#### Cycle Skipped

BRK takes one fewer cycle in emulation mode as it doesn't need to push the program counter bank register to the stack.

If the signature byte was omitted from the assembler source, then it ends up serving double duty as the opcode of the next instruction. In this case the interrupt handler must decrement the return address on the stack so that the eventual RTI does not cause derailment.

BRK used to be considered a one-byte instruction in an early datasheet. On the NMOS 6502, BRK does not affect the decimal flag, but this likely only affects porting code from systems other than the NES because the NES does not have decimal mode anyway.

### See Also

- RTI
- BRK (SPC700)
- NMI
- IRQ
- COP
- WDM
- CLD
- SEI

### External Links

- Eyes & Lichty, [page 436](https://archive.org/details/0893037893ProgrammingThe65816/page/436) on BRK
- Figure 13.3, Break Signature Byte Illustration, lbid, [page 256](https://archive.org/details/0893037893ProgrammingThe65816/page/n282)
- Labiak, [page 126](https://archive.org/details/Programming_the_65816/page/n136) on BRK
- 9.11 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 144](https://archive.org/details/mos_microcomputers_programming_manual/page/n164) on BRK
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 252](https://archive.org/details/6502UsersManual/page/n265) on BRK
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-49](https://archive.org/details/6502-assembly-language-programming/page/n98) on BRK
- snes9x implementation of BRK: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2547](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2547)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#BRK](http://www.6502.org/tutorials/6502opcodes.html#BRK)
- Clark, Bruce. [http://www.6502.org/tutorials/65c02opcodes.html#6](http://www.6502.org/tutorials/65c02opcodes.html#6)
- [https://undisbeliever.net/snesdev/65816-opcodes.html#software-interrupts](https://undisbeliever.net/snesdev/65816-opcodes.html#software-interrupts)
