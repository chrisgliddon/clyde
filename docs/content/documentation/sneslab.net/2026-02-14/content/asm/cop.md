---
title: "COP"
reference_url: https://sneslab.net/wiki/COP
categories:
  - "ASM"
  - "65c816_additions"
  - "Two-byte_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T11:23:56-08:00
cleaned_at: 2026-02-14T17:51:39-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Stack (Interrupt) 02 2 bytes 8 cycles*

Flags Affected N V M X D I Z C . . . . 0 1 . .

**COP** (Co-Processor) is a 65c816 instruction designed to run a co-processor command. COP triggers a software interrupt and control is routed to the COP handler, whose address is stored in the COP vector at $00:FFE4 (in native mode anyway, in emulation mode $FFF4 is used instead). The byte following the opcode is called the signature byte and is required by assemblers:

- Signature bytes of 00h to 7Fh can be programmer-defined
- Signature bytes of 80h to FFh are reserved for future microprocessors by the [Western Design Center](https://www.westerndesigncenter.com/)\[3]

The state of the interrupt disable flag has no effect on the behavior of COP although it will be set after COP runs.

Some examples of the kinds of microprocessors COP could be used to communicate with include:

- floating point
- graphics

The PBR is cleared, but in native mode its previous value is pushed to the stack.

#### Syntax

```
COP sig
```

#### Cycle Skipped

- COP takes one fewer cycle in emulation mode as it doesn't need to push the program counter bank register to the stack.

COP is not really used for anything on the SNES.\[7]

### See Also

- BRK
- WDM
- Enhancement Chips

### External Links

1. Eyes & Lichty, [page 447](https://archive.org/details/0893037893ProgrammingThe65816/page/447) on COP
2. Labiak, [page 135](https://archive.org/details/Programming_the_65816/page/n145) on COP
3. section 7.15 of 65c816 datasheet
4. snes9x implementation of COP: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2738](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2738)
5. [https://ersanio.gitbook.io/assembly-for-the-snes/deep-dives/misc](https://ersanio.gitbook.io/assembly-for-the-snes/deep-dives/misc)
6. [https://undisbeliever.net/snesdev/65816-opcodes.html#software-interrupts](https://undisbeliever.net/snesdev/65816-opcodes.html#software-interrupts)
7. [https://forums.nesdev.org/viewtopic.php?p=176406#p176406](https://forums.nesdev.org/viewtopic.php?p=176406#p176406)
