---
title: "BMI"
reference_url: https://sneslab.net/wiki/BMI
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Conditional_Branches"
  - "Two-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:03:52-08:00
cleaned_at: 2026-02-14T17:51:19-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 30 2 bytes 2 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**BMI** (Branch if Minus) is a 65x instruction that performs a jump if the negative flag is set. The signed displacement of the target address can range from -128 to 127.

If the negative flag is clear, control simply falls through to the instruction following BMI.

No flags are affected.

#### Syntax

```
BMI nearlabel
```

#### Cycle Penalties

- BMI takes one extra cycle if the branch is taken
- BMI takes another extra cycle if that branch crosses a page boundary in emulation mode.

### See Also

- BPL
- BMI (SPC700)

### External Links

- Eyes & Lichty, [page 432](https://archive.org/details/0893037893ProgrammingThe65816/page/432) on BMI
- Labiak, [page 122](https://archive.org/details/Programming_the_65816/page/n132) on BMI
- 4.1.2.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 40](https://archive.org/details/mos_microcomputers_programming_manual/page/n55) on BMI
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 250](https://archive.org/details/6502UsersManual/page/n263) on BMI
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-47](https://archive.org/details/6502-assembly-language-programming/page/n96) on BMI
- snes9x implementation of BMI: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1375](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1375)
