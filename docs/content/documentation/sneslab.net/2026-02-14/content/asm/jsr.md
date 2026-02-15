---
title: "JSR"
reference_url: https://sneslab.net/wiki/JSR
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Unconditional_Branches"
downloaded_at: 2026-02-14T13:30:49-08:00
cleaned_at: 2026-02-14T17:52:12-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 20 3 bytes 6 cycles Absolute Indexed Indirect FC 3 bytes 8 cycles Absolute Long 22 4 bytes 8 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**JSR** (Jump to Subroutine) is a 65x instruction that transfers control to a subroutine.

No flags are affected.

#### Syntax

```
JSR addr
JSR (addr, X)
JSR long
```

#### Execution Sequence

- The return address is pushed onto the stack (the current program counter value, which is the address of the last byte of this instruction)
- Control is transferred to the target location

### See Also

- JSL
- RTS
- RTL

### External Links

- Eyes & Lichty, [page 461](https://archive.org/details/0893037893ProgrammingThe65816/page/461) on JSR
- Labiak, [page 148](https://archive.org/details/Programming_the_65816/page/n158) on JSR
- 8.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 106](https://archive.org/details/mos_microcomputers_programming_manual/page/n125) on JSR
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 262](https://archive.org/details/6502UsersManual/page/n275) on JSR
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-70](https://archive.org/details/6502-assembly-language-programming/page/n119) on JSR
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#JSR](http://www.6502.org/tutorials/6502opcodes.html#JSR)
