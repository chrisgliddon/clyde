-- Debug: check dofile path resolution
local source = debug.getinfo(1, "S").source
print("source: " .. source)
local dir = ""
if source:sub(1, 1) == "@" then
    dir = source:sub(2):match("(.*/)") or ""
end
print("dir: '" .. dir .. "'")
print("helpers path: '" .. dir .. "helpers.lua'")

-- Try loading helpers
local ok, result = pcall(dofile, dir .. "helpers.lua")
if ok then
    print("helpers loaded OK")
else
    print("helpers FAILED: " .. tostring(result))
end

-- Try loading symbols
ok, result = pcall(dofile, dir .. "symbols.lua")
if ok then
    print("symbols loaded OK")
else
    print("symbols FAILED: " .. tostring(result))
end

emu.stop(0)
