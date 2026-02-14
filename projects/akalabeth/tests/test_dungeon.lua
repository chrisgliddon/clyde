-- test_dungeon.lua — Dungeon entry and exit
-- Navigate to dungeon, verify state, exit via stairs

local dir = (debug.getinfo(1, "S").source:match("@(.*/)" ) or "./")
local H = dofile(dir .. "helpers.lua")
local S = dofile(dir .. "symbols.lua")

H.init("Dungeon Entry/Exit")

H.run(function()
    H.doChargen(S)
    H.assert_eq(H.readByte(S.GameState), 0x01, "On overworld")

    -- Navigate to dungeon at (X=12, Y=15)
    -- Path from (9,10): DOWN×5, RIGHT×3
    for i = 1, 5 do H.press("down") end
    for i = 1, 3 do H.press("right") end

    H.assert_eq(H.readByte(S.GameState), 0x02, "Entered dungeon")
    H.assert_eq(H.readByte(S.DungFloor), 0x00, "Floor 0")
    H.assert_eq(H.readByte(S.DungPlayerX), 0x01, "Dungeon X = 1")
    H.assert_eq(H.readByte(S.DungPlayerY), 0x01, "Dungeon Y = 1")

    -- Wait for render to complete, then press B
    H.waitFrames(5)
    H.press("b")

    -- Monitor GameState frame by frame
    print("  DEBUG: Monitoring GameState after B press:")
    for i = 1, 15 do
        coroutine.yield()
        local gs = H.readByte(S.GameState)
        local hp = H.readWord(S.PlayerHP)
        local food = H.readWord(S.PlayerFood)
        print(string.format("    frame %d: GS=$%02X HP=%d Food=%d", i, gs, hp, food))
        if gs == 0x01 then break end
    end

    H.assert_eq(H.readByte(S.GameState), 0x01, "Exited dungeon to overworld")

    H.done()
end)
