-- ==========================================
-- SKENA HUB : +1 Skill Point Legend
-- Game ID: 135668295983945
-- Based on: references/SkillPointOverflow.lua
-- ==========================================
-- Yang perlu dicek via Spy:
--   1. Workspace.__THINGS.__REMOTES.dealdamage (FireServer)
--   2. Workspace.__THINGS.__REMOTES.update_stats (FireServer)
--   3. Format payload: {{"Melee", position, target}}
--   4. Nama stat untuk SP overflow (e.g. "Magic Damage")

local SkenaUI_LibURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua"
local cacheBuster = "?t=" .. tostring(os.time())
local SkenaUI = loadstring(game:HttpGet(SkenaUI_LibURL .. cacheBuster, true))()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Remote references
local Things = workspace:FindFirstChild("__THINGS")
local Remotes = Things and Things:FindFirstChild("__REMOTES")
local DamageRemote = Remotes and Remotes:FindFirstChild("dealdamage")
local StatsRemote = Remotes and Remotes:FindFirstChild("update_stats")

-- ==========================================
-- BUAT WINDOW
-- ==========================================
local Window = SkenaUI.CreateWindow("SkenaHub", "+1 Skill Point Legend", false)
local TabMain = Window:CreateTab("Main", "zap", false)
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
-- STATUS CHECK
-- ==========================================
local statusParts = {}
if DamageRemote then table.insert(statusParts, "✅ dealdamage") else table.insert(statusParts, "❌ dealdamage") end
if StatsRemote then table.insert(statusParts, "✅ update_stats") else table.insert(statusParts, "❌ update_stats") end

TabMain:CreateTextRow({
    Text = "Remote: " .. table.concat(statusParts, "  |  ")
})

-- ==========================================
-- TAB MAIN
-- ==========================================

-- 1. Mob Aura (Auto Kill semua entity di __THINGS)
RegisterLoop("_SKENA_MOB_AURA")
TabMain:CreateToggleRow({
    Name = "Mob Aura",
    OnToggle = function(state)
        getgenv()._SKENA_MOB_AURA = state
        if state then
            if not DamageRemote then
                warn("[Skena] dealdamage remote tidak ditemukan!")
                getgenv()._SKENA_MOB_AURA = false
                return
            end
            task.spawn(function()
                while getgenv()._SKENA_MOB_AURA do
                    pcall(function()
                        for _, folder in pairs(Things:GetChildren()) do
                            if folder:IsA("Folder") and folder.Name ~= "__REMOTES" then
                                for _, entity in pairs(folder:GetChildren()) do
                                    if not getgenv()._SKENA_MOB_AURA then return end
                                    pcall(function()
                                        if entity:IsA("Model") or entity:IsA("BasePart") then
                                            DamageRemote:FireServer({"Melee", entity:GetPivot().Position, entity})
                                        end
                                    end)
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

-- 2. Give Infinite SP (Overflow trick)
TabMain:CreateButtonRow({
    Name = "Give Infinite SP",
    ButtonText = "GET SP",
    Callback = function(btn)
        if not StatsRemote then
            warn("[Skena] update_stats remote tidak ditemukan!")
            return
        end
        pcall(function()
            StatsRemote:FireServer({"Magic Damage", 1e15})
            StatsRemote:FireServer({"Magic Damage", -1e15})
            warn("[Skena] SP Overflow berhasil!")
        end)
    end
})

TabMain:CreateTextRow({
    Text = "SP Overflow: Fire +1e15 lalu -1e15 ke stat 'Magic Damage' agar SP meluap. Gunakan Spy untuk cek nama stat yang benar jika tidak bekerja."
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
