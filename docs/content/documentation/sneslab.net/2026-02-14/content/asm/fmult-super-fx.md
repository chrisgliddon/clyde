---
title: "FMULT (Super FX)"
reference_url: https://sneslab.net/wiki/FMULT_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Arithmetic_Operation_Instructions"
  - "One-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T12:00:40-08:00
cleaned_at: 2026-02-14T17:51:55-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 9F 1 byte 7 or 11 cycles 7 or 11 cycles 4 or 8 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S CY Z

**FMULT** (Fractional Multiply) is a Super FX instruction that performs a signed multiplication. The two factors are the source register and R6. The upper 16 bits of the 32-bit product are stored in the destination register. Bit 15 of the product is stored in CY. The lower 15 bits of the product appear to be discarded.

The exact speed depends on the state of the CFGR register. FMULT utilizes the 8-bit multiplier four times.\[3]

R4 cannot serve as the destination register, but any other register from R0 to R15 can. If R4 is specified as the destination register anyway, the product will simply not be written to it and will be lost instead.\[3]

FMULT shares its multiplication circuit with LMULT. The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
FMULT
```

#### Example

Let:

```
Sreg : R5
Dreg : R2
R5 = 4aaah
R6 = daabh
```

After executing FMULT:

```
R2 = f51ch
```

and the carry flag and sign flag are set

### See Also

- UMULT
- MULT
- Partial Product Buffer
- DIV2

### External Links

1. Official Nintendo documentation on FMULT: 9.33 on [Page 2-9-46 of Book II](https://archive.org/details/SNESDevManual/book2/page/n202)
2. example: [page 2-9-47](https://archive.org/details/SNESDevManual/book2/page/n203), lbid.
3. 8.2 "Multiplication Instructions" on [page 2-8-16](https://archive.org/details/SNESDevManual/book2/page/n155), lbid.
