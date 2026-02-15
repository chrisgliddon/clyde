---
title: "Byte Selection Operator"
reference_url: https://sneslab.net/wiki/Byte_Selection_Operator
categories:
  - "ASM"
downloaded_at: 2026-02-14T11:15:22-08:00
cleaned_at: 2026-02-14T17:51:27-08:00
---

The **Byte Selection Operators** are recommended features of 65c816 assemblers.

- &lt; selects the low byte
- &gt; selects the high byte
- ^ selects the bank byte

ca65 provides the functions .HIBYTE, .LOBYTE, and .BANKBYTE as well.

### References

- page 48 of 65c816 datasheet: [https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
