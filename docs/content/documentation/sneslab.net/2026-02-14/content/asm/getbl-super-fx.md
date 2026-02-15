---
title: "GETBL (Super FX)"
reference_url: https://sneslab.net/wiki/GETBL_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
  - "Two-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T13:02:32-08:00
cleaned_at: 2026-02-14T17:51:58-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3EEF 2 bytes 6 to 10 cycles 6 to 9 cycles 2 to 6 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**GETBL** (Get Byte Low) is a Super FX instruction that loads one byte from the ROM buffer into the low byte of the destination register. GETBL also loads the high byte of the source register into the high byte of the destination register.

The reason the cycle times can vary is because of the ROM buffer. The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
GETBL
```

#### Example

Let:

```
(ROM Buffer) = 75h
Sreg : R2
Dreg : R6
R2 = 4abdh
```

After executing GETBL:

```
R6 = 4a75h
```

### See Also

- GETB
- GETBH
- GETBS
- GETC
- ALT2

### External Links

- Official Super Nintendo development manual on GETBL: 9.37 on [page 2-9-53 of Book II](https://archive.org/details/SNESDevManual/book2/page/n209)
- example: [page 2-9-54 of Book II](https://archive.org/details/SNESDevManual/book2/page/n210), lbid
