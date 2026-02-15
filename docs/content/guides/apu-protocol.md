---
title: "APU Communication Protocol"
weight: 30
---

## Architecture Overview

| Component | CPU | Clock | RAM | Purpose |
|-----------|-----|-------|-----|---------|
| 65816 (main) | 65C816 | 3.58 MHz | 128 KB | Game logic, PPU control |
| SPC700 (audio) | Sony SPC700 | 1.024 MHz | 64 KB | Audio DSP control |

The two processors communicate via **4 bidirectional byte-wide ports**. Each port has **separate read/write registers** — writing to a port on one side does not change what that side reads back.

## Port Map

| CPU Address | SPC Address | Our Constant | Typical Use |
|-------------|-------------|--------------|-------------|
| `$2140` | `$F4` | `APUIO0` | Command / handshake |
| `$2141` | `$F5` | `APUIO1` | Data byte / volume |
| `$2142` | `$F6` | `APUIO2` | Address low / param |
| `$2143` | `$F7` | `APUIO3` | Address high / param |

**Key insight**: When the CPU writes to `$2140`, the SPC reads that value from its `$F4`. When the SPC writes to `$F4`, the CPU reads that value from `$2140`. They are separate storage locations.

## IPL ROM Boot Protocol

At reset, the SPC executes a 64-byte IPL ROM at `$FFC0-$FFFF`. This ROM implements a data upload protocol:

### Step-by-Step

1. **SPC signals ready**: Writes `$AA` to AudioOut0, `$BB` to AudioOut1
2. **CPU waits for `$AA` at `$2140`**
3. **CPU sends block header**:
   - Destination address → `$2142` (low) + `$2143` (high)
   - `$01` → `$2141` (nonzero = "data follows")
   - `$CC` → `$2140` (trigger)
4. **CPU waits for SPC to echo `$CC` on `$2140`**
5. **CPU streams bytes** (counter-based):
   - Data byte → `$2141`
   - Counter (0, 1, 2...) → `$2140`
   - Wait for SPC to echo counter on `$2140`
6. **End block**: increment counter by 2+ (counter > SPC's expected value)
7. **Start execution**: send destination address with `$00` in `$2141` (zero = "execute at address")

### Block Restart Trick

To send multiple blocks without tracking protocol state, end each block by setting the execution address to `$FFC9` (IPL ROM communication entry point). This resets the protocol for the next block.

See full implementation in [Wikibooks Loading SPC700 Programs]({{< ref "/documentation/wikibooks/loading-spc700-programs" >}}).

## SNESGSS Driver Protocol

Our Akalabeth project uses the SNESGSS audio driver (tracker-based). The protocol is simpler than raw IPL ROM communication.

### Constants (from projects/akalabeth/src/audio.s)

```asm
GSS_NOOP        = $00
GSS_SUBCOMMAND  = $01
GSS_SFX_PLAY    = $04
GSS_INITIALIZE  = $01   ; SUBCOMMAND + (INITIALIZE << 4)
GSS_STOP_ALL    = $51   ; SUBCOMMAND + (STOP_ALL_SOUNDS << 4)
```

### AudioInit — Boot + Initialize

From `projects/akalabeth/src/audio.s:47-79`:

```asm
.proc AudioInit
    SET_AXY8
    jsr SpcBootApu          ; Upload SPC driver via IPL ROM protocol

    ; Wait for SPC driver to signal ready
@wait_ready:
    lda APUIO0
    bne @wait_ready         ; Ready when APUIO0 == 0

    ; Send INITIALIZE command
    stz APUIO2              ; No params
    stz APUIO3
    lda #GSS_INITIALIZE     ; Command byte
    xba                     ; → high byte of 16-bit A
    lda #$01                ; Nonzero trigger → low byte
    SET_A16
    sta APUIO0              ; Atomic 16-bit write: APUIO0=trigger, APUIO1=command
    SET_A8

    ; Wait for acknowledgement
    lda APUIO3
@wait_ack:
    cmp APUIO3
    beq @wait_ack           ; Ack when APUIO3 changes

    lda #$01
    sta AudioEnabled
    rts
.endproc
```

**Atomic write trick**: `SET_A16` + `sta APUIO0` writes both APUIO0 and APUIO1 in a single instruction, preventing the SPC from seeing a partial command.

### PlaySfx — Trigger a Sound Effect

From `projects/akalabeth/src/audio.s:86-125`:

```asm
.proc PlaySfx
    SET_A8
    ; A = SFX ID on entry
    pha
    lda AudioEnabled
    beq @skip

@wait:
    lda APUIO0              ; Wait for ready (APUIO0 == 0)
    bne @wait

    pla
    sta APUIO2              ; Effect number
    lda #SFX_VOL_DEFAULT    ; $7F (~50%)
    sta APUIO1              ; Volume
    lda #SFX_PAN_CENTER     ; $80
    sta APUIO3              ; Pan

    lda #GSS_SFX_PLAY       ; $04
    sta APUIO0              ; Trigger

@wait_ack:
    lda APUIO0              ; Wait for ack (APUIO0 returns to 0)
    bne @wait_ack
    rts

@skip:
    pla
    rts
.endproc
```

### Protocol Summary

| Step | APUIO0 | APUIO1 | APUIO2 | APUIO3 |
|------|--------|--------|--------|--------|
| Wait ready | read=0 | — | — | — |
| Set params | — | volume | sfx_id | pan |
| Trigger | write=cmd | — | — | — |
| Wait ack | read=0 | — | — | — |

### AudioStopAll

Uses the atomic 16-bit write pattern with `GSS_STOP_ALL` ($51) and waits for APUIO3 to change as acknowledgement.

## Rules

1. **All APU communication from main loop only** — never from NMI handler
2. **Always check ready before sending** — SPC may be processing previous command
3. **Audio is optional** — check `AudioEnabled` flag before every PlaySfx call
4. **Boot during force blank** — AudioInit calls SpcBootApu which takes significant time

## See Also

- `projects/akalabeth/src/audio.s` — full SNESGSS interface
- `lib/macros.s:140-146` — APU register constants
- [Wikibooks: Loading SPC700 Programs]({{< ref "/documentation/wikibooks/loading-spc700-programs" >}}) — IPL ROM protocol deep dive
