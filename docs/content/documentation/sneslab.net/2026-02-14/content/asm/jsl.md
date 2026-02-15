---
title: "JSL"
reference_url: https://sneslab.net/wiki/JSL
categories:
  - "ASM"
  - "65c816_additions"
  - "Unconditional_Branches"
  - "Four-byte_Instructions"
downloaded_at: 2026-02-14T13:30:44-08:00
cleaned_at: 2026-02-14T17:52:11-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute Long 22 4 bytes 8 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**JSL** (Jump to Subroutine Long) is a 65c816 instruction that transfers control to a subroutine, possibly one in a different bank.

No flags are affected.

#### Syntax

```
JSL long
```

JSL works even in emulation mode, but it is intended primarily for native mode.

#### Execution Sequence

- the current program counter bank register pushed onto the stack
- the return address (JSL's opcode location plus 3) is pushed onto the stack
- control is transferred to the target location

JSR is a smaller/faster alternative if you know the subroutine is in the same bank as the call.

### See Also

- RTS
- RTL

### External Links

- Eyes & Lichty, [page 460](https://archive.org/details/0893037893ProgrammingThe65816/page/460) on JSL
- Labiak, [page 147](https://archive.org/details/Programming_the_65816/page/n157) on JSL
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.2.2.1](http://www.6502.org/tutorials/65c816opcodes.html#6.2.2.1)
