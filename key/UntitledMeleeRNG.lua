-- ==========================================
-- SKENA HUB : Untitled Melee RNG
-- Game ID: 99248392277037
-- ==========================================

local SkenaUI_LibURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua"
local cacheBuster = "?t=" .. tostring(os.time())
local libBody = game:HttpGet(SkenaUI_LibURL .. cacheBuster, true)
local libFunc, libErr = loadstring(libBody)
if not libFunc then error("SkenaUI Library Syntax Error: " .. tostring(libErr)) end
local SkenaUI = libFunc()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Window = SkenaUI.CreateWindow("SkenaHub", "Untitled Melee RNG", false)
local TabMain = Window:CreateTab("Main", "zap", false)

-- Kill phantom loops
pcall(function()
    if getgenv()._SKENA_UMR_LOOPS then
        for _, flag in pairs(getgenv()._SKENA_UMR_LOOPS) do
            getgenv()[flag] = false
        end
    end
end)
getgenv()._SKENA_UMR_LOOPS = {}

local function RegisterLoop(flagName)
    getgenv()[flagName] = false
    table.insert(getgenv()._SKENA_UMR_LOOPS, flagName)
end

-- ==========================================
-- TAB MAIN
-- ==========================================

-- Toggle Run (Default: ON)
-- Set to true by default when script loads
if getgenv()._SKENA_TOGGLE_RUN == nil then
    getgenv()._SKENA_TOGGLE_RUN = true
end
RegisterLoop("_SKENA_TOGGLE_RUN")

task.spawn(function()
    while task.wait(0.1) do
        if getgenv()._SKENA_TOGGLE_RUN then
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= 28 then
                hum.WalkSpeed = 28
            end
        end
    end
end)

TabMain:CreateToggleRow({
    Name = " [ Toggle Run ]",
    Default = getgenv()._SKENA_TOGGLE_RUN,
    OnToggle = function(state)
        getgenv()._SKENA_TOGGLE_RUN = state
        if not state then
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
        end
    end
})

-- Teleports
TabMain:CreateTextRow({
    Text = "── Teleports ──"
})

local function doTP(pos)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(pos)
    end
end

TabMain:CreateButtonRow({
    Name = "Grassland",
    ButtonText = "TP",
    Callback = function()
        doTP(Vector3.new(188.961, 35.779, -254.614))
    end
})

TabMain:CreateButtonRow({
    Name = "Desert (2x luck, 100 kill)",
    ButtonText = "TP",
    Callback = function()
        doTP(Vector3.new(260.278, 17.110, -927.792))
    end
})

TabMain:CreateButtonRow({
    Name = "Snow (4x luck, 1,500 kill)",
    ButtonText = "TP",
    Callback = function()
        doTP(Vector3.new(286.322, 16.160, -1581.303))
    end
})

TabMain:CreateButtonRow({
    Name = "Jungle (6x luck, 15,000 kill)",
    ButtonText = "TP",
    Callback = function()
        doTP(Vector3.new(442.860, 113.981, -2744.834))
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
