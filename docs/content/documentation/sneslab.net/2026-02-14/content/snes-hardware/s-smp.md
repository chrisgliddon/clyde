---
title: "S-SMP"
reference_url: https://sneslab.net/wiki/S-SMP
categories:
  - "ICs_with_unconnected_pins"
  - "Integrated_Circuits"
  - "Audio"
  - "SPC700"
downloaded_at: 2026-02-14T16:16:25-08:00
cleaned_at: 2026-02-14T17:54:35-08:00
---

The **S-SMP** is a Sony SPC700 series 8-bit 65x-based MPU which serves as the SNES' sound chip. It talks to the Ricoh 5A22 over four ports via the SNES Bus and CPU Data Bus. It is clocked by CPUK. The minimum command execution time is 1.953 microseconds.\[2]

The following registers are 8-bit:

- Accumulator
- X Index Register
- Y Index Register
- Program Status Word
- Stack Pointer

The following registers are 16-bit:

- Program Counter
- YA (which is virtually just the Y index reg concatenated to A)

Instructions that try to access memory straddling past the end of ARAM (the last byte of which is at $FFFF) will wrap around and end up accessing the zeropage (which is at $0000). Accesses that use direct page addressing will wrap within the direct page.

The stack is always located in page one (at $0100). Memory accesses that straddle the end of the stack will wrap to the beginning of the stack.

Operands that use absolute addressing are prefixed with an exclamation point (!).

The S-SMP has no hardware interrupt sources, but it does have BRK.

### See Also

- SPC700 Opcode Matrix

### References

1. [anomie's SPC700 doc](https://www.romhacking.net/documents/197)
2. SNES Sound Source Outline on [page 3-1-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n152) of the official Super Nintendo development manual
3. subparagraph 22.5.1 on [page 2-22-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n97), lbid.
