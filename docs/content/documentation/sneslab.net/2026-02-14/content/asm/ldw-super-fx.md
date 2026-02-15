---
title: "LDW (Super FX)"
reference_url: https://sneslab.net/wiki/LDW_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
downloaded_at: 2026-02-14T13:34:21-08:00
cleaned_at: 2026-02-14T17:52:14-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied Indirect 4m 1 byte 10 cycles 12 cycles 7 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**LDW** (Load Word) is a Super FX instruction that loads one word from the Game Pak into the destination register. The cycle times recorded here include the time spent while the load is happening, when the GSU is in the wait state.

The ALT0 state is restored.

The destination registers should be specified in advance using WITH or TO. Otherwise, R0 serves as the default.

#### Syntax

```
LDW (Rm)
```

where m can be from 0~11

#### Example

Let:

```
Dreg : R5
R3 = 6480h
(70:6480h) = C0h
RAMBR = 70h
```

After executing LDW (R3):

```
R5 = C02eh
```

### See Also

- LDB
- STW
- RAMB

### External Links

- Official Super Nintendo development manual on LDW: 9.46 on [Page 2-9-66 of Book II](https://archive.org/details/SNESDevManual/book2/page/n222)
