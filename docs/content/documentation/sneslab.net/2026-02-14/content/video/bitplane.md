---
title: "Bitplane"
reference_url: https://sneslab.net/wiki/Bitplane
categories:
  - "Video"
downloaded_at: 2026-02-14T11:12:41-08:00
cleaned_at: 2026-02-14T17:55:07-08:00
---

A **Bitplane** is a 1bpp slice of an image. Bitplanes are usually 8x8 pixels in size. In Modes 0 to 6, the bytes making up a bitplane are not stored contiguously in VRAM, but the words for adjacent overlapping pairs of bitplanes are. In Mode 7, the words making up a bitplane are contiguous. Mode 7 tiles always have 8 bitplanes.

### Motivation

The primary reason the SNES uses bitplanes is probably because the NES did.\[1]

The SNES' planar image format allows it to easily support a bit-depth (under compression, but not PPU-native) that is not a power of two: 3bpp. In a packed format, 3bpp images would either have to:

- put two pixels into each byte (total of six bits) and waste the other two bits
- put five pixels into each 16-bit word, and waste the Bit-Of-Confusion (which is what CGRAM does)
- put eight pixels into each 24-bit word, which would be awkward considering the 65c816 is a 16-bit CPU and would require more code to manipulate

Bitplanes avoid these problems because adding or removing a bitplane always adds or removes exactly eight bytes, which fits nicely into an address space.

Adjacent bitplanes in a 3D stack of bitplanes (as in, bitplanes in front or in back of each other that belong to the same tile, not adjacent in the tilemap) are always stored in opposite VRAM chips (because one chip stores the low bytes and the other high). Reading/Writing to both chips in parallel is presumably faster than trying to use one chip serially.

### External Links

- 3d animation of stacked bitplanes: [https://youtu.be/nk\_TbDO5QpE](https://youtu.be/nk_TbDO5QpE)
- [https://retrocomputing.stackexchange.com/questions/7459/why-arent-each-pixels-bits-stored-sequentially-on-the-snes](https://retrocomputing.stackexchange.com/questions/7459/why-arent-each-pixels-bits-stored-sequentially-on-the-snes)

### References

1. [https://forums.nesdev.org/viewtopic.php?p=166165#p166165](https://forums.nesdev.org/viewtopic.php?p=166165#p166165)
2. [Appendix A-12 of Book I](https://archive.org/details/SNESDevManual/book1/page/n206) of the official Super Nintendo development manual
