---
title: "CPX"
reference_url: https://sneslab.net/wiki/CPX
categories:
  - "ASM"
  - "Group_Three_Instructions"
  - "Inherited_from_6502"
  - "Compare_Instructions"
downloaded_at: 2026-02-14T11:24:44-08:00
cleaned_at: 2026-02-14T17:51:40-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate E0 2/3 bytes 2 cycles* Absolute EC 3 bytes 4 cycles* Direct Page E4 2 bytes 3 cycles*

Flags Affected N V M X D I Z C N . . . . . Z C

**CPX** (Compare X) is a 65x instruction that compares the value of the X index register to something. Internally, this is done via a subtraction, but the difference is not stored anywhere. Thus, the purpose of CPX is to setup the flags. The index register X is the minuend. Depending on the addressing mode used, the subtrahend will be either an immediate value or the value stored at the effective address specified by the operand. The contents at the effective address (when not using immediate data) and the X index register both remain unchanged.

CPX assumes its operands are unsigned.

#### Syntax

```
CPX #const
CPX addr
CPX dp
```

In immediate addressing, the 65c816 expects the number of bytes of immediate data to match the current size of the index registers.

#### Cycle Penalties

- CPX takes an extra cycle in all three addressing modes when the index registers are 16 bits wide.
- In direct page addressing only, CPX takes an extra cycle when the low byte of the direct register is nonzero.

### See Also

- CPY
- CMP
- SBC

### External Links

- Eyes & Lichty, [page 449](https://archive.org/details/0893037893ProgrammingThe65816/page/449) on CPX
- Labiak, [page 136](https://archive.org/details/Programming_the_65816/page/n146) on CPX
- 7.8 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 99](https://archive.org/details/mos_microcomputers_programming_manual/page/n117) on CPX
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 256](https://archive.org/details/6502UsersManual/page/n269) on CPX
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-58](https://archive.org/details/6502-assembly-language-programming/page/n107) on CPX
- snes9x implementation of CPX: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L402](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L402)
- undisbeliever on CPX: [https://undisbeliever.net/snesdev/65816-opcodes.html#cpx-compare-index-register-x-with-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#cpx-compare-index-register-x-with-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#CPX](http://www.6502.org/tutorials/6502opcodes.html#CPX)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.2](http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.2)
