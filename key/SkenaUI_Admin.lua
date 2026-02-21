local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- =====================================
-- DAFTAR AKSES ADMIN (WHITELIST ID)
-- =====================================
-- Masukkan UserId Roblox Anda dan teman/admin Anda di sini. 
-- UserId adalah angka unik yang ada di URL profil Roblox (contoh: roblox.com/users/12345678/profile)
local WHITELISTED_ADMINS = {
    [123456789] = true, -- Ganti dengan UserId Anda sebenarnya
    [987654321] = true, -- Contoh jika ada Admin ke-2
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
