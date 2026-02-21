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
        pcall(function()
            local args = {
                [1] = 0,
                [2] = false
            }
            game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.GetBibit:FireServer(unpack(args))
        end)
    end
})

-- ==========================================
-- ROW 2: HARVEST ALL PADI
-- ==========================================
TabFarming:CreateButtonRow({
    Name = "Harvest All (Padi)",
    ButtonText = "Harvest",
    Callback = function()
        -- Gunakan task.spawn agar UI tidak macet, dan beri task.wait() 
        -- agar server tidak menolak (Mute/Rate limit) permintaan karena terlalu cepat (Spam).
        task.spawn(function()
            for i = 1, 15 do
                pcall(function()
                    local args = {
                        [1] = "Padi",
                        [2] = i,
                        [3] = "Rice"
                    }
                    game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.HarvestCrop:FireServer(unpack(args))
                end)
                task.wait(0.1) -- Beri jeda 0.1 detik perlahan sebelum kirim panen ke-2, ke-3, dst
            end
        end)
    end
})

-- ==========================================
-- ROW 3: SELL CROP
-- ==========================================
TabFarming:CreateButtonRow({
    Name = "Sell Crop",
    ButtonText = "Sell",
    Callback = function()
        pcall(function()
            local args = {}
            game:GetService("ReplicatedStorage").Remotes.TutorialRemotes.SellCrop:FireServer(unpack(args))
        end)
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
