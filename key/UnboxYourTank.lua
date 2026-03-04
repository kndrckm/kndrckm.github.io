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
local getgenv = getgenv or function() return _G end

-- Auto Collect Money (Terpisah 1-8)
for i = 1, 8 do
    TabMain:CreateToggleRow({
        Name = "Auto Collect Money " .. i,
        OnToggle = function(state)
            getgenv()["_SKENA_AUTO_COLLECT_MONEY_" .. i] = state
            if state then
                task.spawn(function()
                    while getgenv()["_SKENA_AUTO_COLLECT_MONEY_" .. i] do
                        pcall(function()
                            -- Cari Plot milik Player (format nama "Username Plot")
                            local player = game.Players.LocalPlayer
                            local plotName = player.Name .. " Plot"
                            local plot = workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild(plotName)
                            
                            if plot then
                                local podiumsFolder = plot:FindFirstChild("PodiumFloorParts")
                                if podiumsFolder then
                                    local targetPart = podiumsFolder:FindFirstChild(tostring(i))
                                    if targetPart then
                                        local event = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
                                        if event and event:FindFirstChild("PodiumCashCollectVFXEvent") then
                                            event.PodiumCashCollectVFXEvent:FireServer(targetPart)
                                        end
                                    end
                                end
                            end
                        end)
                        task.wait(1) -- Adjust delay if necessary
                    end
                end)
            end
        end
    })
end
