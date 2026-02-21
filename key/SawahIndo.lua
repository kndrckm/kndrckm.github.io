local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer

-- ==========================================
-- INIT SKENA UI
-- ==========================================
local SkenaUI_Loaded = false
local SkenaUI
pcall(function()
    SkenaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua"))()
    SkenaUI_Loaded = true
end)

if not SkenaUI_Loaded then
    warn("Koneksi gagal ke SkenaUI_Library. Hubungkan ke Internet.")
    return
end

local GameName = "SAWAH indo Finder"
local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
if success and info and info.Name then
    GameName = info.Name .. " Hub"
end

local Window = SkenaUI:CreateWindow({
    Name = "SkenaHub - " .. GameName
})

local TabFarming = Window:CreateTab("Farming", "wheat") 
local TabSettings = Window:CreateTab("Settings", "settings", true) 

-- ==========================================
-- ROW 1: BELI BIBIT
-- ==========================================
TabFarming:CreateButtonRow({
    Name = "Beli Bibit (Padi)",
    ButtonText = "Beli",
    Callback = function()
        local rs = game:GetService("ReplicatedStorage")
        rs.Remotes.TutorialRemotes.GetBibit:FireServer(0, false)
    end
})

-- ==========================================
-- ROW 2: HARVEST ALL PADI
-- ==========================================
TabFarming:CreateButtonRow({
    Name = "Harvest All (Padi)",
    ButtonText = "Harvest",
    Callback = function()
        task.spawn(function()
            local rs = game:GetService("ReplicatedStorage")
            for i = 1, 15 do
                rs.Remotes.TutorialRemotes.HarvestCrop:FireServer("Padi", i, "Rice")
                task.wait(0.1)
            end
        end)
    end
})

-- ==========================================
-- ROW 3: HARVEST ALL JAGUNG
-- ==========================================
TabFarming:CreateButtonRow({
    Name = "Harvest All (Jagung)",
    ButtonText = "Harvest",
    Callback = function()
        task.spawn(function()
            local rs = game:GetService("ReplicatedStorage")
            for i = 1, 15 do
                rs.Remotes.TutorialRemotes.HarvestCrop:FireServer("Jagung", i, "Corn")
                task.wait(0.1)
            end
        end)
    end
})

-- ==========================================
-- ROW 4: SELL CROP
-- ==========================================
TabFarming:CreateButtonRow({
    Name = "Sell Crop",
    ButtonText = "Sell",
    Callback = function()
        local rs = game:GetService("ReplicatedStorage")
        rs.Remotes.TutorialRemotes.SellCrop:FireServer()
    end
})

-- ==========================================
-- ISI TAB SETTINGS
-- ==========================================
TabSettings:CreateInputRow({
    Name = "UI Toggle Key",
    Placeholder = "Z",
    Default = "Z",
    Callback = function(keyStr)
        Window:SetToggleKey(keyStr)
    end
})

-- ==========================================
-- ATTACH ADMIN MODULE ONLINE
-- ==========================================
task.spawn(function()
    local succ, SkenaAdmin = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Admin.lua"))()
    end)
    if succ and SkenaAdmin then
        SkenaAdmin.Attach(Window, {})
    end
end)
