-- Ini adalah contoh cara memakai UI Library yang sudah kita buat.
-- Jika kamu mengetes ini di Roblox Studio, copy seluruh teks ini lalu paste di View -> Command Bar lalu tekan Enter!

-- 1. Load Library dari file yang kita buat
-- (Karena kita nentest lokal, kita gunakan fungsi require jika di environment executor, 
-- tapi untuk Command Bar Studio, kita akan gunakan simulasi load cepat)

local TaskManagerUI
-- Jika di game/Studio Command Bar, kita load manual scriptnya (Anggap kita sudah copy paste isi TaskUI_Library)
-- Untuk simulasi ini, kita gunakan Require / Loadstring jika di executor:
if getfenv().loadstring then
    -- Misal script library ditaruh di Github raw nantinya:
    -- TaskManagerUI = loadstring(game:HttpGet("URL_RAW_GITHUB_KAMU"))()
else
    -- Jika di lokal Studio dan ada di ReplicatedStorage dll:
    -- TaskManagerUI = require(game.ReplicatedStorage.TaskUI_Library)
end

-- ==========================================
-- JIKA TESTING LEWAT COMMAND BAR STUDIO, 
-- COPY ISI DARI TaskUI_Library.lua, PASTE DI ATAS BARIS INI,
-- LALU HAPUS `local TaskManagerUI` di atas.
-- ==========================================

-- 2. Membuat Jendela Utama (Mirip Window Task Manager)
local Window = TaskManagerUI:CreateWindow({
    Name = "Task Manager - Roblox Script",
})

-- 3. Membuat Tab Kiri (Gunakan ID Decal Roblox untuk Icon)
-- Icon 11306132213 adalah gambar grid (Home/Processes)
local TabProcesses = Window:CreateTab("Processes", 11306132213) 

-- Icon 11306129524 adalah gambar chart (Performance)
local TabPerformance = Window:CreateTab("Performance", 11306129524)

-- 4. Mengisi Tab dengan Tombol / Konten
TabProcesses:CreateButton({
    Name = "Roblox Game Client",
    Value = "18.4% CPU", -- Meniru tampilan Task Manager
    Callback = function()
        print("Roblox Game Client diklik!")
    end
})

TabProcesses:CreateButton({
    Name = "Auto Farm Script",
    Value = "Running",
    Callback = function()
        print("Fitur Auto Farm Dinyalakan!")
    end
})

TabProcesses:CreateButton({
    Name = "ESP Players",
    Value = "Off",
    Callback = function()
        print("Fitur ESP Ditekan")
    end
})

-- Isi Tab Performance
TabPerformance:CreateButton({
    Name = "Memory Usage",
    Value = "1,762.7 MB",
    Callback = function()
        print("Memory check")
    end
})
