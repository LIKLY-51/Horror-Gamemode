AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("config/horror_config.lua")
include("shared.lua")

GM.config = GM.config or {}
include("config/horror_config.lua")
local config = GM.config

local currentModels = { }
util.AddNetworkString("Horror_SetModel")

hook.Add("PlayerSpawn", "horror_playerspawn", function(ply)
    ply:AllowFlashlight(config.canFlashlight)

    if (config.crosshair) then
        ply:CrosshairEnable()
    else
        ply:CrosshairDisable()
    end

    if (!config.takeDamage) then
        ply:GodEnable()
    else
        ply:GodDisable()
    end
end)

hook.Add("PlayerSetModel", "horror_playersetmodel", function(ply)
    if (currentModels[ply:SteamID()]) then
        ply:SetModel(currentModels[ply:SteamID()])
    else
        local temp = {}
        for v in pairs(config.playermodels) do
            table.insert(temp, v)
        end
        currentModels[ply:SteamID()] = temp[math.random(#temp)]
        ply:SetModel(currentModels[ply:SteamID()])
        temp = nil
    end

    if (config.randomColors) then
        ply:SetPlayerColor(Vector(math.random(255) / 255, math.random(255) / 255, math.random(255) / 255))
    end
end)

hook.Add("PlayerDisconnected", "horror_playerdisconnected", function(ply)
    if (currentModels[ply:SteamID()]) then
        currentModels[ply:SteamID()] = nil
    end
end)

hook.Add("PlayerNoClip", "horror_playernoclip", function(ply, state)
    -- probably a cleaner way of doing this but it works so I'm not gonna touch it
    if (state) then
        if (config.canNoclip == true || ((ply:IsSuperAdmin() || ply:IsAdmin()) && config.canAdminNoclip == true)) then
            return true
        else
            return false
        end
    else
        return true
    end
end)

-- net stuff
net.Receive("Horror_SetModel", function(len, ply)
    local model = net.ReadString()
    if (config.playermodels[model]) then
        currentModels[ply:SteamID()] = model
        ply:SetModel(model)
    end
end)