---
title: "BGE (Super FX)"
reference_url: https://sneslab.net/wiki/BGE_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "GSU_Control_Instructions"
  - "Instructions_with_Delay_Slots"
downloaded_at: 2026-02-14T11:02:25-08:00
cleaned_at: 2026-02-14T17:51:15-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Program Counter Relative 07 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z . . . . . . .

**BGE** (Branch if Greater or Equal) is a Super FX opcode that performs a jump if the sign flag is equal to the O/V flag, effectively checking for a signed greater-equal comparison (compare BCS which is an unsigned greater-equal comparison).

According to fullsnes, the official documentation has BGE exchanged with BLT. \[2]

No flags are affected.

#### Syntax

```
BGE e
```

#### Example

Let the sign flag and O/V flag be set. This instruction jumps the program backward 3 bytes:

```
 BGE $-3h
```

### See also

- BLT
- BCS

### References

1. Official Nintendo dev manual on BGE: 9.17 on [page 2-9-20 of Book II](https://archive.org/details/SNESDevManual/book2/page/n176)
2. [https://problemkaputt.de/fullsnes.htm#snescartgsuncpumisc](https://problemkaputt.de/fullsnes.htm#snescartgsuncpumisc)
3. example: [page 2-9-21](https://archive.org/details/SNESDevManual/book2/page/n177), lbid.
