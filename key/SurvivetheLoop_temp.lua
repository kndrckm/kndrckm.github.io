local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local GUI_NAME = "SurviveTheLoopUI_Dropdown"

if player.PlayerGui:FindFirstChild(GUI_NAME) then
    player.PlayerGui[GUI_NAME]:Destroy()
end
if CoreGui:FindFirstChild("SurviveTheLoopESP") then
    CoreGui["SurviveTheLoopESP"]:Destroy()
end

-- ==========================================
-- SYSTEM VARIABLES & CONFIGURATION
-- ==========================================
local connections = {} 

local espEnabled = false
local flyEnabled = false
local autoMoveEnabled = false
local autoTpLowHpEnabled = false

local tpThreshold = 50 
local hasTeleportedForLowHp = false 

local flySpeed = 300
local flyKey = Enum.KeyCode.X
local menuKey = Enum.KeyCode.Z
local autoMoveKey = Enum.KeyCode.C

local espFolder = nil
local itemFilters = {} 
local detectedGroups = {} 
local isDropdownOpen = false

local cachedBases = {} -- OPTIMIZATION: Cache bases to prevent lag spikes

local BASE_HEIGHT = 335 
local OPEN_HEIGHT = 465 

local STYLE = {
    GLASS_BG = Color3.fromRGB(255, 255, 255),
    GLASS_TRANS = 0.35, 
    ELEMENT_BG = Color3.fromRGB(240, 240, 255),
    ELEMENT_TRANS = 0.3, 
    TEXT_DARK = Color3.fromRGB(20, 20, 20),
    TEXT_LIGHT = Color3.fromRGB(255, 255, 255),
    IOS_BLUE = Color3.fromRGB(0, 122, 255),
    IOS_GREEN = Color3.fromRGB(52, 199, 89),
    IOS_RED = Color3.fromRGB(255, 59, 48),
    GRAY = Color3.fromRGB(120, 120, 120), 
    CORNER_L = 24, CORNER_M = 12, CORNER_S = 8, 
}

-- ==========================================
-- UI HELPERS
-- ==========================================
local function create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness, trans)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.new(1,1,1)
    stroke.Thickness = thickness or 1.5
    stroke.Transparency = trans or 0.4
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function getCleanName(rawName)
    local clean = rawName:split("_")[1]
    return clean or rawName
end

-- ==========================================
-- OPTIMIZATION: CACHE BASES ONCE
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

for _, v in pairs(workspace:GetDescendants()) do
    cacheBaseObject(v)
end

table.insert(connections, workspace.DescendantAdded:Connect(function(obj)
    cacheBaseObject(obj)
end))

-- ==========================================
-- BUILD UI
-- ==========================================
local screenGui = create("ScreenGui", { Name = GUI_NAME, ResetOnSpawn = false, DisplayOrder = 10, Parent = player:WaitForChild("PlayerGui") })

local mainFrame = create("Frame", { 
    Size = UDim2.new(0, 320, 0, BASE_HEIGHT), 
    AnchorPoint = Vector2.new(0, 0.5), 
    Position = UDim2.new(0, 20, 0.5, 0), 
    BackgroundColor3 = STYLE.GLASS_BG, 
    BackgroundTransparency = STYLE.GLASS_TRANS, 
    BorderSizePixel = 0, 
    Active = true, 
    Draggable = true, 
    ClipsDescendants = true, 
    Parent = screenGui 
})
addCorner(mainFrame, STYLE.CORNER_L)
addStroke(mainFrame, Color3.new(1,1,1), 2, 0.3)

create("TextLabel", { Size = UDim2.new(1, -50, 0, 35), Position = UDim2.new(0, 20, 0, 2), BackgroundTransparency = 1, Text = "Survive the Loop", TextColor3 = STYLE.TEXT_DARK, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextSize = 20, Parent = mainFrame })

local closeBtn = create("TextButton", { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -36, 0, 6), Text = "X", BackgroundColor3 = STYLE.IOS_RED, BackgroundTransparency = 0.1, TextColor3 = STYLE.TEXT_LIGHT, Font = Enum.Font.GothamBold, TextSize = 14, BorderSizePixel = 0, AutoButtonColor = false, Parent = mainFrame })
addCorner(closeBtn, 30)

local contentFrame = create("Frame", { Size = UDim2.new(1, -30, 1, -45), Position = UDim2.new(0, 15, 0, 40), BackgroundTransparency = 1, Parent = mainFrame })
local layout = create("UIListLayout", { Parent = contentFrame, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center })

-- [1] FLY MOD
local flyFrame = create("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 1, Parent = contentFrame })
create("TextLabel", { Size = UDim2.new(0, 65, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = "Fly Mod", TextColor3 = STYLE.TEXT_DARK, Font = Enum.Font.GothamSemibold, TextXAlignment = Enum.TextXAlignment.Left, TextSize = 14, Parent = flyFrame })
local flyToggleBtn = create("TextButton", { Size = UDim2.new(0, 120, 0, 26), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 65, 0.5, 0), Text = "Enable", BackgroundColor3 = STYLE.IOS_BLUE, BackgroundTransparency = 0.1, TextColor3 = STYLE.TEXT_LIGHT, Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false, Parent = flyFrame })
addCorner(flyToggleBtn, STYLE.CORNER_M)
local flyKeyBox = create("TextBox", { Size = UDim2.new(0, 28, 0, 26), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -45, 0.5, 0), Text = "X", PlaceholderText = "Key", BackgroundColor3 = STYLE.GLASS_BG, BackgroundTransparency = 0.5, TextColor3 = STYLE.IOS_BLUE, Font = Enum.Font.GothamBold, TextSize = 12, Parent = flyFrame })
addCorner(flyKeyBox, STYLE.CORNER_S)
local flySpeedBox = create("TextBox", { Size = UDim2.new(0, 40, 0, 26), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Text = "300", PlaceholderText = "Spd", BackgroundColor3 = STYLE.GLASS_BG, BackgroundTransparency = 0.5, TextColor3 = STYLE.IOS_BLUE, Font = Enum.Font.GothamBold, TextSize = 12, Parent = flyFrame })
addCorner(flySpeedBox, STYLE.CORNER_S)

-- [2] AUTO STRAFE
local autoMoveBtn = create("TextButton", { Size = UDim2.new(1, 0, 0, 32), LayoutOrder = 2, Text = "Auto Strafe [C]: OFF", BackgroundColor3 = STYLE.ELEMENT_BG, BackgroundTransparency = STYLE.ELEMENT_TRANS, TextColor3 = STYLE.TEXT_DARK, Font = Enum.Font.GothamSemibold, TextSize = 13, AutoButtonColor = false, Parent = contentFrame })
addCorner(autoMoveBtn, STYLE.CORNER_M)

-- [3] AUTO TP LOW HP & SLIDER
local autoTpRow = create("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = 3, Parent = contentFrame })
local autoTpBtn = create("TextButton", { Size = UDim2.new(0.5, -5, 0, 28), Position = UDim2.new(0, 0, 0.5, -14), Text = "Auto TP (Low HP): OFF", BackgroundColor3 = STYLE.ELEMENT_BG, BackgroundTransparency = STYLE.ELEMENT_TRANS, TextColor3 = STYLE.TEXT_DARK, Font = Enum.Font.GothamBold, TextSize = 11, AutoButtonColor = false, Parent = autoTpRow })
addCorner(autoTpBtn, STYLE.CORNER_M)

local sliderContainer = create("Frame", { Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 5, 0, 0), BackgroundTransparency = 1, Parent = autoTpRow })
local sliderBg = create("TextButton", { Size = UDim2.new(1, 0, 0, 8), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.4, 0), BackgroundColor3 = STYLE.ELEMENT_BG, Text = "", AutoButtonColor = false, Parent = sliderContainer })
addCorner(sliderBg, 4)
local sliderFill = create("Frame", { Size = UDim2.new((tpThreshold - 10) / 90, 0, 1, 0), BackgroundColor3 = STYLE.IOS_BLUE, BorderSizePixel = 0, Parent = sliderBg }) 
addCorner(sliderFill, 4)
local sliderValText = create("TextLabel", { Size = UDim2.new(1, 0, 0, 15), AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1, Text = "HP < " .. tpThreshold .. "%", TextColor3 = STYLE.GRAY, Font = Enum.Font.GothamMedium, TextSize = 11, Parent = sliderContainer })

-- [4] SAFE TELEPORT BUTTON 
local safeTpRow = create("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 4, Parent = contentFrame })
local safeTpBtn = create("TextButton", { Size = UDim2.new(1, 0, 1, 0), Text = "Safe Teleport", BackgroundColor3 = STYLE.ELEMENT_BG, BackgroundTransparency = STYLE.ELEMENT_TRANS, TextColor3 = STYLE.TEXT_DARK, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, Parent = safeTpRow })
addCorner(safeTpBtn, STYLE.CORNER_M)

-- [5] DROPDOWN & ESP
local mixedRow = create("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 5, Parent = contentFrame })
local dropdownToggleBtn = create("TextButton", { Size = UDim2.new(0.73, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), Text = "Interact Filter  ▾", BackgroundColor3 = STYLE.ELEMENT_BG, BackgroundTransparency = 0.4, TextColor3 = STYLE.GRAY, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, Parent = mixedRow })
addCorner(dropdownToggleBtn, STYLE.CORNER_M)
local espBtn = create("TextButton", { Size = UDim2.new(0.25, 0, 1, 0), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Text = "ESP", BackgroundColor3 = STYLE.ELEMENT_BG, BackgroundTransparency = STYLE.ELEMENT_TRANS, TextColor3 = STYLE.TEXT_DARK, Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false, Parent = mixedRow })
addCorner(espBtn, STYLE.CORNER_M)

-- [6] SCROLLING FRAME (DROPDOWN)
local dropdownClip = create("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = STYLE.ELEMENT_BG, BackgroundTransparency = 0.6, ClipsDescendants = true, LayoutOrder = 6, Parent = contentFrame })
addCorner(dropdownClip, STYLE.CORNER_M)
local scrollFrame = create("ScrollingFrame", { Size = UDim2.new(1, -10, 1, -10), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1, ScrollBarThickness = 3, ScrollBarImageColor3 = STYLE.IOS_BLUE, ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Always, CanvasSize = UDim2.new(0, 0, 0, 0), Parent = dropdownClip })
local scrollLayout = create("UIListLayout", { Parent = scrollFrame, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.Name })

-- [7] SETTINGS MENU
local settingsFrame = create("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 7, Parent = contentFrame })
create("TextLabel", { Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 5, 0, 0), BackgroundTransparency = 1, Text = "Menu Toggle Key", TextColor3 = STYLE.GRAY, TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.GothamMedium, TextSize = 12, Parent = settingsFrame })
local menuKeyBox = create("TextBox", { Size = UDim2.new(0, 26, 0, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Text = "Z", PlaceholderText = "Key", BackgroundColor3 = STYLE.GLASS_BG, BackgroundTransparency = 0.5, TextColor3 = STYLE.GRAY, Font = Enum.Font.GothamBold, TextSize = 12, Parent = settingsFrame })
addCorner(menuKeyBox, STYLE.CORNER_S)

-- Modal Unload
local modalBackdrop = create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 20, Visible = false, Parent = mainFrame })
local confirmFrame = create("Frame", { Size = UDim2.new(0, 220, 0, 130), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = STYLE.GLASS_BG, BackgroundTransparency = 0.05, BorderSizePixel = 0, Visible = false, ZIndex = 21, Parent = mainFrame })
addCorner(confirmFrame, STYLE.CORNER_L)
addStroke(confirmFrame, Color3.new(0.8,0.8,0.8), 2, 0.2)
create("TextLabel", { Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 10), BackgroundTransparency = 1, Text = "Unload Script?", TextColor3 = STYLE.TEXT_DARK, Font = Enum.Font.GothamBold, TextSize = 16, ZIndex = 22, Parent = confirmFrame })
local confirmYesBtn = create("TextButton", { Size = UDim2.new(0.4, 0, 0, 32), Position = UDim2.new(0.1, 0, 1, -40), Text = "Unload", BackgroundColor3 = STYLE.IOS_RED, TextColor3 = STYLE.TEXT_LIGHT, Font = Enum.Font.GothamBold, TextSize = 14, ZIndex = 22, Parent = confirmFrame })
addCorner(confirmYesBtn, STYLE.CORNER_M)
local confirmNoBtn = create("TextButton", { Size = UDim2.new(0.4, 0, 0, 32), Position = UDim2.new(0.5, 0, 1, -40), Text = "Cancel", BackgroundColor3 = STYLE.ELEMENT_BG, TextColor3 = STYLE.IOS_BLUE, Font = Enum.Font.GothamBold, TextSize = 14, ZIndex = 22, Parent = confirmFrame })
addCorner(confirmNoBtn, STYLE.CORNER_M)

-- ==========================================
-- LOGIC FUNCTIONS
-- ==========================================
local function stringToKey(str) return Enum.KeyCode[str:upper()] or nil end

-- Optimized Safe Teleport Function (Uses cached bases instead of full workspace scan)
local function doSafeTeleport()
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local targetCFrame = nil
    local maxDistance = -1
    
    for _, tempPart in ipairs(cachedBases) do
        if tempPart and tempPart.Parent then -- Ensure it wasn't destroyed
            local dist = (tempPart.Position - hrp.Position).Magnitude
            if dist > maxDistance then
                maxDistance = dist
                targetCFrame = tempPart.CFrame
            end
        end
    end
    
    if targetCFrame then
        hrp.CFrame = targetCFrame + Vector3.new(0, 50, 0)
        return true
    end
    return false
end

-- Logic Safe Teleport Button
safeTpBtn.MouseButton1Click:Connect(function()
    local success = doSafeTeleport()
    if success then
        safeTpBtn.Text = "Teleported!"
        safeTpBtn.BackgroundColor3 = STYLE.IOS_GREEN
        safeTpBtn.TextColor3 = STYLE.TEXT_LIGHT
    else
        safeTpBtn.Text = "Base Not Found!"
        safeTpBtn.BackgroundColor3 = STYLE.IOS_RED
        safeTpBtn.TextColor3 = STYLE.TEXT_LIGHT
    end
    
    task.delay(1.5, function()
        safeTpBtn.Text = "Safe Teleport"
        safeTpBtn.BackgroundColor3 = STYLE.ELEMENT_BG
        safeTpBtn.TextColor3 = STYLE.TEXT_DARK
    end)
end)

-- Slider Logic (10% - 100%)
local isDragging = false
local function updateSlider(input)
    local relativeX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
    local percentage = relativeX / sliderBg.AbsoluteSize.X
    tpThreshold = math.floor(10 + (percentage * 90)) 
    sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
    sliderValText.Text = "HP < " .. tpThreshold .. "%"
end

sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true; updateSlider(input)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- Auto TP (Low HP) Mod
autoTpBtn.MouseButton1Click:Connect(function()
    autoTpLowHpEnabled = not autoTpLowHpEnabled
    if autoTpLowHpEnabled then
        autoTpBtn.Text = "Auto TP (Low HP): ON"
        autoTpBtn.BackgroundColor3 = STYLE.IOS_GREEN
        autoTpBtn.TextColor3 = STYLE.TEXT_LIGHT
        autoTpBtn.BackgroundTransparency = 0.1
        hasTeleportedForLowHp = false
    else
        autoTpBtn.Text = "Auto TP (Low HP): OFF"
        autoTpBtn.BackgroundColor3 = STYLE.ELEMENT_BG
        autoTpBtn.TextColor3 = STYLE.TEXT_DARK
        autoTpBtn.BackgroundTransparency = STYLE.ELEMENT_TRANS
    end
end)

-- Fly Mod
local function toggleFly()
    flyEnabled = not flyEnabled
    local c = player.Character
    if flyEnabled then
        flyToggleBtn.Text = "Enabled"; flyToggleBtn.BackgroundColor3 = STYLE.IOS_GREEN
        if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChild("Humanoid") then
            local hrp = c.HumanoidRootPart
            local bg = Instance.new("BodyGyro", hrp); bg.Name = "FlyGyro"; bg.P = 9e4; bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            local bv = Instance.new("BodyVelocity", hrp); bv.Name = "FlyVel"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0,0,0)
            c.Humanoid.PlatformStand = true
        end
    else
        flyToggleBtn.Text = "Enable"; flyToggleBtn.BackgroundColor3 = STYLE.IOS_BLUE
        if c and c:FindFirstChild("HumanoidRootPart") then
            if c.HumanoidRootPart:FindFirstChild("FlyGyro") then c.HumanoidRootPart.FlyGyro:Destroy() end
            if c.HumanoidRootPart:FindFirstChild("FlyVel") then c.HumanoidRootPart.FlyVel:Destroy() end
            if c:FindFirstChild("Humanoid") then c.Humanoid.PlatformStand = false end
        end
    end
end
flyToggleBtn.MouseButton1Click:Connect(toggleFly)

-- Auto Strafe Mod
local function toggleAutoMove()
    autoMoveEnabled = not autoMoveEnabled
    if autoMoveEnabled then
        autoMoveBtn.Text = "Auto Strafe [C]: ON"; autoMoveBtn.BackgroundColor3 = STYLE.IOS_GREEN; autoMoveBtn.TextColor3 = STYLE.TEXT_LIGHT; autoMoveBtn.BackgroundTransparency = 0.1
    else
        autoMoveBtn.Text = "Auto Strafe [C]: OFF"; autoMoveBtn.BackgroundColor3 = STYLE.ELEMENT_BG; autoMoveBtn.TextColor3 = STYLE.TEXT_DARK; autoMoveBtn.BackgroundTransparency = STYLE.ELEMENT_TRANS
    end
end
autoMoveBtn.MouseButton1Click:Connect(toggleAutoMove)

-- ESP Setup
local function updateFilter(groupName, isEnabled)
    itemFilters[groupName] = isEnabled
    if espEnabled and espFolder then
        for _, hl in pairs(espFolder:GetChildren()) do
            if hl.Adornee then
                local clean = getCleanName(hl.Adornee.Name)
                if clean == groupName then
                    hl.Enabled = isEnabled
                    for _, child in pairs(hl:GetChildren()) do
                        if child:IsA("BillboardGui") then child.Enabled = isEnabled end
                    end
                end
            end
        end
    end
end

local function addToDropdown(groupName)
    if detectedGroups[groupName] then return end
    detectedGroups[groupName] = true
    itemFilters[groupName] = true 

    local btn = create("TextButton", { Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = STYLE.IOS_GREEN, BackgroundTransparency = 0.2, Text = groupName, TextColor3 = STYLE.TEXT_LIGHT, Font = Enum.Font.GothamBold, TextSize = 11, AutoButtonColor = false, Parent = scrollFrame })
    addCorner(btn, 4)

    btn.MouseButton1Click:Connect(function()
        local newState = not itemFilters[groupName]
        updateFilter(groupName, newState)
        if newState then
            btn.BackgroundColor3 = STYLE.IOS_GREEN; btn.BackgroundTransparency = 0.2
        else
            btn.BackgroundColor3 = STYLE.IOS_RED; btn.BackgroundTransparency = 0.4
        end
    end)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 10)
end

local function clearESP()
    if espFolder then espFolder:Destroy() end
    espFolder = nil
end

local function addHighlight(target, cleanName, rawName)
    if not espFolder then return end
    local hlName = rawName .. "_ESP_ID_" .. tostring(target:GetDebugId())
    if not espFolder:FindFirstChild(hlName) then
        local hl = Instance.new("Highlight")
        hl.Name = hlName; hl.Adornee = target; hl.FillTransparency = 1; hl.OutlineTransparency = 0; hl.OutlineColor = STYLE.IOS_GREEN
        local show = (itemFilters[cleanName] ~= false)
        hl.Enabled = show; hl.Parent = espFolder
        
        local bb = Instance.new("BillboardGui")
        bb.Name = "NameTag"; bb.Adornee = target; bb.Size = UDim2.new(0, 100, 0, 20); bb.StudsOffset = Vector3.new(0, 2, 0); bb.AlwaysOnTop = true; bb.Enabled = show; bb.Parent = hl
        
        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, 0, 1, 0); txt.BackgroundTransparency = 1; txt.Text = cleanName; txt.TextColor3 = STYLE.TEXT_LIGHT; txt.TextStrokeTransparency = 0; txt.Font = Enum.Font.GothamBold; txt.TextSize = 12; txt.Parent = bb
    end
end

-- Detect Interactables for ESP
local function checkObject(obj)
    if not obj then return end
    if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") then
        local parent = obj.Parent
        if parent then
            local cleanName = getCleanName(parent.Name)
            addToDropdown(cleanName)
            addHighlight(parent, cleanName, parent.Name)
        end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        espBtn.Text = "ON"; espBtn.BackgroundColor3 = STYLE.IOS_GREEN; espBtn.TextColor3 = STYLE.TEXT_LIGHT; espBtn.BackgroundTransparency = 0.1
        clearESP(); espFolder = Instance.new("Folder"); espFolder.Name = "SurviveTheLoopESP"; espFolder.Parent = CoreGui
        
        for _, v in pairs(workspace:GetDescendants()) do checkObject(v) end
        table.insert(connections, workspace.DescendantAdded:Connect(checkObject))
    else
        espBtn.Text = "ESP"; espBtn.BackgroundColor3 = STYLE.ELEMENT_BG; espBtn.TextColor3 = STYLE.TEXT_DARK; espBtn.BackgroundTransparency = STYLE.ELEMENT_TRANS
        clearESP()
    end
end
espBtn.MouseButton1Click:Connect(toggleESP)

dropdownToggleBtn.MouseButton1Click:Connect(function()
    isDropdownOpen = not isDropdownOpen
    if isDropdownOpen then
        dropdownToggleBtn.Text = "Interact Filter  ▴"
        TweenService:Create(dropdownClip, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 120)}):Play()
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 320, 0, OPEN_HEIGHT)}):Play()
    else
        dropdownToggleBtn.Text = "Interact Filter  ▾"
        TweenService:Create(dropdownClip, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 320, 0, BASE_HEIGHT)}):Play()
    end
end)

-- ==========================================
-- INPUT & RENDER LOOP
-- ==========================================
table.insert(connections, flyKeyBox.FocusLost:Connect(function()
    local newKey = stringToKey(flyKeyBox.Text)
    if newKey then flyKey = newKey else flyKeyBox.Text = flyKey.Name end
end))

table.insert(connections, flySpeedBox.FocusLost:Connect(function()
    local num = tonumber(flySpeedBox.Text)
    if num then flySpeed = num else flySpeedBox.Text = tostring(flySpeed) end
end))

table.insert(connections, menuKeyBox.FocusLost:Connect(function()
    local newKey = stringToKey(menuKeyBox.Text)
    if newKey then menuKey = newKey else menuKeyBox.Text = menuKey.Name end
end))

table.insert(connections, UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == menuKey then screenGui.Enabled = not screenGui.Enabled
    elseif input.KeyCode == flyKey then toggleFly()
    elseif input.KeyCode == autoMoveKey then toggleAutoMove() end
end))

table.insert(connections, RunService.RenderStepped:Connect(function(dt)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")

    -- Check Low HP TP (using optimized cached bases)
    if autoTpLowHpEnabled and hum and hrp then
        local hpPercent = (hum.Health / hum.MaxHealth) * 100
        
        if hpPercent <= tpThreshold and not hasTeleportedForLowHp and hum.Health > 0 then
            local success = doSafeTeleport()
            if success then
                hasTeleportedForLowHp = true
            end
        elseif hpPercent > tpThreshold then
            hasTeleportedForLowHp = false
        end
    end

    -- Fly & AutoMove Logic
    if flyEnabled and hrp and hum then
        local bg = hrp:FindFirstChild("FlyGyro")
        local bv = hrp:FindFirstChild("FlyVel")
        if bg and bv then
            local camCF = workspace.CurrentCamera.CFrame
            bg.CFrame = camCF
            local moveDir = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveDir = moveDir + camCF.UpVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir - camCF.UpVector end
            
            if autoMoveEnabled then moveDir = moveDir + (camCF.RightVector * math.sin(tick() * 5)) end
            bv.Velocity = moveDir.Magnitude > 0 and (moveDir.Unit * flySpeed) or Vector3.new(0,0,0)
        end
    elseif autoMoveEnabled and not flyEnabled and hum then
        hum:Move(workspace.CurrentCamera.CFrame.RightVector * math.sin(tick() * 5), false)
    end
end))

-- ==========================================
-- CLOSE / UNLOAD SYSTEM
-- ==========================================
closeBtn.MouseButton1Click:Connect(function() confirmFrame.Visible = true; modalBackdrop.Visible = true end)
confirmNoBtn.MouseButton1Click:Connect(function() confirmFrame.Visible = false; modalBackdrop.Visible = false end)
confirmYesBtn.MouseButton1Click:Connect(function()
    if flyEnabled then toggleFly() end 
    clearESP()
    for _, conn in pairs(connections) do conn:Disconnect() end
    screenGui:Destroy()
    script:Destroy()
end)
