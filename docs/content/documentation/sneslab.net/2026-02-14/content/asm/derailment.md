---
title: "Derailment"
reference_url: https://sneslab.net/wiki/Derailment
categories:
  - "ASM"
  - "Scene_Slang"
downloaded_at: 2026-02-14T11:44:47-08:00
cleaned_at: 2026-02-14T17:51:45-08:00
---

**Derailment** is a failure state the 65c816 can enter. Usually as the result of a programming error, derailment from the instruction stream occurs when the CPU misinterprets an operand byte as an opcode byte or vice versa. With the SNES, derailment became easier to do than on the NES because of the existence of the M Flag and X Flag, which can change the length the CPU expects some immediate addressing instructions to be, and cause catastrophic program errors if they are toggled incorrectly.

Zeroing memory can help mitigate derailment because accidentally running opcode 00h causes a BRK interrupt. To safely shut down the CPU, consider STP.

### See Also

- SEP
- REP

### Reference

- [https://forums.nesdev.org/viewtopic.php?p=104280#p104280](https://forums.nesdev.org/viewtopic.php?p=104280#p104280)
