local TaskManagerUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Proteksi otomatis: jika dijalankan di executor (CoreGui), taruh di sana. Jika di Studio, taruh di PlayerGui.
local parentUI = nil
if pcall(function() return CoreGui.RobloxGui end) then
    parentUI = CoreGui
else
    parentUI = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

function TaskManagerUI:CreateWindow(Options)
    Options = Options or {}
    local WindowName = Options.Name or "Task Manager"
    
    -- ScreenGui (Wadah Utama)
    local SG = Instance.new("ScreenGui")
    SG.Name = "Win11TaskManagerUI"
    SG.Parent = parentUI
    SG.ResetOnSpawn = false
    
    -- Main Background (Warna Abu-abu khas Windows 11)
    local Main = Instance.new("Frame", SG)
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 800, 0, 500)
    Main.Position = UDim2.new(0.5, -400, 0.5, -250)
    Main.BackgroundColor3 = Color3.fromRGB(243, 243, 243)
    Main.BorderSizePixel = 0
    
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 8)
    
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(210, 210, 210)
    MainStroke.Thickness = 1
    
    -- Script agar UI bisa di-Drag (digeser)
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Top Area (Title Bar)
    local TitleIcon = Instance.new("ImageLabel", Main)
    TitleIcon.Size = UDim2.new(0, 16, 0, 16)
    TitleIcon.Position = UDim2.new(0, 20, 0, 15)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = "rbxassetid://11306132213" -- Icon default (bisa diganti)
    TitleIcon.ImageColor3 = Color3.fromRGB(0, 95, 184)
    
    local TitleText = Instance.new("TextLabel", Main)
    TitleText.Size = UDim2.new(1, -50, 0, 40)
    TitleText.Position = UDim2.new(0, 45, 0, 3)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = WindowName
    TitleText.Font = Enum.Font.BuilderSans
    TitleText.TextSize = 13
    TitleText.TextColor3 = Color3.fromRGB(50, 50, 50)
    TitleText.TextXAlignment = Enum.TextXAlignment.Left

    -- Sidebar (Menu Kiri)
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 50, 1, -50)
    Sidebar.Position = UDim2.new(0, 5, 0, 50)
    Sidebar.BackgroundTransparency = 1
    
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 8)

    -- Tab Header (Teks Tab di atas konten)
    local TabHeader = Instance.new("TextLabel", Main)
    TabHeader.Size = UDim2.new(1, -70, 0, 40)
    TabHeader.Position = UDim2.new(0, 60, 0, 40)
    TabHeader.BackgroundTransparency = 1
    TabHeader.Text = "Tab Name"
    TabHeader.Font = Enum.Font.BuilderSansBold
    TabHeader.TextSize = 22
    TabHeader.TextColor3 = Color3.fromRGB(0, 0, 0)
    TabHeader.TextXAlignment = Enum.TextXAlignment.Left

    -- Content Card (Area Konten Putih Solid)
    local Card = Instance.new("Frame", Main)
    Card.Size = UDim2.new(1, -65, 1, -95)
    Card.Position = UDim2.new(0, 60, 0, 85)
    Card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Card.BorderSizePixel = 0
    Card.ClipsDescendants = true
    
    -- Efek Bevel Curve (Radius tumpul yang terlihat di atas kiri)
    local CardCorner = Instance.new("UICorner", Card)
    CardCorner.CornerRadius = UDim.new(0, 8) 
    
    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Color = Color3.fromRGB(225, 225, 225)
    CardStroke.Thickness = 1

    local TabContainer = Instance.new("Folder", Card)
    TabContainer.Name = "Tabs"

    -- Window API / Obj
    local Window = {
        CurrentTab = nil,
        Tabs = {}
    }
    
    -- Fungsi untuk membuat Tab Menu
    function Window:CreateTab(TabName, IconID)
        local TabData = {}
        
        -- Tombol di Sidebar
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(0, 40, 0, 40)
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = ""
        TabBtn.AutoButtonColor = false
        
        local TabBtnCorner = Instance.new("UICorner", TabBtn)
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        
        local TabIcon = Instance.new("ImageLabel", TabBtn)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Position = UDim2.new(0.5, -10, 0.5, -10)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = "rbxassetid://" .. tostring(IconID)
        TabIcon.ImageColor3 = Color3.fromRGB(90, 90, 90)
        
        -- Garis Biru Indikator Aktif (Kiri)
        local Indicator = Instance.new("Frame", TabBtn)
        Indicator.Size = UDim2.new(0, 3, 0, 16)
        Indicator.Position = UDim2.new(0, 0, 0.5, -8)
        Indicator.BackgroundColor3 = Color3.fromRGB(0, 95, 184) -- Win11 Blue
        Indicator.BorderSizePixel = 0
        Indicator.Visible = false
        Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
        
        -- ScrollingFrame Konten untuk Tab Tersebut
        local Scroll = Instance.new("ScrollingFrame", TabContainer)
        Scroll.Size = UDim2.new(1, 0, 1, 0)
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel = 0
        Scroll.ScrollBarThickness = 4
        Scroll.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
        Scroll.Visible = false
        
        local SLayout = Instance.new("UIListLayout", Scroll)
        SLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SLayout.Padding = UDim.new(0, 5)
        
        local SPad = Instance.new("UIPadding", Scroll)
        SPad.PaddingTop = UDim.new(0, 10)
        SPad.PaddingBottom = UDim.new(0, 10)
        SPad.PaddingLeft = UDim.new(0, 10)
        SPad.PaddingRight = UDim.new(0, 10)

        Window.Tabs[TabName] = { Button = TabBtn, Icon = TabIcon, Indicator = Indicator, Page = Scroll }
        
        TabBtn.MouseButton1Click:Connect(function()
            Window:SelectTab(TabName)
        end)
        
        TabBtn.MouseEnter:Connect(function()
            if Window.CurrentTab ~= TabName then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Window.CurrentTab ~= TabName then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            end
        end)

        -- Otomatis load tab pertama yang dibuat
        if not Window.CurrentTab then
            Window:SelectTab(TabName)
        end
        
        -- Fungsi untuk membuat Tombol (Seperti baris aplikasi / process di Task Manager)
        function TabData:CreateButton(BtnOptions)
            local bName = BtnOptions.Name or "Process Name"
            local bValue = BtnOptions.Value or "0%"
            local bCallback = BtnOptions.Callback or function() end
            
            local Btn = Instance.new("TextButton", Scroll)
            Btn.Size = UDim2.new(1, 0, 0, 36)
            Btn.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
            Btn.Text = "   " .. bName
            Btn.Font = Enum.Font.BuilderSans
            Btn.TextSize = 14
            Btn.TextColor3 = Color3.fromRGB(30, 30, 30)
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.AutoButtonColor = false
            
            Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
            local BStroke = Instance.new("UIStroke", Btn)
            BStroke.Color = Color3.fromRGB(235, 235, 235)
            
            -- Teks tambahan di kanan mirip status CPU/Memory
            local RightText = Instance.new("TextLabel", Btn)
            RightText.Size = UDim2.new(0, 100, 1, 0)
            RightText.Position = UDim2.new(1, -110, 0, 0)
            RightText.BackgroundTransparency = 1
            RightText.Text = bValue
            RightText.Font = Enum.Font.BuilderSans
            RightText.TextSize = 13
            RightText.TextColor3 = Color3.fromRGB(100, 100, 100)
            RightText.TextXAlignment = Enum.TextXAlignment.Right
            
            Btn.MouseButton1Click:Connect(function()
                pcall(bCallback)
            end)
            
            Btn.MouseEnter:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(243, 243, 243)}):Play()
            end)
            Btn.MouseLeave:Connect(function()
                TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(250, 250, 250)}):Play()
            end)
        end
        
        return TabData
    end
    
    function Window:SelectTab(TabName)
        Window.CurrentTab = TabName
        TabHeader.Text = TabName
        for name, data in pairs(Window.Tabs) do
            if name == TabName then
                data.Page.Visible = true
                data.Indicator.Visible = true
                data.Icon.ImageColor3 = Color3.fromRGB(0, 95, 184)
                data.Button.BackgroundTransparency = 0
            else
                data.Page.Visible = false
                data.Indicator.Visible = false
                data.Icon.ImageColor3 = Color3.fromRGB(90, 90, 90)
                data.Button.BackgroundTransparency = 1
            end
        end
    end
    
    return Window
end

return TaskManagerUI
