local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer

-- ==========================================
-- CLEANUP OLD MEMORY
-- ==========================================
pcall(function()
    getgenv().SkenaAutoFarm_Jagung = false
    getgenv().SkenaAutoFarm_Crop = false
    getgenv().SkenaAutoFarm_Egg = false
    getgenv()._SKENA_CALIBRATING = false
end)

-- ==========================================
-- INIT SKENA UI
-- ==========================================
local SkenaUI_Loaded = false
local SkenaUI
pcall(function()
    local cacheBuster = "?t=" .. tostring(os.time())
    SkenaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua" .. cacheBuster))()
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

local TabAutoFarm1 = Window:CreateTab("Auto Farm 1", "wheat") 
local TabAutoFarm2 = Window:CreateTab("Auto Farm 2", "egg") 
local TabFarming = Window:CreateTab("Farming", "shovel") 
local TabSettings = Window:CreateTab("Settings", "settings", true) 

-- ==========================================
-- GLOBAL SETTINGS & CROP DATA 
-- ==========================================
getgenv().AFK_PlantAmount = 15
getgenv().AFK_HarvestDelay = 60
getgenv().SelectedCrop = "Padi"

local CROP_DATA = {
    ["Padi"]       = { SeedName = "Bibit Padi",       EnglishName = "Rice" },
    ["Jagung"]     = { SeedName = "Bibit Jagung",     EnglishName = "Corn" },
    ["Tomat"]      = { SeedName = "Bibit Tomat",      EnglishName = "Tomato" },
    ["Terong"]     = { SeedName = "Bibit Terong",     EnglishName = "Eggplant" },
    ["Strawberry"] = { SeedName = "Bibit Strawberry", EnglishName = "Strawberry" }
}

local CROP_ORDER = {
    { key = "Padi",       label = "Padi [lv. 0]" },
    { key = "Jagung",     label = "Jagung [lv. 20]" },
    { key = "Tomat",      label = "Tomat [lv. 40]" },
    { key = "Terong",     label = "Terong [lv. 60]" },
    { key = "Strawberry", label = "Strawberry [lv. 80]" },
}

local function UpdateSelectedCrop(val)
    for _, entry in ipairs(CROP_ORDER) do
        if entry.label == val or entry.key == val then
            getgenv().SelectedCrop = entry.key
            warn("Terpilih Tanaman target: " .. entry.key)
            return
        end
    end
    getgenv().SelectedCrop = val
end

local function GetCropInventoryCount(itemName)
    local count = 0
    local rs = game:GetService("ReplicatedStorage")
    pcall(function()
        local inv = rs.Remotes.TutorialRemotes.RequestSell:InvokeServer("GET_LIST")
        if typeof(inv) == "table" and typeof(inv.Items) == "table" then
            for _, itemData in pairs(inv.Items) do
                if typeof(itemData) == "table" and tonumber(itemData.Owned) then
                    local name = itemData.Name or itemData.DisplayName
                    if string.find(string.lower(name), string.lower(itemName)) then
                        count = count + tonumber(itemData.Owned)
                    end
                end
            end
        end
    end)
    return count
end

local function SellTargetCrop(cropKey)
    local rs = game:GetService("ReplicatedStorage")
    local remotes = rs.Remotes.TutorialRemotes
    local totalSold = 0
    local cData = CROP_DATA[cropKey]
    if not cData then return 0 end

    pcall(function()
        local inv = remotes.RequestSell:InvokeServer("GET_LIST")
        if typeof(inv) == "table" and typeof(inv.Items) == "table" then
            for _, itemData in pairs(inv.Items) do
                if typeof(itemData) == "table" and tonumber(itemData.Owned) and tonumber(itemData.Owned) > 0 then
                    local name = itemData.Name or itemData.DisplayName
                    if string.find(string.lower(name), string.lower(cData.EnglishName)) or string.find(string.lower(name), string.lower(cropKey)) then
                        local amt = tonumber(itemData.Owned)
                        pcall(function()
                            remotes.RequestSell:InvokeServer("SELL", name, amt)
                        end)
                        totalSold = totalSold + amt
                        task.wait(0.3)
                    end
                end
            end
        end
    end)
    return totalSold
end

-- ==========================================
-- HUD TRACKER (BOTTOM RIGHT)
-- ==========================================
local function CreateTracker()
    pcall(function()
        if game.CoreGui:FindFirstChild("SkenaAFKHUD") then game.CoreGui.SkenaAFKHUD:Destroy() end
        if player.PlayerGui:FindFirstChild("SkenaAFKHUD") then player.PlayerGui.SkenaAFKHUD:Destroy() end
    end)
    local sg = Instance.new("ScreenGui")
    sg.Name = "SkenaAFKHUD"
    if not pcall(function() sg.Parent = game:GetService("CoreGui") end) then
        sg.Parent = player.PlayerGui
    end

    local frm = Instance.new("Frame", sg)
    frm.Size = UDim2.new(0, 220, 0, 95)
    frm.Position = UDim2.new(1, -240, 1, -120)
    frm.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
    Instance.new("UICorner", frm).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", frm)
    stroke.Thickness = 1
    stroke.Color = Color3.fromRGB(60, 60, 60)

    local lblTitle = Instance.new("TextLabel", frm)
    lblTitle.Size = UDim2.new(1, 0, 0, 22)
    lblTitle.BackgroundTransparency = 1
    lblTitle.Text = "  [AFK Tracker]"
    lblTitle.Font = Enum.Font.GothamBold
    lblTitle.TextColor3 = Color3.new(1,1,1)
    lblTitle.TextSize = 13
    lblTitle.TextXAlignment = Enum.TextXAlignment.Left

    local lblStat = Instance.new("TextLabel", frm)
    lblStat.Size = UDim2.new(1, -16, 0, 18)
    lblStat.Position = UDim2.new(0, 8, 0, 30)
    lblStat.BackgroundTransparency = 1
    lblStat.Text = "Prog: -"
    lblStat.Font = Enum.Font.GothamMedium
    lblStat.TextColor3 = Color3.fromRGB(200, 200, 200)
    lblStat.TextSize = 12
    lblStat.TextXAlignment = Enum.TextXAlignment.Left

    local lblNext = Instance.new("TextLabel", frm)
    lblNext.Size = UDim2.new(1, -16, 0, 18)
    lblNext.Position = UDim2.new(0, 8, 0, 50)
    lblNext.BackgroundTransparency = 1
    lblNext.Text = "Next: -"
    lblNext.Font = Enum.Font.Gotham
    lblNext.TextColor3 = Color3.fromRGB(150, 150, 150)
    lblNext.TextSize = 11
    lblNext.TextXAlignment = Enum.TextXAlignment.Left

    local lblTime = Instance.new("TextLabel", frm)
    lblTime.Size = UDim2.new(1, -16, 0, 18)
    lblTime.Position = UDim2.new(0, 8, 0, 70)
    lblTime.BackgroundTransparency = 1
    lblTime.Text = "Wait: -"
    lblTime.Font = Enum.Font.GothamBold
    lblTime.TextColor3 = Color3.fromRGB(80, 255, 120)
    lblTime.TextSize = 12
    lblTime.TextXAlignment = Enum.TextXAlignment.Left

    frm.Visible = false
    getgenv().SkenaTracker = {
        Update = function(prog, nxt, tleft)
            frm.Visible = true
            lblStat.Text = "Prog: " .. tostring(prog)
            lblNext.Text = "Next: " .. tostring(nxt)
            lblTime.Text = "Wait: " .. tostring(tleft)
        end,
        Hide = function() frm.Visible = false end
    }
end
CreateTracker()

local function TUpdate(a,b,c) if getgenv().SkenaTracker then getgenv().SkenaTracker.Update(a,b,c) end end

-- Helper loop robust tanam untuk auto farm 1 dan 2
local function DoPlantCrops(isEggLoop)
    local rs = game:GetService("ReplicatedStorage")
    local cData = CROP_DATA[getgenv().SelectedCrop]
    local plotSize = getgenv().AFK_PlantAmount or 15
    local currentSeeds = 0

    local function getCount(parent)
        for _, v in ipairs(parent:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, cData.SeedName) then
                local amt = 1
                local match = string.match(v.Name, "%d+")
                if match then amt = tonumber(match) end
                for _, child in ipairs(v:GetChildren()) do
                    if (child:IsA("IntValue") or child:IsA("NumberValue")) and string.find(string.lower(child.Name), "amount") then
                        amt = child.Value
                    end
                end
                currentSeeds = currentSeeds + amt
            end
        end
    end
    
    local char = player.Character
    if char then getCount(char) end
    getCount(player.Backpack)
    
    if getgenv().AutoBuySeed and currentSeeds < 15 then
        if not isEggLoop then TUpdate("Membeli Bibit ("..cData.SeedName..")", "Equip & Tanam", "1s") end
        pcall(function() rs.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", cData.SeedName, plotSize) end)
        task.wait(1)
    end
    
    if not isEggLoop then TUpdate("Equip & Tanam ("..plotSize.."x)", "Menunggu Panen", "Proses...") end
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local function getTool(parent)
            for _, v in ipairs(parent:GetChildren()) do
                if v:IsA("Tool") and string.find(v.Name, cData.SeedName) then return v end
            end
            return nil
        end
        
        if hum then
            local heldCrop = getTool(char)
            if not heldCrop then
                hum:UnequipTools()
                task.wait(0.2)
                local inBp = getTool(player.Backpack)
                if inBp then hum:EquipTool(inBp) task.wait(0.4) end
            end
            if not getTool(char) then
                local recheckBp = getTool(player.Backpack)
                if recheckBp then
                    hum:UnequipTools()
                    task.wait(0.2)
                    hum:EquipTool(recheckBp)
                    task.wait(0.4)
                end
            end
        end
        
        if not getTool(char) then
            warn("Batal tanam putaran ini karena bibit target (" .. cData.SeedName .. ") gagal dipegang!")
            task.wait(2)
        else
            local startPos = char.HumanoidRootPart.Position
            for i = 1, plotSize do
                if isEggLoop and not getgenv().SkenaAutoFarm_Egg then return end
                if not isEggLoop and not getgenv().SkenaAutoFarm_Crop then return end
                local angle = math.rad(math.random(0, 360))
                local dist = 0.5 + math.random() * 1.5
                local offset = Vector3.new(math.cos(angle) * dist, 0, math.sin(angle) * dist)
                local pos = startPos + offset
                pcall(function() rs.Remotes.TutorialRemotes.PlantCrop:FireServer(pos) end)
                task.wait(0.6)
            end
        end
    else
        warn("Karakter tidak ditemukan! Tanam ditunda.")
        task.wait(2)
    end
end

-- ==========================================
-- AUTO FARM 1 (TANAMAN ONLY)
-- ==========================================
getgenv().SkenaAutoFarm_Crop = false
getgenv().AutoBuySeed = true

TabAutoFarm1:CreateToggleRow({
    Name = "Auto Farm 1",
    HasSubToggle = true,
    SubToggleName = "Auto Beli",
    SubToggleDefault = true,
    OnSubToggle = function(state) getgenv().AutoBuySeed = state end,
    OnToggle = function(state)
        getgenv().SkenaAutoFarm_Crop = state
        if not state and getgenv().SkenaTracker then getgenv().SkenaTracker.Hide() end
        
        if state then
            task.spawn(function()
                while getgenv().SkenaAutoFarm_Crop do
                    local plotSize = getgenv().AFK_PlantAmount or 15

                    -- 1. Beli, Equip, Tanam
                    DoPlantCrops(false)
                    
                    -- 2. Menunggu (Waktu Tanaman Tumbuh & Auto-Harvest Game)
                    local hDelay = getgenv().AFK_HarvestDelay or 60
                    for hw = hDelay, 1, -1 do
                        if not getgenv().SkenaAutoFarm_Crop then return end
                        TUpdate("Menunggu Tumbuh", "Interact Panen", hw .. "s")
                        task.wait(1)
                    end
                    task.wait(1.5)
                    
                    -- 3. Interact 15x untuk Harvest
                    TUpdate("Memanen (Interact) " .. plotSize .. "x", "Jual Target", "Proses...")
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        for i = 1, plotSize do
                            if not getgenv().SkenaAutoFarm_Crop then return end
                            local hrpPos = char.HumanoidRootPart.Position
                            local interacted = false
                            for _, v in ipairs(workspace:GetDescendants()) do
                                if v:IsA("ProximityPrompt") and v.Parent and v.Parent:IsA("BasePart") then
                                    local dist = (v.Parent.Position - hrpPos).Magnitude
                                    if dist <= 3.5 then -- Fuzzy 2 stud
                                        if fireproximityprompt then fireproximityprompt(v) else v:InputHoldBegin() task.wait(0.1) v:InputHoldEnd() end
                                        interacted = true
                                        break
                                    end
                                end
                            end
                            if interacted then task.wait(0.6) else task.wait(0.5) end
                        end
                    end
                    task.wait(1.5)

                    -- 4. Jual Pintar (Hanya target tanaman)
                    TUpdate("Menjual Target Tanaman", "Restart Loop", "Proses...")
                    local totalSold = SellTargetCrop(getgenv().SelectedCrop)
                    if totalSold > 0 then
                        warn("[Sell Target] Berhasil jual " .. totalSold .. " item")
                    end
                    task.wait(1.5)
                end
            end)
        end
    end
})

local CropDropAF1 = TabAutoFarm1:CreateDropdown({
    Name = " Target Tanaman",
    Callback = function(val) UpdateSelectedCrop(val) end
})
for _, entry in ipairs(CROP_ORDER) do CropDropAF1:AddItem(entry.label, entry.key == "Padi") end

TabAutoFarm1:CreateInputRow({
    Name = " Jumlah Tanam per Loop",
    Placeholder = "15",
    Default = "15",
    Callback = function(val) getgenv().AFK_PlantAmount = tonumber(val) or 15 end
})

TabAutoFarm1:CreateInputRow({
    Name = " Waktu Tunggu / Panen (Detik)",
    Placeholder = "60",
    Default = "60",
    Callback = function(val) getgenv().AFK_HarvestDelay = tonumber(val) or 60 end
})

TabAutoFarm1:CreateTextRow({
    Text = "Step: Atur Target Tanaman, lalu nyalakan Auto Farm 1. Loop menanam target, interaksi 15x untuk harvest, dan menjual target otomatis.\nEstimasi Waktu Farm:\n- Padi: 90 detik\n- Sawit: 270 detik"
})

-- ==========================================
-- AUTO FARM 2 (TELUR + TANAMAN) PREPARATION
-- ==========================================
getgenv().SkenaAutoFarm_Egg = false

TabAutoFarm2:CreateToggleRow({
    Name = "Auto Farm 2 (Telur + Tanaman)",
    OnToggle = function(state)
        getgenv().SkenaAutoFarm_Egg = state
        if not state and getgenv().SkenaTracker then getgenv().SkenaTracker.Hide() end
        if state then
            -- Loop Tanaman (Jalan Paralel agar tidak terblokir jeda telur)
            task.spawn(function()
                while getgenv().SkenaAutoFarm_Egg do
                    local plotSize = getgenv().AFK_PlantAmount or 15
                    DoPlantCrops(true)
                    
                    local hDelay = getgenv().AFK_HarvestDelay or 60
                    for hw = hDelay, 1, -1 do
                        if not getgenv().SkenaAutoFarm_Egg then return end
                        task.wait(1)
                    end
                    task.wait(1.5)
                    
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        for i = 1, plotSize do
                            if not getgenv().SkenaAutoFarm_Egg then return end
                            local hrpPos = char.HumanoidRootPart.Position
                            for _, v in ipairs(workspace:GetDescendants()) do
                                if v:IsA("ProximityPrompt") and v.Parent and v.Parent:IsA("BasePart") then
                                    if (v.Parent.Position - hrpPos).Magnitude <= 3.5 then
                                        if fireproximityprompt then fireproximityprompt(v) else v:InputHoldBegin() task.wait(0.1) v:InputHoldEnd() end
                                        break
                                    end
                                end
                            end
                            task.wait(0.6)
                        end
                    end
                    task.wait(1.5)
                    SellTargetCrop(getgenv().SelectedCrop)
                    task.wait(1.5)
                end
            end)

            -- Loop Telur (Main Loop yg update tracker Auto Farm 2)
            task.spawn(function()
                while getgenv().SkenaAutoFarm_Egg do
                    local isLevel100 = true -- Placeholder Cek Level Asli
                    if not isLevel100 then
                        TUpdate("Level Kurang (100)", "Farm Dibatalkan", "-")
                        warn("[Auto Farm 2] Harus level 100 untuk Egg Farm!")
                        getgenv().SkenaAutoFarm_Egg = false
                        break
                    end

                    TUpdate("Mengecek 5 Padi", "Memberi Makan", "Cek Tas...")
                    local padiCount = GetCropInventoryCount("Rice")
                    if padiCount < 5 then
                        warn("[Auto Farm 2] Padi kurang dari 5 (Punya " .. padiCount .. "). Menunggu pertanian paralel selesai...")
                        task.wait(5)
                    else
                        TUpdate("Memberi Makan Ayam", "Menunggu Panen Telur", "Proses...")
                        warn("[Auto Farm 2] Remote: Feed Chicken (Placeholder)")
                        -- pcall(function() end)
                        task.wait(2)
                        
                        -- Wait 915s
                        local eggWait = 915
                        for ew = eggWait, 1, -1 do
                            if not getgenv().SkenaAutoFarm_Egg then return end
                            TUpdate("Menunggu Panen Telur", "Panen Telur", ew .. "s")
                            task.wait(1)
                        end
                        
                        TUpdate("Memanen Telur", "Menjual Telur", "Proses...")
                        warn("[Auto Farm 2] Memanen Telur (Placeholder)")
                        -- pcall(function() end)
                        task.wait(2)

                        TUpdate("Menjual Telur", "Restart Egg Loop", "Proses...")
                        warn("[Auto Farm 2] Menjual Telur (Placeholder)")
                        -- pcall(function() end)
                        task.wait(2)
                    end
                end
            end)
        end
    end
})

TabAutoFarm2:CreateTextRow({
    Text = "Draft Auto Farm 2: Menyelesaikan auto farm tanaman di background secara terus menerus, sambil mengecek Padi >= 5 untuk memberi makan ayam dan memanen telur dengan jeda siklus 15 menit."
})

-- ==========================================
-- MANUAL FARMING TAB
-- ==========================================
TabFarming:CreateInputButtonRow({
    Name = "Beli Bibit",
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

local CropDropManual = TabFarming:CreateDropdown({
    Name = " Target Tanaman",
    Callback = function(val) UpdateSelectedCrop(val) end
})
for _, entry in ipairs(CROP_ORDER) do CropDropManual:AddItem(entry.label, entry.key == "Padi") end

TabFarming:CreateButtonRow({
    Name = "Sell all target tanaman",
    ButtonText = "Jual",
    Callback = function()
        task.spawn(function()
            local totalSold = SellTargetCrop(getgenv().SelectedCrop)
            if totalSold > 0 then
                warn("[Sell Target] Berhasil jual " .. totalSold .. " item")
            else
                warn("[Sell Target] Inventaris target crop (" .. getgenv().SelectedCrop .. ") kosong.")
            end
        end)
    end
})

getgenv().SkenaNoDelayInteract = true
task.spawn(function()
    while getgenv().SkenaNoDelayInteract do
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.HoldDuration > 0 then
                v.HoldDuration = 0
            end
        end
        task.wait(1)
    end
end)

TabFarming:CreateToggleRow({
    Name = "Fast Interact (No Hold E)",
    Default = true,
    OnToggle = function(state)
        getgenv().SkenaNoDelayInteract = state
        if state then
            task.spawn(function()
                while getgenv().SkenaNoDelayInteract do
                    for _, v in ipairs(workspace:GetDescendants()) do
                        if v:IsA("ProximityPrompt") and v.HoldDuration > 0 then
                            v.HoldDuration = 0
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- ==========================================
-- ISI TAB SETTINGS
-- ==========================================
TabSettings:CreateTextRow({
    Text = getgenv()._SKENA_ANTI_AFK and "🟢 Anti-AFK Active" or "🔴 Anti-AFK Failed"
})

TabSettings:CreateInputRow({
    Name = "UI Toggle Key",
    Placeholder = "Z",
    Default = "Z",
    Callback = function(keyStr)
        Window:SetToggleKey(keyStr)
    end
})

task.spawn(function()
    local succ, SkenaAdmin = pcall(function()
        local adminCacheBuster = "?t=" .. tostring(os.time())
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Admin.lua" .. adminCacheBuster))()
    end)
    if succ and SkenaAdmin then
        SkenaAdmin.Attach(Window, {})
    end
end)
