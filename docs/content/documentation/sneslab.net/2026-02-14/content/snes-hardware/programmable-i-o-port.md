---
title: "Programmable I/O Port"
reference_url: https://sneslab.net/wiki/Programmable_I/O_Port
categories:
  - "SNES_Hardware"
  - "Accessories"
downloaded_at: 2026-02-14T16:01:06-08:00
cleaned_at: 2026-02-14T17:54:27-08:00
---

The 8-bit **Programmable I/O Port** allows the 5A22 to communicate with SNES peripherals.

There is the register commonly referred to as **WRIO** for short located at 4201h. Only the top two bits are used by the control deck. It has [open collector output](http://www.learningaboutelectronics.com/Articles/Open-collector-output.php) and is initialized to FFh on reset.\[2] WRIO is the out-port. The last sentence of page 2-14-1 likely has a typo; supposed to be referring to page 2-28-1 not 1-28-1.

There is also the RDIO register at 4213h. Only the top two bits are used by the control deck. RDIO is the in-port.

### See Also

- 3D Glass
- X-Band Keyboard
- External Latch

### References

1. Official Super Nintendo development manual on the programmable i/o port: [Page 2-14-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n80)
2. [https://problemkaputt.de/fullsnes.htm#snescontrollersioportsmanualreading](https://problemkaputt.de/fullsnes.htm#snescontrollersioportsmanualreading)
3. [page 2-28-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n139) on WRIO
4. [page 2-28-7 of Book I](https://archive.org/details/SNESDevManual/book1/page/n145) on RDIO
