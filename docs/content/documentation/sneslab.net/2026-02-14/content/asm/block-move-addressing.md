---
title: "Block Move Addressing"
reference_url: https://sneslab.net/wiki/Block_Move_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "Simple_Admodes"
  - "65c816_additions"
downloaded_at: 2026-02-14T11:13:16-08:00
cleaned_at: 2026-02-14T17:51:17-08:00
---

Two instructions use **Block Move Addressing** on the 65c816:

- MVP (opcode 44)
- MVN (opcode 54)

They are both 3 bytes long. The total number of bytes copied is the value in the C accumulator plus one. If a block move is interrupted, the current byte copy is completed, then the interrupt is serviced.

When the copying is complete:

- the accumulator will contain the value $FFFF.
- both index registers will point to the byte one past the end of the blocks they were pointing to
- if the source and destination blocks do not overlap, the source block is still intact

#### Syntax

Asar:

```
MVN srds
```

### See Also

- DMA

### References

- Eyes & Lichty, [page 388](https://archive.org/details/0893037893ProgrammingThe65816/page/388)
- "Block Moves" on [page 103](https://archive.org/details/0893037893ProgrammingThe65816/page/103), lbid
- section 3.5.9 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
