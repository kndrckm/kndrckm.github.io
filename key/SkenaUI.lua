local PlaceId = game.PlaceId
local SkenaHub_CoreURL = ""

if PlaceId == 114272390738102 then
    SkenaHub_CoreURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SurvivetheLoop.lua"
elseif PlaceId == 134750290201751 then
    SkenaHub_CoreURL = "https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/refs/heads/main/key/SurvivetheCold.lua"
else
    warn("[SkenaUI] Game ID tidak dikenali atau belum disupport oleh hub ini: " .. tostring(PlaceId))
    -- (Opsional) Jika Anda memiliki UI Fallback/Universal, arahkan SkenaHub_CoreURL ke sana
    return
end

-- Eksekusi script spesifik game
local success, err = pcall(function()
    loadstring(game:HttpGet(SkenaHub_CoreURL, true))()
end)

if not success then
    warn("[SkenaUI] Gagal memuat UI untuk game ini: ", err)
end
