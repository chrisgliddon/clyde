---
title: "BRA"
reference_url: https://sneslab.net/wiki/BRA
categories:
  - "ASM"
  - "65c02_additions"
  - "Unconditional_Branches"
  - "Two-byte_Instructions"
  - "Relocatable_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:04:54-08:00
cleaned_at: 2026-02-14T17:51:22-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Program Counter Relative 80 2 bytes 3 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**BRA** (BRanch Always) is a 65c816 instruction that performs an unconditional jump. The signed displacement ranges from -128 to 127. The displacement is sign-extended to 16 bits and added to the program counter. The displacement is measured from the instruction following BRA.

BRA is relocatable. No flags are affected.

#### Syntax

```
BRA nearlabel
```

BRA has the same timing as other branches, it just has no "branch not taken" case.

##### Cycle Penalty

- BRA takes one additional cycle if the branch crosses a page boundary in emulation mode.

### See Also

- JMP
- BRA (Super FX)

### External Links

- Eyes & Lichty, [page 435](https://archive.org/details/0893037893ProgrammingThe65816/page/435) on BRA
- Labiak, [page 125](https://archive.org/details/Programming_the_65816/page/n135) on BRA
- snes9x implementation of BRA: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1390](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1390)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.2.1.1](http://www.6502.org/tutorials/65c816opcodes.html#6.2.1.1)
