---
title: "JMP"
reference_url: https://sneslab.net/wiki/JMP
categories:
  - "Inherited_from_6502"
  - "Unconditional_Branches"
  - "Non-relocatable_Instructions"
downloaded_at: 2026-02-14T13:30:22-08:00
cleaned_at: 2026-02-14T17:52:11-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 4C 3 bytes 3 cycles Absolute Indirect 6C 3 bytes 5 cycles Absolute Indexed Indirect 7C 3 bytes 6 cycles Absolute Long 5C 4 bytes 4 cycles Absolute Indirect Long DC 3 bytes 6 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**JMP** is a 65c816 instruction that performs an unconditional jump. This is analogous to GOTO in middle level programming languages.

JMP to a long address and JML work even in emulation mode, but are primarily intended for native mode.

#### Quirk

Although it was fixed in the 65c02, the following information is useful to keep in mind when porting code from other systems: The NMOS 6502's opcode 6C sometimes behaves incorrectly. When doing an indirect jump, care must be taken to make sure the two-byte vector containing the absolute target address does not straddle a page boundary (that is, the vector is not located at $xxFF for any xx). Otherwise, byte zero ($xx00) of the page the vector begins in will be misused as the high byte of the target address instead of the first byte of the following page.

JMP is not relocatable. No flags are affected.

#### Syntax

```
JMP addr
JMP (addr)
JMP (addr, X)
JMP long
JML long
JMP [addr]
JML [addr]
```

### See Also

- BRA
- BRL
- LJMP (Super FX)

### External Links

- Eyes & Lichty, [page 459](https://archive.org/details/0893037893ProgrammingThe65816/page/459) on JMP
- Labiak, [page 145](https://archive.org/details/Programming_the_65816/page/n155) on JML
- lbid, [page 146](https://archive.org/details/Programming_the_65816/page/n156) on JMP
- 4.0.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 36](https://archive.org/details/mos_microcomputers_programming_manual/page/n51) on JMP
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 261](https://archive.org/details/6502UsersManual/page/n274) on JMP
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-69](https://archive.org/details/6502-assembly-language-programming/page/n118) on JMP
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#JMP](http://www.6502.org/tutorials/6502opcodes.html#JMP)
