---
title: "GETC (Super FX)"
reference_url: https://sneslab.net/wiki/GETC_(Super_FX)
categories:
  - "Data_Transfer_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T13:03:02-08:00
cleaned_at: 2026-02-14T17:51:59-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) DF 1 byte 3 to 10 cycles 3 to 9 cycles 1 to 6 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**GETC** (Get Color) is a Super FX instruction that loads a color into the color register from the ROM buffer.

The reason the cycle times can vary is because of the ROM buffer. The ALT0 state is restored.

#### Syntax

```
GETC
```

#### Example

Let:

```
(ROM buffer) = 4bh
```

After GETC is executed:

```
color reg = 4bh
```

### See Also

- GETB
- GETBL
- GETBH
- GETBS
- COLOR
- Bitmap Emulation

### External Links

- Official Super Nintendo development manual on GETC: paragraph 9.39 on [page 2-9-57 of Book II](https://archive.org/details/SNESDevManual/book2/page/n213)
- subparagraph 8.1.2 SET COLOR (COLOR, GETC) on [page 2-8-4](https://archive.org/details/SNESDevManual/book2/page/n143), lbid.
