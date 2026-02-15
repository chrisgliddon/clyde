---
title: "Stack"
reference_url: https://sneslab.net/wiki/Stack
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Buffers"
downloaded_at: 2026-02-14T16:49:02-08:00
cleaned_at: 2026-02-14T17:53:15-08:00
---

The **Stack** is a LIFO (last-in, first-out) buffer which remembers the state of subroutines that are currently executing.

On the 65c816, the stack is always in bank zero.\[3] It can be thousands of bytes deep.\[1]

In emulation mode it wraps within page one.\[2]

The stack grows towards zero, but the most recently pushed byte is nontheless called the top of the stack.\[4] These instructions push things to the stack:

- PEA
- PEI
- PER
- PHA
- PHB
- PHD
- PHK
- PHP
- PHX
- PHY
- JSR
- JSL
- COP
- BRK

PL* instructions take one cycle more than their PH* counterparts because they have to increment the stack pointer to point to the top element before it can be pulled, whereas push instructions pipeline the decrement of SP so that it overlaps the opcode fetch of the next instruction. These instructions pull things from the stack:

- PLA
- PLB
- PLD
- PLP
- PLX
- PLY
- RTS
- RTL
- RTI

Note the lack of PLK. PHS and PLS similarly do not exist, nor do any instructions performing the inverse of PEA, PEI, or PER.

### See Also

- Stack Pointer

### References

1. Wilson, Garth. [https://wilsonminesco.com/816myths](https://wilsonminesco.com/816myths)
2. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#5.1.1](http://www.6502.org/tutorials/65c816opcodes.html#5.1.1)
3. section 2.11 of 65c816 datasheet: [https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
4. Eyes & Lichty, [page 33](https://archive.org/details/0893037893ProgrammingThe65816/page/33)
