---
title: "SMS (Super FX)"
reference_url: https://sneslab.net/wiki/SMS_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
downloaded_at: 2026-02-14T16:25:23-08:00
cleaned_at: 2026-02-14T17:53:10-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied Indirect 3EAnkk 3 bytes 9 to 14 cycles 13 to 17 cycles 3 to 8 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**SMS** (Store to raM Short address) is a Super FX instruction that stores a value to the Game Pak. The bank must be specified with RAMB.

The selectable RAM address must be an even number between 0 and 510.

The number of cycles varies because of the RAM buffer.

The ALT0 state is restored.

#### Syntax

```
SMS (yy), Rn
```

#### Example

Let:

```
R11 = abcdh
RAMBR = 71h
```

After executing this program:

```
 Syntax              Opcode
 SMS (194h), R11     3e ab ca
```

We have:

```
(71:0194h) = cdh
(71:0195h) = abh
```

### See Also

- SM
- ALT2
- LMS
- LM

### External Links

- Official Nintendo documentation on SMS: 9.82 on [page 2-9-113 of Book II](https://archive.org/details/SNESDevManual/book2/page/n269)
- example: [Page 2-9-114](https://archive.org/details/SNESDevManual/book2/page/n270), lbid.
