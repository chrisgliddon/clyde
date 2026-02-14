-- symbols.lua — Parse ld65 VICE-format symbol file (.sym)
-- Maps label names to CPU addresses for named memory reads

local S = {}

-- Derive sym file path relative to this script's location
local source = debug.getinfo(1, "S").source
local dir = ""
if source:sub(1, 1) == "@" then
    dir = source:sub(2):match("(.*/)") or ""
end

-- Try paths relative to script dir, then CWD
local candidates = {
    dir .. "../build/akalabeth.sym",
    "build/akalabeth.sym",
}

local f
for _, path in ipairs(candidates) do
    f = io.open(path, "r")
    if f then break end
end

if not f then
    error("Symbol file not found. Build with: make -C projects/akalabeth")
end

for line in f:lines() do
    -- ld65 VICE format: "al XXXXXX .LabelName"
    local addr, name = line:match("^al%s+(%x+)%s+%.(.+)$")
    if addr and name then
        S[name] = tonumber(addr, 16)
    end
end
f:close()

return S
