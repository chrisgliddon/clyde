---
title: "ASL"
reference_url: https://sneslab.net/wiki/ASL
categories:
  - "ASM"
  - "Group_Two_Instructions"
  - "Read-Modify-Write_Instructions"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T10:50:16-08:00
cleaned_at: 2026-02-14T17:51:08-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 0A 1 byte 2 cycles Absolute 0E 3 bytes 6 cycles* Direct Page 06 2 bytes 5 cycles* Absolute Indexed by X 1E 3 bytes 7 cycles* Direct Page Indexed by X 16 2 bytes 6 cycles*

Flags Affected N V M X D I Z C N . . . . . Z C

**ASL** (Arithmetic Shift Left) is a 65x instruction that shifts every bit of a value left one bit (multiplication by two). The least significant bit is cleared. The most significant bit is shifted into the carry flag. The previous value of the carry flag is lost (unlike with ROL).

The size of the accumulator determines how many bits are shifted (8 or 16) not including the clearing zero and carry flag.

#### Syntax

```
ASL
ASL A
ASL addr
ASL dp
ASL addr, X
ASL dp, X
```

#### Cycle Penalties

- Except in accumulator addressing, ASL takes two extra cycles when the accumulator is 16 bits wide
- In direct page addressing modes, ASL takes another extra cycle if the low byte of the direct page register is nonzero.

### See Also

- LSR
- ASL (SPC700)
- ROL

### External Links

- Eyes & Lichty, [page 427](https://archive.org/details/0893037893ProgrammingThe65816/page/427) on ASL
- lbid [page 190](https://archive.org/details/0893037893ProgrammingThe65816/page/190), before & after diagram of ASL
- Labiak, [page 117](https://archive.org/details/Programming_the_65816/page/n127) on ASL
- 10.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 149](https://archive.org/details/mos_microcomputers_programming_manual/page/n170) on ASL
- [B-4](https://archive.org/details/mos_microcomputers_programming_manual/page/n205), lbid.
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 247](https://archive.org/details/6502UsersManual/page/n260) on ASL
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-41](https://archive.org/details/6502-assembly-language-programming/page/n90) on ASL
- undisbeliever on ASL: [https://undisbeliever.net/snesdev/65816-opcodes.html#asl-arithmetic-shift-left](https://undisbeliever.net/snesdev/65816-opcodes.html#asl-arithmetic-shift-left)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#ASL](http://www.6502.org/tutorials/6502opcodes.html#ASL)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.3](http://www.6502.org/tutorials/65c816opcodes.html#6.1.3)
