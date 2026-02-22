-- ==========================================
-- SKENA HUB : ANIME CREATURES
-- Game ID: 133898125416947
-- ==========================================

local SkenaUI_LibURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua"
local cacheBuster = "?t=" .. tostring(os.time())
local SkenaUI = loadstring(game:HttpGet(SkenaUI_LibURL .. cacheBuster, true))()

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- Remote references
local Events = rs:WaitForChild("Events")
local Action = rs:WaitForChild("Action")
local CatchRate = rs:WaitForChild("CatchRate")

-- ==========================================
-- BUAT WINDOW
-- ==========================================
local Window = SkenaUI.CreateWindow("SkenaHub", "Anime Creatures", false)
local TabMain = Window:CreateTab("Main", "zap", false)
local TabSettings = Window:CreateTab("Settings", "settings", true)

-- Kill phantom loops
pcall(function()
    if getgenv()._SKENA_AC_LOOPS then
        for _, flag in pairs(getgenv()._SKENA_AC_LOOPS) do
            getgenv()[flag] = false
        end
    end
end)
getgenv()._SKENA_AC_LOOPS = {}

local function RegisterLoop(flagName)
    getgenv()[flagName] = false
    table.insert(getgenv()._SKENA_AC_LOOPS, flagName)
end

-- ==========================================
-- TAB MAIN
-- ==========================================

-- 1. Auto Attack (Spam PlayerAttack)
RegisterLoop("_SKENA_AUTO_ATTACK")
TabMain:CreateToggleRow({
    Name = "Auto Attack",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_ATTACK = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_ATTACK do
                    pcall(function()
                        Events.PlayerAttack:FireServer()
                    end)
                    task.wait(0.05)
                end
            end)
        end
    end
})

-- 2. Auto Train
TabMain:CreateButtonRow({
    Name = "Auto Train",
    ButtonText = "ON",
    Callback = function()
        pcall(function()
            Action.SetAutoTrainEvent:FireServer(true)
        end)
    end
})

-- 3. Auto Catch Follow
TabMain:CreateButtonRow({
    Name = "Auto Catch Follow",
    ButtonText = "ON",
    Callback = function()
        pcall(function()
            Events.SetStatEvent:FireServer("AutoCatchFollow", true)
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
