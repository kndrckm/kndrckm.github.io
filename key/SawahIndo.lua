local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer

-- ==========================================
-- INIT SKENA UI
-- ==========================================
local SkenaUI_Loaded = false
local SkenaUI
pcall(function()
    SkenaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Library.lua"))()
    SkenaUI_Loaded = true
end)

if not SkenaUI_Loaded then
    warn("Koneksi gagal ke SkenaUI_Library. Hubungkan ke Internet.")
    return
end

local GameName = "SAWAH indo Finder"
local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
if success and info and info.Name then
    GameName = info.Name .. " Hub"
end

local Window = SkenaUI:CreateWindow({
    Name = "SkenaHub - " .. GameName
})

local TabFarming = Window:CreateTab("Farming", "wheat") 
local TabSettings = Window:CreateTab("Settings", "settings", true) 

-- ==========================================
-- SISTEM KALIBRASI (SMART PLOT DETECTOR)
-- ==========================================
getgenv().PLOT_POSITIONS = getgenv().PLOT_POSITIONS or {}
getgenv()._SKENA_CALIBRATING = false

if not getgenv()._SAWAH_HOOKED then
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and tostring(self) == "PlantCrop" and getgenv()._SKENA_CALIBRATING then
                local args = {...}
                if typeof(args[1]) == "Vector3" then
                    local pos = args[1]
                    local found = false
                    for _, p in ipairs(getgenv().PLOT_POSITIONS) do
                        if (p - pos).Magnitude < 1 then found = true break end
                    end
                    if not found and #getgenv().PLOT_POSITIONS < 15 then
                        table.insert(getgenv().PLOT_POSITIONS, pos)
                        print("[Skena Hub] Tersimpan Titik Sawah #" .. #getgenv().PLOT_POSITIONS)
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
        getgenv()._SAWAH_HOOKED = true
    end)
end

TabFarming:CreateToggleRow({
    Name = " [ Mode Kalibrasi Lahan Sawah ]",
    OnToggle = function(state)
        getgenv()._SKENA_CALIBRATING = state
        if state then
            getgenv().PLOT_POSITIONS = {} -- Reset data saat mulai kalibrasi
            warn("MODE KALIBRASI AKTIF. Silakan tanam 1 bibit secara MANUAL ke tiap 15 lubang tanah secara bergantian. Skrip akan merekam polanya.")
        else
            warn("KALIBRASI SELESAI. Total titik tersimpan: " .. tostring(#getgenv().PLOT_POSITIONS))
        end
    end
})

-- ==========================================
-- LOOPING MODE / AUTO-FARM (JAGUNG)
-- ==========================================
getgenv().SkenaAutoFarm_Jagung = false
TabFarming:CreateToggleRow({
    Name = "Auto Farm Jagung (AFK)",
    OnToggle = function(state)
        getgenv().SkenaAutoFarm_Jagung = state
        if state then
            task.spawn(function()
                local rs = game:GetService("ReplicatedStorage")
                while getgenv().SkenaAutoFarm_Jagung do
                    
                    pcall(function() rs.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Jagung", 15) end)
                    task.wait(1)
                    
                    if #getgenv().PLOT_POSITIONS > 0 then
                        for _, pos in ipairs(getgenv().PLOT_POSITIONS) do
                            if not getgenv().SkenaAutoFarm_Jagung then return end
                            pcall(function() rs.Remotes.TutorialRemotes.PlantCrop:FireServer(pos) end)
                            task.wait(0.25)
                        end
                    else
                        warn("AUTO-FARM TERTUNDA: Anda belum merekam titik tanah via Kalibrasi.")
                    end
                    
                    -- 3. Menunggu (Waktu Jagung Tumbuh = Sekitar 15-20 detik)
                    -- Sesuaikan angka ini bila ternyata jagung belum 100% muncul dan siap dipanen
                    task.wait(120)
                    
                    -- 4. Panen Otomatis (Instan)
                    for i = 1, 15 do
                        if not getgenv().SkenaAutoFarm_Jagung then return end
                        pcall(function() rs.Remotes.TutorialRemotes.HarvestCrop:FireServer("Jagung", i, "Corn") end)
                        task.wait(0.2)
                    end
                    task.wait(1.5)
                    
                    -- 5. Jual
                    pcall(function() rs.Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Jagung", 30) end)
                    task.wait(1.5)
                end
            end)
        end
    end
})

TabFarming:CreateTextRow({
    Text = "Step: (1) Nyalakan Kalibrasi, lalu tanam bibit manual ke dalam 15 petak bidang tanah. (2) Setelah selesai, matikan switch Kalibrasi. (3) Tekan Auto Farm AFK dan biarkan bot bermain liar."
})

-- ==========================================
-- MANUAL BUTTONS (JAGUNG)
-- ==========================================
TabFarming:CreateButtonRow({
    Name = "1. Beli Bibit Jagung (15x)",
    ButtonText = "Beli",
    Callback = function()
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            rs.Remotes.TutorialRemotes.RequestShop:InvokeServer("BUY", "Bibit Jagung", 15)
        end)
    end
})

TabFarming:CreateButtonRow({
    Name = "2. Tanam Jagung (15 Petak)",
    ButtonText = "Tanam",
    Callback = function()
        task.spawn(function()
            if #getgenv().PLOT_POSITIONS < 1 then
                warn("Gagal menanam! Silakan lakukan Kalibrasi Lahan terlebih dahulu.")
                return
            end
            local rs = game:GetService("ReplicatedStorage")
            for _, pos in ipairs(getgenv().PLOT_POSITIONS) do
                pcall(function() rs.Remotes.TutorialRemotes.PlantCrop:FireServer(pos) end)
                task.wait(0.25)
            end
        end)
    end
})

TabFarming:CreateButtonRow({
    Name = "3. Sell All Jagung",
    ButtonText = "Jual",
    Callback = function()
        pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            rs.Remotes.TutorialRemotes.RequestSell:InvokeServer("SELL", "Jagung", 30)
        end)
    end
})

-- (AFK Mode dipindah ke atas)

-- ==========================================
-- ISI TAB SETTINGS
-- ==========================================
TabSettings:CreateInputRow({
    Name = "UI Toggle Key",
    Placeholder = "Z",
    Default = "Z",
    Callback = function(keyStr)
        Window:SetToggleKey(keyStr)
    end
})

-- ==========================================
-- ATTACH ADMIN MODULE ONLINE
-- ==========================================
task.spawn(function()
    local succ, SkenaAdmin = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SkenaUI_Admin.lua"))()
    end)
    if succ and SkenaAdmin then
        SkenaAdmin.Attach(Window, {})
    end
end)
