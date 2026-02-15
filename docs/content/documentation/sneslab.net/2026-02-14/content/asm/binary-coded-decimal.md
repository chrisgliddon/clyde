---
title: "Binary Coded Decimal"
reference_url: https://sneslab.net/wiki/Binary_Coded_Decimal
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Official_Jargon"
downloaded_at: 2026-02-14T11:11:03-08:00
cleaned_at: 2026-02-14T17:51:16-08:00
---

**BCD** stands for Binary Coded Decimal.

On the SPC700, the DAA and DAS commands will convert a regular binary/hexadecimal value to a packed BCD value. The high nybble will be the tens column and the low nybble will be the ones column. The value of each BCD nybble will not exceed 0x9.

### See Also

- CLD
- SED
- Decimal Mode
