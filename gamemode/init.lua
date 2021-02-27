AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

GM.config = GM.config or {}
include("config/horror_config.lua")
local config = GM.config

hook.Add("PlayerSpawn", "horror_playerspawn", function(ply)
    ply:AllowFlashlight(config.canFlashlight)

    if (config.crosshair == true) then
        ply:CrosshairEnable()
    else
        ply:CrosshairDisable()
    end
end)

-- possibly make models persistant after death?
hook.Add("PlayerSetModel", "horror_playersetmodel", function(ply)
    ply:SetModel(config.playermodels[math.random(#config.playermodels)])
    if (config.playerColors) then
        ply:SetPlayerColor(Vector(math.random(255) / 255, math.random(255) / 255, math.random(255) / 255))
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