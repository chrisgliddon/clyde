---
title: "Priority Order Shifting"
reference_url: https://sneslab.net/wiki/Priority_Order_Shifting
categories:
  - "Video"
  - "Official_Jargon"
downloaded_at: 2026-02-14T15:59:58-08:00
cleaned_at: 2026-02-14T17:55:18-08:00
---

**Priority Order Shifting** (or **Priority Rotation**) refers to techniques that change which sprites appear on top or behind of other sprites.

While this can be done in software (by moving sprites around in OAM) the SNES contains a hardware feature for priority order shifting, bit 7 of OAMADDH (2103h):

- When clear, OBJ #0 has the highest priority.
- When set, the OBJ number specified by bits 1-7 of OAMADDL (2102h) has the highest priority.

### References

- paragraph 20.3 on [page 2-20-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n91) of official Super Nintendo development manual
- [https://www.problemkaputt.de/fullsnes.htm#snesmemoryoamaccessspriteattributes](https://www.problemkaputt.de/fullsnes.htm#snesmemoryoamaccessspriteattributes)
