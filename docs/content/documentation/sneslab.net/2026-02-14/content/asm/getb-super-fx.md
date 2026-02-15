---
title: "GETB (Super FX)"
reference_url: https://sneslab.net/wiki/GETB_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
  - "One-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T13:02:47-08:00
cleaned_at: 2026-02-14T17:51:57-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) EF 1 byte 3 to 8 cycles 3 to 9 cycles 1 to 6 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**GETB** (Get Byte) is a Super FX instruction that loads one byte from the ROM buffer into the low byte of the destination register. The high byte of the destination register is zeroed.

R14 serves as the ROM address pointer.

The reason the cycle times can vary is because of the ROM buffer. The ALT0 state is restored.

The destination register should be specified in advance using WITH or TO. Otherwise, R0 serves as the default. The source register is ignored.

#### Syntax

```
GETB
```

#### Example

Let:

```
ROM buffer = 0075h
Dreg : R0
```

After executing GETB:

```
R0 = 0075h
```

### See Also

- GETBH
- GETBL
- GETBS
- GETC
- ROMB

### External Links

- Official Super Nintendo development manual on GETB: 9.35 on [Page 2-9-49 of Book II](https://archive.org/details/SNESDevManual/book2/page/n205)
- example: [page 2-9-50 of Book II](https://archive.org/details/SNESDevManual/book2/page/n206), lbid
- page 2-7-1 of Book II, lbid.
