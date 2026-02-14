-- test_chargen.lua — Character generation flow
-- Title → seed → stats → class → overworld

local dir = (debug.getinfo(1, "S").source:match("@(.*/)" ) or "./")
local H = dofile(dir .. "helpers.lua")
local S = dofile(dir .. "symbols.lua")

H.init("Character Generation")

H.run(function()
    -- Wait for boot
    H.waitFrames(60)
    H.assert_eq(H.readByte(S.GameState), 0x00, "Title screen active")

    -- START → chargen seed
    H.press("start")
    H.assert_eq(H.readByte(S.GameState), 0x07, "Chargen seed state")

    -- A → confirm seed, roll stats → chargen stats
    H.press("a")
    H.assert_eq(H.readByte(S.GameState), 0x08, "Chargen stats state")

    -- Verify all stats in valid range (4-24)
    H.assert_range(H.readWord(S.PlayerHP),   4, 24, "HP in range")
    H.assert_range(H.readByte(S.PlayerSTR),  4, 24, "STR in range")
    H.assert_range(H.readByte(S.PlayerDEX),  4, 24, "DEX in range")
    H.assert_range(H.readByte(S.PlayerSTA),  4, 24, "STA in range")
    H.assert_range(H.readByte(S.PlayerWIS),  4, 24, "WIS in range")
    H.assert_range(H.readWord(S.PlayerGold), 4, 24, "Gold in range")

    -- A → accept stats → chargen class
    H.press("a")
    H.assert_eq(H.readByte(S.GameState), 0x09, "Chargen class state")
    H.assert_eq(H.readByte(S.PlayerClass), 0x00, "Default class is Fighter")

    -- RIGHT → toggle to Mage
    H.press("right")
    H.assert_eq(H.readByte(S.PlayerClass), 0x01, "Toggled to Mage")

    -- LEFT → toggle back to Fighter
    H.press("left")
    H.assert_eq(H.readByte(S.PlayerClass), 0x00, "Toggled back to Fighter")

    -- A → confirm class, start game (fade transition ~30 frames)
    H.press("a")
    H.waitFrames(60)
    H.assert_eq(H.readByte(S.GameState), 0x01, "Entered overworld")

    -- Verify CombatInit ran correctly
    H.assert_eq(H.readByte(S.PlayerRapier), 0x01, "Start with 1 rapier")
    H.assert_range(H.readByte(S.PlayerQuest), 0, 9, "Quest in valid range")
    H.assert_eq(H.readByte(S.PlayerClass), 0x00, "PlayerClass preserved as Fighter")

    H.done()
end)
