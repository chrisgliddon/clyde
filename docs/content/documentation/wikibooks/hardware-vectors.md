---
title: "Hardware vectors"
reference_url: https://ersanio.gitbook.io/assembly-for-the-snes/deep-dives/vector
categories:
  - "Documentation"
downloaded_at: 2026-02-13T20:24:53-08:00
---

Hardware vectors are a group of pointers that define how the SNES should handle certain interrupts within the ROM. Each vector is two bytes in size and point to instructions located in bank `$00`. The hardware vectors are grouped by the [two modes of the SNES](/assembly-for-the-snes/processor-flags-and-registers/flags): "emulation mode" vectors and "native mode" vectors.

## [hashtag](#native-mode-vectors) Native mode vectors

These vectors come into play when the SNES runs in native mode (E=0).

ROM address

Vector

Additional notes

`$00:FFE0`

Unused

`$00:FFE2`

Unused

`$00:FFE4`

COP vector

Triggered by the [COP opcode](/assembly-for-the-snes/deep-dives/misc)

`$00:FFE6`

BRK vector

Triggered by the [BRK opcode](/assembly-for-the-snes/deep-dives/misc)

`$00:FFE8`

ABORT vector

Unused by the SNES

`$00:FFEA`

NMI vector

Triggered by the SNES V-Blank Interrupt

`$00:FFEC`

Unused

`$00:FFEE`

IRQ vector

Triggered by the SNES H/V-Timer or external interrupt

## [hashtag](#emulation-mode-vectors) Emulation mode vectors

These vectors come into play when the SNES runs in emulation mode (E=1).

ROM address

Vector

Additional notes

`$00:FFF0`

Unused

`$00:FFF2`

Unused

`$00:FFF4`

COP vector

`$00:FFF6`

Unused

`$00:FFF8`

ABORT vector

Unused by the SNES

`$00:FFFA`

NMI vector

`$00:FFFC`

RESET vector

Triggered by SNES soft/hard reset

`$00:FFFE`

IRQ/BRK vector

It's possible to differentiate between the two using the [BRK flag](/assembly-for-the-snes/processor-flags-and-registers/flags)

## [hashtag](#example-setup) Example setup

Here's an example setup with the most commonly used vectors, which can be used in homebrew SNES ROMs. Note that the labels must be located in bank `$00` (which is located within the same bank as this setup).

Because homebrew programmers generally want to run their program in native mode, all vectors in emulation mode, save for reset, have been ignored. Furthermore, nothing is done with the `BRK` and `COP` vectors as these are opcodes which generally are unused.

[PreviousMachine cycles](/assembly-for-the-snes/deep-dives/cycles)[NextTechniques](/assembly-for-the-snes/deep-dives/techniques)

Last updated 5 years ago
