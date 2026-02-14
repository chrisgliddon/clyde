-- Minimal test to verify Mesen2 Lua API works
print("=== Minimal Test ===")
print("emu type: " .. type(emu))

-- Check memType availability
if emu.memType then
    print("memType available")
    for k, v in pairs(emu.memType) do
        print("  " .. k .. " = " .. tostring(v))
    end
else
    print("memType NOT available")
end

-- Check eventType
if emu.eventType then
    print("eventType available")
    for k, v in pairs(emu.eventType) do
        print("  " .. k .. " = " .. tostring(v))
    end
end

-- Try a simple callback
emu.addEventCallback(function()
    print("inputPolled fired!")
    local val = emu.read(0x00, emu.memType.snesMemory)
    print("GameState = " .. val)
    emu.stop(0)
end, emu.eventType.inputPolled)
