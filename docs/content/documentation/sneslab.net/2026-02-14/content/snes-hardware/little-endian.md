---
title: "little endian"
reference_url: https://sneslab.net/wiki/little_endian
categories:
  - "SNES_Hardware"
  - "ASM"
downloaded_at: 2026-02-14T17:36:33-08:00
cleaned_at: 2026-02-14T17:54:18-08:00
---

**Little endian** refers to a storage of values beyond one byte. It's also known as **LSB** (least significant byte), since the low byte is stored first leading up to the high byte. It's a contrast to big endian which stores in the opposite fashion. The SNES CPU, the 65c816, uses little endian.\[1]

## Example

The 16-bit value $5035 would be stored as $35 $50 in ROM and the 24-bit value $708000 would be stored as $00 $80 $70. Note how the high byte comes after the low byte(s), and the bank byte after the high byte. That's how little endian works.

## In assembly

The parameters of the opcodes are stored as little endian too (ONLY if they're numbers), but the opcode themselves are not. For example, LDA $449922 would be stored as $AF $22 $99 $44 in the ROM. The first byte is the opcode; it doesn't participate in the little endian concept. Therefore, it will remain as the first byte to appear. Its parameter, $449922, does participate though.

### See Also

- big endian
- XBA

### Reference

1. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#2](http://www.6502.org/tutorials/65c816opcodes.html#2)
