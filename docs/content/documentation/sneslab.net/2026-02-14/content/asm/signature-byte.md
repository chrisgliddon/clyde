---
title: "Signature Byte"
reference_url: https://sneslab.net/wiki/Signature_Byte
categories:
  - "ASM"
  - "Official_Jargon"
downloaded_at: 2026-02-14T16:45:34-08:00
cleaned_at: 2026-02-14T17:53:09-08:00
---

A **Signature Byte** is the second byte of certain two-byte 65x instructions:

- BRK
- COP
- WDM

None of these instructions are considered to use immediate addressing even though the signature byte immediately follows the opcode.

### Reference

- 7.22 BRK Instruction on page 53 of 65c816 datasheet: [https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
