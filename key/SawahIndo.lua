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
-- CROP DATA REFERENCE
-- ==========================================
local CROP_DATA = {
    ["Jagung"] = { SeedName = "Bibit Jagung", EnglishName = "Corn" },
    ["Tomat"]  = { SeedName = "Bibit Tomat",  EnglishName = "Tomato" },
    ["Padi"]   = { SeedName = "Bibit Padi",   EnglishName = "Rice" },
    ["Terong"] = { SeedName = "Bibit Terong", EnglishName = "Eggplant" }
}
getgenv().SelectedCrop = "Jagung"

local CropDrop = TabFarming:CreateDropdown({
    Name = " [ Target Tanaman (Global) ]",
    Callback = function(val)
        getgenv().SelectedCrop = val
        warn("Terpilih Tanaman: " .. val)
    end
})
for cName, _ in pairs(CROP_DATA) do
    CropDrop:AddItem(cName, cName == "Jagung")
end

-- ==========================================
-- SETTINGS BATCH & DELAY
-- ==========================================
getgenv().AFK_PlantAmount = 15
getgenv().AFK_HarvestDelay = 120

TabFarming:CreateInputRow({
    Name = " [ Jumlah Tanam per Loop ]",
    Placeholder = "15",
    Default = "15",
    Callback = function(val)
        getgenv().AFK_PlantAmount = tonumber(val) or 15
    end
})

TabFarming:CreateInputRow({
    Name = " [ Waktu Tunggu / Panen (Detik) ]",
    Placeholder = "120",
    Default = "120",
    Callback = function(val)
        getgenv().AFK_HarvestDelay = tonumber(val) or 120
    end
})

-- ==========================================
-- LOOPING MODE / AUTO-FARM
-- ==========================================
getgenv().SkenaAutoFarm_Crop = false
getgenv().AutoBuySeed = true

TabFarming:CreateToggleRow({
    Name = "Auto Farm (AFK)",
    HasSubToggle = true,
    SubToggleName = "Auto Beli",
    SubToggleDefault = true,
    OnSubToggle = function(state)
        getgenv().AutoBuySeed = state
    end,
    OnToggle = function(state)
        getgenv().SkenaAutoFarm_Crop = state
        if state then
            task.spawn(function()
                local rs = game:GetService("ReplicatedStorage")
                while getgenv().SkenaAutoFarm_Crop do
                    local cData = CROP_DATA[getgenv().SelectedCrop]
                    local plotSize = getgenv().AFK_PlantAmount or 15
                    
                    -- 1. Beli Bibit (Hanya jika dicentang)
                    if getgenv().AutoBuySeed then
                        pcall(function() rs.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", cData.SeedName, plotSize) end)
                        task.wait(1)
                    end
                    
                    -- 2. Tanam Berulang di Titik Berdiri (1 Lot/Pijakan)
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum then
                            local heldCrop = char:FindFirstChild(cData.SeedName)
                            if not heldCrop then
                                local inBp = player.Backpack:FindFirstChild(cData.SeedName)
                                if inBp then
                                    hum:EquipTool(inBp)
                                    task.wait(0.25)
                                else
                                    warn("Bibit tidak ditemukan di tangan maupun tas!")
                                end
                            end
                        end
                        
                        local pos = char.HumanoidRootPart.Position
                        for i = 1, plotSize do
                            if not getgenv().SkenaAutoFarm_Crop then return end
                            pcall(function() rs.Remotes.TutorialRemotes.PlantCrop:FireServer(pos) end)
                            task.wait(0.25)
                        end
                    else
                        warn("Karakter tidak ditemukan! Tanam ditunda 2 detik.")
                        task.wait(2)
                    end
                    
                    -- 3. Menunggu (Waktu Tanaman Tumbuh)
                    local hDelay = getgenv().AFK_HarvestDelay or 120
                    task.wait(hDelay)
                    
                    -- 4. Panen Otomatis (Buffer di atas plotSize untuk menimpa sisa tanaman/lag)
                    for i = 1, plotSize + 5 do
                        if not getgenv().SkenaAutoFarm_Crop then return end
                        pcall(function() rs.Remotes.TutorialRemotes.HarvestCrop:FireServer(getgenv().SelectedCrop, i, cData.EnglishName) end)
                        task.wait(0.35) 
                    end
                    task.wait(1.5)
                    
                    -- 5. Jual Pintar
                    local sellAmt = plotSize
                    pcall(function()
                        local inv = rs.Remotes.TutorialRemotes.RequestSell:InvokeServer("GET_LIST")
                        if typeof(inv) == "table" and typeof(inv.Items) == "table" then
                            for _, itemData in pairs(inv.Items) do
                                if typeof(itemData) == "table" and (itemData.Name == getgenv().SelectedCrop or itemData.DisplayName == cData.EnglishName) then
                                    sellAmt = tonumber(itemData.Owned) or sellAmt
                                    break
                                end
                            end
                        end
                    end)
                    
                    pcall(function() rs.Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", getgenv().SelectedCrop, sellAmt) end)
                    task.wait(1.5)
                end
            end)
        end
    end
})

TabFarming:CreateTextRow({
    Text = "Step: Atur Jumlah Target dan Waktu Tunggu, lalu nyalakan Auto Farm. Semua bibit akan ditanam berlipat-lipat secara ditumpuk tepat di tanah tempat karakter Anda berpijak."
})

-- ==========================================
-- MANUAL BUTTONS
-- ==========================================
TabFarming:CreateInputButtonRow({
    Name = "1. Beli Bibit",
    Placeholder = "Jml",
    Default = "15",
    ButtonText = "Beli",
    Callback = function(inputValue)
        local cData = CROP_DATA[getgenv().SelectedCrop]
        local amount = tonumber(inputValue) or 15
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            rs.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", cData.SeedName, amount)
        end)
    end
})

TabFarming:CreateInputButtonRow({
    Name = "2. Tanam di Kaki",
    Placeholder = "Jml",
    Default = "15",
    ButtonText = "Tanam",
    Callback = function(inputValue)
        local amount = tonumber(inputValue) or 15
        task.spawn(function()
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then 
                warn("Gagal menanam! Karakter tidak ditemukan.")
                return 
            end
            
            local cData = CROP_DATA[getgenv().SelectedCrop]
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local heldCrop = char:FindFirstChild(cData.SeedName)
                if not heldCrop then
                    local inBp = player.Backpack:FindFirstChild(cData.SeedName)
                    if inBp then
                        hum:EquipTool(inBp)
                        task.wait(0.25)
                    else
                        warn("Batal tanam manual: Bibit tidak ada di tangan/tas!")
                        return
                    end
                end
            end
            
            local pos = char.HumanoidRootPart.Position
            local rs = game:GetService("ReplicatedStorage")
            for i = 1, amount do
                pcall(function() rs.Remotes.TutorialRemotes.PlantCrop:FireServer(pos) end)
                task.wait(0.25)
            end
        end)
    end
})

TabFarming:CreateButtonRow({
    Name = "3. Sell All",
    ButtonText = "Jual",
    Callback = function()
        task.spawn(function()
            pcall(function()
                local cData = CROP_DATA[getgenv().SelectedCrop]
                local rs = game:GetService("ReplicatedStorage")
                local sellAmt = 15 -- Harga default tebak
                
                -- Sadap data inventaris
                local inv = rs.Remotes.TutorialRemotes.RequestSell:InvokeServer("GET_LIST")
                if typeof(inv) == "table" and typeof(inv.Items) == "table" then
                    for _, itemData in pairs(inv.Items) do
                        if typeof(itemData) == "table" and (itemData.Name == getgenv().SelectedCrop or itemData.DisplayName == cData.EnglishName) then
                            sellAmt = tonumber(itemData.Owned) or sellAmt
                            break
                        end
                    end
                end
                
                if sellAmt > 0 then
                    rs.Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", getgenv().SelectedCrop, sellAmt)
                else
                    warn("Inventaris kosong atau GET_LIST gagal dilacak!")
                end
            end)
        end)
    end
})

-- (AFK Mode dipindah ke atas)

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
