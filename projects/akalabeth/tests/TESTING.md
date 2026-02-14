# Akalabeth Test Harness Reference

Quick reference for Claude Code agents working with the Mesen2 test harness.

## Running Tests

```bash
# Build + run all tests
bash tools/mesen-test.sh akalabeth all

# Build + run single test
bash tools/mesen-test.sh akalabeth test_dungeon

# Run diagnostic (no rebuild)
bash tools/mesen-diag.sh akalabeth projects/akalabeth/tests/diag_foo.lua
```

## Mesen2 Flags (REQUIRED)
```
--testRunner --enableStdout --debug.scriptWindow.allowIoOsAccess=true
```
Without `--enableStdout`: no output. Without `allowIoOsAccess`: no file I/O.

## Test Files
- `tests/helpers.lua` — H.press(), H.waitFrames(), H.readByte/Word(), H.doChargen(), H.assert_eq(), H.done()
- `tests/symbols.lua` — Parses build/akalabeth.sym → S.GameState, S.PlayerHP, etc.
- `tests/test_*.lua` — Automated tests (exit 0=pass, 1=fail)
- `tests/diag_*.lua` — One-off diagnostics (always exit 0)

## Key Symbols (ZP addresses)
| Symbol | Addr | Size | Notes |
|--------|------|------|-------|
| GameState | $00 | 1 | $00=title,$01=OW,$02=dung,$04=shop,$05=castle,$06=gameover,$07-09=chargen |
| PlayerX | $04 | 1 | Overworld X |
| PlayerY | $05 | 1 | Overworld Y |
| MapDirty | $06 | 1 | Set to 1 to trigger tilemap DMA |
| DungPlayerX | $0B | 1 | Dungeon grid X |
| DungPlayerY | $0C | 1 | Dungeon grid Y |
| DungFloor | $0D | 1 | 0-9 |
| PlayerHP | $1D | 2 | 16-bit |
| PlayerFood | $1F | 2 | 16-bit |
| PlayerGold | $21 | 2 | 16-bit |
| StatsDirty | $2E | 1 | Set to 1 to trigger BG3 DMA |
| JoyPress | $37 | 2 | Newly pressed buttons this frame |
| FrameReady | $3B | 1 | Set by NMI, cleared by main loop |

## Mesen2 Lua API (SNES subset)
```lua
emu.read(addr, emu.memType.snesDebug)    -- 8-bit read, no side effects
emu.readWord(addr, emu.memType.snesDebug) -- 16-bit read
emu.write(addr, val, emu.memType.snesDebug) -- 8-bit write
emu.setInput({b=true}, 0, 0)             -- Hold buttons (cleared each frame by Mesen)
emu.setInput({}, 0, 0)                   -- Release all
emu.getState()                            -- Returns table: cpu.pc, cpu.sp, cpu.db, cpu.k, cpu.a, cpu.x, cpu.y, cpu.ps
emu.stop(exitCode)                        -- Exit testRunner
emu.addEventCallback(fn, emu.eventType.inputPolled)  -- Per-frame callback
emu.addMemoryCallback(fn, emu.memCallbackType.exec, addr) -- Exec breakpoint
```

## helpers.lua API
```lua
H.init(name)                  -- Print test header
H.run(coroutineFn)            -- Drive test via inputPolled callbacks
H.press(button, holdFrames)   -- button: "a","b","x","y","up","down","left","right","start","select"
                              -- holdFrames default=2, then releases for 2 frames
H.waitFrames(n)               -- Yield n frames
H.readByte(addr)              -- emu.read with snesDebug
H.readWord(addr)              -- emu.readWord with snesDebug
H.assert_eq(actual, expected, msg) -- Log PASS/FAIL
H.done()                      -- Print summary, emu.stop(0 or 1)
H.doChargen(S)                -- Play through title+chargen to overworld
```

## Common Crash Patterns
| Symptom | Likely Cause |
|---------|-------------|
| ZP filled with repeating 4-byte pattern | Instruction stream misalignment (wrong .i8/.i16 causing ca65 to emit wrong immediate sizes) |
| PC=$0000-$00FF, SP=garbage | CPU executing ZP as code after crash |
| GameState=$00 unexpectedly | RAM corruption zeroed everything |
| Exit code 255, no output | Missing --enableStdout flag |

## 65816 Register Width Gotcha
ca65 tracks register width with `.a8`/`.a16`/`.i8`/`.i16` directives (included in SET_A8 etc. macros).
These are FILE-SCOPED and LINEAR — they carry across .proc boundaries.
If a function is entered with 16-bit X/Y at runtime but ca65 thinks `.i8`:
- `ldx #$00` assembles as 2 bytes instead of 3
- CPU reads extra byte, misaligning ALL subsequent instructions
- Results in total RAM corruption

**Rule**: Every function that uses `ldx #imm` or `ldy #imm` MUST explicitly set X/Y width first.
Use `SET_AXY8` (sep #$30) at function entry to be safe.
