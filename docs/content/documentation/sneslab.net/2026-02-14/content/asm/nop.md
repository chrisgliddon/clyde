---
title: "NOP"
reference_url: https://sneslab.net/wiki/NOP
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "One-byte_Instructions"
  - "Control_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T15:40:58-08:00
cleaned_at: 2026-02-14T17:52:33-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 3) EA 1 byte 2 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**NOP** (No OPeration) is an instruction that does nothing (other than increment the program counter by one).

No flags are affected.

#### Syntax

```
NOP
```

Early 65c816 chips commonly needed NOP after a REP or SEP.

### See Also

- WDM
- WAI
- NOP (SPC700)
- NOP (Super FX)
- STP
- SLEEP

### External Links

- Eyes & Lichty, [page 470](https://archive.org/details/0893037893ProgrammingThe65816/page/470) on NOP
- lbid, [page 263](https://archive.org/details/0893037893ProgrammingThe65816/page/n289).
- Labiak, [page 155](https://archive.org/details/Programming_the_65816/page/n165) on NOP
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 265](https://archive.org/details/6502UsersManual/page/n278) on NOP
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-78](https://archive.org/details/6502-assembly-language-programming/page/n127) on NOP
- snes9x implementation of NOP: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1606](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1606)
- undisbeliever on NOP: [https://undisbeliever.net/snesdev/65816-opcodes.html#nop-no-operation](https://undisbeliever.net/snesdev/65816-opcodes.html#nop-no-operation)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#NOP](http://www.6502.org/tutorials/6502opcodes.html#NOP)
