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
local PLOT_POSITIONS = {
    Vector3.new(-63.81907653808594, 37.296875, -289.13531494140625),
    Vector3.new(-63.25303268432617, 37.296875, -289.9723815917969),
    Vector3.new(-62.667564392089844, 37.296875, -291.13800048828125),
    Vector3.new(-63.12100601196289, 37.296875, -291.4932861328125),
    Vector3.new(-63.52046203613281, 37.296875, -293.7101745605469),
    Vector3.new(-63.930274963378906, 37.296875, -294.2054748535156),
    Vector3.new(-61.150390625, 37.296875, -290.20855712890625),
    Vector3.new(-61.150390625, 37.296875, -288.2495422363281),
    Vector3.new(-60.30989074707031, 37.296875, -290.603271484375),
    Vector3.new(-61.092796325683594, 37.296875, -294.01849365234375),
    Vector3.new(-62.351627349853516, 37.296875, -295.30804443359375),
    Vector3.new(-62.87940979003906, 37.296875, -296.0554504394531),
    Vector3.new(-61.06902313232422, 37.296875, -296.35931396484375),
    Vector3.new(-59.88715744018555, 37.296875, -292.9075927734375),
    Vector3.new(-61.07583999633789, 37.296875, -293.1001892089844)
}

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
            for _, pos in ipairs(PLOT_POSITIONS) do
                pcall(function() rs.Remotes.TutorialRemotes.PlantCrop:FireServer(pos) end)
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
                    
                    -- 2. Tanam di semua titik
                    for _, pos in ipairs(PLOT_POSITIONS) do
                        if not getgenv().SkenaAutoFarm_Jagung then return end
                        pcall(function() rs.Remotes.TutorialRemotes.PlantCrop:FireServer(pos) end)
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
