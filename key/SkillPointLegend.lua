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
-- HELPER: Check if mob is alive
-- ==========================================
local function isMobAlive(mob)
    local ok, alive = pcall(function()
        local hrp = mob:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        if hrp.Anchored then return false end
        if hrp.Transparency >= 0.9 then return false end
        
        -- deadAnim check (wrapped safely)
        local animCtrl = mob:FindFirstChildWhichIsA("AnimationController")
        if animCtrl then
            local animator = animCtrl:FindFirstChildWhichIsA("Animator")
            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    if track.Animation and string.find(track.Animation.Name, "dead") then
                        return false
                    end
                end
            end
        end
        
        return true
    end)
    return ok and alive
end

-- ==========================================
-- HELPER: Find closest mob (filter by parts fingerprint)
-- ==========================================
local function getClosestMob(targetParts, minDist)
    local npcsFolder = workspace:FindFirstChild("Npcs")
    if not npcsFolder then return nil end
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = math.huge
    minDist = minDist or 0
    
    for _, mob in ipairs(npcsFolder:GetChildren()) do
        if mob:IsA("Model") then
            local mobHRP = mob:FindFirstChild("HumanoidRootPart")
            if mobHRP and isMobAlive(mob) then
                if targetParts then
                    local parts = #mob:GetDescendants()
                    -- targetParts can be a table of valid values
                    local match = false
                    if type(targetParts) == "table" then
                        for _, p in ipairs(targetParts) do
                            if parts == p then match = true break end
                        end
                    else
                        match = (parts == targetParts)
                    end
                    if not match then continue end
                end
                local dist = (hrp.Position - mobHRP.Position).Magnitude
                if dist >= minDist and dist < closestDist then
                    closestDist = dist
                    closest = mob
                end
            end
        end
    end
    
    return closest, closestDist
end

-- ==========================================
-- HELPER: Stepped teleport (long distance)
-- ==========================================
local function steppedTeleport(targetCFrame)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local startPos = hrp.Position
    local endPos = targetCFrame.Position
    local totalDist = (endPos - startPos).Magnitude
    
    -- Short distance: just teleport directly
    if totalDist <= 50 then
        hrp.CFrame = targetCFrame
        hrp.Velocity = Vector3.new(0, 0, 0)
        return
    end
    
    -- Long distance: teleport in small steps to avoid rubber-banding
    local stepSize = 50
    local steps = math.ceil(totalDist / stepSize)
    for i = 1, steps do
        if not char or not char.Parent then return end
        local alpha = i / steps
        local pos = startPos:Lerp(endPos, alpha)
        hrp.CFrame = CFrame.new(pos)
        hrp.Velocity = Vector3.new(0, 0, 0)
        if hrp:FindFirstChild("BodyVelocity") then
            hrp.BodyVelocity:Destroy()
        end
        task.wait(0.15)
    end
    -- Final precise position
    hrp.CFrame = targetCFrame
    hrp.Velocity = Vector3.new(0, 0, 0)
end

-- ==========================================
-- WORLDS & MOB LIST (fingerprinted by parts count)
-- ==========================================
local WORLDS = {
    Grassland = Vector3.new(149.254, 12.000, 518.938),
    CursedKingdom = Vector3.new(2543.238, 84.500, -669.682)
}

local MOB_LIST = {
    -- Grassland
    { name = "Snail",           hp = "10",     parts = {116}, world = "Grassland" },
    { name = "Pig",             hp = "800",    parts = {109}, world = "Grassland" },
    { name = "Turtle",          hp = "2.5k",   parts = {157}, world = "Grassland" },
    { name = "Caveman",         hp = "4.5k",   parts = {311}, world = "Grassland" },
    { name = "Spider",          hp = "12.5k",  parts = {107}, world = "Grassland" },
    { name = "Mammoth",         hp = "75k",    parts = {141}, world = "Grassland" },
    
    -- Cursed Kingdom
    { name = "Viperbloom",      hp = "125k",   parts = {255}, world = "CursedKingdom" },
    { name = "Warlock",         hp = "100k",   parts = {162}, world = "CursedKingdom" },
    { name = "Spartan",         hp = "250k",   parts = {189, 177}, world = "CursedKingdom" },

    -- Unknown World yet
    { name = "Reaper",          hp = "750k",   parts = {120} },
    { name = "Angel",           hp = "1.5m",   parts = {133} },
    { name = "Cowboy",          hp = "15m",    parts = {171} },
    { name = "Ghost",           hp = "60m",    parts = {84} },
    { name = "Totem Sentinel",  hp = "250m",   parts = {222} },
    { name = "Mummy",           hp = "500m",   parts = {816} },
    { name = "Blightleap",      hp = "2.5b",   parts = nil },
    { name = "Bonepicker",      hp = "25b",    parts = nil },
    { name = "Oculon",          hp = "100b",   parts = nil },
    { name = "Magmaton",        hp = "600b",   parts = nil },
}

local BOSS_LIST = {
    -- Grassland Bosses
    { name = "Chief",      hp = "25k",    parts = {321}, world = "Grassland" },
    { name = "Dino",       hp = "250k",   parts = {267}, world = "Grassland" },
    { name = "Arachenex",  hp = "450k",   parts = {144, 143}, world = "Grassland" }, -- Added 143p
    
    -- Cursed Kingdom Bosses
    { name = "Grimroot",   hp = "950k",   parts = {497, 498}, world = "CursedKingdom" }, -- Added 498p
    { name = "Leonidas",   hp = "1.25m",  parts = {163, 164}, world = "CursedKingdom" },
    
    -- Unknown World
    { name = "Minotaur",        hp = "30b",    parts = {263} },
    { name = "Lightning God",   hp = "25m",    parts = {123} },
    { name = "Sand Golem",      hp = "2b",     parts = {614} },
    { name = "Hydra Worm",      hp = "4b",     parts = {355} },
}

-- Build fingerprint lookup: parts -> mob name
local PARTS_TO_NAME = {}
for _, m in ipairs(MOB_LIST) do
    if m.parts then
        for _, p in ipairs(m.parts) do PARTS_TO_NAME[p] = m.name end
    end
end
for _, m in ipairs(BOSS_LIST) do
    if m.parts then
        for _, p in ipairs(m.parts) do PARTS_TO_NAME[p] = m.name .. " (Boss)" end
    end
end

-- Only show mobs with known fingerprints in Target Mob dropdown
local MOB_LABELS = {}
for _, m in ipairs(MOB_LIST) do
    if m.parts then
        table.insert(MOB_LABELS, { key = m.name, parts = m.parts, world = m.world, label = m.name .. " [" .. m.hp .. "]" })
    end
end
getgenv().SelectedMob = MOB_LABELS[1] and MOB_LABELS[1].key or "Pig"
getgenv().SelectedMobParts = MOB_LABELS[1] and MOB_LABELS[1].parts or nil
getgenv().SelectedMobWorld = MOB_LABELS[1] and MOB_LABELS[1].world or nil

-- ==========================================
-- TAB MAIN
-- ==========================================

-- Dropdown + Toggle: Target Mob & Auto TP
local MobDrop = TabMain:CreateDropdownToggle({
    Name = " [ Target Mob ]",
    Columns = 2,
    Callback = function(val)
        for _, entry in ipairs(MOB_LABELS) do
            if entry.label == val then
                getgenv().SelectedMob = entry.key
                getgenv().SelectedMobParts = entry.parts
                getgenv().SelectedMobWorld = entry.world
                warn("Target: " .. entry.key .. " (" .. entry.world .. ")")
                return
            end
        end
    end,
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_TP_MOB = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_TP_MOB do
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then task.wait(0.5) continue end
                    
                    local targetWorld = getgenv().SelectedMobWorld
                    if targetWorld and WORLDS[targetWorld] then
                        local worldBasePos = WORLDS[targetWorld]
                        local distToWorld = (hrp.Position - worldBasePos).Magnitude
                        if distToWorld > 1000 then
                            warn("[AutoTP] Teleporting to world base: " .. targetWorld)
                            steppedTeleport(CFrame.new(worldBasePos))
                            task.wait(0.5)
                            continue
                        end
                    end
                    
                    local mob, dist = getClosestMob(getgenv().SelectedMobParts, 10)
                    if mob then
                        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                        if mobHRP then
                            hrp.CFrame = mobHRP.CFrame * CFrame.new(0, 0, 3)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})
for _, entry in ipairs(MOB_LABELS) do
    MobDrop:AddItem(entry.label, entry.key == MOB_LABELS[1].key)
end

local VIM = game:GetService("VirtualInputManager")

local function doAttack()
    local method = getgenv()._SKENA_ATTACK_METHOD
    pcall(function()
        if method == "mouse1click" then
            if mouse1click then mouse1click() end
        elseif method == "keypress_f" then
            if keypress then keypress(0x46) task.wait(0.05) keyrelease(0x46) end
        elseif method == "keypress_e" then
            if keypress then keypress(0x45) task.wait(0.05) keyrelease(0x45) end
        elseif method == "tool_activate" then
            local char = player.Character
            if char then
                local tool = char:FindFirstChildWhichIsA("Tool")
                if tool then tool:Activate() end
            end
        elseif method == "vim_click" then
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end)
end

-- ==========================================
-- AUTO ATTACK (multiple methods)
-- ==========================================
local ATTACK_METHODS = {
    { key = "mouse1click",   label = "mouse1click" },
    { key = "keypress_f",    label = "Keypress F" },
    { key = "keypress_e",    label = "Keypress E" },
    { key = "tool_activate", label = "Tool Activate" },
    { key = "vim_click",     label = "VIM Click" },
}
getgenv()._SKENA_ATTACK_METHOD = "mouse1click"

local AtkDrop = TabMain:CreateDropdownToggle({
    Name = " [ Attack Method ]",
    Columns = 2,
    KeepOpen = true,
    Callback = function(val)
        for _, m in ipairs(ATTACK_METHODS) do
            if m.label == val then
                getgenv()._SKENA_ATTACK_METHOD = m.key
                warn("Attack Method: " .. m.key)
                return
            end
        end
    end,
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_ATTACK = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_ATTACK do
                    doAttack()
                    task.wait(0.15)
                end
            end)
        end
    end
})
for _, m in ipairs(ATTACK_METHODS) do
    AtkDrop:AddItem(m.label, m.key == "mouse1click")
end

-- ==========================================
-- KILL AURA (WIP - slider + toggle)
-- ==========================================
getgenv()._SKENA_KILL_RANGE = 25

RegisterLoop("_SKENA_KILL_AURA")
TabMain:CreateToggleRow({
    Name = "Kill Aura",
    HasInput = true,
    InputPlaceholder = "25",
    InputDefault = "25",
    InputWidth = 35,
    InputPrefix = "R:",
    OnInputChange = function(val)
        getgenv()._SKENA_KILL_RANGE = tonumber(val) or 25
    end,
    OnToggle = function(state)
        getgenv()._SKENA_KILL_AURA = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_KILL_AURA do
                    pcall(function()
                        local char = player.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if not hrp then return end
                        
                        local range = getgenv()._SKENA_KILL_RANGE or 25
                        local npcsF = workspace:FindFirstChild("Npcs")
                        if not npcsF then return end
                        
                        for _, mob in ipairs(npcsF:GetChildren()) do
                            if not getgenv()._SKENA_KILL_AURA then return end
                            if mob:IsA("Model") then
                                local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                                if mobHRP then
                                    local dist = (hrp.Position - mobHRP.Position).Magnitude
                                    if dist <= range then
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

local IdentifyDrop
IdentifyDrop = TabMain:CreateDropdownButton({
    Name = " [ Scan Live Mobs ]",
    ButtonText = "Scan",
    Columns = 2,
    KeepOpen = true,
    Callback = function(val)
        -- Parse ID from label: "Pig | ID:173"
        local mobId = string.match(val, "ID:(%d+)")
        if mobId then
            local npcsF = workspace:FindFirstChild("Npcs")
            if npcsF then
                local mob = npcsF:FindFirstChild(mobId)
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    steppedTeleport(mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                    warn("[TP] " .. val)
                end
            end
        end
    end,
    OnButton = function()
        local npcsF = workspace:FindFirstChild("Npcs")
        if not npcsF then warn("[Scan] Folder Npcs tidak ada!") return end
        
        -- Clear existing items
        local dropToUse = IdentifyDrop -- Self reference trick
        dropToUse:ClearItems()
        
        local allMobs = {}
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        
        for _, mob in ipairs(npcsF:GetChildren()) do
            if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                local parts = #mob:GetDescendants()
                local mobHRP = mob.HumanoidRootPart
                local dist = hrp and math.floor((hrp.Position - mobHRP.Position).Magnitude) or 0
                local knownName = PARTS_TO_NAME[parts] or "???"
                table.insert(allMobs, {
                    id = mob.Name,
                    parts = parts,
                    dist = dist,
                    knownName = knownName
                })
            end
        end
        
        table.sort(allMobs, function(a, b) return a.dist < b.dist end)
        
        for i, m in ipairs(allMobs) do
            dropToUse:AddItem(m.knownName .. " #" .. i .. " | ID:" .. m.id .. (m.knownName == "???" and (" (" .. m.parts .. "p)") or ""), i == 1)
        end
        
        warn("[Scan] " .. #allMobs .. " mob total.")
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

local RunService = game:GetService("RunService")
local blackScreenGui = nil

local function toggleBlackScreen(state)
    if state then
        pcall(function()
            if not blackScreenGui then
                blackScreenGui = Instance.new("ScreenGui")
                blackScreenGui.Name = "SkenaBlackScreen"
                blackScreenGui.IgnoreGuiInset = true
                -- Default to CoreGui, if not possible use PlayerGui but with strictly low DisplayOrder
                blackScreenGui.DisplayOrder = -999999 
                
                local bg = Instance.new("Frame", blackScreenGui)
                bg.Size = UDim2.new(1, 0, 1, 0)
                bg.BackgroundColor3 = Color3.new(0, 0, 0)
                bg.BorderSizePixel = 0
                bg.Active = false
                bg.Interactable = false
            end
            
            -- Prioritize CoreGui so UI libraries (usually in CoreGui) render above it
            local targetParent = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or player.PlayerGui
            blackScreenGui.Parent = targetParent
        end)
    else
        pcall(function()
            if blackScreenGui then
                blackScreenGui.Parent = nil
            end
        end)
    end
end

TabSettings:CreateToggleRow({
    Name = " [ Black Screen (Low CPU) ]",
    Callback = toggleBlackScreen,    -- Jika UI parser pakai Callback
    OnToggle = toggleBlackScreen     -- Jika UI parser pakai OnToggle
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
