local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- =====================================
-- DAFTAR AKSES ADMIN (WHITELIST ID)
-- =====================================
-- Masukkan UserId Roblox Anda dan teman/admin Anda di sini. 
-- UserId adalah angka unik yang ada di URL profil Roblox (contoh: roblox.com/users/12345678/profile)
local WHITELISTED_ADMINS = {
    [4871650676] = true, -- UserId User (Akses Admin Utama)
}

local SkenaAdmin = {}

function SkenaAdmin.Attach(Window, DebugData)
    -- VERIFIKASI KEAMANAN: Cek apakah UserId pemain ada di tabel whitelist di atas
    if not WHITELISTED_ADMINS[player.UserId] then
        -- Jika tidak terdaftar, batalkan pembuatan tab admin. Script akan diam-diam berhenti di sini.
        return 
    end

    -- Jika berhasil lolos verifikasi, buat Tab Admin
    local TabAdmin = Window:CreateTab("Admin", "database") 
    
    -- Alat Dasar Admin (Universal)
    TabAdmin:CreateButtonRow({
        Name = "Copy My Position",
        ButtonText = "Copy Vector3",
        Callback = function()
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local p = hrp.Position
                local posStr = string.format("Vector3.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
                if setclipboard then
                    setclipboard(posStr)
                else
                    warn("Posisi anda: " .. posStr)
                end
            end
        end
    })
    
    -- Alat Admin: Remote Spy Logger
    if not getgenv()._SKENA_SPY_HOOKED then
        pcall(function()
            local gm = getrawmetatable(game)
            setreadonly(gm, false)
            local oldNamecall = gm.__namecall
            
            gm.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if getgenv()._SKENA_IS_SPYING and (method == "FireServer" or method == "InvokeServer") then
                    local args = {...}
                    local pName = "UnknownParent"
                    pcall(function() pName = tostring(self.Parent) end)
                    
                    local logLine = string.format("\n[Remote] %s.%s (%s)", pName, tostring(self), method)
                    for i, v in ipairs(args) do
                        local tStr = typeof(v)
                        local vStr = tostring(v)
                        if tStr == "string" then vStr = '"' .. vStr .. '"' end
                        logLine = logLine .. string.format("\n  [%d] = %s  (%s)", i, vStr, tStr)
                    end
                    table.insert(getgenv()._SKENA_SPY_LOGS, logLine)
                end
                
                return oldNamecall(self, ...)
            end)
            setreadonly(gm, true)
            getgenv()._SKENA_SPY_HOOKED = true
            getgenv()._SKENA_SPY_LOGS = {}
            getgenv()._SKENA_IS_SPYING = false
        end)
    end

    TabAdmin:CreateToggleRow({
        Name = "Record Game Actions (Spy)",
        OnToggle = function(state)
            getgenv()._SKENA_IS_SPYING = state
            if state then
                getgenv()._SKENA_SPY_LOGS = {} -- Reset ketika record di start ulang
                warn("Merekam semua aksi ke Server dalam mode Spy...")
            end
        end
    })

    TabAdmin:CreateButtonRow({
        Name = "Copy Recorded Actions",
        ButtonText = "Copy",
        Callback = function()
            local logs = getgenv()._SKENA_SPY_LOGS
            if not logs or #logs == 0 then
                warn("Belum ada tindakan rahasia yang direkam/tertangkap.")
                return
            end
            local finalStr = "=== SKENA REMOTE SPY DUMP ===" .. table.concat(logs, "\n-------------------")
            if setclipboard then
                setclipboard(finalStr)
                warn("Data Spy dicopy ke clipboard PC Anda!")
            else
                print(finalStr)
                warn("Cek F9 Console untuk melihat rekaman Spy.")
            end
        end
    })
    
    -- Modul 1: Dump ESP Data (jika skrip asalnya mengirim data ESP)
    if DebugData and DebugData.CapturedPaths then
        TabAdmin:CreateButtonRow({
            Name = "Copy Captured ESP Data",
            ButtonText = "Copy to Clipboard",
            Callback = function()
                local lines = {"=== ESP RAW DATA DUMP ==="}
                for path, cN in pairs(DebugData.CapturedPaths) do
                    table.insert(lines, "[" .. tostring(cN) .. "]  =>  " .. tostring(path))
                end
                local finalStr = table.concat(lines, "\n")
                if setclipboard then
                    setclipboard(finalStr)
                else
                    print(finalStr)
                    warn("Executor tidak mendukung setclipboard. Cek menu console (F9)!")
                end
            end
        })
    end
end

return SkenaAdmin
