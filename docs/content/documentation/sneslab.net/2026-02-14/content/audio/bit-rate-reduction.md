---
title: "Bit Rate Reduction"
reference_url: https://sneslab.net/wiki/Bit_Rate_Reduction
categories:
  - "Audio"
downloaded_at: 2026-02-14T11:11:55-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

**Bit Rate Reduction** or **BRR** is the name given to the audio compression method used on the SPC700 sound chip used in the SNES, as well as the audio processors of a few other consoles. It is a form of [**ADPCM**](https://wiki.hydrogenaud.io/index.php?title=Adaptive_Differential_Pulse_Code_Modulation).

BRR uses blocks of 9 bytes, which the S-DSP decompresses to create 16 16-bit samples. This gives a compression ratio of 32:9. Aside from using a form of streaming to the echo buffer, this is the only sound format the APU can play back (it cannot play uncompressed samples).

## Format

Each block is made of 9 bytes. Of these there is a header byte, and 8 data bytes. The header contains some flags, and the 8 data bytes contain 16 nibbles of data, one for each sample.

### header

```
- ssssffle
```

s - The shift amount for the block. This is an integer between 0 and 12 (inclusive), to which each nibble is shifted left. The exact formula is:

```
sample = (nibble _shift left_ shift) _shift right_ 1
```

This means that a value of 12 will shift left 11, and a value of 0 will actually shift right 1. Values between 13 and 15 (inclusive) perform the formula:

```
sample = (nibble _shift right_ 3) _shift left_ 11
```

f - The filter used on the sample. After being decoded through the shift, it is put through a "filter". There are 4 available on the SNES (more on the PS1). The filters are (with the output from the shift referred to as the "current sample"):

```
Filter 0: no effect is applied, current sample is output.
Filter 1: output is the current sample, plus the previous times 0.9375.
Filter 2: output is the current sample, plus the previous times 1.90625 minus the one before that times 0.9375
Filter 3: output is the current sample, plus the previous times 1.796875 minus the one before that times 0.8125
```

e - If this bit is set, it is the end of the sample. The relevant bit in ENDx is set, and either the sample instantaneously stops or loops.

l - If this bit is set, when the end of the sample is hit the DSP jumps to the loop point and continues processing. ENDx is still set. If both of the above flags are not set, then the next block is decoded and output.

### data

```
- 11112222
```

1 - first sample

2 - second sample In the second byte it is the third and fourth, and so on.

## Other notes

If the output of the sample is larger that +3FFF or smaller than -4000 then the sample will under/overflow to the other side. This will not happen more than once - after one under/overflow it starts to [clip](https://sneslab.net/wiki/Clipping) instead of wrapping.

A good idea is to start a sample with a filter 0 block, because at that point the previous two samples are undefined.

### See Also

- RF Register

### References

- Official Super Nintendo development manual chapter on BRR: [page 3-2-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n156)
