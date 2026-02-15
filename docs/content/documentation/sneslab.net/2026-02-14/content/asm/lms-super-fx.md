---
title: "LMS (Super FX)"
reference_url: https://sneslab.net/wiki/LMS_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
downloaded_at: 2026-02-14T13:35:34-08:00
cleaned_at: 2026-02-14T17:52:19-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** 3DAnkk 3 bytes 17 cycles 17 cycles 10 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**LMS** (Load from raM, Short address) is a Super FX instruction that is a short LM.

The ALT0 state is restored.

#### Syntax

```
LMS Rn, (yy)
```

#### Example

Let:

```
(70:1aah) = 32h
(70:1abh) = 92h
RAMBR = 70h
```

After executing this program:

```
Syntax            Opcode
LMS R3, (1aah)    3d a3 d5
```

We have:

```
R3 = 9232h
```

### See Also

- RAMB
- ALT1
- SMS
- SM

### External Links

- Official Nintendo documentation on LMS: 9.51 on [page 2-9-71 of Book II](https://archive.org/details/SNESDevManual/book2/page/n227)
- example: [page 2-9-72 of Book II](https://archive.org/details/SNESDevManual/book2/page/n228), lbid
