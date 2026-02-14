---
title: "Miscellaneous opcodes"
reference_url: https://ersanio.gitbook.io/assembly-for-the-snes/deep-dives/misc
categories:
  - "Documentation"
downloaded_at: 2026-02-13T20:24:42-08:00
---

This chapter explains opcodes which don't really fit in any other chapter.

## [hashtag](#nop) NOP

Opcode

Full name

Explanation

**NOP**

No operation

Does absolutely nothing

It is often used to disable existing opcodes in a ROM without shifting around the machine code. It can also be used to give time for the [math hardware registers](/assembly-for-the-snes/mathemathics-and-logic/math) to do their work.

## [hashtag](#xba) XBA

Opcode

Full name

Explanation

**XBA**

Exchange B and A

Swaps the high and the low bytes of the A register, regardless of the register size.

Here's an example:

Copy

```
LDA #$0231         ; A = $0231
XBA                ; A is now $3102
```

This even works with 8-bit A, as the high byte of A is "hidden" rather than set to $00:

Copy

```
LDA #$12           ; A = $xx12
XBA                ; A = $12xx
LDA #$05           ; A = $1205
```

## [hashtag](#wai) WAI

Opcode

Full name

Explanation

**WAI**

Wait for interrupt

Halts the SNES CPU until either an NMI or IRQ occurs.

Exactly what it says, it halts the SNES CPU until either an NMI or IRQ (both are interrupts) occurs. Practically speaking, the opcode loops itself infinitely until an interrupt occurs.

## [hashtag](#stp) STP

Opcode

Full name

Explanation

**STP**

Stop the clock

The "clock" being the SNES CPU in this case, it halts the CPU completely until either a soft or hard reset occurs.

Exactly what it says, it stops the SNES CPU until you hit reset or power cycle the SNES. It does lower the power consumption of the SNES, if the couple of cents it'll shave off your power bill means that much to you.

## [hashtag](#brk) BRK

Opcode

Full name

Explanation

**BRK**

Software break

Causes a break to occur

This opcode causes the SNES to jump to the [break vector](/assembly-for-the-snes/deep-dives/vector). It also takes a byte parameter. Example usage:

The parameter is not used for anything in particular, but if you write a meaningful "catch" to the BRK, you could probably read what the value of the BRK was supposed to be, and do certain things depending on the value.

When the BRK opcode is executed, the following events happen:

- First, the (24-bit) address of the instruction after `BRK #$xx` is pushed onto the stack
- Then, the (8-bit) processor flag register is pushed onto the stack.
- The interrupt disable flag is set (akin to `SEI`)
- The decimal mode flag is cleared (akin to `CLD`)
- The program bank register is cleared to $00
- The program counter is loaded from the break vector. In other words, the code jumps to the address at the break vector.

If the emulators are made properly, the opcode BRK makes debuggers snap. You could also program the break vector to do meaningful things. In fact, on SMWCentral, [p4plus2 released a patch which does exactly thisarrow-up-right](https://www.smwcentral.net/?p=section&a=details&id=20796); it shows debug information about the crash.

## [hashtag](#cop) COP

Opcode

Full name

Explanation

**COP**

Coprocessor empowerment

Similar effects as BRK, as the SNES has no coprocessor to empower.

This opcode causes the SNES to jump to the [COP hardware vector](/assembly-for-the-snes/deep-dives/vector). It also takes a byte parameter. Example usage:

The parameter is not used for anything in particular, but if you write a meaningful "catch" to the COP, you could probably read what the value of the COP was supposed to be, and do certain things depending on the value.

When the COP opcode is executed, the following events happen:

- First, the (24-bit) address of the instruction after `COP #$xx` is pushed onto the stack
- Then, the (8-bit) processor flag register is pushed onto the stack.
- The interrupt disable flag is set (akin to `SEI`)
- The decimal mode flag is cleared (akin to `CLD`)
- The program bank register is cleared to $00
- The program counter is loaded from the COP hardware vector. In other words, the code jumps to the address at the COP hardware vector.

## [hashtag](#wdm) WDM

Opcode

Full name

Explanation

**WDM**

Reserved for future expansion

Does absolutely nothing

WDM stands for "[William (Bill) David Mensch, Jr.arrow-up-right](https://en.wikipedia.org/wiki/Bill_Mensch)", who designed the 65c816. This opcode was reserved for the possibility of multi-byte opcodes. Therefore, this opcode actually takes a parameter. Example:

This opcode has the same effect as NOP however. Therefore, it does nothing.

[PreviousAddressing modes revisted](/assembly-for-the-snes/deep-dives/addressing)[NextMachine cycles](/assembly-for-the-snes/deep-dives/cycles)

Last updated 4 years ago
