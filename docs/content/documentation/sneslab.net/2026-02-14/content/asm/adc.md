---
title: "ADC"
reference_url: https://sneslab.net/wiki/ADC
categories:
  - "ASM"
  - "Group_One_Instructions"
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T10:46:39-08:00
cleaned_at: 2026-02-14T17:51:02-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 69 2/3 bytes 2 cycles* Absolute 6D 3 bytes 4 cycles* Absolute Long 6F 4 bytes 5 cycles* Direct Page 65 2 bytes 3 cycles* Direct Page Indirect 72 2 bytes 5 cycles* Direct Page Indirect Long 67 2 bytes 6 cycles* Absolute Indexed by X 7D 3 bytes 4 cycles* Absolute Long Indexed by X 7F 4 bytes 5 cycles* Absolute Indexed by Y 79 3 bytes 4 cycles* Direct Page Indexed by X 75 2 bytes 4 cycles* Direct Page Indexed Indirect by X 61 2 bytes 6 cycles* Direct Page Indirect Indexed by Y 71 2 bytes 5 cycles* Direct Page Indirect Long Indexed by Y 77 2 bytes 6 cycles* Stack Relative 63 2 bytes 4 cycles* Stack Relative Indirect Indexed by Y 73 2 bytes 7 cycles*

Flags Affected N V M X D I Z C N V . . . . Z C

**ADC** (Add with Carry) is the main 65x addition instruction. The accumulator is always both one of the addends and where the sum is stored. The operand serves as the other addend.

As there is no add-without-carry instruction, a CLC should be run (or the carry flag otherwise ensured to be clear) before an ADC, or else the sum will be one greater than expected.

After ADC runs, the carry flag will indicate whether the addition caused an unsigned overflow (sum greater than $FF or $FFFF depending on how wide the accumulator is). The zero flag will be set if the sum is zero and cleared otherwise.

If the decimal flag is set, then binary coded decimal addition is performed (with the sum being adjusted automatically), otherwise binary addition.

#### Syntax

```
ADC #const
ADC addr
ADC long
ADC dp
ADC (dp)
ADC [dp]
ADC addr, X
ADC long, X
ADC addr, Y
ADC dp, X
ADC (dp, X)
ADC (dp), Y
ADC [dp], Y
ADC sr, S
ADC (sr, S), Y
```

#### Cycle Penalties

ADC takes an extra cycle for each of the following:

- if the accumulator is 16 bits wide, in all addressing modes
- when utilizing the direct register, if the low byte of the direct register is nonzero
- in certain addressing modes if adding an index crosses a page boundary

If you only need to add one, consider INC instead. Unlike the 65c02, the 65c816 does not have a cycle penalty when adding in decimal mode.

### See Also

- SBC
- ADC (SPC700)
- ADC (Super FX)
- ADD (Super FX)
- INX
- INY

### External Links

- Eyes & Lichty, [page 423](https://archive.org/details/0893037893ProgrammingThe65816/page/423) on ADC
- Labiak, [page 115](https://archive.org/details/Programming_the_65816/page/n125) on ADC
- 2.2.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 7](https://archive.org/details/mos_microcomputers_programming_manual/page/n22) on ADC
- [B-3](https://archive.org/details/mos_microcomputers_programming_manual/page/n204), lbid.
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 245](https://archive.org/details/6502UsersManual/page/n258) on ADC
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-38](https://archive.org/details/6502-assembly-language-programming/page/n87) on ADC
- undisbeliever on ADC: [https://undisbeliever.net/snesdev/65816-opcodes.html#adc-add-with-carry](https://undisbeliever.net/snesdev/65816-opcodes.html#adc-add-with-carry)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#ADC](http://www.6502.org/tutorials/6502opcodes.html#ADC)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.1](http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.1)
