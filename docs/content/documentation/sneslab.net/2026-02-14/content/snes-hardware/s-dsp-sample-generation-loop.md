---
title: "S-DSP/Sample Generation Loop"
reference_url: https://sneslab.net/wiki/S-DSP/Sample_Generation_Loop
categories:
  - "SNES_Hardware"
  - "Audio"
  - "Timing"
downloaded_at: 2026-02-14T16:16:01-08:00
cleaned_at: 2026-02-14T17:54:33-08:00
---

The S-DSP's **Sample Generation Loop** takes 32 cycles to complete.

Note: most of this information was extracted from anomie's APU DSP doc with jwdonal.

Sample Generation Loop Cycle Number Action Voice 0 Voice 1 Voice 2 Voice 3 Voice 4 Voice 5 Voice 6 Voice 7 0 Tick the SPC700 Stage 1 timers, always for T2 and every 4 samples for T0 and T1. V0:S5 V1:S2 1 V0:S6 V1:S3 2 V0:S7 V1:S4 V3:S1 3 V0:S8 V1:S5 V2:S2 4 V0:S9 V1:S6 V2:S3 5 V1:S7 V2:S4 V4:S1 6 V1:S8 V2:S5 V3:S2 7 V1:S9 V2:S6 V3:S3 8 V2:S7 V3:S4 V5:S1 9 V2:S8 V3:S5 V4:S2 10 V2:S9 V3:S6 V4:S3 11 V3:S7 V4:S4 V6:S1 12 V3:S8 V4:S5 V5:S2 13 V3:S9 V4:S6 V5:S3 14 V4:S7 V5:S4 V7:S1 15 V4:S8 V5:S5 V6:S2 16 Tick the SPC700 Stage 1 timer for T2. V4:S9 V5:S6 V6:S3 17 V0:S1 V5:S7 V6:S4 18 V5:S8 V6:S5 V7:S2 19 V5:S9 V6:S6 V7:S3 20 V1:S1 V6:S7 V7:S4 21 V0:S2 V6:S8 V7:S5 22 Apply ESA using the previously loaded value along with the previously calculated echo offset to calculate new echo pointer. Load left channel sample from the Echo Buffer. Load FFC0. V0:S3a V6:S9 V7:S6 23 Load right channel sample from the echo buffer. Load FFC1 and FFC2. V7:S7 24 Load FFC3, FFC4, and FFC5. V7:S8 25 Load FFC6 and FFC7. V0:S3b V7:S9 26 Load and apply MVOLL. Load and apply EVOLL. Output the left sample to the DAC. Load and apply EFB. 27 Load and apply MVOLR. Load and apply EVOLR. Output the right sample to the DAC. Load PMON 28 Load NON, EON, and DIR. Load FLG bit 5 (ECENx) for application to the left channel. 29 Update Global Counter. Write left channel sample to the echo buffer, if allowed by ECENx. Load EDL - if the current echo offset is 0, apply EDL. Load ESA for future use. Load FLG bit 5 (ECENx) again for application to the right channel. Clear internal KON bits for any channels keyed on in the previous 2 samples. 30 Write right channel sample to the echo buffer, if allowed by ECENx. Increment the echo offset, and set to 0 if it exceeds the buffer length. Load FLG bits 0-4 and update noise sample if necessary. Load KOFF and internal KON. V0:S3c 31 V0:S4 V2:S1

### Reference

- [anomie's APU DSP doc](https://www.romhacking.net/documents/191)
