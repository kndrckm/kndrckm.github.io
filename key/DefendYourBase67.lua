-- ==========================================
-- SKENA HUB : Defend Your Base From 67
-- Game ID: 102669100769936, 97689234675651
-- ==========================================
local SkenaUI_LibURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua"
local cacheBuster = "?t=" .. tostring(os.time())
local libBody = game:HttpGet(SkenaUI_LibURL .. cacheBuster, true)
local libFunc, libErr = loadstring(libBody)
if not libFunc then error("SkenaUI Library Syntax Error: " .. tostring(libErr)) end
local SkenaUI = libFunc()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Window = SkenaUI.CreateWindow("SkenaHub", "Defend Your Base 67", false)
local TabMain = Window:CreateTab("Main", "zap", false)
local TabSettings = Window:CreateTab("Settings", "settings", true)

-- Kill phantom loops
pcall(function()
    if getgenv()._SKENA_DYB67_LOOPS then
        for _, flag in pairs(getgenv()._SKENA_DYB67_LOOPS) do
            getgenv()[flag] = false
        end
    end
end)
getgenv()._SKENA_DYB67_LOOPS = {}

local function RegisterLoop(flagName)
    getgenv()[flagName] = false
    table.insert(getgenv()._SKENA_DYB67_LOOPS, flagName)
end

-- ==========================================
-- AUTO REPAIR SYSTEM
-- ==========================================
getgenv().AutoRepairThreshold = 50
RegisterLoop("_SKENA_AUTO_REPAIR")

local function GetBaseHPPercentage()
    local hpValue = nil
    local maxHpValue = nil

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("IntValue") or obj:IsA("NumberValue") then
            local name = obj.Name:lower()
            if name:match("health") or name == "hp" or name:match("basehp") then
                hpValue = obj.Value
                local parent = obj.Parent
                if parent then
                    local maxObj = parent:FindFirstChild("MaxHealth") or parent:FindFirstChild("MaxHP")
                    if maxObj and (maxObj:IsA("IntValue") or maxObj:IsA("NumberValue")) then
                        maxHpValue = maxObj.Value
                    end
                end
                break
            end
        end
    end

    if hpValue and maxHpValue and maxHpValue > 0 then
        return (hpValue / maxHpValue) * 100
    elseif hpValue then
        return hpValue 
    end
    
    return nil 
end

TabMain:CreateToggleRow({
    Name = " [ Auto Repair Base ]",
    Callback = function(state) end,
    OnToggle = function(state)
        getgenv()._SKENA_AUTO_REPAIR = state
        if state then
            task.spawn(function()
                while getgenv()._SKENA_AUTO_REPAIR do
                    task.wait(0.5)
                    local success, hpPercent = pcall(GetBaseHPPercentage)
                    
                    if not success or hpPercent == nil then
                         local args = { [1] = "repair" }
                         pcall(function()
                             game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Base"):FireServer(unpack(args))
                         end)
                         task.wait(1.5)
                    else
                         if hpPercent <= getgenv().AutoRepairThreshold then
                             local args = { [1] = "repair" }
                             pcall(function()
                                 game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Base"):FireServer(unpack(args))
                             end)
                             task.wait(2)
                         end
                    end
                end
            end)
        end
    end
})

TabMain:CreateSliderRow({
    Name = "HP Threshold (%)",
    Min = 10,
    Max = 95,
    Default = 50,
    Suffix = "%",
    Callback = function(val)
        getgenv().AutoRepairThreshold = tonumber(val) or 50
    end
})

TabMain:CreateButtonRow({
    Name = "Spam Repair (10x)",
    ButtonText = "Execute",
    Callback = function()
        warn("[Repair] Sending 10x repair requests...")
        for i = 1, 10 do
            local args = { [1] = "repair" }
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Base"):FireServer(unpack(args))
            end)
            task.wait(0.1)
        end
    end
})

-- ==========================================
-- TAB SETTINGS
-- ==========================================
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
