---
title: "Pipeline"
reference_url: https://sneslab.net/wiki/Pipeline
categories:
  - "SNES_Hardware"
  - "ASM"
downloaded_at: 2026-02-14T15:57:11-08:00
cleaned_at: 2026-02-14T17:54:26-08:00
---

**Pipelining** is a feature of 65x processors to increase throughput.

When finishing up an ADC instruction for example, these two things are happening simultaneously:

- opcode fetch for the next instruction
- the internal cycle of putting the sum into the accumulator.

### See Also

- Super\_FX#Pipeline\_Processing

### Reference

- Eyes & Lichty, [page 40](https://archive.org/details/0893037893ProgrammingThe65816/page/40)
