local SkenaUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local parentUI = nil
if pcall(function() return CoreGui.RobloxGui end) then
    parentUI = CoreGui
else
    parentUI = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function LoadLucideIcons()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/src/Icons.lua"))()
    end)
    if success and result and result.assets then
        return result.assets
    end
    return {}
end
local LucideIcons = LoadLucideIcons()

-- Windows 11 Dark Mode Palette
local Palette = {
    Background = Color3.fromRGB(32, 32, 32),
    Sidebar = Color3.fromRGB(32, 32, 32),
    Card = Color3.fromRGB(39, 39, 39),
    RowItem = Color3.fromRGB(45, 45, 45),
    RowHover = Color3.fromRGB(55, 55, 55),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    Accent = Color3.fromRGB(76, 194, 255), -- Windows 11 Blue
    AccentDark = Color3.fromRGB(50, 150, 210),
    Border = Color3.fromRGB(60, 60, 60),
    RedHover = Color3.fromRGB(232, 17, 35),
    InputHdr = Color3.fromRGB(25, 25, 25)
}

function SkenaUI:CreateWindow(Options)
    Options = Options or {}
    local WindowName = Options.Name or "SkenaHub"
    
    if parentUI:FindFirstChild("SkenaHub_UI") then
        parentUI.SkenaHub_UI:Destroy()
    end

    local SG = Instance.new("ScreenGui")
    SG.Name = "SkenaHub_UI"
    SG.Parent = parentUI
    SG.ResetOnSpawn = false

    local WindowObj = {
        CurrentTab = nil,
        Tabs = {},
        ToggleKey = Enum.KeyCode.Z
    }

    -- Global shortcut to toggle UI
    local uiToggleConnection
    uiToggleConnection = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == WindowObj.ToggleKey then
            SG.Enabled = not SG.Enabled
        end
    end)
    
    -- When SG is destroyed, cleanup Toggle shortcut
    SG.Destroying:Connect(function()
        if uiToggleConnection then uiToggleConnection:Disconnect() end
    end)
    
    local DragFrame = Instance.new("Frame", SG)
    DragFrame.Name = "DragFrame"
    DragFrame.Size = UDim2.new(0, 450, 0, 50) 
    DragFrame.Position = UDim2.new(0.5, -225, 0.4, 0)
    DragFrame.BackgroundTransparency = 1
    DragFrame.Active = true

    local Main = Instance.new("Frame", DragFrame)
    Main.Name = "Main"
    Main.Size = UDim2.new(1, 0, 0, 0) 
    Main.AutomaticSize = Enum.AutomaticSize.Y 
    Main.BackgroundColor3 = Palette.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 8)
    
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Palette.Border
    MainStroke.Thickness = 1

    -- Drag Logic
    local dragging, dragInput, dragStart, startPos
    DragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = DragFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    DragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            DragFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Top Area (Title Bar Controls)
    local TitleBar = Instance.new("Frame", Main)
    TitleBar.Size = UDim2.new(1, 0, 0, 32)
    TitleBar.BackgroundTransparency = 1

    local TitleText = Instance.new("TextLabel", TitleBar)
    TitleText.Size = UDim2.new(1, -100, 1, 0)
    TitleText.Position = UDim2.new(0, 12, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = WindowName
    TitleText.Font = Enum.Font.BuilderSans
    TitleText.TextSize = 12
    TitleText.TextColor3 = Palette.TextSecondary
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    WindowObj.TitleText = TitleText

    local ControlContainer = Instance.new("Frame", TitleBar)
    ControlContainer.Size = UDim2.new(0, 92, 1, 0)
    ControlContainer.Position = UDim2.new(1, -92, 0, 0)
    ControlContainer.BackgroundTransparency = 1

    -- Seamless window buttons
    local Minibtn = Instance.new("TextButton", ControlContainer)
    Minibtn.Size = UDim2.new(0, 46, 1, 0)
    Minibtn.Position = UDim2.new(0, 0, 0, 0)
    Minibtn.Text = "–"
    Minibtn.BackgroundColor3 = Palette.Background
    Minibtn.BackgroundTransparency = 1
    Minibtn.TextColor3 = Palette.TextPrimary
    Minibtn.Font = Enum.Font.Gotham
    Minibtn.TextSize = 14
    Minibtn.BorderSizePixel = 0

    local CloseBtn = Instance.new("TextButton", ControlContainer)
    CloseBtn.Size = UDim2.new(0, 46, 1, 0)
    CloseBtn.Position = UDim2.new(0, 46, 0, 0)
    CloseBtn.Text = "✕"
    CloseBtn.BackgroundColor3 = Palette.Background
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.TextColor3 = Palette.TextPrimary
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.TextSize = 14
    CloseBtn.BorderSizePixel = 0

    -- Hover logic for window controls
    Minibtn.MouseEnter:Connect(function() Minibtn.BackgroundTransparency = 0; Minibtn.BackgroundColor3 = Palette.RowHover end)
    Minibtn.MouseLeave:Connect(function() Minibtn.BackgroundTransparency = 1 end)
    CloseBtn.MouseEnter:Connect(function() CloseBtn.BackgroundTransparency = 0; CloseBtn.BackgroundColor3 = Palette.RedHover end)
    CloseBtn.MouseLeave:Connect(function() CloseBtn.BackgroundTransparency = 1 end)

    local isMinimized = false
    Minibtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        Main.ClipsDescendants = true
        for _, ch in pairs(Main:GetChildren()) do
            if ch ~= TitleBar and ch.Name ~= "UICorner" and ch.Name ~= "UIStroke" then
                ch.Visible = not isMinimized
            end
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function() SG:Destroy() end)

    -- Under Title Bar
    local BodyFrame = Instance.new("Frame", Main)
    BodyFrame.Size = UDim2.new(1, 0, 0, 5) 
    BodyFrame.Position = UDim2.new(0, 0, 0, 32)
    BodyFrame.AutomaticSize = Enum.AutomaticSize.Y
    BodyFrame.BackgroundTransparency = 1
    
    local BodyPadding = Instance.new("UIPadding", BodyFrame)
    BodyPadding.PaddingBottom = UDim.new(0, 8)

    -- Sidebar (Left)
    local Sidebar = Instance.new("Frame", BodyFrame)
    Sidebar.Size = UDim2.new(0, 45, 1, 0)
    Sidebar.Position = UDim2.new(0, 5, 0, 0)
    Sidebar.BackgroundTransparency = 1

    local SidebarTop = Instance.new("Frame", Sidebar)
    SidebarTop.Size = UDim2.new(1, 0, 0, 0)
    SidebarTop.AutomaticSize = Enum.AutomaticSize.Y
    SidebarTop.BackgroundTransparency = 1
    local STLayout = Instance.new("UIListLayout", SidebarTop)
    STLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    STLayout.SortOrder = Enum.SortOrder.LayoutOrder
    STLayout.Padding = UDim.new(0, 8)

    local SidebarBottom = Instance.new("Frame", Sidebar)
    SidebarBottom.Size = UDim2.new(1, 0, 1, 0)
    SidebarBottom.BackgroundTransparency = 1
    local SBLayout = Instance.new("UIListLayout", SidebarBottom)
    SBLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SBLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    SBLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SBLayout.Padding = UDim.new(0, 8)

    -- Inner Card (Right)
    local Card = Instance.new("Frame", BodyFrame)
    Card.Size = UDim2.new(1, -60, 0, 0) 
    Card.Position = UDim2.new(0, 55, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Palette.Card
    Card.BorderSizePixel = 0

    local CardCorner = Instance.new("UICorner", Card)
    CardCorner.CornerRadius = UDim.new(0, 8)
    
    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = Palette.Border
    CardStroke.Thickness = 1
    
    local CardPadding = Instance.new("UIPadding", Card)
    CardPadding.PaddingTop = UDim.new(0, 8)
    CardPadding.PaddingBottom = UDim.new(0, 8)
    CardPadding.PaddingLeft = UDim.new(0, 8)
    CardPadding.PaddingRight = UDim.new(0, 8)

    local TabContainer = Instance.new("Folder", Card)
    TabContainer.Name = "Tabs"
    
    local function CreateTabButton(TabName, IconID, isSettings)
        local TabBtn = Instance.new("TextButton", isSettings and SidebarBottom or SidebarTop)
        TabBtn.Size = UDim2.new(0, 36, 0, 36)
        TabBtn.BackgroundColor3 = Palette.RowHover
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        local TabIcon = Instance.new("ImageLabel", TabBtn)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0.5, -10, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        
        local finalImage = ""
        if type(IconID) == "string" then
            local checkKey = "lucide-" .. IconID
            if LucideIcons[checkKey] then
                finalImage = LucideIcons[checkKey]
            elseif LucideIcons[IconID] then
                finalImage = LucideIcons[IconID]
            else
                finalImage = "rbxassetid://10709798174" -- Circle Fallback
            end
        else
            finalImage = "rbxassetid://" .. tostring(IconID)
        end
        
        TabIcon.Image = finalImage
        TabIcon.ImageColor3 = Palette.TextSecondary
        
        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.Size = UDim2.new(0, 3, 0, 16)
        Indicator.Position = UDim2.new(0, 0, 0.5, -8)
        Indicator.BackgroundColor3 = Palette.Accent
        Indicator.BorderSizePixel = 0
        Indicator.Visible = false
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

        TabBtn.MouseEnter:Connect(function()
            if WindowObj.CurrentTab ~= TabName then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if WindowObj.CurrentTab ~= TabName then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end
        end)

        return TabBtn, TabIcon, Indicator
    end

    function WindowObj:CreateTab(TabName, IconID, isSettings)
        local TabData = {}
        
        local TabBtn, TabIcon, Indicator = CreateTabButton(TabName, IconID, isSettings)

        local Page = Instance.new("Frame", TabContainer)
        Page.Size = UDim2.new(1, 0, 0, 0)
        Page.AutomaticSize = Enum.AutomaticSize.Y
        Page.BackgroundTransparency = 1
        Page.Visible = false
        
        local PLayout = Instance.new("UIListLayout", Page)
        PLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PLayout.Padding = UDim.new(0, 4)

        WindowObj.Tabs[TabName] = { Button = TabBtn, Icon = TabIcon, Indicator = Indicator, Page = Page }
        
        TabBtn.MouseButton1Click:Connect(function() WindowObj:SelectTab(TabName) end)

        if not WindowObj.CurrentTab then WindowObj:SelectTab(TabName) end

        -- Header within Tab
        local Header = Instance.new("TextLabel", Page)
        Header.Size = UDim2.new(1, 0, 0, 36)
        Header.BackgroundTransparency = 1
        Header.Text = TabName
        Header.Font = Enum.Font.BuilderSansBold
        Header.TextSize = 20
        Header.TextColor3 = Palette.TextPrimary
        Header.TextXAlignment = Enum.TextXAlignment.Left

        -- Utility to add a generic Row Container
        local function AddRowContainer()
            local Row = Instance.new("Frame", Page)
            Row.Size = UDim2.new(1, 0, 0, 44)
            Row.BackgroundColor3 = Palette.RowItem
            Row.BorderSizePixel = 0
            Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)
            local Stroke = Instance.new("UIStroke", Row)
            Stroke.Color = Palette.Border
            Stroke.Thickness = 1
            return Row
        end

        function TabData:CreateToggleRow(Options)
            local Title = Options.Name or "Toggle"
            local cbToggle = Options.OnToggle or function() end
            
            local Row = AddRowContainer()
            
            local Txt = Instance.new("TextLabel", Row)
            Txt.Size = UDim2.new(0.4, 0, 1, 0)
            Txt.Position = UDim2.new(0, 12, 0, 0)
            Txt.BackgroundTransparency = 1
            Txt.Text = Title
            Txt.Font = Enum.Font.GothamMedium
            Txt.TextSize = 13
            Txt.TextColor3 = Palette.TextPrimary
            Txt.TextXAlignment = Enum.TextXAlignment.Left

            local RightContainer = Instance.new("Frame", Row)
            RightContainer.Size = UDim2.new(0.6, -12, 1, 0)
            RightContainer.Position = UDim2.new(0.4, 0, 0, 0)
            RightContainer.BackgroundTransparency = 1
            local RCLayout = Instance.new("UIListLayout", RightContainer)
            RCLayout.FillDirection = Enum.FillDirection.Horizontal
            RCLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            RCLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            RCLayout.Padding = UDim.new(0, 8)
            RCLayout.SortOrder = Enum.SortOrder.LayoutOrder

            -- Toggle Button
            local ToggleBg = Instance.new("TextButton", RightContainer)
            ToggleBg.Size = UDim2.new(0, 44, 0, 22)
            ToggleBg.BackgroundColor3 = Palette.InputHdr
            ToggleBg.Text = ""
            ToggleBg.AutoButtonColor = false
            ToggleBg.LayoutOrder = 10
            Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)
            local TStroke = Instance.new("UIStroke", ToggleBg)
            TStroke.Color = Palette.Border
            TStroke.Thickness = 1

            local Knob = Instance.new("Frame", ToggleBg)
            Knob.Size = UDim2.new(0, 14, 0, 14)
            Knob.Position = UDim2.new(0, 4, 0.5, -7)
            Knob.BackgroundColor3 = Palette.TextSecondary
            Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

            local state = false

            local function UpdateToggleRender(noAnim)
                local targetColor = state and Palette.Accent or Palette.InputHdr
                local knobColor = state and Color3.fromRGB(0,0,0) or Palette.TextSecondary
                local knobPos = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)
                
                if noAnim then
                    ToggleBg.BackgroundColor3 = targetColor
                    Knob.BackgroundColor3 = knobColor
                    Knob.Position = knobPos
                else
                    TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {BackgroundColor3 = knobColor, Position = knobPos}):Play()
                end
            end

            ToggleBg.MouseButton1Click:Connect(function()
                state = not state
                UpdateToggleRender(false)
                pcall(cbToggle, state)
            end)

            local function attachTextBox(placeholder, defaultVal, callback, width, layoutOrder, prefix)
                local container = Instance.new("Frame", RightContainer)
                container.BackgroundTransparency = 1
                container.LayoutOrder = layoutOrder
                local UIList = Instance.new("UIListLayout", container)
                UIList.FillDirection = Enum.FillDirection.Horizontal
                UIList.VerticalAlignment = Enum.VerticalAlignment.Center
                UIList.Padding = UDim.new(0, 4)

                if prefix then
                    local lbl = Instance.new("TextLabel", container)
                    lbl.BackgroundTransparency = 1
                    lbl.Size = UDim2.new(0, 0, 0, 24)
                    lbl.AutomaticSize = Enum.AutomaticSize.X
                    lbl.Text = prefix
                    lbl.Font = Enum.Font.Gotham
                    lbl.TextSize = 12
                    lbl.TextColor3 = Palette.TextSecondary
                end

                local Box = Instance.new("TextBox", container)
                Box.Size = UDim2.new(0, width, 0, 24)
                Box.BackgroundColor3 = Palette.InputHdr
                Box.Text = tostring(defaultVal or "")
                Box.PlaceholderText = placeholder
                Box.TextColor3 = Palette.TextPrimary
                Box.Font = Enum.Font.GothamMedium
                Box.TextSize = 12
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
                local BStroke = Instance.new("UIStroke", Box)
                BStroke.Color = Palette.Border
                BStroke.Thickness = 1
                
                Box.FocusLost:Connect(function()
                    pcall(callback, Box.Text)
                end)
                container.Size = UDim2.new(0, 0, 0, 24)
                container.AutomaticSize = Enum.AutomaticSize.X
                return Box
            end

            local out = { ToggleState = function(s) state=s; UpdateToggleRender(true) end }
            
            if Options.HasKey then
                out.KeyBox = attachTextBox("Key", Options.DefaultKey, Options.OnKeyChange, 30, 9, nil)
            end
            if Options.HasSpeed then
                out.SpeedBox = attachTextBox("Spd", Options.DefaultSpeed, Options.OnSpeedChange, 40, 8, "Speed")
            end

            return out
        end

        function TabData:CreateSliderRow(Options)
            local Title = Options.Name or "Slider"
            local Min = Options.Min or 0
            local Max = Options.Max or 100
            local Default = Options.Default or 50
            local Prefix = Options.Prefix or ""
            local Suffix = Options.Suffix or "%"
            local cb = Options.Callback or function() end

            local Row = AddRowContainer()

            local Txt = Instance.new("TextLabel", Row)
            Txt.Size = UDim2.new(0.3, 0, 1, 0)
            Txt.Position = UDim2.new(0, 12, 0, 0)
            Txt.BackgroundTransparency = 1
            Txt.Text = Title
            Txt.Font = Enum.Font.GothamMedium
            Txt.TextSize = 13
            Txt.TextColor3 = Palette.TextPrimary
            Txt.TextXAlignment = Enum.TextXAlignment.Left

            local RightContainer = Instance.new("Frame", Row)
            RightContainer.Size = UDim2.new(0.7, -12, 1, 0)
            RightContainer.Position = UDim2.new(0.3, 0, 0, 0)
            RightContainer.BackgroundTransparency = 1

            local ValTxt = Instance.new("TextLabel", RightContainer)
            ValTxt.Size = UDim2.new(0, 40, 1, 0)
            ValTxt.Position = UDim2.new(0, 0, 0, 0)
            ValTxt.BackgroundTransparency = 1
            ValTxt.Text = Prefix .. tostring(Default) .. Suffix
            ValTxt.Font = Enum.Font.GothamMedium
            ValTxt.TextSize = 12
            ValTxt.TextColor3 = Palette.TextSecondary
            ValTxt.TextXAlignment = Enum.TextXAlignment.Right

            -- iOS style slider
            local SlideBg = Instance.new("TextButton", RightContainer)
            SlideBg.Size = UDim2.new(1, -50, 0, 6)
            SlideBg.Position = UDim2.new(0, 50, 0.5, -3)
            SlideBg.BackgroundColor3 = Palette.InputHdr
            SlideBg.Text = ""
            SlideBg.AutoButtonColor = false
            Instance.new("UICorner", SlideBg).CornerRadius = UDim.new(1,0)
            local SStroke = Instance.new("UIStroke", SlideBg)
            SStroke.Color = Palette.Border
            SStroke.Thickness = 1

            local SlideFill = Instance.new("Frame", SlideBg)
            SlideFill.Size = UDim2.new((Default-Min)/(Max-Min), 0, 1, 0)
            SlideFill.BackgroundColor3 = Palette.TextPrimary
            Instance.new("UICorner", SlideFill).CornerRadius = UDim.new(1,0)

            local dragging = false
            local function update(input)
                local relX = math.clamp(input.Position.X - SlideBg.AbsolutePosition.X, 0, SlideBg.AbsoluteSize.X)
                local pct = relX / SlideBg.AbsoluteSize.X
                local val = math.floor(Min + (pct * (Max-Min)))
                SlideFill.Size = UDim2.new(pct, 0, 1, 0)
                ValTxt.Text = Prefix .. tostring(val) .. Suffix
                pcall(cb, val)
            end

            SlideBg.InputBegan:Connect(function(input) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true; update(input) end 
            end)
            UserInputService.InputEnded:Connect(function(input) 
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end 
            end)
            UserInputService.InputChanged:Connect(function(input) 
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end 
            end)
        end

        function TabData:CreateButtonRow(Options)
            local Title = Options.Name or "Action"
            local BtnText = Options.ButtonText or "Execute"
            local cb = Options.Callback or function() end

            local Row = AddRowContainer()

            local Txt = Instance.new("TextLabel", Row)
            Txt.Size = UDim2.new(0.6, 0, 1, 0)
            Txt.Position = UDim2.new(0, 12, 0, 0)
            Txt.BackgroundTransparency = 1
            Txt.Text = Title
            Txt.Font = Enum.Font.GothamMedium
            Txt.TextSize = 13
            Txt.TextColor3 = Palette.TextPrimary
            Txt.TextXAlignment = Enum.TextXAlignment.Left

            local ExecBtn = Instance.new("TextButton", Row)
            ExecBtn.Size = UDim2.new(0, 80, 0, 24)
            ExecBtn.Position = UDim2.new(1, -92, 0.5, -12)
            ExecBtn.BackgroundColor3 = Palette.InputHdr
            ExecBtn.Text = BtnText
            ExecBtn.TextColor3 = Palette.TextPrimary
            ExecBtn.Font = Enum.Font.GothamMedium
            ExecBtn.TextSize = 12
            ExecBtn.AutoButtonColor = false
            Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 4)
            local BStroke = Instance.new("UIStroke", ExecBtn)
            BStroke.Color = Palette.Border
            BStroke.Thickness = 1

            ExecBtn.MouseEnter:Connect(function() TweenService:Create(ExecBtn, TweenInfo.new(0.2), {BackgroundColor3 = Palette.RowHover}):Play() end)
            ExecBtn.MouseLeave:Connect(function() TweenService:Create(ExecBtn, TweenInfo.new(0.2), {BackgroundColor3 = Palette.InputHdr}):Play() end)
            ExecBtn.MouseButton1Click:Connect(function() pcall(cb) end)
        end

        function TabData:CreateInputRow(Options)
            local Title = Options.Name or "Input"
            local Placeholder = Options.Placeholder or ""
            local Default = Options.Default or ""
            local cb = Options.Callback or function() end

            local Row = AddRowContainer()

            local Txt = Instance.new("TextLabel", Row)
            Txt.Size = UDim2.new(0.6, 0, 1, 0)
            Txt.Position = UDim2.new(0, 12, 0, 0)
            Txt.BackgroundTransparency = 1
            Txt.Text = Title
            Txt.Font = Enum.Font.GothamMedium
            Txt.TextSize = 13
            Txt.TextColor3 = Palette.TextPrimary
            Txt.TextXAlignment = Enum.TextXAlignment.Left

            local Box = Instance.new("TextBox", Row)
            Box.Size = UDim2.new(0, 80, 0, 24)
            Box.Position = UDim2.new(1, -92, 0.5, -12)
            Box.BackgroundColor3 = Palette.InputHdr
            Box.Text = tostring(Default)
            Box.PlaceholderText = Placeholder
            Box.TextColor3 = Palette.TextPrimary
            Box.Font = Enum.Font.GothamMedium
            Box.TextSize = 12
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
            local BStroke = Instance.new("UIStroke", Box)
            BStroke.Color = Palette.Border
            BStroke.Thickness = 1

            Box.FocusLost:Connect(function()
                pcall(cb, Box.Text)
            end)
        end

        return TabData
    end
    
    function WindowObj:SelectTab(TabName)
        WindowObj.CurrentTab = TabName
        for name, data in pairs(WindowObj.Tabs) do
            if name == TabName then
                data.Page.Visible = true
                data.Indicator.Visible = true
                data.Icon.ImageColor3 = Palette.Accent
                data.Button.BackgroundTransparency = 0
            else
                data.Page.Visible = false
                data.Indicator.Visible = false
                data.Icon.ImageColor3 = Palette.TextSecondary
                data.Button.BackgroundTransparency = 1
            end
        end
    end

    function WindowObj:SetToggleKey(KeycodeStr)
        local kc = Enum.KeyCode[string.upper(KeycodeStr)]
        if kc then WindowObj.ToggleKey = kc end
    end

    function WindowObj:SetTitle(NewTitle)
        if WindowObj.TitleText then
            WindowObj.TitleText.Text = tostring(NewTitle)
        end
    end
    
    return WindowObj
end

return SkenaUI
