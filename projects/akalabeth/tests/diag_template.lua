-- diag_template.lua — Template for Mesen2 diagnostic scripts
-- Copy this, rename, and customize for your diagnostic need.
-- Run: tools/mesen-diag.sh akalabeth tests/diag_<name>.lua

local dir = (debug.getinfo(1, "S").source:match("@(.*/)" ) or "./")
local H = dofile(dir .. "helpers.lua")
local S = dofile(dir .. "symbols.lua")

H.init("Diagnostic: <NAME>")

H.run(function()
    -- === SETUP: Get to the game state you want to test ===
    H.doChargen(S)  -- Plays through title + chargen, lands on overworld (GS=$01)

    -- === NAVIGATE: Move to specific location ===
    -- for i = 1, N do H.press("down") end
    -- for i = 1, N do H.press("right") end

    -- === PRE-STATE: Record state before action ===
    local MEM = emu.memType.snesDebug
    print(string.format("  Pre: GS=$%02X HP=%d Food=%d Gold=%d",
        H.readByte(S.GameState),
        H.readWord(S.PlayerHP),
        H.readWord(S.PlayerFood),
        H.readWord(S.PlayerGold)))

    -- === ACTION: Press button / wait / modify state ===
    -- H.press("b")
    -- H.waitFrames(5)

    -- === MONITOR: Watch frame-by-frame ===
    for i = 1, 10 do
        coroutine.yield()
        local gs = H.readByte(S.GameState)
        local hp = H.readWord(S.PlayerHP)

        -- Dump ZP for debugging
        local zp = {}
        for j = 0, 15 do
            table.insert(zp, string.format("%02X", emu.read(j, MEM)))
        end

        print(string.format("  f%02d: GS=$%02X HP=%d ZP: %s",
            i, gs, hp, table.concat(zp, " ")))

        -- CPU state if something looks wrong
        if gs == 0x00 and i > 1 then
            local state = emu.getState()
            print(string.format("  CRASH: PC=$%04X SP=$%04X DB=$%02X PB=$%02X",
                state["cpu.pc"], state["cpu.sp"],
                state["cpu.db"] or 0, state["cpu.k"] or 0))
            break
        end
    end

    emu.stop(0)
end)
