---
title: "Interrupt Handler"
reference_url: https://sneslab.net/wiki/Interrupt_Handler
categories:
  - "ASM"
downloaded_at: 2026-02-14T13:29:39-08:00
cleaned_at: 2026-02-14T17:52:07-08:00
---

An **Interrupt Handler** is a subroutine which the CPU automatically runs when an interrupt occurs.

ISR stands for "interrupt service routine." Interrupts are never serviced when an instruction is only partially finished running (except if you count MVP/MVN which can be interrupted once every 7 cycles), but only after the instruction completes.

Use BRK to force a software interrupt.

Return control back with RTI when on the 65c816 or RETI when on the SPC700.

### See Also

- NMI
- IRQ
- WAI
