-- test_shop_buy.lua — Shop purchase
-- Navigate to town, buy food + rapier, verify inventory/gold

local dir = (debug.getinfo(1, "S").source:match("@(.*/)" ) or "./")
local H = dofile(dir .. "helpers.lua")
local S = dofile(dir .. "symbols.lua")

H.init("Shop Purchase")

H.run(function()
    H.doChargen(S)
    H.assert_eq(H.readByte(S.GameState), 0x01, "On overworld")

    -- Find town on procedural map
    local tx, ty = H.findTile(S, 0x03)  -- TILE_TOWN
    assert(tx, "Town not found on map")

    -- Teleport near town and walk onto it
    H.teleportNear(S, tx, ty)
    if H.readByte(S.PlayerX) < tx then
        H.press("right")
    else
        H.press("left")
    end

    H.assert_eq(H.readByte(S.GameState), 0x04, "Entered shop")
    H.assert_eq(H.readByte(S.ShopCursor), 0x00, "Cursor at food")

    -- Record state before purchase
    local goldBefore = H.readWord(S.PlayerGold)
    local foodBefore = H.readWord(S.PlayerFood)

    -- A -> buy food (cost 1 gold, +10 food)
    H.press("a")
    H.assert_eq(H.readWord(S.PlayerFood), foodBefore + 10, "Food +10 after buy")
    H.assert_eq(H.readWord(S.PlayerGold), goldBefore - 1, "Gold -1 after food buy")

    -- DOWN -> cursor to rapier (index 1)
    H.press("down")
    H.assert_eq(H.readByte(S.ShopCursor), 0x01, "Cursor at rapier")

    -- Buy rapier if affordable (cost 8)
    local goldNow = H.readWord(S.PlayerGold)
    local rapierBefore = H.readByte(S.PlayerRapier)
    if goldNow >= 8 then
        H.press("a")
        H.assert_eq(H.readByte(S.PlayerRapier), rapierBefore + 1, "Rapier +1 after buy")
        H.assert_eq(H.readWord(S.PlayerGold), goldNow - 8, "Gold -8 after rapier buy")
    else
        print("  SKIP: Not enough gold for rapier (" .. goldNow .. ")")
    end

    -- B -> leave shop
    H.press("b")
    H.waitFrames(10)
    H.assert_eq(H.readByte(S.GameState), 0x01, "Back on overworld")

    H.done()
end)
