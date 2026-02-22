-- ==========================================
-- SKENA HUB : +1 Skill Point Legend
-- Game ID: 135668295983945
-- ==========================================
-- Info Game:
--   Mob ada di Workspace.Npcs (Model, nama numerik)
--   Mob punya HumanoidRootPart (bisa TP)
--   Mob TIDAK pakai Humanoid (HP server-side via ByteNet)
--   Attack = client-side click simulation

local SkenaUI_LibURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua"
local cacheBuster = "?t=" .. tostring(os.time())
local SkenaUI = loadstring(game:HttpGet(SkenaUI_LibURL .. cacheBuster, true))()

local Players = game:GetService("Players")
local VIM = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer

-- ==========================================
-- BUAT WINDOW
-- ==========================================
local Window = SkenaUI.CreateWindow("SkenaHub", "+1 Skill Point Legend", false)
local TabMain = Window:CreateTab("Main", "zap", false)
local TabBoss = Window:CreateTab("Bosses", "map-pin", false)
local TabSettings = Window:CreateTab("Settings", "settings", true)

-- Kill phantom loops
pcall(function()
    if getgenv()._SKENA_SPL_LOOPS then
        for _, flag in pairs(getgenv()._SKENA_SPL_LOOPS) do
            getgenv()[flag] = false
        end
    end
end)
getgenv()._SKENA_SPL_LOOPS = {}

local function RegisterLoop(flagName)
    getgenv()[flagName] = false
    table.insert(getgenv()._SKENA_SPL_LOOPS, flagName)
end

-- ==========================================
-- HELPER: Find closest mob
-- ==========================================
local function getClosestMob()
    local npcsFolder = workspace:FindFirstChild("Npcs")
    if not npcsFolder then return nil end
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = math.huge
    
    for _, mob in ipairs(npcsFolder:GetChildren()) do
        if mob:IsA("Model") then
            local mobHRP = mob:FindFirstChild("HumanoidRootPart")
            if mobHRP then
                local dist = (hrp.Position - mobHRP.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = mob
                end
            end
        end
    end
    
    return closest, closestDist
end

-- ==========================================
-- HELPER: Simulate attack click
-- ==========================================
local function simulateAttack()
    pcall(function()
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end)
end

-- ==========================================
-- STATUS
-- ==========================================
local npcsFolder = workspace:FindFirstChild("Npcs")
TabMain:CreateTextRow({
    Text = npcsFolder 
        and ("✅ Npcs ditemukan (" .. #npcsFolder:GetChildren() .. " mob)")
        or "❌ Folder Npcs tidak ditemukan!"
})

-- ==========================================
-- TAB MAIN
-- ==========================================

-- 1. Auto Farm (TP ke mob terdekat + auto attack)
RegisterLoop("_SKENA_AUTO_FARM")
TabMain:CreateToggleRow({
    Name = "Auto Farm (TP + Attack)",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_FARM = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_FARM do
                    local mob, dist = getClosestMob()
                    if mob then
                        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                        local char = player.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if mobHRP and hrp then
                            -- Teleport ke mob jika jauh
                            if dist > 10 then
                                hrp.CFrame = mobHRP.CFrame * CFrame.new(0, 0, 3)
                                task.wait(0.2)
                            end
                            -- Attack
                            simulateAttack()
                        end
                    end
                    task.wait(0.15)
                end
            end)
        end
    end
})

-- 2. Auto Attack Only (tanpa TP)
RegisterLoop("_SKENA_AUTO_ATTACK")
TabMain:CreateToggleRow({
    Name = "Auto Attack (No TP)",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_ATTACK = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_ATTACK do
                    simulateAttack()
                    task.wait(0.15)
                end
            end)
        end
    end
})

-- 3. Auto Teleport Only (tanpa attack)
RegisterLoop("_SKENA_AUTO_TP_MOB")
TabMain:CreateToggleRow({
    Name = "Auto TP to Nearest Mob",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_TP_MOB = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_TP_MOB do
                    local mob, dist = getClosestMob()
                    if mob and dist > 10 then
                        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if mobHRP and hrp then
                            hrp.CFrame = mobHRP.CFrame * CFrame.new(0, 0, 3)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
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

TabMain:CreateToggleRow({
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
-- TAB BOSSES (TP via Gate system)
-- ==========================================
TabBoss:CreateTextRow({
    Text = "Teleport ke boss lewat Gates di Workspace.Gates"
})

local function createBossTP(name, gatePath)
    TabBoss:CreateButtonRow({
        Name = name,
        ButtonText = "TP",
        Callback = function()
            pcall(function()
                local gate = workspace
                for _, part in ipairs(string.split(gatePath, ".")) do
                    gate = gate:FindFirstChild(part)
                    if not gate then break end
                end
                if gate then
                    local target = gate:FindFirstChild("HumanoidRootPart") or gate:FindFirstChild("Portal") or gate.PrimaryPart or (gate:IsA("BasePart") and gate)
                    if not target then
                        -- Cari BasePart pertama
                        for _, ch in ipairs(gate:GetDescendants()) do
                            if ch:IsA("BasePart") then target = ch break end
                        end
                    end
                    if target then
                        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = target.CFrame * CFrame.new(0, 3, 0)
                            warn("[TP] Teleported to " .. name)
                        end
                    else
                        warn("[TP] Target part tidak ditemukan di " .. gatePath)
                    end
                else
                    warn("[TP] Gate tidak ditemukan: " .. gatePath)
                end
            end)
        end
    })
end

-- Gate-based TP (dari Workspace.Gates)
createBossTP("Grassland (Spawn)", "Gates.Grassland")

-- Scan gates otomatis
pcall(function()
    local gatesFolder = workspace:FindFirstChild("Gates")
    if gatesFolder then
        for _, gate in ipairs(gatesFolder:GetChildren()) do
            if gate.Name ~= "Grassland" then -- Skip spawn karena sudah di atas
                createBossTP(gate.Name, "Gates." .. gate.Name)
            end
        end
    end
end)

-- ==========================================
-- TAB SETTINGS
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

-- ==========================================
-- ATTACH ADMIN MODULE
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
