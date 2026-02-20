local TaskManagerUI

-- Mendeteksi apakah dijalankan lewat Executor (mendukung loadstring & game:HttpGet)
local success, err = pcall(function()
    TaskManagerUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/TaskUI_Library.lua"))()
end)

if not success or not TaskManagerUI then
    warn("Gagal mengambil UI Library dari Github. Error: " .. tostring(err))
    return
end

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

local cachedBases = {}

-- ==========================================
-- OPTIMIZATION: CACHE BASES ONCE (Untuk Safe TP)
-- ==========================================
local function cacheBaseObject(obj)
    if string.find(string.lower(obj.Name), "base") then
        if obj:IsA("Model") and obj.PrimaryPart then
            table.insert(cachedBases, obj.PrimaryPart)
        elseif obj:IsA("BasePart") then
            table.insert(cachedBases, obj)
        end
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
            if dist > maxDistance then
                maxDistance = dist; targetCFrame = tempPart.CFrame
            end
        end
    end
    if targetCFrame then hrp.CFrame = targetCFrame + Vector3.new(0, 50, 0); return true end
    return false
end

-- ==========================================
-- MEMUAT UI WINDOWS 11 TASK MANAGER
-- ==========================================
local Window = TaskManagerUI:CreateWindow({
    Name = "Survive The Loop - Task Manager"
})

-- ==========================================
-- TAB KIRI (Menu)
-- ==========================================
local TabPlayer = Window:CreateTab("Player Mods", 11306132213) 
local TabESP = Window:CreateTab("ESP & Visuals", 11306129524)

-- ==========================================
-- ISI TAB PLAYER MODS
-- ==========================================

TabPlayer:CreateButton({
    Name = "Fly Mod",
    Value = "Off",
    Callback = function()
        flyEnabled = not flyEnabled
        local c = player.Character
        if flyEnabled then
            if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") then
                local hrp = c.HumanoidRootPart
                local bg = Instance.new("BodyGyro", hrp); bg.Name = "FlyGyro"; bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyVel"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0,0,0)
                c.Humanoid.PlatformStand = true
            end
            print("Fly Enabled")
        else
            if c and c:FindFirstChild("HumanoidRootPart") then
                if c.HumanoidRootPart:FindFirstChild("FlyGyro") then c.HumanoidRootPart.FlyGyro:Destroy() end
                if c.HumanoidRootPart:FindFirstChild("FlyVel") then c.HumanoidRootPart.FlyVel:Destroy() end
                if c:FindFirstChild("Humanoid") then c.Humanoid.PlatformStand = false end
            end
            print("Fly Disabled")
        end
    end
})

TabPlayer:CreateButton({
    Name = "Auto Strafe",
    Value = "Off",
    Callback = function()
        autoMoveEnabled = not autoMoveEnabled
        print("Auto Move: " .. tostring(autoMoveEnabled))
    end
})

TabPlayer:CreateButton({
    Name = "Auto TP (Low HP)",
    Value = "Off",
    Callback = function()
        autoTpLowHpEnabled = not autoTpLowHpEnabled
        hasTeleportedForLowHp = false
        print("Auto TP: " .. tostring(autoTpLowHpEnabled))
    end
})

TabPlayer:CreateButton({
    Name = "Safe Teleport (Now)",
    Value = "Execute",
    Callback = function()
        local success = doSafeTeleport()
        if success then print("Teleported Safely!") else print("Safe Base Not Found") end
    end
})

-- ==========================================
-- ISI TAB ESP
-- ==========================================

TabESP:CreateButton({
    Name = "Toggle ESP Player",
    Value = "Off",
    Callback = function()
        espEnabled = not espEnabled
        -- Logika ESP akan dimasukkan ke rendering loop atau dijalankan di sini.
        -- Karena space / template UI basic, implementasi Folder CoreGui ESP bisa dipasang di sini.
        print("ESP Toggled: " .. tostring(espEnabled))
    end
})

-- ==========================================
-- RENDERING LOOP (RunService) 
-- ==========================================
table.insert(connections, game:GetService("RunService").RenderStepped:Connect(function(dt)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    -- Check Low HP
    if autoTpLowHpEnabled and hum and hrp then
        local hpPercent = (hum.Health / hum.MaxHealth) * 100
        if hpPercent <= tpThreshold and not hasTeleportedForLowHp and hum.Health > 0 then
            local success = doSafeTeleport()
            if success then hasTeleportedForLowHp = true end
        elseif hpPercent > tpThreshold then
            hasTeleportedForLowHp = false
        end
    end

    -- Fly & Automove Logic Handle (Basic)
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
