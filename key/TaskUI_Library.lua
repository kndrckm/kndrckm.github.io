local TaskManagerUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local parentUI = nil
if pcall(function() return CoreGui.RobloxGui end) then
    parentUI = CoreGui
else
    parentUI = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

function TaskManagerUI:CreateWindow(Options)
    Options = Options or {}
    local WindowName = Options.Name or "Task Manager"
    
    -- Destroy old instances to prevent overlapping if re-executed
    if parentUI:FindFirstChild("SulisUI") then
        parentUI.SulisUI:Destroy()
    end

    local SG = Instance.new("ScreenGui")
    SG.Name = "SulisUI"
    SG.Parent = parentUI
    SG.ResetOnSpawn = false
    
    -- Frame Wrapper untuk drag dan animasi Minimize/Hide
    local DragFrame = Instance.new("Frame", SG)
    DragFrame.Name = "DragFrame"
    DragFrame.Size = UDim2.new(0, 360, 0, 50) -- Lebar sesuai kebutuhan (Sidebar 50 + Card 310)
    DragFrame.Position = UDim2.new(0.5, -180, 0.4, 0)
    DragFrame.BackgroundTransparency = 1
    DragFrame.Active = true

    -- Main Container (Yang menyesuaikan tinggi konten)
    local Main = Instance.new("Frame", DragFrame)
    Main.Name = "Main"
    Main.Size = UDim2.new(1, 0, 0, 0) 
    Main.AutomaticSize = Enum.AutomaticSize.Y -- Tinggi fleksibel ke bawah
    Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Main.BackgroundTransparency = 0.3 -- Transparansi 30%
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 10)

    -- Efek Gradasi Biru ke Ungu
    local Gradient = Instance.new("UIGradient", Main)
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 85, 255)), -- Blue
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 0, 255)) -- Purple
    }
    Gradient.Rotation = 45

    -- Drag Script Logic
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
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundTransparency = 1

    local TitleText = Instance.new("TextLabel", TitleBar)
    TitleText.Size = UDim2.new(1, -90, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = WindowName
    TitleText.Font = Enum.Font.BuilderSansBold
    TitleText.TextSize = 16
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextXAlignment = Enum.TextXAlignment.Left

    -- Tombol Minimize/Toggle
    local Minibtn = Instance.new("TextButton", TitleBar)
    Minibtn.Size = UDim2.new(0, 30, 0, 30)
    Minibtn.Position = UDim2.new(1, -75, 0, 5)
    Minibtn.Text = "_"
    Minibtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Minibtn.BackgroundTransparency = 0.8
    Minibtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minibtn.Font = Enum.Font.GothamBold
    Minibtn.TextSize = 16
    Instance.new("UICorner", Minibtn).CornerRadius = UDim.new(1, 0)

    -- Tombol Close/Destroy
    local CloseBtn = Instance.new("TextButton", TitleBar)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 5)
    CloseBtn.Text = "X"
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseBtn.BackgroundTransparency = 0.2
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)

    local isMinimized = false
    Minibtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        Main.ClipsDescendants = true
        if isMinimized then
            -- Animasi menghilangkan konten
            for _, ch in pairs(Main:GetChildren()) do
                if ch.Name ~= "UIGradient" and ch.Name ~= "UICorner" and ch ~= TitleBar then
                    ch.Visible = false
                end
            end
        else
            for _, ch in pairs(Main:GetChildren()) do
                if ch.Name ~= "UIGradient" and ch.Name ~= "UICorner" and ch ~= TitleBar then
                    ch.Visible = true
                end
            end
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        SG:Destroy()
    end)
    
    -- Global shortcut Z to toggle UI
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.Z then
            SG.Enabled = not SG.Enabled
        end
    end)

    -- Wrapper Di Bawah Title Bar
    local BodyFrame = Instance.new("Frame", Main)
    BodyFrame.Size = UDim2.new(1, 0, 0, 5) 
    BodyFrame.Position = UDim2.new(0, 0, 0, 40)
    BodyFrame.AutomaticSize = Enum.AutomaticSize.Y
    BodyFrame.BackgroundTransparency = 1
    
    local BodyPadding = Instance.new("UIPadding", BodyFrame)
    BodyPadding.PaddingBottom = UDim.new(0, 10)

    -- Sidebar / Tab List (Kiri)
    local Sidebar = Instance.new("Frame", BodyFrame)
    Sidebar.Size = UDim2.new(0, 45, 1, 0)
    Sidebar.Position = UDim2.new(0, 5, 0, 0)
    Sidebar.BackgroundTransparency = 1
    
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 8)

    -- Inner Card (Kanan)
    local Card = Instance.new("Frame", BodyFrame)
    Card.Size = UDim2.new(1, -60, 0, 0) 
    Card.Position = UDim2.new(0, 55, 0, 0)
    Card.AutomaticSize = Enum.AutomaticSize.Y
    Card.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
    Card.BackgroundTransparency = 0.1
    Card.BorderSizePixel = 0

    local CardCorner = Instance.new("UICorner", Card)
    CardCorner.CornerRadius = UDim.new(0, 12)
    
    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = Color3.fromRGB(255, 255, 255)
    CardStroke.Transparency = 0.5
    CardStroke.Thickness = 1
    
    local CardPadding = Instance.new("UIPadding", Card)
    CardPadding.PaddingTop = UDim.new(0, 8)
    CardPadding.PaddingBottom = UDim.new(0, 8)
    CardPadding.PaddingLeft = UDim.new(0, 8)
    CardPadding.PaddingRight = UDim.new(0, 8)

    local TabContainer = Instance.new("Folder", Card)
    TabContainer.Name = "Tabs"

    -- Window API / Obj
    local Window = { CurrentTab = nil, Tabs = {} }
    
    function Window:CreateTab(TabName, IconID)
        local TabData = {}
        
        -- Tombol Sidebar
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0, 36, 0, 36)
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
        
        local TabIcon = Instance.new("ImageLabel", TabBtn)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0.5, -10, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxassetid://" .. tostring(IconID)
        TabIcon.ImageColor3 = Color3.fromRGB(230, 230, 230)
        
        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.Size = UDim2.new(0, 3, 0, 16)
        Indicator.Position = UDim2.new(0, 0, 0.5, -8)
        Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Indicator.BorderSizePixel = 0
        Indicator.Visible = false
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
        
        -- Container Item di dalam Tab card (Flex Height)
        local Page = Instance.new("Frame", TabContainer)
        Page.Size = UDim2.new(1, 0, 0, 0)
        Page.AutomaticSize = Enum.AutomaticSize.Y
        Page.BackgroundTransparency = 1
        Page.Visible = false
        
        local PLayout = Instance.new("UIListLayout", Page)
        PLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PLayout.Padding = UDim.new(0, 6)

        Window.Tabs[TabName] = { Button = TabBtn, Icon = TabIcon, Indicator = Indicator, Page = Page }
        
        TabBtn.MouseButton1Click:Connect(function() Window:SelectTab(TabName) end)

        if not Window.CurrentTab then Window:SelectTab(TabName) end
        
        -- 1. Create Default Button Row
        function TabData:CreateButton(BtnOptions)
            local bName = BtnOptions.Name or "Button"
            local bCallback = BtnOptions.Callback or function() end
            
            local Btn = Instance.new("TextButton", Page)
            Btn.Size = UDim2.new(1, 0, 0, 34)
            Btn.BackgroundColor3 = Color3.fromRGB(225, 230, 240)
            Btn.Text = bName
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 13
            Btn.TextColor3 = Color3.fromRGB(30, 30, 30)
            Btn.AutoButtonColor = false
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
            
            Btn.MouseButton1Click:Connect(function() pcall(bCallback) end)
            Btn.MouseEnter:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 210, 255)}):Play() end)
            Btn.MouseLeave:Connect(function() TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(225, 230, 240)}):Play() end)
            
            return Btn
        end

        -- 2. Create Layout Baris Kompleks (Label + Toggle + Tombol + TextBox) -> Mirip Fly Mod
        function TabData:CreateAdvancedRow(Options)
            local rName = Options.Name or "Feature"
            local cbToggle = Options.OnToggle or function() end
            local cbKey = Options.OnKeyChange or function() end
            local cbSpd = Options.OnSpeedChange or function() end
            
            local Row = Instance.new("Frame", Page)
            Row.Size = UDim2.new(1, 0, 0, 36)
            Row.BackgroundTransparency = 1

            local Txt = Instance.new("TextLabel", Row)
            Txt.Size = UDim2.new(0, 70, 1, 0)
            Txt.Position = UDim2.new(0, 5, 0, 0)
            Txt.BackgroundTransparency = 1
            Txt.Text = rName
            Txt.Font = Enum.Font.GothamBold
            Txt.TextSize = 12
            Txt.TextColor3 = Color3.fromRGB(50, 50, 50)
            Txt.TextXAlignment = Enum.TextXAlignment.Left

            -- Toggle Btn
            local tBtn = Instance.new("TextButton", Row)
            tBtn.Size = UDim2.new(0, 95, 0, 26)
            tBtn.Position = UDim2.new(0, 80, 0.5, -13)
            tBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
            tBtn.Text = "Enable"
            tBtn.TextColor3 = Color3.fromRGB(255,255,255)
            tBtn.Font = Enum.Font.GothamBold
            tBtn.TextSize = 12
            tBtn.AutoButtonColor = false
            Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 6)
            
            local state = false
            tBtn.MouseButton1Click:Connect(function()
                state = not state
                if state then tBtn.BackgroundColor3 = Color3.fromRGB(52, 199, 89); tBtn.Text = "Enabled" else tBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255); tBtn.Text = "Enable" end
                pcall(cbToggle, state)
            end)

            -- Key Box
            local kb = Instance.new("TextBox", Row)
            kb.Size = UDim2.new(0, 28, 0, 26)
            kb.Position = UDim2.new(1, -78, 0.5, -13)
            kb.BackgroundColor3 = Color3.fromRGB(220, 225, 235)
            kb.Text = Options.DefaultKey or "X"
            kb.TextColor3 = Color3.fromRGB(0, 100, 255)
            kb.Font = Enum.Font.GothamBold
            kb.TextSize = 12
            Instance.new("UICorner", kb).CornerRadius = UDim.new(0, 6)
            kb.FocusLost:Connect(function() cbKey(kb.Text) end)

            -- Value/Speed Box
            local vb = Instance.new("TextBox", Row)
            vb.Size = UDim2.new(0, 40, 0, 26)
            vb.Position = UDim2.new(1, -43, 0.5, -13)
            vb.BackgroundColor3 = Color3.fromRGB(220, 225, 235)
            vb.Text = tostring(Options.DefaultSpeed or "300")
            vb.TextColor3 = Color3.fromRGB(0, 100, 255)
            vb.Font = Enum.Font.GothamBold
            vb.TextSize = 12
            Instance.new("UICorner", vb).CornerRadius = UDim.new(0, 6)
            vb.FocusLost:Connect(function() cbSpd(vb.Text) end)

            return { Row=Row, Toggle=tBtn, Key=kb, Speed=vb }
        end

        -- 3. Create Slider
        function TabData:CreateSlider(Options)
            local sName = Options.Name or "Slider"
            local min = Options.Min or 0
            local max = Options.Max or 100
            local default = Options.Default or 50
            local cb = Options.Callback or function() end

            local Row = Instance.new("Frame", Page)
            Row.Size = UDim2.new(1, 0, 0, 40)
            Row.BackgroundColor3 = Color3.fromRGB(230, 235, 245)
            Row.BackgroundTransparency = 0.5
            Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

            local Txt = Instance.new("TextLabel", Row)
            Txt.Size = UDim2.new(0.5, 0, 1, 0)
            Txt.Position = UDim2.new(0, 10, 0, 0)
            Txt.BackgroundTransparency = 1
            Txt.Text = sName .. ": " .. tostring(default)
            Txt.Font = Enum.Font.GothamBold
            Txt.TextSize = 12
            Txt.TextColor3 = Color3.fromRGB(30,30,30)
            Txt.TextXAlignment = Enum.TextXAlignment.Left

            local SlideBg = Instance.new("TextButton", Row)
            SlideBg.Size = UDim2.new(0.4, 0, 0, 8)
            SlideBg.Position = UDim2.new(0.55, 0, 0.5, -4)
            SlideBg.BackgroundColor3 = Color3.fromRGB(200, 210, 230)
            SlideBg.Text = ""
            SlideBg.AutoButtonColor = false
            Instance.new("UICorner", SlideBg).CornerRadius = UDim.new(1,0)

            local SlideFill = Instance.new("Frame", SlideBg)
            SlideFill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            SlideFill.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
            Instance.new("UICorner", SlideFill).CornerRadius = UDim.new(1,0)

            local dragging = false
            local function update(input)
                local relX = math.clamp(input.Position.X - SlideBg.AbsolutePosition.X, 0, SlideBg.AbsoluteSize.X)
                local pct = relX / SlideBg.AbsoluteSize.X
                local val = math.floor(min + (pct * (max-min)))
                SlideFill.Size = UDim2.new(pct, 0, 1, 0)
                Txt.Text = sName .. ": " .. tostring(val)
                pcall(cb, val)
            end

            SlideBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true; update(input) end end)
            UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end end)
            UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
        end
        
        return TabData
    end
    
    function Window:SelectTab(TabName)
        Window.CurrentTab = TabName
        for name, data in pairs(Window.Tabs) do
            if name == TabName then
                data.Page.Visible = true
                data.Indicator.Visible = true
                data.Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                data.Button.BackgroundTransparency = 0.2
            else
                data.Page.Visible = false
                data.Indicator.Visible = false
                data.Icon.ImageColor3 = Color3.fromRGB(230, 230, 230)
                data.Button.BackgroundTransparency = 1
            end
        end
    end
    
    return Window
end

return TaskManagerUI
