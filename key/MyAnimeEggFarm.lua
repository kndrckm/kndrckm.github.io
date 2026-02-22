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

-- Helper: buat payload sesuai format game
local function raw(data)
    return {["__raw"] = true, ["data"] = data or {}}
end

-- ==========================================
-- TAB MAIN
-- ==========================================

-- 1. Auto Interact All ProximityPrompts (fireproximityprompt)
RegisterLoop("_SKENA_AUTO_INTERACT")
TabMain:CreateToggleRow({
    Name = "Auto Interact All (Nearby)",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_INTERACT = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_INTERACT do
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp and fireproximityprompt then
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and obj.Enabled then
                                local part = obj.Parent
                                if part and part:IsA("BasePart") then
                                    local dist = (hrp.Position - part.Position).Magnitude
                                    if dist < 30 then
                                        pcall(function()
                                            fireproximityprompt(obj)
                                        end)
                                        task.wait(0.1)
                                    end
                                end
                            end
                        end
                    elseif not fireproximityprompt then
                        warn("[Skena] Executor tidak mendukung fireproximityprompt!")
                        getgenv()._SKENA_AUTO_INTERACT = false
                        break
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- 2. Auto Collect & Sell (Teleport Loop)
RegisterLoop("_SKENA_AUTO_FARM_LOOP")
TabMain:CreateToggleRow({
    Name = "Auto Farm (TP Collect → Sell)",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_FARM_LOOP = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_FARM_LOOP do
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then task.wait(1) continue end
                    
                    -- Cari semua ProximityPrompt dan kategorikan
                    local prompts = {}
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") and obj.Enabled then
                            local part = obj.Parent
                            if part and part:IsA("BasePart") then
                                table.insert(prompts, {prompt = obj, position = part.Position, name = obj.ObjectText ~= "" and obj.ObjectText or part.Name})
                            end
                        end
                    end
                    
                    -- Teleport ke setiap prompt, fire, lalu lanjut
                    for _, data in ipairs(prompts) do
                        if not getgenv()._SKENA_AUTO_FARM_LOOP then break end
                        pcall(function()
                            hrp.CFrame = CFrame.new(data.position + Vector3.new(0, 3, 0))
                        end)
                        task.wait(0.3)
                        pcall(function()
                            if fireproximityprompt then
                                fireproximityprompt(data.prompt)
                            end
                        end)
                        task.wait(0.5)
                    end
                    
                    task.wait(1)
                end
            end)
        end
    end
})

-- 3. Auto Request Egg (Spawn + Skip Hatch)
RegisterLoop("_SKENA_AUTO_REQUEST_EGG")
TabMain:CreateToggleRow({
    Name = "Auto Request Egg",
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_REQUEST_EGG = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_REQUEST_EGG do
                    pcall(function()
                        instances._requestEgg:FireServer(raw())
                    end)
                    task.wait(0.3)
                    pcall(function()
                        instances._requestEgg:FireServer(raw({["confirmedSkip"] = true}))
                    end)
                    task.wait(0.3)
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
