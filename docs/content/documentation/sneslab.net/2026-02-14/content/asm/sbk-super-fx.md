---
title: "SBK (Super FX)"
reference_url: https://sneslab.net/wiki/SBK_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
  - "One-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T16:18:40-08:00
cleaned_at: 2026-02-14T17:53:04-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 90 1 byte 3 to 8 cycles 7 to 11 cycles 1 to 6 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**SBK** is a Super FX instruction that uses bulk processing. It stores the value in the source register to the address in the [ram address cache](/mw/index.php?title=Ram_Address_Cache_%28Super_FX%29&action=edit&redlink=1 "Ram Address Cache (Super FX) (page does not exist)").

The ALT0 state is restored.

The source register should be specified in advance using WITH or FROM. Otherwise, R0 serves as the default.

#### Syntax

```
SBK
```

#### Example

Let:

```
(70:3230h) = 51h
(70:3231h) = 49h
RAMBR = 70h
```

After executing this program:

```
LM   R1, (3230h)
INC  R1
SBK
```

We have:

```
R1 = 4952h
(70:3230h) = 52h
(70:3231h) = 49h
```

### External Links

- Official Super Nintendo development manual on SBK: 9.79 on [page 2-9-109 of Book II](https://archive.org/details/SNESDevManual/book2/page/n265)
