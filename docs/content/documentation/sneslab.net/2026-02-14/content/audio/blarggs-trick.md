---
title: "Blargg's trick"
reference_url: https://sneslab.net/wiki/Blargg's_trick
categories:
  - "Audio"
  - "Scene_Slang"
downloaded_at: 2026-02-14T11:13:05-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

**Blargg's trick** is scene slang for writing to DSPRAM without writing any SPC700 code by only using the IPL ROM itself to upload sample data and the directory, then writing directly to the memory locations that the DSP registers are located in $00F2-$00F3 to produce sound.

Nintendo and Sony likely never intended for Blargg's trick to work; the official way to use the IPL is to perform SPC700 Driver Upload.

### Reference

- [https://wiki.superfamicom.org/how-to-write-to-dsp-registers-without-any-spc-700-code](https://wiki.superfamicom.org/how-to-write-to-dsp-registers-without-any-spc-700-code)
