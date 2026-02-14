-- test_overworld.lua — Overworld navigation
-- Movement, castle entry/exit

local dir = (debug.getinfo(1, "S").source:match("@(.*/)" ) or "./")
local H = dofile(dir .. "helpers.lua")
local S = dofile(dir .. "symbols.lua")

H.init("Overworld Navigation")

H.run(function()
    H.doChargen(S)
    H.assert_eq(H.readByte(S.GameState), 0x01, "On overworld")

    -- Player should start adjacent to a castle (the forced one)
    local px = H.readByte(S.PlayerX)
    local py = H.readByte(S.PlayerY)
    local base = S.OverworldMap
    local function tileAt(x, y)
        if x < 0 or x >= 20 or y < 0 or y >= 20 then return -1 end
        return H.readByte(base + y * 20 + x)
    end
    local castleDir = nil
    if tileAt(px+1, py) == 0x04 then castleDir = "right"
    elseif tileAt(px-1, py) == 0x04 then castleDir = "left"
    elseif tileAt(px, py+1) == 0x04 then castleDir = "down"
    elseif tileAt(px, py-1) == 0x04 then castleDir = "up"
    end
    H.assert_eq(castleDir ~= nil, true, "Player starts adjacent to castle")

    -- Move onto adjacent castle
    H.press(castleDir)

    H.assert_eq(H.readByte(S.GameState), 0x05, "Entered castle")

    -- B -> leave castle (fade transition ~30 frames)
    H.press("b")
    H.waitFrames(60)
    H.assert_eq(H.readByte(S.GameState), 0x01, "Back on overworld")

    H.done()
end)
