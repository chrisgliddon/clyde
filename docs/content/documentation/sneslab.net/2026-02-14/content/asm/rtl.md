---
title: "RTL"
reference_url: https://sneslab.net/wiki/RTL
categories:
  - "ASM"
  - "65c816_additions"
  - "Unconditional_Branches"
  - "One-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T16:10:28-08:00
cleaned_at: 2026-02-14T17:53:00-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (RTL) 6B 1 byte 6 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**RTL** (Return from Subroutine Long) is a 65c816 instruction used to return control from a subroutine that may have been called from a different bank.

RTL pulls the return address from the stack, but increments the value by one before loading it into the program counter. The calling bank is then pulled into the program bank register. In other words, RTL unwinds what JSL did to the stack.

No flags are affected.

#### Syntax

```
RTL
```

RTL works even in emulation mode, but it is intended primarily for native mode.

### See Also

- RTI
- RTS
- RET
- RETI
- JSL
- JSR

### External Links

- Eyes & Lichty, [page 494](https://archive.org/details/0893037893ProgrammingThe65816/page/494) on RTL
- Labiak, [page 177](https://archive.org/details/Programming_the_65816/page/n187) on RTL
- snes9x implementation of RTL: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2879](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2879)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.2.2.2](http://www.6502.org/tutorials/65c816opcodes.html#6.2.2.2)
