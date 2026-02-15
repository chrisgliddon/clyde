---
title: "Absolute Boolean Bit Addressing"
reference_url: https://sneslab.net/wiki/Absolute_Boolean_Bit_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "Official_Jargon"
downloaded_at: 2026-02-14T10:52:42-08:00
cleaned_at: 2026-02-14T17:50:57-08:00
---

**Absolute Boolean Bit** is used on the SPC700 by some three-byte instructions to address individual bits:

- AND1
- OR1
- EOR1
- MOV1
- NOT1

The bottom 13 bits of a 16-bit value specify an absolute address, while the top 3 bits specify which bit within the byte stored at that address. The greatest address these instructions can affect is 1FFFh.

#### Syntax

```
AND1 C, mem. bit
AND1 C, /mem. bit
OR1 C, mem. bit
OR1 C, /mem. bit
EOR1 C, mem. bit
MOV1 C, mem. bit
MOV1 mem. bit, C
NOT1 mem. bit
```

### See Also

- Absolute Addressing
- Direct Page Bit Addressing

### References

- [page 3-8-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n186) of the official Super Nintendo development manual
- Figure 3-8-3 Memory Access Addressing Effective Address on [page 3-8-9](https://archive.org/details/SNESDevManual/book1/page/n187), lbid.
