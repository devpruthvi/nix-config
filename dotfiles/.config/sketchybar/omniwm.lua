local cjson = require("cjson")

local json = cjson.new()

local OMNIWMCTL = "/opt/homebrew/bin/omniwmctl"

local Omniwm = {}
Omniwm.__index = Omniwm

function Omniwm.new()
    return setmetatable({}, Omniwm)
end

local function run(args)
    local handle = io.popen(OMNIWMCTL .. " " .. args .. " 2>/dev/null")
    if not handle then return nil end
    local out = handle:read("*a")
    handle:close()
    if not out or out:match("^%s*$") then return nil end
    local ok, decoded = pcall(json.decode, out)
    if not ok then return nil end
    return decoded
end

local function payload(decoded)
    if type(decoded) ~= "table" then return decoded end
    if decoded.result and decoded.result.payload ~= nil then
        return decoded.result.payload
    end
    if decoded.result ~= nil then return decoded.result end
    return decoded
end

function Omniwm:list_workspaces()
    local decoded = run(
        "query workspaces --fields id,raw-name,display-name,number,is-focused,is-current,is-visible --format json")
    local data = payload(decoded)
    if type(data) ~= "table" then return {} end
    local workspaces = data.workspaces or data
    table.sort(workspaces, function(a, b)
        return (a.number or 0) < (b.number or 0)
    end)
    return workspaces
end

function Omniwm:windows_by_workspace()
    local decoded = run(
        "query windows --fields id,app,bundle-id,workspace --format json")
    local data = payload(decoded)
    local windows = (type(data) == "table" and (data.windows or data)) or {}
    local grouped = {}
    for _, window in ipairs(windows) do
        local ws = window.workspace
        if ws ~= nil then
            grouped[ws] = grouped[ws] or {}
            table.insert(grouped[ws], window)
        end
    end
    return grouped
end

function Omniwm:focus_workspace(id)
    if id == nil then return end
    os.execute(OMNIWMCTL .. " workspace focus " .. tostring(id) .. " >/dev/null 2>&1")
end

return Omniwm
