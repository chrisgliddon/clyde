---
title: "Half-Carry Flag"
reference_url: https://sneslab.net/wiki/Half-Carry_Flag
categories:
  - "ASM"
  - "SPC700"
  - "Flags"
downloaded_at: 2026-02-14T13:19:26-08:00
cleaned_at: 2026-02-14T17:52:00-08:00
---

The **Half-carry flag** (H) is bit 3 of the S-SMP's program status word. It applies to the bottom 4 bits of the accumulator, meaning it is set whenever bit 3 of an ALU operation carries over into bit 4. It is also set when there has not been any borrow.

It is cleared by CLRV, but there is no SETV command to set it.

Whenever H is set, the overflow flag is set as well.

Both DAA and DAS examine the half-carry flag.

### See Also

- Decimal Mode
- Carry Flag
- BCD

### References

- [https://problemkaputt.de/fullsnes.htm#snesapuspc700cpuoverview](https://problemkaputt.de/fullsnes.htm#snesapuspc700cpuoverview)
- [Page 3-8-6 of Book I](https://archive.org/details/SNESDevManual/book1/page/n184) of the official Super Nintendo development manual
