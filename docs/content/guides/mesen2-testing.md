---
title: "Mesen2 Lua Test API Reference"
weight: 50
---

## Running Tests

```bash
# Build + run all tests
bash tools/mesen-test.sh akalabeth all

# Build + run single test
bash tools/mesen-test.sh akalabeth test_dungeon

# Run diagnostic (no rebuild)
bash tools/mesen-diag.sh akalabeth projects/akalabeth/tests/diag_foo.lua
```

## Required Flags

```
--testRunner --enableStdout --debug.scriptWindow.allowIoOsAccess=true
```

| Flag | Without It |
|------|-----------|
| `--testRunner` | No headless mode, no `emu.stop()` |
| `--enableStdout` | Zero output (exit code 255) |
| `--debug.scriptWindow.allowIoOsAccess` | No file I/O (screenshots, symbol parsing) |

## Mesen2 Lua API

### Memory Access

```lua
-- 8-bit read (no side effects)
local val = emu.read(addr, emu.memType.snesDebug)

-- 16-bit read (little-endian)
local val = emu.read16(addr, emu.memType.snesDebug)

-- 8-bit write
emu.write(addr, val, emu.memType.snesDebug)
```

**Always use `emu.memType.snesDebug`** — this reads/writes without triggering hardware side effects (no register reads, no auto-increment).

### Input Control

```lua
-- Hold buttons (must be set every frame — Mesen clears after each frame)
emu.setInput({a = true, right = true}, 0, 0)
--                                      ^  ^
--                                      |  subIndex (0)
--                                      port (0 = player 1)

-- Release all buttons
emu.setInput({}, 0, 0)
```

**Button names**: `a`, `b`, `x`, `y`, `up`, `down`, `left`, `right`, `start`, `select`, `l`, `r`

### CPU State

```lua
local state = emu.getState()

state.cpu.pc    -- Program counter (16-bit)
state.cpu.a     -- Accumulator
state.cpu.x     -- X index
state.cpu.y     -- Y index
state.cpu.sp    -- Stack pointer
state.cpu.ps    -- Processor status (flags)
state.cpu.db    -- Data bank
state.cpu.k     -- Program bank
```

### Execution Control

```lua
-- Stop emulation and exit with code
emu.stop(0)    -- exit 0 = success
emu.stop(1)    -- exit 1 = failure

-- Execute N CPU instructions (blocking)
emu.execute(100, emu.execType.cpuInstructions)
```

### Callbacks

```lua
-- Per-frame callback (fires once per input poll, ~60Hz)
emu.addEventCallback(function()
    -- called every frame
end, emu.eventType.inputPolled)

-- Another useful event: start of frame
emu.addEventCallback(function()
    -- called at frame start
end, emu.eventType.startFrame)

-- Execution breakpoint (fires when CPU reaches address)
emu.addMemoryCallback(function()
    -- CPU just hit this address
end, emu.memCallbackType.exec, targetAddr)
```

### Screenshots

```lua
local png = emu.takeScreenshot()
-- Returns PNG data as string, or nil on failure
local f = io.open("screenshot.png", "wb")
if f then f:write(png); f:close() end
```

## Our Test Framework (helpers.lua)

From `projects/akalabeth/tests/helpers.lua`. Coroutine-driven architecture: test functions yield each frame via the `inputPolled` callback.

### Core API

```lua
local H = require("helpers")

H.init("test_name")            -- Print test header, reset counters
H.setMaxFrames(3600)           -- Timeout (default: 3600 = 60 seconds)

H.readByte(addr)               -- emu.read with snesDebug
H.readWord(addr)               -- emu.read16 with snesDebug
H.writeByte(addr, val)         -- emu.write with snesDebug

H.waitFrames(n)                -- Yield n frames (coroutine.yield)
H.press(button, holdFrames)    -- Hold button for holdFrames (default 2), release, wait 2 frames
                               -- button: "a","b","x","y","up","down","left","right","start","select"

H.assert_eq(actual, expected, msg)          -- Log PASS/FAIL
H.assert_range(actual, low, high, msg)      -- Range check

H.doChargen(S)                 -- Play through title→chargen→overworld (fighter class)
H.screenshot("path.png")       -- Save screenshot to file

H.done()                       -- Print summary, emu.stop(0 or 1)
```

### Coroutine Architecture

```lua
H.run(function()
    -- This function runs as a coroutine.
    -- H.waitFrames() and H.press() yield back to Mesen each frame.
    -- The inputPolled callback resumes the coroutine.

    H.waitFrames(60)           -- Wait 1 second
    H.press("start")           -- Press start for 2 frames
    local hp = H.readWord(0x1D)
    H.assert_range(hp, 1, 999, "HP is valid")
    H.done()
end)
```

The `H.run()` function creates a coroutine and registers an `inputPolled` callback that resumes it each frame. If the coroutine exceeds `MAX_FRAMES`, the test times out with exit code 1.

### Symbol File Parsing

Tests use `symbols.lua` to parse the ca65 symbol file (`build/akalabeth.sym`):

```lua
local S = require("symbols")
-- S.GameState, S.PlayerHP, S.PlayerX, etc.
-- These are the CPU addresses of each exported symbol

local hp = H.readWord(S.PlayerHP)
```

## Minimal Test Skeleton

```lua
package.path = "projects/akalabeth/tests/?.lua;" .. package.path

local H = require("helpers")
local S = require("symbols")

H.init("test_example")

H.run(function()
    -- Wait for boot
    H.waitFrames(60)

    -- Navigate to game state
    H.doChargen(S)

    -- Test something
    local state = H.readByte(S.GameState)
    H.assert_eq(state, 0x01, "GameState is overworld")

    -- Take screenshot for visual verification
    H.screenshot("projects/akalabeth/tests/screenshots/example.png")

    H.done()
end)
```

## Common Crash Patterns

| Symptom | Likely Cause |
|---------|-------------|
| ZP filled with repeating 4-byte pattern | Instruction misalignment (wrong `.i8`/`.i16` → ca65 emits wrong immediate sizes) |
| PC=$0000-$00FF, SP=garbage | CPU executing zero page as code after crash |
| GameState=$00 unexpectedly | RAM corruption zeroed everything |
| Exit code 255, no output | Missing `--enableStdout` flag |
| "TIMEOUT" message | Test exceeds MAX_FRAMES — increase with `H.setMaxFrames()` or check for infinite loop |
| "ERROR: ..." message | Lua error in coroutine — check stack trace |

## Debugging Tips

1. **Add `H.screenshot()` calls** at key points to visually verify state
2. **Read CPU state** with `emu.getState()` when debugging crashes
3. **Use `emu.addMemoryCallback`** to break on specific addresses (e.g., a function you suspect is crashing)
4. **Check symbol addresses** — if symbols.lua fails to parse, all addresses will be wrong

## See Also

- `projects/akalabeth/tests/helpers.lua` — framework source
- `projects/akalabeth/tests/symbols.lua` — symbol file parser
- `projects/akalabeth/tests/TESTING.md` — original test reference
- `tools/mesen-test.sh` — test runner script
