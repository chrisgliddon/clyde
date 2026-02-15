---
title: "STW (Super FX)"
reference_url: https://sneslab.net/wiki/STW_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T16:40:09-08:00
cleaned_at: 2026-02-14T17:53:19-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied Indirect 3m 1 byte 3 to 8 cycles 7 to 11 cycles 1 to 6 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**STW** (Store Word) is a Super FX instruction that stores the value of the source register to the Game Pak. The bank must be specified with RAMB.

The exact number of cycles varies because STW utilizes the RAM buffer.

The operand may be any register from R0 to R11.

The source register should be specified in advance using WITH or FROM. Otherwise, R0 serves as the default.

The ALT0 state is restored.

#### Syntax

```
STW (Rm)
```

#### Example

Let:

```
Sreg : R10
R10 = 9326h
R2 : 5872h
RAMBR = 70h
```

After STW (R2) is executed:

```
(70:5872h) = 26h
(70:5873h) = 93h
```

### See Also

- STB
- LDW

### External Links

- Official Super Nintendo development manual on STW: 9.85 on [page 2-9-117 of Book II](https://archive.org/details/SNESDevManual/book2/page/n273)
