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
-- MOB LIST (dari referensi game)
-- ==========================================
local MOB_LIST = {
    { name = "Pig",             hp = "800" },
    { name = "Turtle",          hp = "2.5k" },
    { name = "Caveman",         hp = "4.5k" },
    { name = "Spider",          hp = "25k" },
    { name = "Mammoth",         hp = "75k" },
    { name = "Warlock",         hp = "100k" },
    { name = "Spartan",         hp = "250k" },
    { name = "Reaper",          hp = "750k" },
    { name = "Angel",           hp = "1.5m" },
    { name = "Cowboy",          hp = "15m" },
    { name = "Ghost",           hp = "60m" },
    { name = "Totem Sentinel",  hp = "250m" },
    { name = "Mummy",           hp = "500m" },
    { name = "Blightleap",      hp = "2.5b" },
    { name = "Bonepicker",      hp = "25b" },
    { name = "Oculon",          hp = "100b" },
    { name = "Magmaton",        hp = "600b" },
}

local MOB_LABELS = {}
for _, m in ipairs(MOB_LIST) do
    table.insert(MOB_LABELS, { key = m.name, label = m.name .. " [" .. m.hp .. "]" })
end
getgenv().SelectedMob = MOB_LIST[1].name

-- ==========================================
-- TAB MAIN
-- ==========================================

-- Dropdown: Target Mob
local MobDrop = TabMain:CreateDropdown({
    Name = " [ Target Mob ]",
    Callback = function(val)
        for _, entry in ipairs(MOB_LABELS) do
            if entry.label == val then
                getgenv().SelectedMob = entry.key
                warn("Target Mob: " .. entry.key)
                return
            end
        end
        getgenv().SelectedMob = val
    end
})
for _, entry in ipairs(MOB_LABELS) do
    MobDrop:AddItem(entry.label, entry.key == MOB_LIST[1].name)
end

-- Auto TP to Selected Mob
RegisterLoop("_SKENA_AUTO_TP_MOB")
TabMain:CreateToggleRow({
    Name = "Auto TP to Mob",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_TP_MOB = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_TP_MOB do
                    local mob, dist = getClosestMob()
                    if mob then
                        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if mobHRP and hrp and dist > 10 then
                            hrp.CFrame = mobHRP.CFrame * CFrame.new(0, 0, 3)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- Auto Attack
RegisterLoop("_SKENA_AUTO_ATTACK")
TabMain:CreateToggleRow({
    Name = "Auto Attack",
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
