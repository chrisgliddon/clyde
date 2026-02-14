-- playthrough.lua — Full automated playthrough: title → victory
-- Diagnostic/demo script. Run: tools/mesen-diag.sh akalabeth tests/playthrough.lua
-- Uses direct memory writes (teleport, stat boost) to reliably complete the game.

local dir = (debug.getinfo(1, "S").source:match("@(.*/)") or "./")
local H = dofile(dir .. "helpers.lua")
local S = dofile(dir .. "symbols.lua")

H.setMaxFrames(36000)  -- 10 minutes for full game
H.init("Full Playthrough")

-- Game state constants
local GS_OVERWORLD = 0x01
local GS_DUNGEON   = 0x02
local GS_SHOP      = 0x04
local GS_CASTLE    = 0x05
local GS_GAMEOVER  = 0x06

-- Overworld tile types
local TILE_TOWN    = 0x03
local TILE_CASTLE  = 0x04
local TILE_DUNGEON = 0x05

-- Dungeon tile types
local DTILE_FLOOR     = 0x00
local DTILE_STAIRS_UP = 0x03
local DTILE_STAIRS_DN = 0x04
local DTILE_MONSTER   = 0x06

-- ============================================================================
-- Helpers
-- ============================================================================

local function log(msg)
    print("  [PT] " .. msg)
end

local function gs()
    return H.readByte(S.GameState)
end

local function waitState(target, maxWait)
    maxWait = maxWait or 120
    for i = 1, maxWait do
        if gs() == target then return true end
        coroutine.yield()
    end
    return gs() == target
end

-- ============================================================================
-- Overworld: teleport adjacent, walk onto tile
-- ============================================================================

local function goToTile(tileType)
    local tx, ty = H.findTile(S, tileType)
    if not tx then
        log("ERROR: tile " .. tileType .. " not on map")
        return false
    end
    H.teleportNear(S, tx, ty)
    local px = H.readByte(S.PlayerX)
    if px < tx then H.press("right")
    elseif px > tx then H.press("left")
    else
        local py = H.readByte(S.PlayerY)
        if py < ty then H.press("down") else H.press("up") end
    end
    H.waitFrames(60)
    return true
end

-- ============================================================================
-- Shop: buy food + rapier
-- ============================================================================

local function doShop()
    if gs() ~= GS_OVERWORLD then return end
    goToTile(TILE_TOWN)
    if not waitState(GS_SHOP) then log("Can't enter shop"); return end
    H.waitFrames(5)

    local gold = H.readWord(S.PlayerGold)
    local rapier = H.readByte(S.PlayerRapier)

    -- Buy rapier if needed
    if rapier == 0 and gold >= 8 then
        H.press("down")    -- cursor → rapier
        H.waitFrames(2)
        H.press("a")       -- buy
        H.waitFrames(2)
        H.press("up")      -- cursor → food
        H.waitFrames(2)
        log("Bought rapier")
    end

    -- Buy food
    local buys = 0
    local food = H.readWord(S.PlayerFood)
    gold = H.readWord(S.PlayerGold)
    while food < 40 and gold >= 1 and buys < 8 do
        H.press("a")
        H.waitFrames(2)
        food = food + 10
        gold = gold - 1
        buys = buys + 1
    end
    if buys > 0 then log("Bought " .. buys*10 .. " food") end

    H.press("b")
    H.waitFrames(60)
end

-- ============================================================================
-- Castle: check/advance quest
-- ============================================================================

local function doCastle()
    if gs() ~= GS_OVERWORLD then return false end
    goToTile(TILE_CASTLE)
    if not waitState(GS_CASTLE) then log("Can't enter castle"); return false end
    H.waitFrames(5)

    local quest = H.readByte(S.PlayerQuest)
    log(string.format("Castle: quest=$%02X", quest))

    if quest >= 0x80 then
        H.press("a")       -- Accept/advance quest
        H.waitFrames(10)
        if gs() == GS_GAMEOVER then
            log("VICTORY!")
            return true
        end
        log(string.format("New quest=$%02X", H.readByte(S.PlayerQuest)))
    end

    H.press("b")
    H.waitFrames(60)
    return false
end

-- ============================================================================
-- Dungeon helpers
-- ============================================================================

local function getDungTile(row, col)
    return H.readByte(S.DungeonGrid + row * 11 + col)
end

local function findTileInDungeon(tileType)
    for row = 0, 10 do
        for col = 0, 10 do
            if getDungTile(row, col) == tileType then
                return col, row
            end
        end
    end
    return nil, nil
end

local function dungTeleport(x, y)
    H.writeByte(S.DungPlayerX, x)
    H.writeByte(S.DungPlayerY, y)
    -- Trigger re-render
    H.writeByte(S.MapDirty, 1)
    H.waitFrames(5)
end

local function findQuestMonster()
    local quest = H.readByte(S.PlayerQuest)
    if quest >= 0x80 then return nil end
    for i = 0, 9 do
        if H.readByte(S.MonAlive + i) ~= 0 and H.readByte(S.MonType + i) == quest then
            return H.readByte(S.MonX + i), H.readByte(S.MonY + i), i
        end
    end
    return nil
end

local function faceAndAttack(mx, my, monIdx)
    local px = H.readByte(S.DungPlayerX)
    local py = H.readByte(S.DungPlayerY)
    local dx, dy = mx - px, my - py

    -- Determine needed facing
    local wantFace
    if dy < 0 then wantFace = 0       -- North
    elseif dy > 0 then wantFace = 2   -- South
    elseif dx > 0 then wantFace = 1   -- East
    else wantFace = 3 end             -- West

    -- Set facing directly
    H.writeByte(S.DungFacing, wantFace)
    H.waitFrames(3)

    -- Attack until monster dead
    for atk = 1, 80 do
        if gs() ~= GS_DUNGEON then return end
        if H.readByte(S.MonAlive + monIdx) == 0 then
            log("Monster killed!")
            return
        end
        H.press("a")
        H.waitFrames(4)
    end
end

-- ============================================================================
-- Dungeon: descend, find quest monster, kill, exit
-- ============================================================================

local function doDungeon()
    if gs() ~= GS_OVERWORLD then return false end
    goToTile(TILE_DUNGEON)
    if not waitState(GS_DUNGEON) then log("Can't enter dungeon"); return false end

    local quest = H.readByte(S.PlayerQuest)
    log(string.format("In dungeon. Quest=%d HP=%d", quest, H.readWord(S.PlayerHP)))

    -- Boost stats each dungeon entry
    H.writeByte(S.PlayerHP, 0xFF)
    H.writeByte(S.PlayerHP + 1, 0x00)
    H.writeByte(S.PlayerSTR, 30)
    H.writeByte(S.PlayerDEX, 30)

    -- Explore up to 10 floors
    for depth = 1, 10 do
        if gs() ~= GS_DUNGEON then break end
        local floor = H.readByte(S.DungFloor)
        log(string.format("Floor %d", floor))

        -- Check for quest monster
        local mx, my, mi = findQuestMonster()
        if mx then
            log(string.format("Quest monster at (%d,%d), idx=%d", mx, my, mi))
            -- Teleport adjacent to monster
            local placed = false
            local offsets = {{-1,0},{1,0},{0,-1},{0,1}}
            for _, off in ipairs(offsets) do
                local ax, ay = mx + off[1], my + off[2]
                if ax >= 0 and ax <= 10 and ay >= 0 and ay <= 10 then
                    local t = getDungTile(ay, ax)
                    if t ~= 1 and t ~= DTILE_MONSTER then  -- Not wall, not monster
                        dungTeleport(ax, ay)
                        placed = true
                        break
                    end
                end
            end
            if placed then
                faceAndAttack(mx, my, mi)
                local q = H.readByte(S.PlayerQuest)
                if q >= 0x80 then
                    log("Quest complete!")
                    break
                end
            end
        end

        -- Monster not found or not killed — go deeper if eligible
        -- Quest monster type X can appear on floor >= X-2
        -- So we need to be on at least floor quest-2
        if gs() == GS_DUNGEON then
            local sx, sy = findTileInDungeon(DTILE_STAIRS_DN)
            if sx then
                dungTeleport(sx, sy)
                H.press("b")   -- Use stairs down
                H.waitFrames(10)
            else
                log("No stairs down, exiting")
                break
            end
        end
    end

    -- Exit dungeon: climb back up
    for climb = 1, 12 do
        if gs() ~= GS_DUNGEON then break end
        local sx, sy = findTileInDungeon(DTILE_STAIRS_UP)
        if sx then
            dungTeleport(sx, sy)
            H.press("b")
            H.waitFrames(10)
        else
            log("No stairs up!")
            break
        end
    end

    H.waitFrames(60)  -- Wait for overworld gfx swap
    local q = H.readByte(S.PlayerQuest)
    return q >= 0x80
end

-- ============================================================================
-- Main playthrough loop
-- ============================================================================

H.run(function()
    H.doChargen(S)
    log(string.format("Overworld. HP=%d Food=%d Gold=%d Quest=$%02X",
        H.readWord(S.PlayerHP), H.readWord(S.PlayerFood),
        H.readWord(S.PlayerGold), H.readByte(S.PlayerQuest)))

    -- Boost starting stats
    H.writeByte(S.PlayerHP, 0xFF)
    H.writeByte(S.PlayerHP + 1, 0x00)
    H.writeByte(S.PlayerSTR, 30)
    H.writeByte(S.PlayerDEX, 30)
    H.writeByte(S.PlayerGold, 0xFF)
    H.writeByte(S.PlayerGold + 1, 0x00)

    -- Visit castle for initial quest
    doCastle()

    for cycle = 1, 15 do
        log(string.format("=== Cycle %d (quest=$%02X) ===", cycle, H.readByte(S.PlayerQuest)))
        if gs() == GS_GAMEOVER then break end
        if gs() ~= GS_OVERWORLD then
            log(string.format("Bad state $%02X, aborting", gs()))
            break
        end

        doShop()
        if gs() ~= GS_OVERWORLD then
            if gs() == GS_GAMEOVER then break end
            H.waitFrames(60)
        end

        -- Re-boost
        H.writeByte(S.PlayerHP, 0xFF)
        H.writeByte(S.PlayerHP + 1, 0x00)

        local questDone = doDungeon()
        if gs() == GS_GAMEOVER then break end

        if questDone then
            local victory = doCastle()
            if victory then break end
        else
            log("Quest not completed, retrying")
        end
    end

    log(string.format("DONE. State=$%02X Quest=$%02X HP=%d",
        gs(), H.readByte(S.PlayerQuest), H.readWord(S.PlayerHP)))
    emu.stop(0)
end)
