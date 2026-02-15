---
title: "Transfer Word Select"
reference_url: https://sneslab.net/wiki/Transfer_Word_Select
categories:
  - "ASM"
downloaded_at: 2026-02-14T17:05:38-08:00
cleaned_at: 2026-02-14T17:53:29-08:00
---

The **Transfer Word Select** is the bottom 3 bits of DMAPx.

The block of memory transferred by a DMA is broken into some number of **transfer units**. A transfer unit may be one, two, or four bytes in size. Here is how the transfer word select determines how big transfer units are:

When these three bits are 000, transfer units are one byte in size. When these three bits are 001, 010, or 110, transfer units are two bytes in size. Otherwise, transfer units are four bytes in size.
