--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
	MODIFIED: Added "Copy Path" to context menu!
]]
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomExplorer"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 250, 0, 400)
mainFrame.Position = UDim2.new(0.6, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40) -- Darker background
mainFrame.BorderSizePixel = 0

local dragBar = Instance.new("Frame")
dragBar.Parent = mainFrame
dragBar.Size = UDim2.new(1, 0, 0, 20)
dragBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50) -- Darker title bar
dragBar.BorderSizePixel = 0
dragBar.Position = UDim2.new(0, 0, 0, 0)

local dragTitle = Instance.new("TextLabel")
dragTitle.Parent = dragBar
dragTitle.Size = UDim2.new(0.8, 0, 1, 0) -- Adjusted for buttons
dragTitle.BackgroundTransparency = 1
dragTitle.Text = "Explorer"
dragTitle.TextColor3 = Color3.fromRGB(200, 200, 210) -- Lighter text
dragTitle.TextSize = 16
dragTitle.Font = Enum.Font.SourceSansBold
dragTitle.TextXAlignment = Enum.TextXAlignment.Center
dragTitle.BorderSizePixel = 0

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Parent = dragBar
minimizeButton.Size = UDim2.new(0, 20, 0, 20)
minimizeButton.Position = UDim2.new(0.9, 0, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60) -- Subtle button color
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 210)
minimizeButton.TextSize = 14
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.BorderSizePixel = 0
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeButton

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Parent = dragBar
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50) -- Red accent for close
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.SourceSansBold
closeButton.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

local explorerFrame = Instance.new("Frame")
explorerFrame.Parent = mainFrame
explorerFrame.Size = UDim2.new(1, 0, 0.7, 0)
explorerFrame.BackgroundTransparency = 1
explorerFrame.Position = UDim2.new(0, 0, 0, 20)

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Parent = explorerFrame
scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollingFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 2)

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

local propertiesFrame = Instance.new("Frame")
propertiesFrame.Parent = mainFrame
propertiesFrame.Size = UDim2.new(1, 0, 0.3, 0)
propertiesFrame.Position = UDim2.new(0, 0, 0.7, 0)
propertiesFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45) -- Slightly lighter dark
propertiesFrame.BorderSizePixel = 0
local propCorner = Instance.new("UICorner")
propCorner.CornerRadius = UDim.new(0, 4)
propCorner.Parent = propertiesFrame

local propertiesDragBar = Instance.new("Frame")
propertiesDragBar.Parent = propertiesFrame
propertiesDragBar.Size = UDim2.new(1, 0, 0, 20)
propertiesDragBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50) -- Matches title bar
propertiesDragBar.BorderSizePixel = 0

local propertiesTitle = Instance.new("TextLabel")
propertiesTitle.Parent = propertiesDragBar
propertiesTitle.Size = UDim2.new(1, 0, 1, 0)
propertiesTitle.BackgroundTransparency = 1
propertiesTitle.Text = "Properties"
propertiesTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
propertiesTitle.TextSize = 14
propertiesTitle.Font = Enum.Font.SourceSansBold
propertiesTitle.TextXAlignment = Enum.TextXAlignment.Center
propertiesTitle.BorderSizePixel = 0

local propertiesSearch = Instance.new("TextBox")
propertiesSearch.Parent = propertiesFrame
propertiesSearch.Size = UDim2.new(1, -10, 0, 25)
propertiesSearch.Position = UDim2.new(0, 5, 0, 25)
propertiesSearch.BackgroundColor3 = Color3.fromRGB(45, 45, 55) -- Darker search box
propertiesSearch.Text = "Search Properties"
propertiesSearch.TextColor3 = Color3.fromRGB(140, 140, 150)
propertiesSearch.TextSize = 14
propertiesSearch.Font = Enum.Font.SourceSans
propertiesSearch.BorderSizePixel = 0
local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 4)
searchCorner.Parent = propertiesSearch

local propertiesScrolling = Instance.new("ScrollingFrame")
propertiesScrolling.Parent = propertiesFrame
propertiesScrolling.Position = UDim2.new(0, 5, 0, 55)
propertiesScrolling.Size = UDim2.new(1, -10, 1, -60)
propertiesScrolling.BackgroundTransparency = 1
propertiesScrolling.BorderSizePixel = 0
propertiesScrolling.ScrollBarThickness = 6
propertiesScrolling.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
propertiesScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)

local propertiesLayout = Instance.new("UIListLayout")
propertiesLayout.Parent = propertiesScrolling
propertiesLayout.SortOrder = Enum.SortOrder.LayoutOrder
propertiesLayout.Padding = UDim.new(0, 2)

propertiesLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    propertiesScrolling.CanvasSize = UDim2.new(0, 0, 0, propertiesLayout.AbsoluteContentSize.Y)
end)

-- Resizing functionality
local resizing
local resizeInput
local resizeStart
local startSize

local resizeHandle = Instance.new("Frame")
resizeHandle.Parent = mainFrame
resizeHandle.Size = UDim2.new(0, 10, 0, 10)
resizeHandle.Position = UDim2.new(1, -10, 1, -10)
resizeHandle.BackgroundColor3 = Color3.fromRGB(50, 50, 60) -- Matches minimize button
resizeHandle.BorderSizePixel = 0
local resizeCorner = Instance.new("UICorner")
resizeCorner.CornerRadius = UDim.new(0, 4)
resizeCorner.Parent = resizeHandle

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        startSize = mainFrame.Size

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
            end
        end)
    end
end)

resizeHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        resizeInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == resizeInput and resizing then
        local delta = input.Position - resizeStart
        local newWidth = math.max(150, startSize.X.Offset + delta.X)
        local newHeight = math.max(200, startSize.Y.Offset + delta.Y)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
        explorerFrame.Size = UDim2.new(1, 0, 0.7, 0)
        propertiesFrame.Size = UDim2.new(1, 0, 0.3, 0)
        propertiesFrame.Position = UDim2.new(0, 0, 0.7, 0)
        resizeHandle.Position = UDim2.new(1, -10, 1, -10)
    end
end)

-- Dragging functionality for main frame
local dragging
local dragInput
local dragStart
local startPos

dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Dragging functionality for properties frame
local propDragging
local propDragInput
local propDragStart
local propStartPos

propertiesDragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        propDragging = true
        propDragStart = input.Position
        propStartPos = propertiesFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                propDragging = false
            end
        end)
    end
end)

propertiesDragBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        propDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == propDragInput and propDragging then
        local delta = input.Position - propDragStart
        local newY = math.max(20, propStartPos.Y.Offset + delta.Y)
        if newY + propertiesFrame.Size.Y.Offset <= mainFrame.Size.Y.Offset then
            propertiesFrame.Position = UDim2.new(0, 0, 0, newY)
            explorerFrame.Size = UDim2.new(1, 0, 0, mainFrame.Size.Y.Offset - propertiesFrame.Size.Y.Offset)
        end
    end
end)

local selectedInstance = nil
local selectedNode = nil
local isMinimized = false

local defaultIcon = "rbxasset://textures/StudioIcon.png"

local function getClassIcon(className)
    -- Map of common classes to their index in the ClassImages spritesheet
    local classIndexes = {
        ["Workspace"] = 19,
        ["Part"] = 1,
        ["Model"] = 2,
        ["Camera"] = 5,
        ["Folder"] = 20,
        ["Frame"] = 48,
        ["TextLabel"] = 49,
        ["TextButton"] = 51,
        ["ImageButton"] = 52,
        ["ImageLabel"] = 46,
        ["TextBox"] = 50,
        ["ScrollingFrame"] = 48, -- Fallback to frame
        ["ScreenGui"] = 47,
        ["BillboardGui"] = 64,
        ["SurfaceGui"] = 64,
        ["LocalScript"] = 18,
        ["Script"] = 6,
        ["ModuleScript"] = 71,
        ["Humanoid"] = 9,
        ["Players"] = 21,
        ["Player"] = 12,
        ["Lighting"] = 13,
        ["ReplicatedStorage"] = 69,
        ["ServerStorage"] = 73,
        ["StarterGui"] = 47,
        ["StarterPack"] = 20,
        ["CoreGui"] = 47,
        ["CorePackages"] = 20,
        ["BindableEvent"] = 67,
        ["BindableFunction"] = 66,
        ["RemoteEvent"] = 80,
        ["RemoteFunction"] = 79,
        ["StringValue"] = 4,
        ["NumberValue"] = 4,
        ["IntValue"] = 4,
        ["BoolValue"] = 4,
        ["ObjectValue"] = 4,
        ["Color3Value"] = 4,
        ["Vector3Value"] = 4,
        ["CFrameValue"] = 4,
        ["RayValue"] = 4,
        ["BrickColorValue"] = 4,
        ["Accessory"] = 32,
        ["Shirt"] = 43,
        ["Pants"] = 44,
        ["Tool"] = 17,
        ["Sound"] = 11,
        ["ParticleEmitter"] = 68,
        ["Fire"] = 61,
        ["Smoke"] = 59,
        ["Sparkles"] = 42,
        ["PointLight"] = 13,
        ["SurfaceLight"] = 13,
        ["SpotLight"] = 13,
        ["Decal"] = 7,
        ["Texture"] = 7,
        ["SpecialMesh"] = 8,
        ["BlockMesh"] = 8,
        ["CylinderMesh"] = 8,
        ["Weld"] = 34,
        ["Motor6D"] = 34,
        ["Configuration"] = 58,
        ["Terrain"] = 65,
        ["Attachment"] = 82,
        ["MaterialService"] = 10,
        ["NetworkClient"] = 9,
        ["ReplicatedFirst"] = 72,
        ["Teams"] = 23,
        ["SoundService"] = 11,
        ["TextChatService"] = 33,
        ["VoiceChatService"] = 84,
        ["LocalizationService"] = 85,
        ["TestService"] = 66,
        ["VRService"] = 101,
    }
    
    local idx = classIndexes[className] or 0 
    return "rbxasset://textures/ClassImages.png", idx
end

local function getClassIconOffset(className)
    -- Deprecated, handled by getClassIcon now
    return Vector2.new(0, 0)
end

-- Context Menu System
local contextMenuGui = Instance.new("ScreenGui")
contextMenuGui.Name = "ContextMenuGui"
contextMenuGui.Parent = playerGui
contextMenuGui.ResetOnSpawn = false
contextMenuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
contextMenuGui.DisplayOrder = 2

local contextMenuFrame = Instance.new("Frame")
contextMenuFrame.Parent = contextMenuGui
-- MODIFIED height for 2 buttons
contextMenuFrame.Size = UDim2.new(0, 150, 0, 60)
contextMenuFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50) -- Matches title bar
contextMenuFrame.BorderSizePixel = 0
contextMenuFrame.Visible = false
local contextCorner = Instance.new("UICorner")
contextCorner.CornerRadius = UDim.new(0, 4)
contextCorner.Parent = contextMenuFrame

local deleteButton = Instance.new("TextButton")
deleteButton.Parent = contextMenuFrame
-- MODIFIED size/position
deleteButton.Size = UDim2.new(1, 0, 0.5, 0)
deleteButton.Position = UDim2.new(0, 0, 0, 0)
deleteButton.BackgroundTransparency = 1
deleteButton.Text = "  Delete"
deleteButton.TextColor3 = Color3.fromRGB(200, 50, 50)
deleteButton.TextSize = 14
deleteButton.Font = Enum.Font.SourceSansBold
deleteButton.BorderSizePixel = 0
deleteButton.ZIndex = 2
deleteButton.TextXAlignment = Enum.TextXAlignment.Left

local deleteIcon = Instance.new("ImageLabel")
deleteIcon.Parent = deleteButton
deleteIcon.Size = UDim2.new(0, 16, 0, 16)
deleteIcon.Position = UDim2.new(0, 4, 0.5, -8)
deleteIcon.Image = "rbxasset://textures/Delete.png"
deleteIcon.BackgroundTransparency = 1
deleteIcon.ZIndex = 2

-- MODIFIED: Added Copy Path Button
local copyPathButton = Instance.new("TextButton")
copyPathButton.Parent = contextMenuFrame
copyPathButton.Size = UDim2.new(1, 0, 0.5, 0)
copyPathButton.Position = UDim2.new(0, 0, 0.5, 0)
copyPathButton.BackgroundTransparency = 1
copyPathButton.Text = "  Copy Path"
copyPathButton.TextColor3 = Color3.fromRGB(200, 200, 210)
copyPathButton.TextSize = 14
copyPathButton.Font = Enum.Font.SourceSansBold
copyPathButton.BorderSizePixel = 0
copyPathButton.ZIndex = 2
copyPathButton.TextXAlignment = Enum.TextXAlignment.Left

-- Use a built-in icon or placeholder for copy
local copyIcon = Instance.new("ImageLabel")
copyIcon.Parent = copyPathButton
copyIcon.Size = UDim2.new(0, 16, 0, 16)
copyIcon.Position = UDim2.new(0, 4, 0.5, -8)
copyIcon.Image = "rbxasset://textures/ui/ImageSet/LuaApp/img_set_1x_1.png"
copyIcon.ImageRectOffset = Vector2.new(206, 362)
copyIcon.ImageRectSize = Vector2.new(24, 24)
copyIcon.BackgroundTransparency = 1
copyIcon.ZIndex = 2

local connections = {}

local function showContextMenu(position, targetInstance)
    print("Attempting to show context menu at:", position.X, position.Y, "Instance:", targetInstance and targetInstance.Name or "nil") -- Debug
    
    -- IMPORTANT FIX: Ensure it shows up exactly where the mouse is
    contextMenuFrame.Position = UDim2.new(0, math.clamp(position.X, 0, screenGui.AbsoluteSize.X - 150), 0, math.clamp(position.Y, 0, screenGui.AbsoluteSize.Y - 60))
    contextMenuFrame.Visible = true
    
    -- Bring to front
    contextMenuGui.DisplayOrder = 9999
    
    selectedInstance = targetInstance

    -- Clean up old connections
    for _, conn in pairs(connections) do
        conn:Disconnect()
    end
    connections = {}

    local deleteConnection = deleteButton.MouseButton1Click:Connect(function()
        if selectedInstance then
            selectedInstance:Destroy()
            contextMenuFrame.Visible = false
            updateProperties()
        end
        for _, conn in pairs(connections) do conn:Disconnect() end
        connections = {}
    end)
    table.insert(connections, deleteConnection)

    local copyConnection = copyPathButton.MouseButton1Click:Connect(function()
        if selectedInstance then
            if setclipboard then
                setclipboard(selectedInstance:GetFullName())
            end
            contextMenuFrame.Visible = false
        end
        for _, conn in pairs(connections) do conn:Disconnect() end
        connections = {}
    end)
    table.insert(connections, copyConnection)

    local closeConnection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Check if we clicked outside the context menu
            local mousePos = input.Position
            local framePos = contextMenuFrame.AbsolutePosition
            local frameSize = contextMenuFrame.AbsoluteSize
            
            if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y then
                contextMenuFrame.Visible = false
                for _, conn in pairs(connections) do conn:Disconnect() end
                connections = {}
            end
        end
    end)
    table.insert(connections, closeConnection)
end

local function updateProperties()
    for _, child in ipairs(propertiesScrolling:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    if not selectedInstance then
        return
    end

    local commonProperties = {
        "Name", "ClassName", "Parent", "Position", "Size", "Transparency", "Color", "Material",
        "Enabled", "Visible", "Anchored", "CanCollide", "Locked", "Orientation", "Rotation",
        "Scale", "Reflectance", "BrickColor", "Shape", "CastShadow", "CollisionGroup",
        "Mass", "Velocity", "AngularVelocity", "AssemblyAngularVelocity", "AssemblyLinearVelocity",
        "AssemblyMass", "AssemblyRootPart", "PivotOffset", "WorldPivot", "CFrame",
        "BackgroundColor3", "BackgroundTransparency", "BorderColor3", "BorderSizePixel",
        "ZIndex", "Active", "AutoLocalize", "ClipsDescendants", "Draggable", "Selectable",
        "Text", "TextColor3", "TextSize", "Font", "TextWrapped", "TextXAlignment", "TextYAlignment"
    }

    for _, propName in ipairs(commonProperties) do
        local row = Instance.new("Frame")
        row.Parent = propertiesScrolling
        row.Size = UDim2.new(1, 0, 0, 25)
        row.BackgroundTransparency = 1

        local propLabel = Instance.new("TextLabel")
        propLabel.Parent = row
        propLabel.Size = UDim2.new(0.5, 0, 1, 0)
        propLabel.BackgroundTransparency = 1
        propLabel.Text = propName
        propLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
        propLabel.TextSize = 14
        propLabel.Font = Enum.Font.SourceSans
        propLabel.TextXAlignment = Enum.TextXAlignment.Left
        propLabel.BorderSizePixel = 0

        local valueBox
        local success, value = pcall(function()
            return selectedInstance[propName]
        end)
        if not success then
            value = "Error"
        end

        if typeof(value) == "boolean" then
            valueBox = Instance.new("TextButton")
            valueBox.Text = value and "✔" or "✖"
            valueBox.TextColor3 = value and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
            valueBox.MouseButton1Click:Connect(function()
                selectedInstance[propName] = not value
                updateProperties()
            end)
        elseif typeof(value) == "string" or typeof(value) == "number" then
            valueBox = Instance.new("TextBox")
            valueBox.Text = tostring(value)
            valueBox.TextColor3 = Color3.fromRGB(200, 200, 210)
            valueBox.TextSize = 14
            valueBox.Font = Enum.Font.SourceSans
            valueBox.TextXAlignment = Enum.TextXAlignment.Left
            valueBox.BorderSizePixel = 0
            if propName == "Name" then
                valueBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        selectedInstance.Name = valueBox.Text
                        updateProperties()
                    end
                end)
            end
        else
            valueBox = Instance.new("TextLabel")
            valueBox.Text = tostring(value)
            valueBox.TextColor3 = Color3.fromRGB(200, 200, 210)
            valueBox.TextSize = 14
            valueBox.Font = Enum.Font.SourceSans
            valueBox.TextXAlignment = Enum.TextXAlignment.Left
        end
        valueBox.Parent = row
        valueBox.Position = UDim2.new(0.5, 0, 0, 0)
        valueBox.Size = UDim2.new(0.5, 0, 1, 0)
        valueBox.BackgroundTransparency = 1
        valueBox.BorderSizePixel = 0
    end
end

local function createNode(instance, parentContainer, depth, parentUpdate)
    depth = depth or 0
    parentUpdate = parentUpdate or function() end

    local nodeFrame = Instance.new("Frame")
    nodeFrame.Parent = parentContainer
    nodeFrame.Size = UDim2.new(1, 0, 0, 18) -- REDUCED from 25
    nodeFrame.BackgroundTransparency = 1
    nodeFrame.BorderSizePixel = 0

    local highlight = Instance.new("Frame")
    highlight.Name = "Highlight"
    highlight.Parent = nodeFrame
    highlight.Size = UDim2.new(1, 0, 1, 0)
    highlight.BackgroundColor3 = Color3.fromRGB(55, 120, 200) -- Studio Blue Selection
    highlight.BackgroundTransparency = 1
    highlight.BorderSizePixel = 0
    highlight.ZIndex = 0

    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, depth * 14 + 2) -- Tighter indentation
    padding.Parent = nodeFrame

    local contentFrame = Instance.new("TextButton")
    contentFrame.Parent = nodeFrame
    contentFrame.Size = UDim2.new(1, 0, 0, 18) -- REDUCED from 25
    contentFrame.BackgroundTransparency = 1
    contentFrame.Text = ""
    contentFrame.ZIndex = 1
    contentFrame.AutoButtonColor = false

    local uiLayout = Instance.new("UIListLayout")
    uiLayout.Parent = contentFrame
    uiLayout.FillDirection = Enum.FillDirection.Horizontal
    uiLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    uiLayout.Padding = UDim.new(0, 4) -- Small gap
    uiLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local expandButton = Instance.new("TextButton")
    expandButton.Parent = contentFrame
    expandButton.Size = UDim2.new(0, 12, 0, 12)
    expandButton.BackgroundTransparency = 1
    expandButton.TextColor3 = Color3.fromRGB(180, 180, 190)
    expandButton.Text = "▶"
    expandButton.Font = Enum.Font.SourceSansBold
    expandButton.TextSize = 10 -- Smaller arrow
    expandButton.BorderSizePixel = 0

    local iconLabel = Instance.new("ImageLabel")
    iconLabel.Parent = contentFrame
    iconLabel.Size = UDim2.new(0, 14, 0, 14) -- 14x14 icon
    iconLabel.BackgroundTransparency = 1
    local iconAsset, iconIdx = getClassIcon(instance.ClassName)
    iconLabel.Image = iconAsset
    
    -- Calculate spritesheet offset
    if iconAsset == "rbxasset://textures/ClassImages.png" then
        iconLabel.ImageRectSize = Vector2.new(16, 16)
        local row = math.floor(iconIdx / 16)
        local col = iconIdx % 16
        iconLabel.ImageRectOffset = Vector2.new(col * 16, row * 16)
    end

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Parent = contentFrame
    nameLabel.Size = UDim2.new(1, -33, 1, 0)
    nameLabel.BackgroundTransparency = 1
    
    local extraTxt = ""
    pcall(function()
        if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
            if instance.Text and instance.Text ~= "" then
                local txt = instance.Text
                -- Clean newlines
                txt = string.gsub(txt, "\n", " ")
                if #txt > 20 then txt = string.sub(txt, 1, 18) .. ".." end
                extraTxt = ' ["' .. txt .. '"]'
            end
        end
    end)
    
    nameLabel.Text = instance.Name .. extraTxt
    nameLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
    nameLabel.TextSize = 13 -- SMALLER FONT
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.SplitWord

    local childrenContainer = Instance.new("Frame")
    childrenContainer.Parent = nodeFrame
    childrenContainer.Position = UDim2.new(0, 0, 0, 18) -- Matches row height
    childrenContainer.Size = UDim2.new(1, 0, 0, 0)
    childrenContainer.BackgroundTransparency = 1
    childrenContainer.Visible = false

    local childrenLayout = Instance.new("UIListLayout")
    childrenLayout.Parent = childrenContainer
    childrenLayout.SortOrder = Enum.SortOrder.LayoutOrder
    childrenLayout.Padding = UDim.new(0, 0) -- NO PADDING between rows for compact look

    local expanded = false
    local loaded = false

    local function updateNodeSize()
        local height = 18 -- Base height
        if expanded then
            height = height + childrenLayout.AbsoluteContentSize.Y
        end
        nodeFrame.Size = UDim2.new(1, 0, 0, height)
        parentUpdate()
    end

    childrenLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateNodeSize)

    contentFrame.MouseButton1Click:Connect(function()
        if selectedNode then
            local prevHighlight = selectedNode:FindFirstChild("Highlight")
            if prevHighlight then
                prevHighlight.BackgroundTransparency = 1
            end
        end
        highlight.BackgroundTransparency = 0.5
        selectedNode = nodeFrame
        selectedInstance = instance
        updateProperties()
    end)

    local isHovering = false
    
    contentFrame.MouseEnter:Connect(function()
        isHovering = true
    end)
    
    contentFrame.MouseLeave:Connect(function()
        isHovering = false
    end)

    -- Detect Right Click while hovering using UserInputService (Bypass MouseButton2Click issues)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if isHovering and input.UserInputType == Enum.UserInputType.MouseButton2 then
            if selectedNode then
                local prevHighlight = selectedNode:FindFirstChild("Highlight")
                if prevHighlight then
                    prevHighlight.BackgroundTransparency = 1
                end
            end
            highlight.BackgroundTransparency = 0.5
            selectedNode = nodeFrame
            selectedInstance = instance
            updateProperties()
            
            -- Show context menu exactly at mouse click position
            showContextMenu(input.Position, selectedInstance)
        end
    end)

    expandButton.MouseButton1Click:Connect(function()
        expanded = not expanded
        childrenContainer.Visible = expanded
        expandButton.Text = expanded and "▼" or "▶"

        if expanded and not loaded then
            loaded = true
            local children = instance:GetChildren()
            table.sort(children, function(a, b)
                return a.Name < b.Name
            end)
            for _, child in ipairs(children) do
                createNode(child, childrenContainer, depth + 1, updateNodeSize)
            end
        end

        updateNodeSize()
    end)

    if #instance:GetChildren() == 0 then
        expandButton.Visible = false
        nameLabel.Size = UDim2.new(1, -18, 1, 0)
    end

    return nodeFrame
end

local services = {
    game.Players,
    game.CoreGui,
    game.Lighting,
    game.ReplicatedStorage,
    game.StarterGui,
    game.Workspace
}
table.sort(services, function(a, b)
    return a.Name < b.Name
end)

for _, service in ipairs(services) do
    createNode(service, scrollingFrame, 0, function()
        listLayout:ApplyLayout()
    end)
end

local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
    if contextMenuFrame.Visible then
        contextMenuFrame.Visible = false
        for _, conn in pairs(connections) do
            conn:Disconnect()
        end
        connections = {}
    end
end)

-- Minimize Functionality
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local function toggleMinimize()
    if isMinimized then
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 250, 0, 400)})
        tween:Play()
        explorerFrame.Visible = true
        propertiesFrame.Visible = true
        resizeHandle.Visible = true
    else
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 250, 0, 20)})
        tween:Play()
        explorerFrame.Visible = false
        propertiesFrame.Visible = false
        resizeHandle.Visible = false
    end
    isMinimized = not isMinimized
end

minimizeButton.MouseButton1Click:Connect(toggleMinimize)

-- Close Functionality
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
