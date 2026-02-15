---
title: "STB (Super FX)"
reference_url: https://sneslab.net/wiki/STB_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T16:39:34-08:00
cleaned_at: 2026-02-14T17:53:16-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied Indirect 3D3m 2 bytes 6 to 9 cycles 8 to 14 cycles 2 to 5 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**STB** (Store Byte) is a Super FX instruction that stores the low byte of the source register to the Game Pak. STB expects the target address to be in the Rm register. The bank must be specified with RAMB.

The operand may be any register from R0 to R11. The number of cycles can vary because of the RAM buffer.

The source register should be specified in advance using WITH or FROM. Otherwise, R0 serves as the default.

The ALT0 state is restored.

#### Syntax

```
STB (Rm)
```

#### Example

Let:

```
Sreg : R5
R5 = 216ch
R8 = 9a34h
RAMBR = 70h
```

After STB (R8) is executed:

```
(70:9A34h) = 6ch
```

### See Also

- STW
- LDB
- ALT1

### External Links

- Official Super Nintendo development manual on STB: 9.83 on [page 2-9-115](https://archive.org/details/SNESDevManual/book2/page/n271)
