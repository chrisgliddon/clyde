---
title: "SPC700/Driver Upload"
reference_url: https://sneslab.net/wiki/SPC700/Driver_Upload
categories:
  - "Audio"
  - "SPC700"
downloaded_at: 2026-02-14T16:36:35-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

In order to use main audio (Blargg's trick notwithstanding), the 5A22 must first upload a sound driver to the SPC700 over the following four ports via the SNES Bus:

Official Port Name Port Name (SPC side) Port Address (SPC side) Port Name (5A22 side) Port Address (5A22 side) Data Notes PORT0 CPUIO0 00F4h APUIO0 2140h

- The SPC IPL writes AAh here when ready
- kick and kickback (as described by fullsnes) also go through here

**PT0** is Nintendo's official name for the data the 5A22 writes to this port PORT1 CPUIO1 00F5h APUIO1 2141h

- The SPC IPL writes BBh here when ready
- The 5A22 writes which command ("transfer" or "entry" as described by fullsnes) it wants the IPL to run here
- The SPC700 driver code is uploaded through here too

When the IPL is interpreting the value from this port as a command, zero means "jump to the entrypoint in the driver we just uploaded" and non-zero means "get ready to receive another block transfer." Anomie refers to these as "Mode 0" and "Mode non-0," having nothing to do with background Mode 0. PORT2 CPUIO2 00F6h APUIO2 2142h

- The 5A22 writes the low byte of the upload destination ARAM address here
- The 5A22 writes the low byte of the entrypoint into the SPC program here after all blocks have been uploaded

PORT3 CPUIO3 00F7h APUIO3 2143h

- The 5A22 writes the high byte of the upload destination ARAM address here
- The 5A22 writes the high byte of the entrypoint into the SPC program here after all blocks have been uploaded

Each of the four ports are actually composed of two 8-bit registers, for a total of eight registers used for SPC/5A22 communication. All eight registers are inside the APU.\[3] They cannot be a DMA target.\[4]

The official Super Nintendo development manual describes the driver upload process in Appendix D of Book I. \[1] Fullsnes has pseudocode for the upload procedure in [https://problemkaputt.de/fullsnes.htm#snesapumaincpucommunicationport](https://problemkaputt.de/fullsnes.htm#snesapumaincpucommunicationport), and anomie's SPC700 Doc also lists a very similar 11 step procedure.

For the purposes of uploading to the SPC, the sound driver SPC700 machine code is divided into some number of contiguous data blocks. Each block has a four byte header which consists of:

- the block size (2 bytes)
- the target address where the block will end up in ARAM (another 2 bytes) \[2]

### See Also

- SPC700/IPL ROM

### References

1. [Appendix D-1, "Data Transfer Procedure"](https://archive.org/details/SNESDevManual/book1/page/n236) of the official Super Nintendo development manual
2. [page D-3 "Data Block Organization"](https://archive.org/details/SNESDevManual/book1/page/n238), lbid
3. [page 2-27-24 of Book I](https://archive.org/details/SNESDevManual/book1/page/n137), lbid
4. [https://forums.nesdev.org/viewtopic.php?p=141221&sid=56b7fdb49f7c0d608a4ec82a1b99e851#p141221](https://forums.nesdev.org/viewtopic.php?p=141221&sid=56b7fdb49f7c0d608a4ec82a1b99e851#p141221)
