local TeamManager = {}
TeamManager.version = nil

function TeamManager.init()
    local path
    if TeamManager.version then
        path = "@" .. TeamManager.version .. "/main.lua"
    else
        path = "main/main.lua"
    end

    local url =
        "https://raw.githubusercontent.com/rconsoIe/TeamManager/refs/heads/main/" .. path

    local ok, impl = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if not ok then
        error("TeamManager: failed to load implementation (" .. path .. ")")
    end

    return impl
end

return TeamManager
