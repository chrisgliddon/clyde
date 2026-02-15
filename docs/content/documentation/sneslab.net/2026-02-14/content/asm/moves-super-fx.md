---
title: "MOVES (Super FX)"
reference_url: https://sneslab.net/wiki/MOVES_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T13:48:31-08:00
cleaned_at: 2026-02-14T17:52:26-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 2n'Bn 2 bytes 6 cycles 6 cycles 2 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 D7 D15 . Z

**MOVES** (Move and Set flags) is a Super FX instruction that moves the value of a general register into another general register.

According to fullsnes, the official documentation has the source and destination operands for MOVES mixed up. \[2]

The flags are affected according to the datum moved. O/V will reflect bit 7, the sign flag will reflect bit 15, and the zero flag will be set iff the datum moved is zero.

The ALT0 state is restored.

#### Syntax

```
MOVES Rn, Rn'
```

#### Example

Let:

```
R7 = 4983h
```

After executing MOVES R10, R7:

```
R10 = 4983h
```

and the overflow flag is set.

### See Also

- MOVE
- MOVEW
- MOVEB
- MOV

### External Links

1. Official Super Nintendo development manual on MOVES: 9.63 on [Page 2-9-89 of Book II](https://archive.org/details/SNESDevManual/book2/page/n245)
2. [https://problemkaputt.de/fullsnes.htm#snescartgsuncpumisc](https://problemkaputt.de/fullsnes.htm#snescartgsuncpumisc)
