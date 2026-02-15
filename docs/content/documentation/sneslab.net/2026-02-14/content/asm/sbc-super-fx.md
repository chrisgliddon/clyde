---
title: "SBC (Super FX)"
reference_url: https://sneslab.net/wiki/SBC_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Two-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T16:18:31-08:00
cleaned_at: 2026-02-14T17:53:02-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3D6n 2 bytes 6 cycles 6 cycles 2 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 O/V S CY Z

**SBC** (SuBtract with Carry) is a Super FX instruction that performs a subtraction with regards to the carry flag. Unlike ADD, ADC and SUB, this one can only be used with registers, not with constant values since since the ALT3 version of SUB is a CMP instead.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
SBC Rn
```

#### Example

Let:

```
Sreg : R4
Dreg : R6
R4 = 5682h
R5 = 3609h
CY = 1
```

After executing SBC R5:

```
R6 = 2079h
CY = 0
```

### See Also

- SBC
- ADC (Super FX)
- SUB (Super FX)
- ALT1

### Reference

- 9.78 on [page 2-9-108 of Book II](https://archive.org/details/SNESDevManual/book2/page/n264) of the official Super Nintendo development manual
