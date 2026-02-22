-- ==========================================
-- SKENA HUB : MY ANIME EGG FARM
-- Game ID: 97883985639349
-- ==========================================

local SkenaUI_LibURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua"
local cacheBuster = "?t=" .. tostring(os.time())
local SkenaUI = loadstring(game:HttpGet(SkenaUI_LibURL .. cacheBuster, true))()

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- ==========================================
-- BUAT WINDOW
-- ==========================================
local Window = SkenaUI.CreateWindow("SkenaHub", "My Anime Egg Farm", false)
local TabMain = Window:CreateTab("Main", "zap", false)
local TabSettings = Window:CreateTab("Settings", "settings", true)

local instances = rs:WaitForChild("Modules"):WaitForChild("Internals"):WaitForChild("Skeleton"):WaitForChild("Conduit"):WaitForChild("Instances")

-- Kill phantom loops
pcall(function()
    if getgenv()._SKENA_EGG_LOOPS then
        for _, flag in pairs(getgenv()._SKENA_EGG_LOOPS) do
            getgenv()[flag] = false
        end
    end
end)
getgenv()._SKENA_EGG_LOOPS = {}

local function RegisterLoop(flagName)
    getgenv()[flagName] = false
    table.insert(getgenv()._SKENA_EGG_LOOPS, flagName)
end

-- ==========================================
-- TAB MAIN
-- ==========================================

-- 1. Auto Collect Earnings
RegisterLoop("_SKENA_AUTO_COLLECT_EGG")
TabMain:CreateToggleRow({
    Name = "Auto Collect Earnings",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_COLLECT_EGG = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_COLLECT_EGG do
                    pcall(function()
                        instances._collectEarnings:FireServer({})
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- 2. Auto Sell Stack
RegisterLoop("_SKENA_AUTO_SELL_EGG")
TabMain:CreateToggleRow({
    Name = "Auto Sell Stack",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_SELL_EGG = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_SELL_EGG do
                    pcall(function()
                        instances._sellStack:FireServer({})
                    end)
                    task.wait(0.5)
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
