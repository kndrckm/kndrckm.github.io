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
-- DATA KORDINAT LOKASI PETAK SAWAH
-- ==========================================
-- Karena game mengizinkan bibit ditumpuk di titik yang sama (Stacking),
-- kita cukup menanam 15 biji di satu titik koordinat ini secara berulang.
local STACK_POSITION = Vector3.new(-162.22613525390625, 39.296875, -345.8756408691406)

-- ==========================================
-- MANUAL BUTTONS (JAGUNG)
-- ==========================================
TabFarming:CreateButtonRow({
    Name = "1. Beli Bibit Jagung (15x)",
    ButtonText = "Beli",
    Callback = function()
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            rs.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Jagung", 15)
        end)
    end
})

TabFarming:CreateButtonRow({
    Name = "2. Tanam Jagung (15 Petak)",
    ButtonText = "Tanam",
    Callback = function()
        task.spawn(function()
            local rs = game:GetService("ReplicatedStorage")
            for i = 1, 15 do
                pcall(function() rs.Remotes.TutorialRemotes.PlantCrop:FireServer(STACK_POSITION) end)
                task.wait(0.12)
            end
        end)
    end
})

TabFarming:CreateButtonRow({
    Name = "3. Harvest All (Jagung)",
    ButtonText = "Panen",
    Callback = function()
        task.spawn(function()
            local rs = game:GetService("ReplicatedStorage")
            for i = 1, 15 do
                pcall(function() rs.Remotes.TutorialRemotes.HarvestCrop:FireServer("Jagung", i, "Corn") end)
                task.wait(0.12)
            end
        end)
    end
})

TabFarming:CreateButtonRow({
    Name = "4. Sell All Jagung",
    ButtonText = "Jual",
    Callback = function()
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            rs.Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Jagung", 30)
        end)
    end
})

-- ==========================================
-- LOOPING MODE / AUTO-FARM (JAGUNG)
-- ==========================================
getgenv().SkenaAutoFarm_Jagung = false
TabFarming:CreateToggleRow({
    Name = "Auto Farm Jagung (AFK)",
    OnToggle = function(state)
        getgenv().SkenaAutoFarm_Jagung = state
        if state then
            task.spawn(function()
                local rs = game:GetService("ReplicatedStorage")
                while getgenv().SkenaAutoFarm_Jagung do
                    
                    -- 1. Beli Bibit
                    pcall(function() rs.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Jagung", 15) end)
                    task.wait(1)
                    
                    -- 2. Tanam bertumpuk (Stack) di 1 titik
                    for i = 1, 15 do
                        if not getgenv().SkenaAutoFarm_Jagung then return end
                        pcall(function() rs.Remotes.TutorialRemotes.PlantCrop:FireServer(STACK_POSITION) end)
                        task.wait(0.15)
                    end
                    
                    -- 3. Menunggu (Asumsi Jagung Tumbuh Butuh ~15-20 detik)
                    -- Sesuaikan angka ini bila tumbuhnya lebih lama. Saya mengatur waktu tunggu ideal 10 detik.
                    task.wait(10)
                    
                    -- 4. Panen 
                    for i = 1, 15 do
                        if not getgenv().SkenaAutoFarm_Jagung then return end
                        pcall(function() rs.Remotes.TutorialRemotes.HarvestCrop:FireServer("Jagung", i, "Corn") end)
                        task.wait(0.15)
                    end
                    task.wait(1.5)
                    
                    -- 5. Jual
                    pcall(function() rs.Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Jagung", 30) end)
                    task.wait(1.5)
                    
                end
            end)
        end
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
