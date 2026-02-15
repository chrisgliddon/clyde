---
title: "CPY"
reference_url: https://sneslab.net/wiki/CPY
categories:
  - "ASM"
downloaded_at: 2026-02-14T11:24:48-08:00
cleaned_at: 2026-02-14T17:51:40-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate C0 2/3 bytes 2 cycles* Absolute CC 3 bytes 4 cycles* Direct Page C4 2 bytes 3 cycles*

Flags Affected N V M X D I Z C N . . . . . Z C

**CPY** (Compare Y) is a 65x instruction that compares the value of the Y index register to something. Internally, this is done via a subtraction, but the difference is not stored anywhere. Thus, the purpose of CPY is to setup the flags. The index register Y is the minuend. Depending on the addressing mode used, the subtrahend will be either an immediate value or the value stored at the effective address specified by the operand. The contents at the effective address (when not using immediate data) and the Y index register both remain unchanged.

CPY assumes its operands are unsigned.

#### Syntax

```
CPY #const
CPY addr
CPY dp
```

In immediate addressing, the 65c816 expects the number of bytes of immediate data to match the current size of the index registers.

#### Cycle Penalties

- CPY takes an extra cycle in all three addressing modes when the index registers are 16 bits wide.
- In direct page addressing only, CPY takes an extra cycle when the low byte of the direct register is nonzero.

### See Also

- CPX
- CMP
- SBC

### External Links

- Eyes & Lichty, [page 450](https://archive.org/details/0893037893ProgrammingThe65816/page/450) on CPY
- Labiak, [page 137](https://archive.org/details/Programming_the_65816/page/n147) on CPY
- 7.9 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 99](https://archive.org/details/mos_microcomputers_programming_manual/page/n117) on CPY
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 257](https://archive.org/details/6502UsersManual/page/n270) on CPY
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-59](https://archive.org/details/6502-assembly-language-programming/page/n108) on CPY
- snes9x implementation of CPY: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L442](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L442)
- undisbeliever on CPY: [https://undisbeliever.net/snesdev/65816-opcodes.html#cpy-compare-index-register-y-with-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#cpy-compare-index-register-y-with-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#CPY](http://www.6502.org/tutorials/6502opcodes.html#CPY)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.2](http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.2)
