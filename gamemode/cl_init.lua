include("shared.lua")

GM.config = GM.config or {}
include("config/horror_config.lua")
local config = GM.config
local playermodels = { }

for v in pairs(config.playermodels) do
    table.insert(playermodels, v)
end

local ply = nil

hook.Add( "InitPostEntity", "horror_initpost", function()
    chat.AddText(Color(255,255,255), "You can now open the player model menu with f4!")
    ply = LocalPlayer()
end)


local menuOpen = false
hook.Add("Think", "horror_PMmenu", function()
    if (input.IsKeyDown(KEY_F4) && !menuOpen && ply != nil) then
        menuOpen = true
        local PMmenu = vgui.Create("DFrame")
        PMmenu:SetSize(800, 700)
        PMmenu:Center()
        PMmenu:SetTitle("Playermodel Selector")
        PMmenu:SetAlpha(253)
        PMmenu:MakePopup()
        PMmenu.Paint = function(self, w, h)
            draw.RoundedBox(2, 0, 0, w, h, Color(27, 27, 27))
        end
        PMmenu.OnClose = function()
            menuOpen = false
        end

        local currentModel = ply:GetModel()
        local menuModel = vgui.Create("DModelPanel", PMmenu)
        menuModel:SetPos(160, 5)
        menuModel:SetSize(500, 400)
        menuModel:SetModel(currentModel)
        menuModel:SetAnimated(true)
        local run = menuModel:GetEntity():LookupSequence("menu_walk")
        menuModel:GetEntity():SetSequence(run)
        
        local Scroll = vgui.Create("DScrollPanel", PMmenu)
        Scroll:SetSize(800, 300)
        Scroll:SetPos(0, 400)

        local modelList = vgui.Create("DIconLayout", Scroll)
        modelList:Dock(FILL)
        modelList:SetSpaceX(10)
        modelList:SetSpaceY(10)

        for i = 1, #playermodels do
            local icon = vgui.Create("SpawnIcon" , modelList)
            icon:SetModel(playermodels[i])
            icon.DoClick = function()
                menuModel:SetModel(playermodels[i])
                net.Start("Horror_SetModel")
                net.WriteString(playermodels[i])
                net.SendToServer()
            end
        end
    end
end)