local Players = game:GetService("Players")

local TeamManager = {}

local localPlayer = Players.LocalPlayer
local teams = {}
local listeners = {
    teamChanged = {},
    allyAdded = {},
    allyRemoved = {}
}

local function emit(bucket, ...)
    for fn in pairs(bucket) do
        fn(...)
    end
end

local function getTeamName(player)
    return player.Team and player.Team.Name or nil
end

local function addPlayer(player)
    local team = getTeamName(player)
    if not team then return end

    teams[team] = teams[team] or {}
    teams[team][player] = true
end

local function removePlayer(player)
    for _, bucket in pairs(teams) do
        bucket[player] = nil
    end
end

local function onTeamChanged(player, oldTeam, newTeam)
    if oldTeam and teams[oldTeam] then
        teams[oldTeam][player] = nil
    end

    if newTeam then
        teams[newTeam] = teams[newTeam] or {}
        teams[newTeam][player] = true
    end

    emit(listeners.teamChanged, player, oldTeam, newTeam)

    if player ~= localPlayer then
        if newTeam == getTeamName(localPlayer) then
            emit(listeners.allyAdded, player)
        elseif oldTeam == getTeamName(localPlayer) then
            emit(listeners.allyRemoved, player)
        end
    end
end

function TeamManager.getTeam(player)
    return getTeamName(player)
end

function TeamManager.getPlayers(team)
    local bucket = teams[team]
    if not bucket then return {} end

    local list = {}
    for player in pairs(bucket) do
        table.insert(list, player)
    end
    return list
end

function TeamManager.sameTeam(a, b)
    return getTeamName(a) ~= nil and getTeamName(a) == getTeamName(b)
end

function TeamManager.isAlly(player)
    return TeamManager.sameTeam(player, localPlayer)
end

function TeamManager.isEnemy(player)
    local myTeam = getTeamName(localPlayer)
    local theirTeam = getTeamName(player)
    return myTeam ~= nil and theirTeam ~= nil and myTeam ~= theirTeam
end

function TeamManager.onTeamChanged(fn)
    listeners.teamChanged[fn] = true
end

function TeamManager.onAllyAdded(fn)
    listeners.allyAdded[fn] = true
end

function TeamManager.onAllyRemoved(fn)
    listeners.allyRemoved[fn] = true
end

for _, player in ipairs(Players:GetPlayers()) do
    addPlayer(player)

    player:GetPropertyChangedSignal("Team"):Connect(function()
        local old = nil
        for team, bucket in pairs(teams) do
            if bucket[player] then
                old = team
                break
            end
        end

        local new = getTeamName(player)
        onTeamChanged(player, old, new)
    end)
end

Players.PlayerAdded:Connect(function(player)
    addPlayer(player)

    player:GetPropertyChangedSignal("Team"):Connect(function()
        local old = nil
        for team, bucket in pairs(teams) do
            if bucket[player] then
                old = team
                break
            end
        end

        local new = getTeamName(player)
        onTeamChanged(player, old, new)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removePlayer(player)
end)

return TeamManager
