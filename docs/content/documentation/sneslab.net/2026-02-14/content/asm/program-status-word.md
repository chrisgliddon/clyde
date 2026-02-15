---
title: "Program Status Word"
reference_url: https://sneslab.net/wiki/Program_Status_Word
categories:
  - "Registers"
  - "Flags"
downloaded_at: 2026-02-14T16:00:56-08:00
cleaned_at: 2026-02-14T17:52:50-08:00
---

The **Program Status Word** is an 8-bit register on the SPC700 that stores the values of status flags. They are typically listed in this order: NVPBHIZC. More verbosely:

Flag Name Bit Position Negative Flag bit 7 Overflow Flag bit 6 Direct Page Flag bit 5 Break Flag bit 4 Half-carry flag bit 3 Interrupt Enable Flag bit 2 Zero Flag bit 1 Carry Flag bit 0

Both the PUSH and POP commands can operate on the PSW. The PSW has the value $02 upon entry into the first user code.\[2]

### See Also

- Processor Status Register

### References

1. subparagraph 8.1.6, [page 3-8-6 of Book I](https://archive.org/details/SNESDevManual/book1/page/n184) of the official Super Nintendo development manual
2. anomie: [https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L73](https://github.com/gilligan/snesdev/blob/master/docs/spc700.txt#L73)
