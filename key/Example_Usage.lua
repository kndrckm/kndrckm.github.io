local TaskManagerUI

-- Mendeteksi apakah dijalankan lewat Executor (mendukung loadstring & game:HttpGet)
local success, err = pcall(function()
    TaskManagerUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/TaskUI_Library.lua"))()
end)

if not success or not TaskManagerUI then
    warn("Gagal mengambil UI Library dari Github. Error: " .. tostring(err))
    return
end


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
