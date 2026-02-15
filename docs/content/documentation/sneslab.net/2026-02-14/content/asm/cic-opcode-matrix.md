---
title: "CIC Opcode Matrix"
reference_url: https://sneslab.net/wiki/CIC_Opcode_Matrix
categories:
  - "ASM"
  - "Tables"
downloaded_at: 2026-02-14T11:19:45-08:00
cleaned_at: 2026-02-14T17:51:31-08:00
---

Mnemonics ending in "sk" may skip the next instruction.

x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 xA xB xC xD xE xF 0x nop addsk addsk addsk addsk addsk addsk addsk addsk addsk addsk addsk addsk addsk addsk addsk 1x cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk cmpsk 2x mov mov mov mov mov mov mov mov mov mov mov mov mov mov mov mov 3x mov mov mov mov mov mov mov mov mov mov mov mov mov mov mov mov 4x mov xchg A,\[HL] xchgsk A,\[HL+] xchgsk A,\[HL-] neg A ? out out set clr mov ? ret retsk ? ? 5x movsk A,\[HL+] ? not A in A,\[L] ? xchg ? ? ? ? mov X,A xchg X,A ??? ? 6x testsk testsk testsk testsk testsk testsk testsk testsk clr clr clr clr set set set set 7x add A,\[HL] ? adc A,\[HL] adcsk A,\[HL] mov H, 0 mov H, 1 mov H, 2 mov H, 3 jmp jmp jmp jmp call call call call

### See Also

- Checking Integrated Circuit

### Source

- [https://problemkaputt.de/fullsnes.htm#snescartridgecicinstructionset](https://problemkaputt.de/fullsnes.htm#snescartridgecicinstructionset)
