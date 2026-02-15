---
title: "MOVEW (Super FX)"
reference_url: https://sneslab.net/wiki/MOVEW_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Macro_Instructions"
downloaded_at: 2026-02-14T13:48:40-08:00
cleaned_at: 2026-02-14T17:52:27-08:00
---

**MOVEW** (Move Word) is a Super FX macro instruction that loads data from the Game Pak.

#### Syntax

```
MOVEW Rn, (Rn')
MOVEW (Rn'), Rn
```

#### Example 1

Let:

```
R3 = 6480h
(71:6480h) = 2eh
(71:6481h) = c0h
RAMBR = 71h
```

After executing this program:

```
MOVEW R5, (R3)
; (R3) -> R5 (low byte)
; (R3+1) -> R5 (high byte)
```

We have:

```
R5 = c02eh
```

#### Example 2

Let:

```
R6 = 0822h
(70:0822h) = 43h
(70:0823h) = 96h
RAMBR = 70h
```

After executing this program:

```
MOVEW R0, (R6)
```

We have:

```
R0 = 9643h
```

#### Example 3

Let:

```
R9 = bfa3h
R10 = 4444h
RAMBR = 71h
```

After executing this program:

```
MOVEW (R10), R9
```

We have:

```
(71:4444h) = a3h
(71:4445h) = bfh
```

#### Example 4

Let:

```
R0 = 3151h
R6 = 92a0h
RAMBR = 71h
```

After executing this program:

```
MOVEW (R6), R0
```

We have:

```
(71:92a0h) = 51h
(71:92a1h) = 31h
```

### See Also

- MOVE
- MOVES
- MOVEB
- LDW
- TO
- FROM
- STW
- RAMB
- MOV

### External Links

- Official Super Nintendo development manual on MOVEW: 9.64 on [Page 2-9-90 of Book II](https://archive.org/details/SNESDevManual/book2/page/n246)
