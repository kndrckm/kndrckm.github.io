local TaskManagerUI

-- Mendeteksi apakah dijalankan lewat Executor
local success, err = pcall(function()
    TaskManagerUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/TaskUI_Library.lua"))()
end)

if not success or not TaskManagerUI then warn("Gagal mengambil UI Library"); return end

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
-- MEMUAT UI COMPACT SURVIVE THE LOOP
-- ==========================================
local Window = TaskManagerUI:CreateWindow({Name = "Survive the Loop"})

-- 11306132213 adalah gambar icon Home standard dari Roblox Decal
local TabHome = Window:CreateTab("Player Mods", 11210499092) 

-- ==========================================
-- ISI TAB PLAYER MODS (Fungsional Kompak)
-- ==========================================

-- Fly Mod: Teks | Tombol Enable | TextBox Key | TextBox Speed
TabHome:CreateAdvancedRow({
    Name = "Fly Mod",
    DefaultKey = "X",
    DefaultSpeed = "300",
    OnToggle = function(state) -- Nilai 'state' dikirim dari library (true/false)
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
    end,
    OnKeyChange = function(newKeyString)
        flyKey = Enum.KeyCode[string.upper(newKeyString)] or flyKey
    end,
    OnSpeedChange = function(newSpeedVal)
        flySpeed = tonumber(newSpeedVal) or flySpeed
    end
})

-- Auto Strafe Toggle (Muka Tombol Penuh)
local autoStrafeBtn = TabHome:CreateButton({
    Name = "Auto Strafe [C]: OFF",
    Callback = function()
        autoMoveEnabled = not autoMoveEnabled
        -- Kita bisa merubah properties tombol yang dikembalikan library
        -- secara langsung, tetapi dalam library kita otomatis diberi animasi hover
        print("Auto Strafe", autoMoveEnabled)
    end
})

-- Auto TP Slider dan Toggle
TabHome:CreateButton({
    Name = "Auto TP (Low HP): OFF -> Klik untuk Toggle",
    Callback = function()
        autoTpLowHpEnabled = not autoTpLowHpEnabled
        hasTeleportedForLowHp = false
        print("Auto TP Low HP Status:", autoTpLowHpEnabled)
    end
})

TabHome:CreateSlider({
    Name = "TP Threshold (%)",
    Min = 10,
    Max = 90,
    Default = 50,
    Callback = function(Value)
        tpThreshold = Value
    end
})

-- Safe Teleport
TabHome:CreateButton({
    Name = "Safe Teleport",
    Callback = function()
        local success = doSafeTeleport()
        if not success then warn("Gagal Safe Teleport. Base tidak ditemukan.") end
    end
})

-- Tombol ESP List & Toggle (Simplified)
TabHome:CreateButton({
    Name = "ESP Visualize Nodes: OFF -> Toggle",
    Callback = function()
        espEnabled = not espEnabled
        print("ESP Enabled:", espEnabled)
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

    -- Fly Logic Basic Mapping
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

-- Bind AutoMove shortcut
table.insert(connections, game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.C then
        autoMoveEnabled = not autoMoveEnabled
        print("Auto Strafe Toggled by Shortcut [C]")
    end
end))
