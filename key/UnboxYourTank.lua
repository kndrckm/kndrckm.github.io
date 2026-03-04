-- ==========================================
-- SKENA HUB : UNBOX YOUR TANK
-- ==========================================

local SkenaHub_LibURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua"
local SkenaHub_AdminURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Admin.lua"
local cacheBuster = "?t=" .. tostring(os.time())

-- 1. Load Library
local SkenaUI
local success, err = pcall(function()
    SkenaUI = loadstring(game:HttpGet(SkenaHub_LibURL .. cacheBuster, true))()
end)

if not success or not SkenaUI then
    warn("[SkenaUI] Gagal memuat UI Library: ", err)
    return
end

-- 2. Create Window
local Window = SkenaUI.CreateWindow("SkenaHub", "Unbox Your Tank", false)

-- 3. Load Admin Panel
local adminLoaded, SkenaAdmin = pcall(function()
    return loadstring(game:HttpGet(SkenaHub_AdminURL .. cacheBuster, true))()
end)

if adminLoaded and SkenaAdmin then
    SkenaAdmin.Attach(Window, {})
else
    warn("[SkenaUI] Gagal memuat Admin Module atau Anda tidak di-whitelist.")
end

-- 4. Main Script Features
local TabMain = Window:CreateTab("Main", "home")

TabMain:CreateTextRow({
    Text = "Game: Unbox Your Tank"
})

-- Tambahkan fitur spesifik game di sini
