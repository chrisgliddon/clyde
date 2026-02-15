---
title: "Direct Page Bit Relative Addressing"
reference_url: https://sneslab.net/wiki/Direct_Page_Bit_Relative_Addressing
categories:
  - "ASM"
  - "Addressing_Modes"
  - "SPC700"
downloaded_at: 2026-02-14T11:46:58-08:00
cleaned_at: 2026-02-14T17:51:48-08:00
---

**Direct Page Bit Relative Addressing** is an addressing mode supported by the SPC700, used by these instructions:

- BBS
- BBC

Both of which are three bytes long:

- The first byte is the opcode, as usual. The opcode's top 3 bits address which bit to test within a particular direct page byte.
- The middle byte is which direct page location the bit to test lives in.
- The last byte is the target relative address to conditionally jump to.

#### Syntax

```
BBS dp, bit, rel
BBC dp, bit, rel
```

### See Also

- Direct Page Bit Addressing

### Reference

- Figure 3-8-3 Memory Access Addressing Effective Address on [page 3-8-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n187) of the official Super Nintendo development manual
