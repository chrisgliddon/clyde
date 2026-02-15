---
title: "HCU04"
reference_url: https://sneslab.net/wiki/HCU04
categories:
  - "SNES_Hardware"
  - "Integrated_Circuits"
  - "ICs_with_unconnected_pins"
downloaded_at: 2026-02-14T13:17:12-08:00
cleaned_at: 2026-02-14T17:54:15-08:00
---

The **HCU04** is a [hex inverter](https://www.ourpcb.com/hex-inverter-ic.html). The first two inverters take SCLK from pin 41 of S-DSP as input:

- **U9A** outputs CIC3 to the Cartridge Slot
- **U9B** outputs CL1 to the CIC

The next two inverters help generate XIN:

- **U9C** appears to undo the inversion that U9C did, and sends the output to R5, which eventually becomes XIN after passing by the pull-down R4
- **U9D** is in parallel with R6, receiving its input from C4 and outputting to U9C

The last two inverters take ground as input and their outputs are not connected:

- **U9E**
- **U9F**
