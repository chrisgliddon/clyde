---
title: "Bit-Breakdown Diagram"
reference_url: https://sneslab.net/wiki/Bit-Breakdown_Diagram
categories:
  - "ASM"
downloaded_at: 2026-02-14T11:11:13-08:00
cleaned_at: 2026-02-14T17:51:16-08:00
---

A **Bit-Breakdown Diagram** shows what the individual bits of a word do. It is very common on the SNES for registers to pack more than one value into 8 or 16 bits. When writing to a register, care must be taken to ensure only the relevant bits are changed.

In the official Super Nintendo development manual, bit 0 is conventionally labeled "D0" (data).

In the Super FX documentation, it is common to draw only the least and most significant bits as cells and omit the vertical divider between all other bits.
