---
title: "Bit Reversal"
reference_url: https://sneslab.net/wiki/Bit_Reversal
categories:
  - "Official_Jargon"
downloaded_at: 2026-02-14T11:11:59-08:00
cleaned_at: 2026-02-14T17:53:55-08:00
---

**Bit Reversal** on the SPC700 is indicated with a slash '/'. It denotes the complement (inversion) of its operand. The following two instructions support it:

- AND1
- OR1

When the bit reversal operator is used with them, the opcode emitted by the assembler is 20h greater than if it were omitted.

### Reference

- [Appendix C-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n226) of the official Super Nintendo development manual
