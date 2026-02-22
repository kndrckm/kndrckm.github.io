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
-- HELPER: Find closest mob (filter by parts fingerprint)
-- ==========================================
local function getClosestMob(targetParts)
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
                -- Filter by parts count if specified
                if targetParts then
                    local parts = #mob:GetDescendants()
                    if parts ~= targetParts then continue end
                end
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
-- STATUS
-- ==========================================
local npcsFolder = workspace:FindFirstChild("Npcs")
TabMain:CreateTextRow({
    Text = npcsFolder 
        and ("✅ Npcs ditemukan (" .. #npcsFolder:GetChildren() .. " mob)")
        or "❌ Folder Npcs tidak ditemukan!"
})

-- ==========================================
-- MOB LIST (fingerprinted by parts count)
-- ==========================================
local MOB_LIST = {
    { name = "Pig",             hp = "800",    parts = 109 },
    { name = "Turtle",          hp = "2.5k",   parts = 157 },
    { name = "Caveman",         hp = "4.5k",   parts = 311 },
    { name = "Spider",          hp = "12.5k",  parts = 107 },
    { name = "Mammoth",         hp = "75k",    parts = 141 },
    { name = "Viperbloom",      hp = "125k",   parts = 255 },
    { name = "Warlock",         hp = "100k",   parts = nil }, -- belum diketahui
    { name = "Spartan",         hp = "250k",   parts = nil },
    { name = "Reaper",          hp = "750k",   parts = nil },
    { name = "Angel",           hp = "1.5m",   parts = nil },
    { name = "Cowboy",          hp = "15m",    parts = nil },
    { name = "Ghost",           hp = "60m",    parts = nil },
    { name = "Totem Sentinel",  hp = "250m",   parts = nil },
    { name = "Mummy",           hp = "500m",   parts = nil },
    { name = "Blightleap",      hp = "2.5b",   parts = nil },
    { name = "Bonepicker",      hp = "25b",    parts = nil },
    { name = "Oculon",          hp = "100b",   parts = nil },
    { name = "Magmaton",        hp = "600b",   parts = nil },
}

local BOSS_LIST = {
    { name = "Dino",       hp = "250k",  parts = 267 },
    { name = "Arachenex",  hp = "450k",  parts = 144 },
    { name = "Grimroot",   hp = "950k",  parts = 497 },
    { name = "Minotaur",   hp = "30b",   parts = 263 },
}

-- Build fingerprint lookup: parts -> mob name
local PARTS_TO_NAME = {}
for _, m in ipairs(MOB_LIST) do
    if m.parts then PARTS_TO_NAME[m.parts] = m.name end
end
for _, m in ipairs(BOSS_LIST) do
    if m.parts then PARTS_TO_NAME[m.parts] = m.name .. " (Boss)" end
end

-- Only show mobs with known fingerprints in Target Mob dropdown
local MOB_LABELS = {}
for _, m in ipairs(MOB_LIST) do
    if m.parts then
        table.insert(MOB_LABELS, { key = m.name, parts = m.parts, label = m.name .. " [" .. m.hp .. "]" })
    end
end
getgenv().SelectedMob = MOB_LABELS[1] and MOB_LABELS[1].key or "Pig"
getgenv().SelectedMobParts = MOB_LABELS[1] and MOB_LABELS[1].parts or nil

-- ==========================================
-- TAB MAIN
-- ==========================================

-- Dropdown: Target Mob (hanya yang sudah di-mapping)
local MobDrop = TabMain:CreateDropdown({
    Name = " [ Target Mob ]",
    Columns = 2,
    Callback = function(val)
        for _, entry in ipairs(MOB_LABELS) do
            if entry.label == val then
                getgenv().SelectedMob = entry.key
                getgenv().SelectedMobParts = entry.parts
                warn("Target: " .. entry.key .. " (" .. entry.parts .. "p)")
                return
            end
        end
    end
})
for _, entry in ipairs(MOB_LABELS) do
    MobDrop:AddItem(entry.label, entry.key == MOB_LABELS[1].key)
end

-- Auto TP to Selected Mob (filtered by type)
RegisterLoop("_SKENA_AUTO_TP_MOB")
TabMain:CreateToggleRow({
    Name = "Auto TP to Mob",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_TP_MOB = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_TP_MOB do
                    local mob, dist = getClosestMob(getgenv().SelectedMobParts)
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

-- ==========================================
-- KILL AURA (WIP - belum terpublish method)
-- ==========================================
getgenv()._SKENA_KILL_RANGE = 55

TabMain:CreateInputRow({
    Name = "Set Range",
    Placeholder = "55",
    Default = "55",
    Callback = function(val)
        getgenv()._SKENA_KILL_RANGE = tonumber(val) or 55
    end
})

RegisterLoop("_SKENA_KILL_AURA")
TabMain:CreateToggleRow({
    Name = "Kill Aura",
    OnToggle = function(state)
        getgenv()._SKENA_KILL_AURA = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_KILL_AURA do
                    pcall(function()
                        local char = player.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if not hrp then return end
                        
                        local range = getgenv()._SKENA_KILL_RANGE or 55
                        local npcsF = workspace:FindFirstChild("Npcs")
                        if not npcsF then return end
                        
                        for _, mob in ipairs(npcsF:GetChildren()) do
                            if not getgenv()._SKENA_KILL_AURA then return end
                            if mob:IsA("Model") then
                                local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                                if mobHRP then
                                    local dist = (hrp.Position - mobHRP.Position).Magnitude
                                    if dist <= range then
                                        -- TODO: Replace with actual attack method
                                        -- Method belum diketahui, placeholder:
                                        -- Kemungkinan: ByteNet buffer, atau firetouchinterest, atau remote lain
                                        pcall(function()
                                            if firetouchinterest then
                                                firetouchinterest(hrp, mobHRP, 0)
                                                task.wait()
                                                firetouchinterest(hrp, mobHRP, 1)
                                            end
                                        end)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.2)
                end
            end)
        end
    end
})

-- ==========================================
-- IDENTIFY MOBS (Scan & TP via Dropdown)
-- Untuk temukan mob baru yang belum di-mapping
-- ==========================================
TabMain:CreateTextRow({
    Text = "── Identifikasi Mob ──"
})

local IdentifyDrop = TabMain:CreateDropdown({
    Name = " [ Scan Live Mobs ]",
    Columns = 2,
    Callback = function(val)
        -- Parse ID from label: "Pig | ID:173"
        local mobId = string.match(val, "ID:(%d+)")
        if mobId then
            local npcsF = workspace:FindFirstChild("Npcs")
            if npcsF then
                local mob = npcsF:FindFirstChild(mobId)
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        warn("[TP] " .. val)
                    end
                end
            end
        end
    end
})

TabMain:CreateButtonRow({
    Name = "Refresh Mob List",
    ButtonText = "Scan",
    Callback = function(btn)
        local npcsF = workspace:FindFirstChild("Npcs")
        if not npcsF then warn("[Scan] Folder Npcs tidak ada!") return end
        
        -- Clear existing dropdown items
        for _, data in ipairs(IdentifyDrop.Items) do
            pcall(function() data.Btn:Destroy() end)
        end
        IdentifyDrop.Items = {}
        
        local seen = {}
        local uniqueMobs = {}
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        
        for _, mob in ipairs(npcsF:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                local parts = #mob:GetDescendants()
                if not seen[parts] then
                    seen[parts] = true
                    local mobHRP = mob.HumanoidRootPart
                    local dist = hrp and math.floor((hrp.Position - mobHRP.Position).Magnitude) or 0
                    local knownName = PARTS_TO_NAME[parts] or "???"
                    table.insert(uniqueMobs, {
                        id = mob.Name,
                        parts = parts,
                        dist = dist,
                        knownName = knownName
                    })
                end
            end
        end
        
        table.sort(uniqueMobs, function(a, b) return a.dist < b.dist end)
        
        for i, m in ipairs(uniqueMobs) do
            IdentifyDrop:AddItem(m.knownName .. " | ID:" .. m.id .. " (" .. m.parts .. "p)", i == 1)
        end
        
        warn("[Scan] " .. #uniqueMobs .. " tipe mob unik.")
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
