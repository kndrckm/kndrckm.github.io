local TaskManagerUI

-- Mendeteksi apakah dijalankan lewat Executor
local success, err = pcall(function()
    TaskManagerUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/TaskUI_Library.lua"))()
end)

if not success or not TaskManagerUI then warn("Gagal memuat UI Library Windows 11"); return end

-- ==========================================
-- INISIALISASI VARIABEL & SISTEM
-- ==========================================
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local connections = {} 

local espEnabled = false
local flyEnabled = false
local autoMoveEnabled = false
local autoTpLowHpEnabled = false

local tpThreshold = 50 
local hasTeleportedForLowHp = false 
local flySpeed = 300
local flyKey = Enum.KeyCode.X
local strafeKey = Enum.KeyCode.C

local cachedBases = {}

-- Cache Bases Optimization
local function cacheBaseObject(obj)
    if string.find(string.lower(obj.Name), "base") then
        if obj:IsA("Model") and obj.PrimaryPart then table.insert(cachedBases, obj.PrimaryPart)
        elseif obj:IsA("BasePart") then table.insert(cachedBases, obj) end
    end
end
for _, v in pairs(workspace:GetDescendants()) do cacheBaseObject(v) end
table.insert(connections, workspace.DescendantAdded:Connect(function(obj) cacheBaseObject(obj) end))

local function doSafeTeleport()
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local targetCFrame = nil
    local maxDistance = -1
    for _, tempPart in ipairs(cachedBases) do
        if tempPart and tempPart.Parent then 
            local dist = (tempPart.Position - hrp.Position).Magnitude
            if dist > maxDistance then maxDistance = dist; targetCFrame = tempPart.CFrame end
        end
    end
    if targetCFrame then hrp.CFrame = targetCFrame + Vector3.new(0, 50, 0); return true end
    return false
end

-- ==========================================
-- MEMBUAT WINDOW DARK MODE
-- ==========================================
local Window = TaskManagerUI:CreateWindow({Name = "Survive the Loop"})

-- Tab utama
local TabMods = Window:CreateTab("Player Mods", 11306132213) 
-- Tab Settings (Ikon Gear) dipin di bawah
local TabSettings = Window:CreateTab("Settings", 11295281432, true) 

-- ==========================================
-- ISI TAB PLAYER MODS
-- ==========================================

-- Row 1: Fly Mode (Speed, Key, Toggle)
TabMods:CreateToggleRow({
    Name = "Fly Mod",
    HasSpeed = true, DefaultSpeed = "300",
    HasKey = true, DefaultKey = "X",
    OnSpeedChange = function(newSpeed) flySpeed = tonumber(newSpeed) or flySpeed end,
    OnKeyChange = function(newKey)
        local key = Enum.KeyCode[string.upper(newKey)]
        if key then flyKey = key end
    end,
    OnToggle = function(state)
        flyEnabled = state
        local c = player.Character
        if flyEnabled then
            if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") then
                local hrp = c.HumanoidRootPart
                local bg = Instance.new("BodyGyro", hrp); bg.Name = "FlyGyro"; bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyVel"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0,0,0)
                c.Humanoid.PlatformStand = true
            end
        else
            if c and c:FindFirstChild("HumanoidRootPart") then
                if c.HumanoidRootPart:FindFirstChild("FlyGyro") then c.HumanoidRootPart.FlyGyro:Destroy() end
                if c.HumanoidRootPart:FindFirstChild("FlyVel") then c.HumanoidRootPart.FlyVel:Destroy() end
                if c:FindFirstChild("Humanoid") then c.Humanoid.PlatformStand = false end
            end
        end
    end
})

-- Row 2: Auto Strafe (Key, Toggle)
TabMods:CreateToggleRow({
    Name = "Auto Strafe",
    HasKey = true, DefaultKey = "C",
    OnKeyChange = function(newKey)
        local key = Enum.KeyCode[string.upper(newKey)]
        if key then strafeKey = key end
    end,
    OnToggle = function(state)
        autoMoveEnabled = state
    end
})

-- Row 3: Auto TP when Low (Toggle Only)
TabMods:CreateToggleRow({
    Name = "Auto TP (Low HP)",
    OnToggle = function(state)
        autoTpLowHpEnabled = state
        hasTeleportedForLowHp = false
    end
})

-- Row 4: Auto TP Threshold Slider
TabMods:CreateSliderRow({
    Name = "TP Threshold",
    Min = 10,
    Max = 90,
    Default = 50,
    Suffix = "%",
    Callback = function(val)
        tpThreshold = val
    end
})

-- Row 5: Safe TP Button
TabMods:CreateButtonRow({
    Name = "Safe Teleport",
    ButtonText = "Execute",
    Callback = function()
        doSafeTeleport()
    end
})

-- Row 6: ESP Toggle
TabMods:CreateToggleRow({
    Name = "ESP Node Visualize",
    OnToggle = function(state)
        espEnabled = state
    end
})

-- ==========================================
-- ISI TAB SETTINGS
-- ==========================================
TabSettings:CreateInputRow({
    Name = "Menu Toggle Key",
    Default = "Z",
    Placeholder = "Key",
    Callback = function(val)
        Window:SetToggleKey(val)
    end
})


-- ==========================================
-- RENDERING LOOP (Fly & AutoMove)
-- ==========================================
table.insert(connections, game:GetService("RunService").RenderStepped:Connect(function(dt)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    -- Check Low HP Target
    if autoTpLowHpEnabled and hum and hrp then
        local hpPercent = (hum.Health / hum.MaxHealth) * 100
        if hpPercent <= tpThreshold and not hasTeleportedForLowHp and hum.Health > 0 then
            local success = doSafeTeleport()
            if success then hasTeleportedForLowHp = true end
        elseif hpPercent > tpThreshold then
            hasTeleportedForLowHp = false
        end
    end

    -- Fly Logic
    if flyEnabled and hrp and hum then
        local bg = hrp:FindFirstChild("FlyGyro")
        local bv = hrp:FindFirstChild("FlyVel")
        if bg and bv then
            local camCF = workspace.CurrentCamera.CFrame
            bg.CFrame = camCF
            local moveDir = Vector3.new()
            
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
            
            if autoMoveEnabled then moveDir = moveDir + (camCF.RightVector * math.sin(tick() * 5)) end
            bv.Velocity = moveDir.Magnitude > 0 and (moveDir.Unit * flySpeed) or Vector3.new(0,0,0)
        end
    elseif autoMoveEnabled and not flyEnabled and hum then
        hum:Move(workspace.CurrentCamera.CFrame.RightVector * math.sin(tick() * 5), false)
    end
end))

-- Global Hotkeys
table.insert(connections, game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == strafeKey then
        autoMoveEnabled = not autoMoveEnabled
        -- (Ideally sync visual toggle with UI, current UI architecture is one-way binding logic, 
        -- but this handles internal state accurately).
    end
end))
