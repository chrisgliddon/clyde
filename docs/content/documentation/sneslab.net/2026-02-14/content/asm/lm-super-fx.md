---
title: "LM (Super FX)"
reference_url: https://sneslab.net/wiki/LM_(Super_FX)
categories:
  - "Super_FX"
  - "Data_Transfer_Instructions"
downloaded_at: 2026-02-14T13:35:54-08:00
cleaned_at: 2026-02-14T17:52:18-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** 3DFnxxxx 4 bytes 20 cycles 21 cycles 11 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**LM** (Load from raM) is a Super FX instruction that loads data from Game Pak RAM.

The ALT0 state is restored.

#### Syntax

```
LM Rn, (xx)
```

#### Example

Let:

```
(70:bacch) = 28h
(70:bacdh) = 96h
RAMBR = 70h
```

After executing LM R9, (0bacch):

```
R9 = 9628h
```

### See Also

- Lunar Magic
- LMS
- RAMB
- ALT1
- SM
- SMS

### External Links

- Official Nintendo documentation on LM: 9.50 on [Page 2-9-70 of Book II](https://archive.org/details/SNESDevManual/book2/page/n226)
