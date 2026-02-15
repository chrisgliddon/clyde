---
title: "LDB (Super FX)"
reference_url: https://sneslab.net/wiki/LDB_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T13:33:50-08:00
cleaned_at: 2026-02-14T17:52:14-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied Indirect 3D4m 2 byte 11 cycles 13 cycles 6 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**LDB** (Load Byte) is a Super FX instruction that loads one byte from the Game Pak and stores it in the low byte of the destination register. The high byte of the destination register is zeroed.

Part of the reason why LDB takes so many cycles is that the GSU waits for data to be loaded from game pak ram.

The ALT0 state is restored.

The destination register should be specified in advance using WITH or TO. Otherwise, R0 serves as the default.

#### Syntax

```
LDB (Rm)
```

where m can be from 0~11

#### Example

Let:

```
Dreg : R7
R1 = 3482h
RAMBR : 70h
(70:3482h) = 51h
```

After LDB (R1) is executed:

```
R7 = 0051h
```

### See Also

- LDW
- STB
- RAMB
- ALT1

### External Links

- Official Super Nintendo development manual on LDB: 9.45 on [Page 2-9-64 of Book II](https://archive.org/details/SNESDevManual/book2/page/n220)
- example: [Page 2-9-65](https://archive.org/details/SNESDevManual/book2/page/n221), lbid.
