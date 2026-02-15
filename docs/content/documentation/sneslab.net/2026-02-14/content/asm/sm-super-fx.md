---
title: "SM (Super FX)"
reference_url: https://sneslab.net/wiki/SM_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
downloaded_at: 2026-02-14T16:26:44-08:00
cleaned_at: 2026-02-14T17:53:10-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied Indirect 3EFnxxxx 4 bytes 12 to 17 cycles 16 to 20 cycles 4 to 9 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**SM** (Store to raM) is a Super FX instruction that stores a value to the Game Pak. The bank must be specified with RAMB.

The number of cycles varies because of the RAM buffer.

The ALT0 state is restored.

#### Syntax

```
SM (xx), Rn
```

#### Example

Let:

```
R4 = 438ch
RAMBR = 70h
```

After executing SM (0b492h), R4:

```
(70:b492h) = 8ch
(70:b493h) = 43h
```

### See Also

- SMS
- LM
- LMS
- ALT2

### External Links

- Official Nintendo documentation on SM: 9.81 on [page 2-9-112 of Book II](https://archive.org/details/SNESDevManual/book2/page/n268)
