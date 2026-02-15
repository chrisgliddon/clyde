---
title: "GETBS (Super FX)"
reference_url: https://sneslab.net/wiki/GETBS_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
  - "Two-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T13:02:42-08:00
cleaned_at: 2026-02-14T17:51:59-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3FEF 2 bytes 6 to 10 cycles 6 to 9 cycles 2 to 6 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**GETBS** (Get Signed Byte) is a Super FX instruction that loads one byte from the ROM buffer into the low byte of the destination register. Every bit of the destination register's high byte becomes whatever bit 7 of that loaded byte is.

The reason the cycle times can vary is because of the ROM buffer. The ALT0 state is restored.

The destination register should be specified in advance using WITH or TO. Otherwise, R0 serves as the default. The source register is ignored.

#### Syntax

```
GETBS
```

#### Example

Let:

```
(ROM buffer) = 85h
Dreg : R8
```

After executing GETBS:

```
R8 = ff85h
```

### See Also

- GETB
- GETBL
- GETBH
- GETC
- ALT3

### External Links

- Official Super Nintendo development manual on GETBS: 9.38 on [page 2-9-55 of Book II](https://archive.org/details/SNESDevManual/book2/page/n211)
- example: [page 2-9-56 of Book II](https://archive.org/details/SNESDevManual/book2/page/n212), lbid
