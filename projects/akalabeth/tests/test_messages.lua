-- test_messages.lua — Dungeon message display system
-- Verify messages appear on BG3 row 26 and auto-clear

local dir = (debug.getinfo(1, "S").source:match("@(.*/)" ) or "./")
local H = dofile(dir .. "helpers.lua")
local S = dofile(dir .. "symbols.lua")

H.init("Dungeon Messages")

-- Read a string from BG3 tilemap at a given row/col
-- BG3 tilemap entries are 2 bytes: tile_num (low) + attr (high)
-- Tile 0 = ASCII $20 (space), so tile_num + $20 = ASCII char
local function readBg3String(row, col, len)
    local base = S.Bg3Tilemap
    local str = ""
    for i = 0, len - 1 do
        local offset = (row * 32 + col + i) * 2
        local tile = H.readByte(base + offset)
        if tile == 0 then
            str = str .. " "
        else
            str = str .. string.char(tile + 0x20)
        end
    end
    return str
end

-- Check if row 26 has any non-zero tiles (message present)
local function hasMessageRow26()
    local base = S.Bg3Tilemap
    for i = 0, 31 do
        local offset = (26 * 32 + i) * 2
        if H.readByte(base + offset) ~= 0 then
            return true
        end
    end
    return false
end

H.run(function()
    H.doChargen(S)
    H.assert_eq(H.readByte(S.GameState), 0x01, "On overworld")

    -- Navigate to dungeon at (X=12, Y=15)
    for i = 1, 5 do H.press("down") end
    for i = 1, 3 do H.press("right") end

    H.assert_eq(H.readByte(S.GameState), 0x02, "Entered dungeon")

    -- Walk forward to potentially trigger a chest or trap
    -- First, walk around to trigger messages
    -- Press up (forward) several times — should hit walls or features
    H.waitFrames(5)

    -- Turn to face south and walk forward
    H.press("down")   -- Turn around (now facing north)
    H.press("down")   -- Turn around again (back to south)
    H.press("up")     -- Move forward (south)
    H.waitFrames(2)
    H.press("up")     -- Move forward again
    H.waitFrames(2)

    -- Press A to attack (even if no monster, should show "YOU MISS!")
    H.press("a")
    H.waitFrames(2)

    -- Check if MsgTimer is set (indicating a message was displayed)
    local timer = H.readByte(S.MsgTimer)
    print(string.format("  DEBUG: MsgTimer after attack = %d", timer))

    -- Read row 26 to see what message is there
    local msg = readBg3String(26, 1, 28)
    print(string.format("  DEBUG: Row 26 = [%s]", msg))

    -- We should have some message (either YOU MISS or a hit message)
    local hasMsg = hasMessageRow26()
    H.assert_eq(hasMsg, true, "Message appears on BG3 row 26 after attack")

    -- Wait for message timer to expire (120 frames + buffer)
    H.waitFrames(130)

    -- Message should have cleared
    local hasMsg2 = hasMessageRow26()
    H.assert_eq(hasMsg2, false, "Message clears after timer expires")

    -- Exit dungeon via stairs (B)
    H.press("b")
    H.waitFrames(5)

    -- May need to navigate back to stairs
    for i = 1, 10 do
        local gs = H.readByte(S.GameState)
        if gs == 0x01 then break end
        H.press("up")
        H.waitFrames(2)
    end

    H.done()
end)
