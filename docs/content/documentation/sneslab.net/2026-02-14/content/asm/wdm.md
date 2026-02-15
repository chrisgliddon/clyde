---
title: "WDM"
reference_url: https://sneslab.net/wiki/WDM
categories:
  - "ASM"
  - "65c816_additions"
  - "Two-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T17:16:43-08:00
cleaned_at: 2026-02-14T17:53:41-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 3)\[4] 42 2 bytes 2 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**WDM** (the initials of [William David Mensch](https://themenschfoundation.org/who-is-william-d-mensch-jr-aka-bill-mensch/), the designer of the 65c816) is an instruction that reserves its signature byte for future expansion of the instruction set. None of these extra 256 opcodes were ever implemented, so WDM functions essentially as a two-byte NOP.

No flags are affected, but future expanded WDM opcodes may affect the flags (or even have different instruction lengths/speeds for that matter.)

WDM "works" even in emulation mode.

#### Syntax

```
WDM
WDM sig
```

ca65 for example requires the signature byte to be specified in the assembly source.

Directly specifying the opcode 42h can be used to skip the next instruction.\[5]

WDM is a popular way to insert debug breakpoints into SNES code - by configuring your emulator to trip on WDM, the signature byte can be used to disambiguate which breakpoint has been reached.

### Trivia

- WDM is the only implied addressing instruction that is more than one byte long
- The Labiak textbook does not describe the WDM instruction.

### See Also

- COP
- BRK

### External Links

1. Eyes & Lichty, [page 523](https://archive.org/details/0893037893ProgrammingThe65816/page/523) on WDM
2. snes9x implementation of WDM: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3335](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3335)
3. undisbeliever on WDM: [https://undisbeliever.net/snesdev/65816-opcodes.html#wdm-reserved-for-future-expansion](https://undisbeliever.net/snesdev/65816-opcodes.html#wdm-reserved-for-future-expansion)
4. Table 5-4 Opcode Matrix of official 65c816 datasheet
5. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.7](http://www.6502.org/tutorials/65c816opcodes.html#6.7)
