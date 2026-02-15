---
title: "MVN"
reference_url: https://sneslab.net/wiki/MVN
categories:
  - "Block_Move_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T14:57:09-08:00
cleaned_at: 2026-02-14T17:52:30-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Block Move 54 3 bytes 7 cycles per byte moved

Flags Affected N V M X D I Z C . . . . . . . .

**MVN** (Block Move Negative) is a 65c816 instruction that copies a contiguous block of memory. It is intended to copy a block from a higher address to a lower address (moving it in the negative direction). No flags are affected.

In Eyes & Lichty, the "N" in the mnemonic stands for "Next" not "Negative."

MVN works even in emulation mode, but the blocks must be in the zeropage.

### Parameters

- the X index register specifies the starting (lowest) source address of the block
- the Y index register specifies the starting (lowest) destination address of the block
- the C double accumulator specifies the length of the block in bytes minus one
- the first operand byte specifies the destination bank the block will be in
- the second operand byte specifies the source bank the block starts out in

### Execution Sequence

The following loop is repeated until the value in the C double accumulator is $FFFF:

- one byte is copied from the address in X to the address in Y
- both X and Y are incremented
- C is decremented

If interrupted, the current byte finishes copying before servicing the interrupt. The destination bank is written to DBR.\[2]

### Assembler Syntax

Asar:

```
MVN srds
```

where "sr" is the source bank, and "ds" is the destination bank, with nothing in between them.\[1]

### See Also

- MVP
- DMA

### External Links

- Eyes & Lichty, [page 466](https://archive.org/details/0893037893ProgrammingThe65816/page/466) on MVN
- Labiak, [page 153](https://archive.org/details/Programming_the_65816/page/n163) on MVN
- snes9x implementation of MVN: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3011](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L3011)
- undisbeliever on MVN: [https://undisbeliever.net/snesdev/65816-opcodes.html#mvn-block-move-next](https://undisbeliever.net/snesdev/65816-opcodes.html#mvn-block-move-next)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.6](http://www.6502.org/tutorials/65c816opcodes.html#6.6)

### References

1. example source file which contains MVN: [https://github.com/InsaneFirebat/sm\_practice\_hack/blob/master/src/custompresets.asm](https://github.com/InsaneFirebat/sm_practice_hack/blob/master/src/custompresets.asm)
2. paragraph 7.18 on 65c816 datasheet
