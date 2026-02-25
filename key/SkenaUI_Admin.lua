local Players = game:GetService("Players")
local player = Players.LocalPlayer
local WHITELISTED_ADMINS = {
    [4871650676] = true, -- UserId User (Akses Admin Utama)
    [72548092] = true,
}
local SkenaAdmin = {}

local function animateBtn(btn, success)
    if not btn or typeof(btn) ~= "Instance" then return end
    local oldText = btn.Text
    local oldColor = btn.BackgroundColor3
    -- Efek Pop!
    btn.Text = success and "Copied!" or "Gagal"
    btn.BackgroundColor3 = success and Color3.fromRGB(40, 200, 80) or Color3.fromRGB(200, 60, 60)
    task.delay(1.5, function()
        if btn and btn.Parent then
            btn.Text = oldText
            btn.BackgroundColor3 = oldColor
        end
    end)
end

function SkenaAdmin.Attach(Window, DebugData)
    if not WHITELISTED_ADMINS[player.UserId] then
        return 
    end
   local TabAdmin = Window:CreateTab("Admin", "database") 
    
    TabAdmin:CreateButtonRow({
        Name = "Copy My Position",
        ButtonText = "Copy Vector3",
        Callback = function(btn)
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local p = hrp.Position
                local posStr = string.format("Vector3.new(%.3f, %.3f, %.3f)", p.X, p.Y, p.Z)
                if setclipboard then
                    setclipboard(posStr)
                    animateBtn(btn, true)
                else
                    warn("Posisi anda: " .. posStr)
                    animateBtn(btn, false)
                end
            else
                animateBtn(btn, false)
            end
        end
    })

    TabAdmin:CreateButtonRow({
        Name = "Bypassed Dark Dex V3",
        ButtonText = "Load Dex",
        Callback = function(btn)
            local success, err = pcall(function()
                warn("[Admin] Memulai proses Bypassing...")

                -- 1. Load CloneRef & Bypasses dari LOCAL REPOSITORY
                pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/main/key/CloneRef.lua", true))() end)
                pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/main/key/DexBypasses.lua", true))() end)
                
                -- 2. Memanipulasi Environment sebelum Dex di-load
                local charset = {}
                for i = 48,  57 do table.insert(charset, string.char(i)) end
                for i = 65,  90 do table.insert(charset, string.char(i)) end
                for i = 97, 122 do table.insert(charset, string.char(i)) end
                local function RandomCharacters(length)
                    if length > 0 then
                        return RandomCharacters(length - 1) .. charset[math.random(1, #charset)]
                    else
                        return ""
                    end
                end

                -- Kita buat environment palsu (Sandbox) agar Dex memakai gethui()
                local fakeEnv = getfenv(0)
                local hiddenParent
                if gethui then
                    hiddenParent = gethui()
                elseif syn and syn.protect_gui then
                    hiddenParent = cloneref(game:GetService("CoreGui"))
                else
                    hiddenParent = cloneref(game:GetService("CoreGui"))
                end

                -- Memaksa Dex untuk menaruh UI-nya di Hidden Parent dengan nama acak
                local OriginalInstanceNew = Instance.new
                fakeEnv.Instance = {
                    new = function(className, parent)
                        local inst = OriginalInstanceNew(className)
                        if className == "ScreenGui" then
                            inst.Name = RandomCharacters(math.random(10, 20))
                            if syn and syn.protect_gui then syn.protect_gui(inst) end
                            inst.Parent = hiddenParent
                        elseif parent then
                            inst.Parent = parent
                        end
                        return inst
                    end
                }
                setmetatable(fakeEnv.Instance, {__index = Instance})

                warn("[Admin] Mengunduh Source Code Dark Dex...")
                -- 3. Load Dark Dex dari repository mu!
                local dexSource = game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/main/key/CustomDex.lua")
                
                local dexFunc, loadErr = loadstring(dexSource)
                if not dexFunc then
                    error("Gagal mengkompilasi Dex: " .. tostring(loadErr))
                end

                -- Menjalankan Dex dengan Environment terlindungi
                setfenv(dexFunc, fakeEnv)
                task.spawn(dexFunc)
            end)

            if success then
                warn("[Admin] Bypassed Dark Dex berhasil di-load!")
                animateBtn(btn, true)
            else
                warn("[Admin] Gagal me-load Dark Dex: " .. tostring(err))
                animateBtn(btn, false)
            end
        end
    })
    
    -- Selalu update fungsi LogRemote (agar re-exec mendapat versi terbaru)
    getgenv()._SKENA_SPY_SERIALIZE = function(v, depth)
        depth = depth or 0
        if depth > 3 then return "..." end
        local ok, result = pcall(function()
            local t = typeof(v)
            if t == "string" then return '"' .. v .. '"'
            elseif t == "number" or t == "boolean" then return tostring(v)
            elseif t == "nil" then return "nil"
            elseif t == "table" then
                local parts = {}
                local indent = string.rep("  ", depth + 1)
                for k, val in pairs(v) do
                    parts[#parts + 1] = indent .. "[" .. getgenv()._SKENA_SPY_SERIALIZE(k, depth + 1) .. "] = " .. getgenv()._SKENA_SPY_SERIALIZE(val, depth + 1)
                end
                if #parts == 0 then return "{}" end
                return "{\n" .. table.concat(parts, ",\n") .. "\n" .. string.rep("  ", depth) .. "}"
            elseif t == "Instance" then return v:GetFullName()
            elseif t == "Vector3" then return string.format("Vector3.new(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
            elseif t == "CFrame" then return string.format("CFrame.new(%.2f, %.2f, %.2f)", v.X, v.Y, v.Z)
            elseif t == "Color3" then return string.format("Color3.new(%.2f, %.2f, %.2f)", v.R, v.G, v.B)
            elseif t == "EnumItem" then return tostring(v)
            else return tostring(v) .. " (" .. t .. ")"
            end
        end)
        if ok then return result else return tostring(v) end
    end

    getgenv()._SKENA_SPY_LOG_FN = function(self, method, args)
        local timeSec = os.clock()
        local gap = 0
        if getgenv()._SKENA_SPY_LAST_TIME then
            gap = timeSec - getgenv()._SKENA_SPY_LAST_TIME
        end
        getgenv()._SKENA_SPY_LAST_TIME = timeSec

        task.spawn(function()
            pcall(function()
                local pName = tostring(self.Parent)
                local logLine = string.format("\n[+%.3fs GAP] [Remote] %s.%s (%s)", gap, pName, tostring(self), method)
                for i, v in ipairs(args) do
                    logLine = logLine .. string.format("\n  [%d] = %s", i, getgenv()._SKENA_SPY_SERIALIZE(v, 1))
                end
                table.insert(getgenv()._SKENA_SPY_LOGS, logLine)
            end)
        end)
    end

    -- Force re-hook jika versi berubah
    local SPY_VERSION = 3
    if getgenv()._SKENA_SPY_VERSION ~= SPY_VERSION then
        getgenv()._SKENA_SPY_HOOKED = false
        getgenv()._SKENA_SPY_VERSION = SPY_VERSION
    end

    if not getgenv()._SKENA_SPY_HOOKED then
        local success, err = pcall(function()
            -- 1. Hook via Namecall (Metode Umum)
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if getgenv()._SKENA_IS_SPYING and (method == "FireServer" or method == "InvokeServer") then
                    getgenv()._SKENA_SPY_LOG_FN(self, method, {...})
                end
                return oldNamecall(self, ...)
            end)
            
            -- 2. Hook via Function Closure (Direct / Bypassed Namecall)
            local dummyEvent = Instance.new("RemoteEvent")
            local dummyFunc = Instance.new("RemoteFunction")
            
            local oldFireServer
            oldFireServer = hookfunction(dummyEvent.FireServer, function(self, ...)
                if getgenv()._SKENA_IS_SPYING then getgenv()._SKENA_SPY_LOG_FN(self, "FireServer", {...}) end
                return oldFireServer(self, ...)
            end)
            
            local oldInvokeServer
            oldInvokeServer = hookfunction(dummyFunc.InvokeServer, function(self, ...)
                if getgenv()._SKENA_IS_SPYING then getgenv()._SKENA_SPY_LOG_FN(self, "InvokeServer", {...}) end
                return oldInvokeServer(self, ...)
            end)
            
            getgenv()._SKENA_SPY_HOOKED = true
            getgenv()._SKENA_SPY_LOGS = {}
            getgenv()._SKENA_IS_SPYING = false
        end)
        
        if not success then
            warn("[Skena Spy] Executor tidak mensupport hookmetamethod! Error: " .. tostring(err))
        end
    end

    -- Scanner: TouchInterests
    TabAdmin:CreateButtonRow({
        Name = "Scan TouchInterests",
        ButtonText = "Scan",
        Callback = function(btn)
            local ok, errMsg = pcall(function()
                local lines = {"=== SKENA TOUCHINTEREST SCAN ==="}
                local seen = {}
                local count = 0
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if (obj.ClassName == "TouchInterest" or (pcall(function() return obj:IsA("TouchInterest") end) and obj:IsA("TouchInterest"))) and obj.Parent then
                        local part = obj.Parent
                        local path = part:GetFullName()
                        if not seen[path] then
                            seen[path] = true
                            count = count + 1
                            lines[#lines + 1] = "[" .. count .. "] (TouchInterest) " .. part.Name .. " | " .. path
                        end
                    end
                end
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        for _, child in ipairs(obj:GetChildren()) do
                            if child:IsA("Script") or child:IsA("LocalScript") then
                                local path = obj:GetFullName()
                                if not seen[path] then
                                    seen[path] = true
                                    count = count + 1
                                    lines[#lines + 1] = "[" .. count .. "] (Script) " .. obj.Name .. " | " .. path
                                end
                                break
                            end
                        end
                    end
                end
                if count == 0 then
                    warn("[Scan] Tidak ada TouchInterest ditemukan.")
                    animateBtn(btn, false)
                    return
                end
                local finalStr = table.concat(lines, "\n")
                if setclipboard then
                    setclipboard(finalStr)
                    warn("[Scan] " .. count .. " objek dicopy ke clipboard!")
                    animateBtn(btn, true)
                else
                    print(finalStr)
                    animateBtn(btn, false)
                end
            end)
            if not ok then
                warn("[Scan ERROR] " .. tostring(errMsg))
                animateBtn(btn, false)
            end
        end
    })

    -- Scanner: All Remotes (ReplicatedStorage)
    TabAdmin:CreateButtonRow({
        Name = "Scan All Remotes (RS)",
        ButtonText = "Scan",
        Callback = function(btn)
            local ok, errMsg = pcall(function()
                local rs = game:GetService("ReplicatedStorage")
                local lines = {"=== SKENA REMOTE SCANNER ===", "Location: ReplicatedStorage", ""}
                local count = 0
                for _, obj in ipairs(rs:GetDescendants()) do
                    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
                        count = count + 1
                        lines[#lines + 1] = "[" .. count .. "] (" .. obj.ClassName .. ") " .. obj.Name .. " | " .. obj:GetFullName()
                    end
                end
                if count == 0 then
                    warn("[Scan] Tidak ada Remote ditemukan.")
                    animateBtn(btn, false)
                    return
                end
                local finalStr = table.concat(lines, "\n")
                if setclipboard then
                    setclipboard(finalStr)
                    warn("[Scan] " .. count .. " Remote dicopy ke clipboard!")
                    animateBtn(btn, true)
                else
                    print(finalStr)
                    animateBtn(btn, false)
                end
            end)
            if not ok then
                warn("[Scan Remote ERROR] " .. tostring(errMsg))
                animateBtn(btn, false)
            end
        end
    })

    -- Spy: Toggle Record + Copy Button (1 baris)
    TabAdmin:CreateToggleButtonRow({
        Name = "Spy (Record Actions)",
        ButtonText = "Copy",
        OnToggle = function(state)
            getgenv()._SKENA_IS_SPYING = state
            if state then
                getgenv()._SKENA_SPY_LOGS = {}
                warn("[Spy] Merekam semua aksi ke Server...")
            end
        end,
        OnButton = function(btn)
            local logs = getgenv()._SKENA_SPY_LOGS
            if not logs or #logs == 0 then
                warn("Belum ada tindakan yang direkam.")
                animateBtn(btn, false)
                return
            end
            local finalStr = "=== SKENA REMOTE SPY DUMP ===" .. table.concat(logs, "\n-------------------")
            if setclipboard then
                setclipboard(finalStr)
                warn("[Spy] " .. #logs .. " log dicopy ke clipboard!")
                animateBtn(btn, true)
            else
                print(finalStr)
                animateBtn(btn, false)
            end
        end
    })
    
    -- ESP: Toggle + Copy Data (1 baris)
    TabAdmin:CreateToggleButtonRow({
        Name = "ESP ProximityPrompt",
        ButtonText = "Copy",
        OnToggle = function(state)
            getgenv()._SKENA_ESP_PP = state
            if state then
                task.spawn(function()
                    while getgenv()._SKENA_ESP_PP do
                        for _, obj in ipairs(workspace:GetDescendants()) do
                            if obj:IsA("ProximityPrompt") and obj.Parent and obj.Parent:IsA("BasePart") then
                                local part = obj.Parent
                                if not part:FindFirstChild("_SkenaESP") then
                                    pcall(function()
                                        local bb = Instance.new("BillboardGui")
                                        bb.Name = "_SkenaESP"
                                        bb.Size = UDim2.new(0, 200, 0, 50)
                                        bb.StudsOffset = Vector3.new(0, 3, 0)
                                        bb.AlwaysOnTop = true
                                        bb.Parent = part
                                        
                                        local lbl = Instance.new("TextLabel", bb)
                                        lbl.Size = UDim2.new(1, 0, 1, 0)
                                        lbl.BackgroundTransparency = 0.5
                                        lbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                                        lbl.TextColor3 = Color3.fromRGB(0, 255, 100)
                                        lbl.Font = Enum.Font.GothamBold
                                        lbl.TextSize = 12
                                        lbl.TextWrapped = true
                                        Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 4)
                                        
                                        local action = obj.ActionText ~= "" and obj.ActionText or "E"
                                        local objText = obj.ObjectText ~= "" and obj.ObjectText or part.Name
                                        lbl.Text = "[" .. action .. "] " .. objText
                                        
                                        if not part:FindFirstChild("_SkenaHighlight") then
                                            local hl = Instance.new("Highlight")
                                            hl.Name = "_SkenaHighlight"
                                            hl.FillColor = Color3.fromRGB(0, 255, 100)
                                            hl.FillTransparency = 0.7
                                            hl.OutlineColor = Color3.fromRGB(0, 255, 100)
                                            hl.OutlineTransparency = 0
                                            hl.Parent = part
                                        end
                                    end)
                                end
                            end
                        end
                        task.wait(2)
                    end
                    -- Cleanup
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name == "_SkenaESP" or obj.Name == "_SkenaHighlight" then
                            pcall(function() obj:Destroy() end)
                        end
                    end
                end)
            end
        end,
        OnButton = function(btn)
            -- Scan & Copy semua ProximityPrompt
            local lines = {"=== SKENA PROXIMITY PROMPT SCAN ==="}
            local count = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    count = count + 1
                    local part = obj.Parent
                    local action = obj.ActionText ~= "" and obj.ActionText or "E"
                    local objText = obj.ObjectText ~= "" and obj.ObjectText or ""
                    lines[#lines + 1] = string.format("[%d] Action: %s | Object: %s | Part: %s | Path: %s",
                        count, action, objText, part and part.Name or "?", part and part:GetFullName() or "?")
                end
            end
            if count == 0 then
                warn("[ESP] Tidak ada ProximityPrompt ditemukan.")
                animateBtn(btn, false)
                return
            end
            if setclipboard then
                setclipboard(table.concat(lines, "\n"))
                warn("[ESP] " .. count .. " prompt dicopy ke clipboard!")
                animateBtn(btn, true)
            else
                print(table.concat(lines, "\n"))
                animateBtn(btn, false)
            end
        end
    })

    -- Scanner: Mobs / NPCs (Humanoid di workspace)
    TabAdmin:CreateButtonRow({
        Name = "Scan Mobs / NPCs",
        ButtonText = "Scan",
        Callback = function(btn)
            local ok, errMsg = pcall(function()
                local lp = game.Players.LocalPlayer
                local playerNames = {}
                for _, p in ipairs(game.Players:GetPlayers()) do
                    playerNames[p.Name] = true
                end
                
                local lines = {"=== SKENA MOB/NPC SCAN ==="}
                local count = 0
                
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Humanoid") and obj.Parent and obj.Parent:IsA("Model") then
                        local model = obj.Parent
                        if not playerNames[model.Name] and model ~= lp.Character then
                            count = count + 1
                            local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
                            local pos = hrp and string.format("(%.0f, %.0f, %.0f)", hrp.Position.X, hrp.Position.Y, hrp.Position.Z) or "?"
                            lines[#lines + 1] = string.format("[%d] %s | HP: %s/%s | Pos: %s | Path: %s",
                                count, model.Name, tostring(math.floor(obj.Health)), tostring(math.floor(obj.MaxHealth)), pos, model:GetFullName())
                        end
                    end
                end
                
                lines[#lines + 1] = "\nTotal: " .. count
                local finalStr = table.concat(lines, "\n")
                if setclipboard then
                    setclipboard(finalStr)
                    warn("[Scan] " .. count .. " mob/NPC dicopy ke clipboard!")
                    animateBtn(btn, true)
                else
                    print(finalStr)
                    animateBtn(btn, false)
                end
            end)
            if not ok then
                warn("[Scan Mob ERROR] " .. tostring(errMsg))
                animateBtn(btn, false)
            end
        end
    })

    -- Auto Interact: Toggle + Copy Log (1 baris)
    getgenv()._SKENA_INTERACT_LOGS = getgenv()._SKENA_INTERACT_LOGS or {}
    TabAdmin:CreateToggleButtonRow({
        Name = "Auto Interact (Log)",
        ButtonText = "Copy",
        OnToggle = function(state)
            getgenv()._SKENA_AUTO_INTERACT_ADMIN = state
            if state then
                getgenv()._SKENA_INTERACT_LOGS = {}
                task.spawn(function()
                    local lp = game.Players.LocalPlayer
                    while getgenv()._SKENA_AUTO_INTERACT_ADMIN do
                        local char = lp.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp and fireproximityprompt then
                            for _, obj in ipairs(workspace:GetDescendants()) do
                                if obj:IsA("ProximityPrompt") and obj.Enabled then
                                    local part = obj.Parent
                                    if part and part:IsA("BasePart") then
                                        local dist = (hrp.Position - part.Position).Magnitude
                                        if dist < 30 then
                                            local action = obj.ActionText ~= "" and obj.ActionText or "E"
                                            local objText = obj.ObjectText ~= "" and obj.ObjectText or ""
                                            local logEntry = string.format("[%.1fs] Action: %s | Object: %s | Part: %s | Path: %s | Dist: %.1f",
                                                os.clock(), action, objText, part.Name, part:GetFullName(), dist)
                                            table.insert(getgenv()._SKENA_INTERACT_LOGS, logEntry)
                                            pcall(function()
                                                fireproximityprompt(obj)
                                            end)
                                            task.wait(0.15)
                                        end
                                    end
                                end
                            end
                        elseif not fireproximityprompt then
                            warn("[Skena] fireproximityprompt tidak didukung!")
                            getgenv()._SKENA_AUTO_INTERACT_ADMIN = false
                            break
                        end
                        task.wait(0.5)
                    end
                end)
            end
        end,
        OnButton = function(btn)
            local logs = getgenv()._SKENA_INTERACT_LOGS
            if not logs or #logs == 0 then
                warn("[Interact] Belum ada interaksi yang dicatat.")
                animateBtn(btn, false)
                return
            end
            local finalStr = "=== SKENA INTERACT LOG (" .. #logs .. " entries) ===\n" .. table.concat(logs, "\n")
            if setclipboard then
                setclipboard(finalStr)
                warn("[Interact] " .. #logs .. " log dicopy ke clipboard!")
                animateBtn(btn, true)
            else
                print(finalStr)
                animateBtn(btn, false)
            end
        end
    })
end

return SkenaAdmin
