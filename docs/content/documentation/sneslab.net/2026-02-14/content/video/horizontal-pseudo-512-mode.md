---
title: "Horizontal Pseudo 512 Mode"
reference_url: https://sneslab.net/wiki/Horizontal_Pseudo_512_Mode
categories:
  - "Video"
  - "Official_Jargon"
downloaded_at: 2026-02-14T13:21:22-08:00
cleaned_at: 2026-02-14T17:55:10-08:00
---

**Pseudo Hi-Res Mode** is a transparency technique that displays the Main Screen and Sub Screen at the same time without digital color math blending any pixels. It is enabled by setting bit 3 of SETINI (2133h). Columns of dots with an odd horizontal position are drawn by sampling a subscreen pixel, and columns of dots with an even horizontal position are drawn by sampling a main screen pixel. \[3] A CRT televsion blends the adjacent dots together, creating the transparency effect.

Psuedo hi-res mode is not effective in Mode 5 or Mode 6.

As of 2022, there are no tools for working with psuedo hi-res mode. \[2]

### Examples

- the HUD in *Jurassic Park*
- the trees in *Kirby's Dreamland 3*

### See Also

- H-512 Mode

### References

1. [https://nesdoug.com/2022/05/30/other-modes](https://nesdoug.com/2022/05/30/other-modes)
2. [https://forums.nesdev.org/viewtopic.php?p=279353#p279353](https://forums.nesdev.org/viewtopic.php?p=279353#p279353)
3. [https://board.zsnes.com/phpBB3/viewtopic.php?p=47257](https://board.zsnes.com/phpBB3/viewtopic.php?p=47257)
4. Chapter 9. [page 2-9-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n74) of the official Super Nintendo development manual
