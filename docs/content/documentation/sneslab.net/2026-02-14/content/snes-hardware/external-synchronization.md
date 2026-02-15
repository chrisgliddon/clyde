---
title: "External Synchronization"
reference_url: https://sneslab.net/wiki/External_Synchronization
categories:
  - "SNES_Hardware"
  - "Traces"
  - "Video"
downloaded_at: 2026-02-14T11:58:34-08:00
cleaned_at: 2026-02-14T17:54:13-08:00
---

**EXTSYNC** is a mysterious signal sent to pin 26 of PPU1. It is tied to VCC. One theory is that it was supposed to allow the PPU to not have to generate the TV synchronization signals itself and have them input into it instead.

The EXTSYNC bit is the most significant bit of SETINI (2133h). The official Super Nintendo development manual recommends zeoring it.

### References

- [https://forums.nesdev.org/viewtopic.php?p=136035&hilit=EXTSYNC#p136035](https://forums.nesdev.org/viewtopic.php?p=136035&hilit=EXTSYNC#p136035)
- [page 2-27-19](https://archive.org/details/SNESDevManual/book1/page/n132)
