---
title: "MVP"
reference_url: https://sneslab.net/wiki/MVP
categories:
  - "ASM"
  - "65c816_additions"
  - "Block_Move_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T14:57:30-08:00
cleaned_at: 2026-02-14T17:52:30-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Block Move 44 3 bytes 7 cycles per byte moved

Flags Affected N V M X D I Z C . . . . . . . .

**MVP** (Block Move Positive) is a 65c816 instruction that copies a contiguous block of memory. It is intended to copy a block from a lower address to a higher address (moving it in the positive direction). No flags are affected.

In Eyes & Lichty, the "P" in the mnemonic stands for "Previous" not "Positive."

MVP works even in emulation mode, but the blocks must be in the zeropage.

### Parameters

- the X index register specifies the ending (highest) source address of the block
- the Y index register specifies the ending (highest) destination address of the block
- the C double accumulator specifies the length of the block in bytes minus one
- the first operand byte specifies the destination bank the block will be in
- the second operand byte specifies the source bank the block starts out in

### Execution Sequence

The following loop is repeated until the value in the C double accumulator is $FFFF:

- one byte is copied from the address in X to the address in Y
- both X and Y are decremented
- C is decremented

If interrupted, the current byte finishes copying before servicing the interrupt. The destination bank is written to DBR.\[1]

### See Also

- MVN
- DMA

### External Links

- Eyes & Lichty, [page 468](https://archive.org/details/0893037893ProgrammingThe65816/page/468) on MVP
- Labiak, [page 154](https://archive.org/details/Programming_the_65816/page/n164) on MVP
- snes9x implementation of MVP: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3077](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3077)
- undisbeliever on MVP: [https://undisbeliever.net/snesdev/65816-opcodes.html#mvp-block-move-previous](https://undisbeliever.net/snesdev/65816-opcodes.html#mvp-block-move-previous)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.6](http://www.6502.org/tutorials/65c816opcodes.html#6.6)

### Reference

1. paragraph 7.18 on 65c816 datasheet
