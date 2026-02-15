---
title: "fullsnes"
reference_url: https://sneslab.net/wiki/fullsnes
categories:
  - "SNES_Hardware"
  - "Documents"
downloaded_at: 2026-02-14T17:33:36-08:00
cleaned_at: 2026-02-14T17:54:14-08:00
---

**Fullsnes** is a large hardware reference for the SNES created by nocash with several ascii art illustrations.

### Errata

- With regards to the break flag, this sentence is dubious: "PHP opcodes always write "1" into the bit"
- The Color Math register at 2130h is missing an "S" - the full name is CGSWSEL not CGWSEL.
- In [https://problemkaputt.de/fullsnes.htm#snesapumaincpucommunicationport](https://problemkaputt.de/fullsnes.htm#snesapumaincpucommunicationport), fullsnes only mentions storing the entrypoint to 2142h and does not mention whether the entrypoint is a word or byte (the other places in this section where the bracket notation omits "Byte" or "Word" it is a single byte being stored). The Official Super Nintendo development manual is clear that the program start address for the uploaded SPC700 driver is stored to both PORT 2 and 3 (as part of step 11 on page D-2).
- In [https://problemkaputt.de/fullsnes.htm#snescartridgecicnotes](https://problemkaputt.de/fullsnes.htm#snescartridgecicnotes), the formula for the Polynomial Counter is missing an inversion in the second term.
- In [https://problemkaputt.de/fullsnes.htm#snespputimersandstatus](https://problemkaputt.de/fullsnes.htm#snespputimersandstatus), the Interlace Odd/Even Flag should use the term "field" instead of "frame" as an interlaced field is half of a frame
- In [https://problemkaputt.de/fullsnes.htm#snesapuspc700ioports](https://problemkaputt.de/fullsnes.htm#snesapuspc700ioports), it could be clearer that bits 0-3 of TnOUT are reset to 0 automatically by hardware after reading - it is not the programmer's responsibility to zero them after reading. \[1]
- In [https://problemkaputt.de/fullsnes.htm#snesapudspvolumeregisters](https://problemkaputt.de/fullsnes.htm#snesapudspvolumeregisters), MVOL should stand for "main volume," not "master volume" because MVOL does not control the echo volume, and "Main Volume" is how the official docs expand "MVOL." \[2]
- In [https://problemkaputt.de/fullsnes.htm#snesapublockdiagram](https://problemkaputt.de/fullsnes.htm#snesapublockdiagram), the word "Reverb" is used (the only place this word is used in fullsnes) but should probably say "Echo" instead like the rest of the times this feature is mentioned, as they have slightly different musical meanings.
- In [https://problemkaputt.de/fullsnes.htm#snesapudspechoregisters](https://problemkaputt.de/fullsnes.htm#snesapudspechoregisters), "bit" should be plural in several places when describing the ESA buffer entry bytes
- In [https://problemkaputt.de/fullsnes.htm#snescartridgeromimageinterleave](https://problemkaputt.de/fullsnes.htm#snescartridgeromimageinterleave), the worst case scenario can much worse than triple-interleaved or double-mis-de-interleaved - in fact ten interleavings of a normal 320Kbyte file is the identity operation, so in this particular case the worst is quintuple-interleaved.
- "Game Boy" is spelled several times as one word
- In the [https://problemkaputt.de/fullsnes.htm#snesapumaincpucommunicationport](https://problemkaputt.de/fullsnes.htm#snesapumaincpucommunicationport) notes there is a typo: "injumping"
- In [https://problemkaputt.de/fullsnes.htm#snesapuspc700ioports](https://problemkaputt.de/fullsnes.htm#snesapuspc700ioports) under "SPC700 Waitstates on Internal Cycles" the note at the bottom has typo: "cylces"
- In the IPL Boot ROM Disassembly, both the zerofill and transfer loops have a typo where "loop" is spelled with one "o"
- The four communication ports between the APU and the 5A22 are prefixed CPUIO (cpu input/output) on the 5A22 side but APUI0 (apu eye zero) on the APU side

### External Links

- [https://problemkaputt.de/fullsnes.htm](https://problemkaputt.de/fullsnes.htm)

### References

1. [Page 3-5-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n164) of the official Super Nintendo development manual: "When CN is read, the 4-bit up counter alone is cleared through IC internal timing"
2. [page 3-7-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n175) lbid
