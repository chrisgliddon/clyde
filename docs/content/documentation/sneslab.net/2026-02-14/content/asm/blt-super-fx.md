---
title: "BLT (Super FX)"
reference_url: https://sneslab.net/wiki/BLT_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "GSU_Control_Instructions"
  - "Instructions_with_Delay_Slots"
downloaded_at: 2026-02-14T11:03:35-08:00
cleaned_at: 2026-02-14T17:51:18-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Program Counter Relative 06 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z . . . . . . .

**BLT** (Branch if Less Than) is a Super FX opcode that performs a jump if the sign flag is unequal to the O/V flag, effectively checking for a signed less-than comparison (compare BCC which is an unsigned less-than comparison).

According to fullsnes, the official documentation has BLT exchanged with BGE. \[2]

No flags are affected.

#### Syntax

```
BLT e
```

#### Example

Let the sign flag be set and the overflow flag clear. This instruction jumps the program forward 4 bytes:

```
 BLT $+4h
```

### See also

- BGE
- BCC (Super FX)

### External Links

1. Official Nintendo documentation on BLT: [Page 2-9-24 of Book II](https://archive.org/details/SNESDevManual/book2/page/n180)
2. [https://problemkaputt.de/fullsnes.htm#snescartgsuncpumisc](https://problemkaputt.de/fullsnes.htm#snescartgsuncpumisc)
3. example: [page 2-9-25](https://archive.org/details/SNESDevManual/book2/page/n181), lbid.
