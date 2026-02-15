---
title: "BRR Encoding Guide"
weight: 60
---

## Overview

BRR (Bit Rate Reduction) is the only audio sample format the SNES S-DSP can play. It's a form of ADPCM (Adaptive Differential Pulse Code Modulation).

**Compression ratio**: 32:9 — each 9-byte BRR block decodes to 16 samples (16-bit each = 32 bytes uncompressed).

## Block Format

Each BRR block is 9 bytes: 1 header + 8 data bytes.

```
Header byte:  ssssffle
              ||||||||
              |||||| +-- End flag: 1 = last block of sample
              |||||+--- Loop flag: 1 = loop to loop point on end
              |||++---- Filter: 0-3 (prediction mode)
              ++++------ Shift: 0-12 (amplitude scaling)
```

### Data Bytes

Each data byte contains 2 nibbles = 2 samples:

```
Byte:  11112222
       ||||++++-- Second sample (signed 4-bit)
       ++++------ First sample (signed 4-bit)
```

8 data bytes × 2 nibbles = 16 samples per block.

## Shift (bits 7-4)

The shift value scales each nibble to 16-bit range:

| Shift | Effect | Use |
|-------|--------|-----|
| 0 | Right-shift by 1 | Very quiet |
| 1 | No shift | Quiet |
| 12 | Left-shift by 11 | Maximum amplitude |
| 13-15 | Special: `(nibble >> 3) << 11` | Rarely useful |

Higher shift = louder but more quantization noise (fewer effective bits).

## Filter (bits 3-2)

Filters apply prediction based on previous samples to improve compression:

| Filter | Formula | Notes |
|--------|---------|-------|
| 0 | `output = sample` | No prediction. Safe for first block. |
| 1 | `output = sample + prev × 0.9375` | Simple prediction |
| 2 | `output = sample + prev × 1.90625 - prev2 × 0.9375` | Two-sample prediction |
| 3 | `output = sample + prev × 1.796875 - prev2 × 0.8125` | Two-sample prediction (variant) |

- **Filter 0** should be used for the first block of every sample (previous samples are undefined at that point)
- **Filters 1-3** give better compression but can cause loop artifacts if the loop point doesn't align well

## End/Loop Flags

| End | Loop | Behavior |
|-----|------|----------|
| 0 | 0 | Continue to next block |
| 1 | 0 | Stop playback. ENDx flag set. |
| 1 | 1 | Jump to loop point. ENDx flag set. |
| 0 | 1 | (Undefined — don't use) |

## Sample Directory Table

The S-DSP uses a **source directory table** in ARAM to find samples. The table base address is set by DSP register `$5D` (DIR), which is the high byte of the ARAM address (so DIR=$20 → table at ARAM $2000).

Each entry is 4 bytes:

```
Offset  Size  Purpose
  +0     2    Start address of sample (little-endian)
  +2     2    Loop address of sample (little-endian)
```

When a voice plays source N, the DSP reads entry N from the directory table. The loop address must point to a 9-byte-aligned BRR block boundary.

## WAV → BRR Pipeline

### Requirements

- **Sample rate**: 32 kHz is the S-DSP native rate. Higher rates waste ARAM space with no quality benefit. Lower rates save space but reduce fidelity.
- **Mono**: The S-DSP is mono per voice (stereo via pan)
- **Loop alignment**: Loop points must fall on 16-sample boundaries (since each BRR block = 16 samples)

### Tools

| Tool | Purpose |
|------|---------|
| **BRRtools** | CLI WAV→BRR converter. Supports loop points, filter optimization. |
| **snesbrr** | Alternative converter |
| **SNESGSS** | Tracker with built-in BRR handling — what we use |
| **OpenMPT** | Tracker that can export to SPC-compatible formats |

### SNESGSS Workflow (Our Approach)

1. Create/import samples in SNESGSS tracker
2. Compose music and SFX in the tracker
3. Export: produces a single binary blob (SPC driver + samples + sequence data)
4. Include in ROM: `.incbin "audio_data.bin"` in the `AUDIODATA` segment
5. At boot: `SpcBootApu` uploads the blob to ARAM via IPL ROM protocol

The tracker handles BRR encoding, sample directory, and driver code — you don't manually encode BRR.

### Manual BRR Encoding (Advanced)

If encoding BRR manually with BRRtools:

```bash
# Basic conversion (no loop)
brr_encoder input.wav output.brr

# With loop point (sample offset, must be 16-sample aligned)
brr_encoder -l 1024 input.wav output.brr
```

## Quality Tradeoffs

| Factor | Better Quality | Smaller Size |
|--------|---------------|--------------|
| Sample rate | 32 kHz | 8-16 kHz |
| Shift range | Low shift (more bits) | High shift (fewer bits) |
| Filter | 0 (no artifacts) | 1-3 (better prediction) |
| Loop | One-shot (no loop artifacts) | Looped (reuse data) |

**ARAM budget**: 64 KB total, shared between SPC driver code, sample data, echo buffer, and sequence data. Typical budget: 40-50 KB for samples.

## BRR Math

| Metric | Value |
|--------|-------|
| Bytes per block | 9 |
| Samples per block | 16 |
| Compression ratio | 32:9 (3.56:1) |
| 1 second at 32 kHz | 32000 samples = 2000 blocks = 18000 bytes |
| ARAM capacity | ~3.5 seconds at 32 kHz (full 64KB) |

## See Also

- [Sneslab: Bit Rate Reduction]({{< ref "/documentation/sneslab.net/2026-02-14/content/audio/bit-rate-reduction" >}}) — detailed format reference
- [Sneslab: FIR Filter]({{< ref "/documentation/sneslab.net/2026-02-14/content/audio/fir-filter" >}}) — echo FIR filter coefficients and frequency response
- [APU Communication Protocol]({{< ref "apu-protocol" >}}) — how samples get uploaded to ARAM
- `projects/akalabeth/src/audio.s` — our SNESGSS driver interface
