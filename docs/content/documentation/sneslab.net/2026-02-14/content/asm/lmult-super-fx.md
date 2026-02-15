---
title: "LMULT (Super FX)"
reference_url: https://sneslab.net/wiki/LMULT_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
downloaded_at: 2026-02-14T13:35:49-08:00
cleaned_at: 2026-02-14T17:52:19-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3D9F 2 bytes 10 or 14 cycles 10 or 14 cycles 5 or 9 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S CY Z

**LMULT** is a signed multiplication Super FX instruction. The two 16-bit factors are the source register and R6. The exact speed depends on the state of the CFGR register.

The upper 16 bits of the product are stored in the destination register. The lower 16 bits of the product are stored in R4.

LMULT utilizes the 8-bit multiplier four times.\[3]

LMULT shares its multiplication circuit with FMULT.

If R4 is specified as the destination register, the product will be invalid.\[1]

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
LMULT
```

#### Example

Let:

```
Sreg : R9
Dreg : R8
R9 = b556h
R6 = daabh
```

After LMULT is executed:

```
R8 = 0ae3h
R4 = 5c72h
```

### See Also

- UMULT
- MULT
- Partial Product Buffer
- DIV2
- ALT1

### External Links

1. Official Nintendo documentation on LMULT: 9.52 on [page 2-9-73 of Book II](https://archive.org/details/SNESDevManual/book2/page/n229)
2. example: [page 2-9-74 of Book II](https://archive.org/details/SNESDevManual/book2/page/n230), lbid.
3. [page 2-8-16 of Book II](https://archive.org/details/SNESDevManual/book2/page/n155), lbid.
