-- ==========================================
-- SKENA HUB : MY ANIME EGG FARM
-- Game ID: 97883985639349
-- ==========================================

local SkenaUI_LibURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua"
local cacheBuster = "?t=" .. tostring(os.time())
local SkenaUI = loadstring(game:HttpGet(SkenaUI_LibURL .. cacheBuster, true))()

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")

-- ==========================================
-- BUAT WINDOW
-- ==========================================
local Window = SkenaUI.CreateWindow("SkenaHub", "My Anime Egg Farm", false)
local TabMain = Window:CreateTab("Main", "zap", false)
local TabSettings = Window:CreateTab("Settings", "settings", true)

-- ==========================================
-- TAB MAIN (Kosong - Siap diisi)
-- ==========================================
TabMain:CreateTextRow({
    Text = "Fitur sedang dalam pengembangan. Gunakan tab Admin untuk scan Remote dan TouchInterest."
})

-- ==========================================
-- TAB SETTINGS
-- ==========================================
TabSettings:CreateTextRow({
    Text = getgenv()._SKENA_ANTI_AFK and "🟢 Anti-AFK Active" or "🔴 Anti-AFK Failed"
})

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
