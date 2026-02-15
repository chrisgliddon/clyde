---
title: "Darlington triad"
reference_url: https://sneslab.net/wiki/Darlington_triad
categories:
  - "SNES_Hardware"
  - "Transistors"
  - "Video"
downloaded_at: 2026-02-14T11:43:30-08:00
cleaned_at: 2026-02-14T17:54:11-08:00
---

The **Darlington triad** is an array of three PNP [Darlington pairs](https://www.electronicshub.org/darlington-transistor/) on the SNES Motherboard, one for each of the three color channels. The pairs are:

- Q3 and Q4 for red
- Q5 and Q6 for green
- Q7 and Q8 for blue

The Darlington bases are connected directly to S-PPU2 (pins 95, 96, and 97) and the Darlington emitters' signals are sent to the Video Encoder (pins 20, 21, and 22). The emitters are also connected to Multi-Out (pins 1, 2, and 4) through an alternate path that does not go through the video encoder first. On the schematic, these alternate paths are denoted as R', B', and G'. The collectors are grounded.

Curiously, the green channel is unique in that Q5 and R12 are in parallel with the polarized C83, but there is no corresponding capacitor for the blue and red Darlington pairs.
