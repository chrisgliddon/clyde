---
title: "Mode 7 VRAM Map"
reference_url: https://sneslab.net/wiki/Mode_7_VRAM_Map
categories:
  - "Video"
  - "Tables"
downloaded_at: 2026-02-14T15:35:17-08:00
cleaned_at: 2026-02-14T17:55:17-08:00
---

In Mode 7, the PPU expects the first 25% (16K) of VRAM to be filled with the tilemap and tile data. This region cannot be moved around.\[1] The tilemap is stored in the low bytes of each 16-bit word, and the tileset is stored in the high bytes. Appendix A-11 has a bit-breakdown diagram of what a word of this chunk of VRAM should look like.\[2]

0000h 0001h 0002h 0003h 007dh 007eh 007fh 0080h 0081h 0082h 0083h 00fdh 00feh 00ffh 0100h 0101h 0102h 017eh 017fh 0180h 0181h 3e80h 3e81h 3efeh 3effh 3f00h 3f01h 3f02h 3f7dh 3f7eh 3f7fh 3f80h 3f81h 3f82h 3ffdh 3ffeh 3fffh

### See Also

- SC0 VRAM Map

### References

1. [Appendix A-15 of Book I](https://archive.org/details/SNESDevManual/book1/page/n209) of the official Super Nintendo development manual
2. [Appendix A-11](https://archive.org/details/SNESDevManual/book1/page/n205), lbid.
