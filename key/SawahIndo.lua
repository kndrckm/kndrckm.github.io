local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer

-- ==========================================
-- CLEANUP OLD MEMORY (BUNUH PHANTOM LOOP)
-- ==========================================
pcall(function()
    getgenv().SkenaAutoFarm_Jagung = false
    getgenv().SkenaAutoFarm_Crop = false
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

local TabFarming = Window:CreateTab("Farming", "wheat") 
local TabSettings = Window:CreateTab("Settings", "settings", true) 

-- ==========================================
-- CROP DATA REFERENCE
-- ==========================================
local CROP_DATA = {
    ["Padi"]   = { SeedName = "Bibit Padi",   EnglishName = "Rice" },
    ["Jagung"] = { SeedName = "Bibit Jagung", EnglishName = "Corn" },
    ["Tomat"]  = { SeedName = "Bibit Tomat",  EnglishName = "Tomato" },
    ["Terong"] = { SeedName = "Bibit Terong", EnglishName = "Eggplant" }
}
getgenv().SelectedCrop = "Padi"

local CROP_ORDER = {
    { key = "Padi",   label = "Padi [lv. 0]" },
    { key = "Jagung", label = "Jagung [lv. 20]" },
    { key = "Tomat",  label = "Tomat [lv. 40]" },
    { key = "Terong", label = "Terong [lv. 60]" },
}

local CropDrop = TabFarming:CreateDropdown({
    Name = " [ Target Tanaman (Global) ]",
    Callback = function(val)
        -- Map label kembali ke key (e.g. "Padi [lv. 0]" -> "Padi")
        for _, entry in ipairs(CROP_ORDER) do
            if entry.label == val then
                getgenv().SelectedCrop = entry.key
                warn("Terpilih Tanaman: " .. entry.key)
                return
            end
        end
        getgenv().SelectedCrop = val
    end
})
for _, entry in ipairs(CROP_ORDER) do
    CropDrop:AddItem(entry.label, entry.key == "Padi")
end

-- ==========================================
-- SETTINGS BATCH & DELAY
-- ==========================================
getgenv().AFK_PlantAmount = 15
getgenv().AFK_HarvestDelay = 60

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
    Placeholder = "60",
    Default = "60",
    Callback = function(val)
        getgenv().AFK_HarvestDelay = tonumber(val) or 60
    end
})

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
        if not state and getgenv().SkenaTracker then getgenv().SkenaTracker.Hide() end
        
        if state then
            task.spawn(function()
                local rs = game:GetService("ReplicatedStorage")
                while getgenv().SkenaAutoFarm_Crop do
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
                    
                    -- 1. Beli Bibit (hanya jika stok < 15)
                    if getgenv().AutoBuySeed and currentSeeds < 15 then
                        TUpdate("Membeli Bibit ("..cData.SeedName..")", "Equip & Tanam", "1s")
                        pcall(function() rs.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", cData.SeedName, plotSize) end)
                        task.wait(1)
                    end
                    
                    -- 2. Tanam Berulang
                    TUpdate("Equip & Tanam ("..plotSize.."x)", "Menunggu Panen", "Proses...")
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
                                if inBp then
                                    hum:EquipTool(inBp)
                                    task.wait(0.4)
                                end
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
                                if not getgenv().SkenaAutoFarm_Crop then return end
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
                    
                    -- 3. Menunggu (Waktu Tanaman Tumbuh & Auto-Harvest Game)
                    local hDelay = getgenv().AFK_HarvestDelay or 300
                    for hw = hDelay, 1, -1 do
                        if not getgenv().SkenaAutoFarm_Crop then return end
                        TUpdate("Menunggu Panenan Game", "Jual Hasil", hw .. "s")
                        task.wait(1)
                    end
                    task.wait(1.5)
                    
                    -- 4. Jual Pintar
                    TUpdate("Menganalisa Tas (Jual)", "Restart Loop", "Proses...")
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

TabFarming:CreateButtonRow({
    Name = "2. Sell All",
    ButtonText = "Jual",
    Callback = function()
        task.spawn(function()
            pcall(function()
                local cData = CROP_DATA[getgenv().SelectedCrop]
                local rs = game:GetService("ReplicatedStorage")
                local sellAmt = 15
                
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

-- Fast Interact (Default ON)
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
        local adminCacheBuster = "?t=" .. tostring(os.time())
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Admin.lua" .. adminCacheBuster))()
    end)
    if succ and SkenaAdmin then
        SkenaAdmin.Attach(Window, {})
    end
end)
