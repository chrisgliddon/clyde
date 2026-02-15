---
title: "MSU1"
reference_url: https://sneslab.net/wiki/MSU1
categories:
  - "SNES_Hardware"
  - "Integrated_Circuits"
  - "Enhancement_Chips"
downloaded_at: 2026-02-14T14:56:41-08:00
cleaned_at: 2026-02-14T17:54:23-08:00
---

**MSU1**, also named "Media Streaming Unit revision 1", is a homemade enhancement chip made by Near/Byuu for the SNES.

It allows the SNES to have 4 GB of storage space and CD quality Stereo Audio.

It can be used for every SNES games, but is so far only emulated by bsnes, and supported by sd2snes.

You can add MSU1 registers just by having &lt;ROMname&gt;.msu with the ROM. (since bsnes v081)

Registers :

Read:

$2000 - Status (bit 7 - Data Port Busy?; bit 6 - Audio Port Busy?; bit 5 - Audio is repeating; bit 4 - Audio is playing; bit3-0 - Revision)

$2001 - Data Port (Gives byte from the position in 4GB Data)

$2002-$2007 - Identification "S-MSU1"

Write:

$2000-$2003 - 4GB 32-bit Offset value ($2003 must be written to seek)

$2004-$2005 - Choose Audio Track ($2005 must be written to seek)

$2006 - Audio Volume

$2007 - Play, Repeat Audio. (bit 0 = If 1, Track plays; bit 1 = If 1, Track repeats)
