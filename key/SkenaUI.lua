local PlaceId = game.PlaceId
local SkenaHub_CoreURL = ""

if PlaceId == 114272390738102 then
    SkenaHub_CoreURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SurvivetheLoop.lua"
elseif PlaceId == 134750290201751 then
    SkenaHub_CoreURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SurvivetheCold.lua"
elseif PlaceId == 83369512629707 then
    SkenaHub_CoreURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SawahIndo.lua"
else
    -- Game tidak disupport: Load Fallback Admin (untuk di-test / bypass oleh admin)
    SkenaHub_CoreURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/FallbackAdmin.lua"
end

-- Eksekusi script spesifik game (dengan cache buster)1
local cacheBuster = "?t=" .. tostring(os.time())
local success, err = pcall(function()
    loadstring(game:HttpGet(SkenaHub_CoreURL .. cacheBuster, true))()
end)

if not success then
    warn("[SkenaUI] Gagal memuat UI untuk game ini: ", err)
    -- Tampilkan error di layar agar tidak silent-fail
    pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "SkenaErrorDisplay"
        local ok = pcall(function() sg.Parent = game:GetService("CoreGui") end)
        if not ok then sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end
        local lbl = Instance.new("TextLabel", sg)
        lbl.Size = UDim2.new(0, 500, 0, 60)
        lbl.Position = UDim2.new(0.5, -250, 0, 10)
        lbl.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextWrapped = true
        lbl.Text = "[SkenaUI Error] " .. tostring(err)
        Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6)
        task.delay(15, function() if sg then sg:Destroy() end end)
    end)
end
