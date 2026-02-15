---
title: "BIT"
reference_url: https://sneslab.net/wiki/BIT
categories:
  - "ASM"
  - "Group_Three_Instructions"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T11:03:13-08:00
cleaned_at: 2026-02-14T17:51:17-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 89 2/3 bytes 2 cycles* Absolute 2C 3 bytes 4 cycles* Direct Page 24 2 bytes 3 cycles* Absolute Indexed by X 3C 3 bytes 4 cycles* Direct Page Indexed by X 34 2 bytes 4 cycles*

Flags Affected Addressing Mode N V M X D I Z C Immediate . . . . . . Z . other N V . . . . Z .

**BIT** is a 65x instruction that performs a logical AND operation between the accumulator and memory without storing the conjunction. If the conjunction is zero, the zero flag is set, otherwise it is cleared.

Except in immediate addressing, the most significant bit of the data located at the effective address is moved into the negative flag, and the second most significant bit of that data is moved into the overflow flag. BIT is often used right before a conditional branch instruction like BVC or BVS.

#### Syntax

```
BIT #const
BIT addr
BIT dp
BIT addr, X
BIT dp, X
```

#### Cycle Penalties

- BIT takes an extra cycle when the accumulator is 16 bits wide, in all addressing modes
- In direct page addressing modes, BIT takes an extra cycle when the low byte of the direct page register is nonzero
- In Absolute Indexed, X Addressing, BIT takes an extra cycle when adding the index crosses a page boundary

### See Also

- AND
- BPL
- BNE
- BCC
- BCS

### External Links

- Eyes & Lichty, [page 431](https://archive.org/details/0893037893ProgrammingThe65816/page/431) on BIT
- Labiak, [page 121](https://archive.org/details/Programming_the_65816/page/n131) on BIT
- 4.2.2.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 47](https://archive.org/details/mos_microcomputers_programming_manual/page/n62) on BIT
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 249](https://archive.org/details/6502UsersManual/page/n262) on BIT
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-45](https://archive.org/details/6502-assembly-language-programming/page/n94) on BIT
- snes9x implementation of BIT: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L265](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L265)
- undisbeliever on BIT: [https://undisbeliever.net/snesdev/65816-opcodes.html#bit-test-memory-bits-against-accumulator](https://undisbeliever.net/snesdev/65816-opcodes.html#bit-test-memory-bits-against-accumulator)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#BIT](http://www.6502.org/tutorials/6502opcodes.html#BIT)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.2.2](http://www.6502.org/tutorials/65c816opcodes.html#6.1.2.2)
