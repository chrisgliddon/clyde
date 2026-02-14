-- test_overworld.lua — Overworld navigation
-- Movement, castle entry/exit

local dir = (debug.getinfo(1, "S").source:match("@(.*/)" ) or "./")
local H = dofile(dir .. "helpers.lua")
local S = dofile(dir .. "symbols.lua")

H.init("Overworld Navigation")

H.run(function()
    H.doChargen(S)
    H.assert_eq(H.readByte(S.GameState), 0x01, "On overworld")

    -- Initial position: X=9, Y=10 (next to castle)
    H.assert_eq(H.readByte(S.PlayerX), 9, "Initial X = 9")
    H.assert_eq(H.readByte(S.PlayerY), 10, "Initial Y = 10")

    -- UP → Y decrements
    H.press("up")
    H.assert_eq(H.readByte(S.PlayerY), 9, "Moved up: Y = 9")
    H.assert_eq(H.readByte(S.PlayerX), 9, "X unchanged: X = 9")

    -- DOWN → Y increments back
    H.press("down")
    H.assert_eq(H.readByte(S.PlayerY), 10, "Moved down: Y = 10")

    -- RIGHT → (X=10, Y=10) is castle tile
    H.press("right")
    H.assert_eq(H.readByte(S.GameState), 0x05, "Entered castle")

    -- B → leave castle
    H.press("b")
    H.waitFrames(10)
    H.assert_eq(H.readByte(S.GameState), 0x01, "Back on overworld")

    H.done()
end)
