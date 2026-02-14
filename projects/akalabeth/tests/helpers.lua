-- helpers.lua — Mesen2 SNES test framework for Akalabeth
-- Coroutine-driven: test functions yield each frame via inputPolled callback

local H = {}

local failCount = 0
local passCount = 0
local testName = "unknown"
local co = nil
local frameCount = 0
local MAX_FRAMES = 3600  -- 60 seconds timeout

-- SNES debug memory type (no side effects)
local MEM = emu.memType.snesDebug

-- ============================================================================
-- Core API
-- ============================================================================

function H.init(name)
    testName = name
    failCount = 0
    passCount = 0
    print("=== " .. name .. " ===")
end

function H.readByte(addr)
    return emu.read(addr, MEM)
end

function H.readWord(addr)
    return emu.read16(addr, MEM)
end

-- Yield N frames (call from within a test coroutine)
function H.waitFrames(n)
    for i = 1, n do
        coroutine.yield()
    end
end

-- Press a single button for holdFrames, then release and wait 2 frames
function H.press(button, holdFrames)
    holdFrames = holdFrames or 2
    local input = {}
    input[button] = true
    emu.setInput(input, 0, 0)
    H.waitFrames(holdFrames)
    emu.setInput({}, 0, 0)
    H.waitFrames(2)
end

-- ============================================================================
-- Assertions
-- ============================================================================

function H.assert_eq(actual, expected, msg)
    if actual == expected then
        passCount = passCount + 1
        print("  PASS: " .. msg)
    else
        failCount = failCount + 1
        print(string.format("  FAIL: %s (expected 0x%X, got 0x%X)", msg, expected, actual))
    end
end

function H.assert_range(actual, low, high, msg)
    if actual >= low and actual <= high then
        passCount = passCount + 1
        print(string.format("  PASS: %s (%d)", msg, actual))
    else
        failCount = failCount + 1
        print(string.format("  FAIL: %s (%d not in %d..%d)", msg, actual, low, high))
    end
end

-- ============================================================================
-- Map helpers (procedural overworld)
-- ============================================================================

function H.writeByte(addr, val)
    emu.write(addr, val, emu.memType.snesDebug)
end

function H.findTile(S, tileType)
    local base = S.OverworldMap
    for i = 0, 399 do
        if H.readByte(base + i) == tileType then
            local x = i % 20
            local y = math.floor(i / 20)
            return x, y
        end
    end
    return nil, nil
end

function H.teleportNear(S, x, y)
    local px
    if x > 1 then
        px = x - 1
    else
        px = x + 1
    end
    H.writeByte(S.PlayerX, px)
    H.writeByte(S.PlayerY, y)
    H.writeByte(S.MapDirty, 1)
    H.waitFrames(2)
end

-- ============================================================================
-- Test lifecycle
-- ============================================================================

function H.done()
    print("")
    print(string.format("Results: %d passed, %d failed", passCount, failCount))
    if failCount > 0 then
        print("FAILED: " .. testName)
        emu.stop(1)
    else
        print("PASSED: " .. testName)
        emu.stop(0)
    end
end

-- Run a test function as a coroutine driven by inputPolled callbacks
function H.run(testFn)
    co = coroutine.create(testFn)

    emu.addEventCallback(function()
        frameCount = frameCount + 1
        if frameCount > MAX_FRAMES then
            print("TIMEOUT: test exceeded " .. MAX_FRAMES .. " frames")
            emu.stop(1)
            return
        end
        if co and coroutine.status(co) ~= "dead" then
            local ok, err = coroutine.resume(co)
            if not ok then
                print("ERROR: " .. tostring(err))
                emu.stop(1)
            end
        end
    end, emu.eventType.inputPolled)
end

-- ============================================================================
-- Common setup: title → chargen → overworld (fighter class)
-- ============================================================================

function H.doChargen(S)
    -- Wait for boot
    H.waitFrames(60)
    -- START: title → chargen seed
    H.press("start")
    -- A: confirm seed → chargen stats (rolls stats)
    H.press("a")
    -- A: accept stats → chargen class
    H.press("a")
    -- A: confirm fighter → overworld
    H.press("a")
    -- Wait for gfx upload + state transition
    H.waitFrames(10)
end

return H
