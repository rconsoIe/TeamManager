# TeamManager

Client-side team tracking and relationship manager for Roblox.

TeamManager centralizes team-related logic on the client, providing fast queries, cached team data, and clean events when players change teams.

Pure Lua. Client-only. No server authority.

---

## What it does

- Caches players by team on the client
- Tracks team changes efficiently
- Provides fast ally / enemy queries
- Emits events when teams change
- Removes duplicated team logic from gameplay scripts

---

## What it does NOT do

- It does not set teams
- It does not replicate data
- It does not enforce permissions
- It does not replace server authority

TeamManager observes team state — it never controls it.

---

## Setup

Load TeamManager using HttpGet:

```lua
TeamManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/rconsoIe/TeamManager/refs/heads/main/loader.lua"
))()

-- Optional version selection:

-- TeamManager.version = "v1.0.0"

TeamManager = TeamManager.init()
```

If no version is specified, the latest version is loaded by default.

---

## Core concepts

TeamManager maintains a cached view of teams on the client:

- Players are grouped by `player.Team.Name`
- The cache updates automatically when:
  - players join
  - players leave
  - players change teams

No per-frame checks are used.

---

## API Reference

### TeamManager.getTeam

Returns the name of a player's team, or nil if they have no team.

```lua
TeamManager.getTeam(player)
```

Example:

```lua
local team = TeamManager.getTeam(player)
```

---

### TeamManager.getPlayers

Returns a list of players currently on the given team.

```lua
TeamManager.getPlayers(teamName)
```

Example:

```lua
local redPlayers = TeamManager.getPlayers("Red")
```

---

### TeamManager.sameTeam

Checks whether two players are on the same team.

```lua
TeamManager.sameTeam(playerA, playerB)
```

Returns true or false.

---

### TeamManager.isAlly

Checks whether a player is on the same team as the local player.

```lua
TeamManager.isAlly(player)
```

Returns true or false.

---

### TeamManager.isEnemy

Checks whether a player is on a different team than the local player.

```lua
TeamManager.isEnemy(player)
```

Returns true or false.

---

## Events

TeamManager provides client-side events for reacting to team changes.

Events are synchronous and lightweight.

---

### TeamManager.onTeamChanged

Called when a player's team changes.

```lua
TeamManager.onTeamChanged(callback)
```

Callback signature:

```lua
callback(player, oldTeam, newTeam)
```

Example:

```lua
TeamManager.onTeamChanged(function(player, oldTeam, newTeam)
    print(player.Name, oldTeam, "→", newTeam)
end)
```

---

### TeamManager.onAllyAdded

Called when a player becomes an ally of the local player.

```lua
TeamManager.onAllyAdded(callback)
```

Callback signature:

```lua
callback(player)
```

Example:

```lua
TeamManager.onAllyAdded(function(player)
    print(player.Name, "is now an ally")
end)
```

---

### TeamManager.onAllyRemoved

Called when a player stops being an ally of the local player.

```lua
TeamManager.onAllyRemoved(callback)
```

Callback signature:

```lua
callback(player)
```

Example:

```lua
TeamManager.onAllyRemoved(function(player)
    print(player.Name, "is no longer an ally")
end)
```

---

## Performance notes

- No Heartbeat usage
- No polling loops
- No repeated Players:GetPlayers() calls
- Team lookups are O(1)
- Event dispatch is lightweight

Designed for use in combat logic, UI updates, and client-only systems.

---

## Recommended usage

Use TeamManager for:
- combat team checks
- hitbox filtering
- UI coloring (ally vs enemy)
- scoreboard logic
- spectator handling (client-side)

Avoid using TeamManager for:
- server validation
- security decisions
- authoritative gameplay logic

---

## Example (realistic)

```lua
TeamManager.onTeamChanged(function(player, oldTeam, newTeam)
    if TeamManager.isEnemy(player) then
        print(player.Name, "is hostile")
    end
end)
```

---

## Design goals

- Minimal API
- No server dependency
- Predictable behavior
- Easy integration with other client libraries

TeamManager is designed to work well alongside:
- Packets (networking)
- Scheduler (timing)
- Signals (client communication)

---

## Notes

- Team names are compared by string
- Players without a team return nil
- Listener execution order is not guaranteed
- Keep callbacks lightweight
