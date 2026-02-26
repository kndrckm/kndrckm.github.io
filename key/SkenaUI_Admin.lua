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
    -- === GENERAL PANEL (Available to everyone) ===
    local TabGeneral = Window:CreateTab("General", "home")
    
    local isFlying = false
    local flySpeed = 50
    TabGeneral:CreateToggleRow({
        Name = "Fly Toggle",
        HasSpeed = true,
        DefaultSpeed = "50",
        OnSpeedChange = function(val)
            local s = tonumber(val)
            if s then flySpeed = s end
        end,
        OnToggle = function(state)
            isFlying = state
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end
            
            if isFlying then
                -- Cleanup any existing fly objects
                for _, v in ipairs(hrp:GetChildren()) do
                    if v.Name == "SkenaFlyBG" or v.Name == "SkenaFlyBV" then v:Destroy() end
                end
                
                local bg = Instance.new("BodyGyro")
                bg.Name = "SkenaFlyBG"
                bg.P = 9e4
                bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.CFrame = hrp.CFrame
                bg.Parent = hrp
                
                local bv = Instance.new("BodyVelocity")
                bv.Name = "SkenaFlyBV"
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                bv.Parent = hrp
                
                hum.PlatformStand = true
                
                local cam = workspace.CurrentCamera
                local uis = game:GetService("UserInputService")
                
                if getgenv()._SKENA_FLY_CONN then getgenv()._SKENA_FLY_CONN:Disconnect() end
                getgenv()._SKENA_FLY_CONN = game:GetService("RunService").RenderStepped:Connect(function()
                    if not isFlying or not hrp or not hrp:FindFirstChild("SkenaFlyBG") or not hrp:FindFirstChild("SkenaFlyBV") then 
                        if getgenv()._SKENA_FLY_CONN then getgenv()._SKENA_FLY_CONN:Disconnect() end
                        return 
                    end
                    
                    bg.CFrame = cam.CFrame
                    local moveDir = Vector3.new()
                    
                    if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                    if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                    if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                    if uis:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                    if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                    
                    if moveDir.Magnitude > 0 then
                        moveDir = moveDir.Unit
                    end
                    bv.Velocity = moveDir * flySpeed
                end)
            else
                if getgenv()._SKENA_FLY_CONN then getgenv()._SKENA_FLY_CONN:Disconnect() end
                local bg = hrp:FindFirstChild("SkenaFlyBG")
                local bv = hrp:FindFirstChild("SkenaFlyBV")
                if bg then bg:Destroy() end
                if bv then bv:Destroy() end
                hum.PlatformStand = false
            end
        end
    })

    local speedChangerEnabled = false
    local targetWalkSpeed = 16
    TabGeneral:CreateToggleRow({
        Name = "Speed Changer",
        HasSpeed = true,
        DefaultSpeed = "16",
        OnSpeedChange = function(val)
            local num = tonumber(val)
            if num then targetWalkSpeed = num end
        end,
        OnToggle = function(state)
            speedChangerEnabled = state
            if speedChangerEnabled then
                if getgenv()._SKENA_SPEED_CONN then getgenv()._SKENA_SPEED_CONN:Disconnect() end
                getgenv()._SKENA_SPEED_CONN = game:GetService("RunService").Stepped:Connect(function()
                    local char = player.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if hum and speedChangerEnabled then
                        if hum.WalkSpeed ~= targetWalkSpeed then
                            hum.WalkSpeed = targetWalkSpeed
                        end
                    end
                end)
            else
                if getgenv()._SKENA_SPEED_CONN then getgenv()._SKENA_SPEED_CONN:Disconnect() end
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = 16
                end
            end
        end
    })

    if not WHITELISTED_ADMINS[player.UserId] then
        return 
    end
   local TabAdmin = Window:CreateTab("Admin", "database") 
    
    TabAdmin:CreateDoubleButtonRow({
        Name = "External Tools",
        Button1Text = "Load Dex V3",
        Button2Text = "Load RSpy",
        Callback1 = function(btn)
            local success, err = pcall(function()
                warn("[Admin] Memulai proses Bypassing...")
                pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/main/key/CloneRef.lua", true))() end)
                pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/main/key/DexBypasses.lua", true))() end)
                warn("[Admin] Mengunduh Source Code Dark Dex...")
                local dexSource = game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/main/key/CustomDex.lua")
                local dexFunc, loadErr = loadstring(dexSource)
                if not dexFunc then error("Gagal mengkompilasi Dex: " .. tostring(loadErr)) end
                task.spawn(dexFunc)
            end)
            if success then
                warn("[Admin] Bypassed Dark Dex berhasil di-load!")
                animateBtn(btn, true)
            else
                warn("[Admin] Gagal me-load Dark Dex: " .. tostring(err))
                animateBtn(btn, false)
            end
        end,
        Callback2 = function(btn)
            local success, err = pcall(function()
                warn("[Admin] Memuat SimpleSpy V3 (External)...")
                loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))()
            end)
            if success then
                warn("[Admin] SimpleSpy berhasil di-load!")
                animateBtn(btn, true)
            else
                warn("[Admin] Gagal me-load SimpleSpy: " .. tostring(err))
                animateBtn(btn, false)
            end
        end
    })

    TabAdmin:CreateDoubleButtonRow({
        Name = "Workspace Scanners",
        Button1Text = "TouchInt",
        Button2Text = "Remotes",
        Callback1 = function(btn)
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
        end,
        Callback2 = function(btn)
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

    TabAdmin:CreateDoubleButtonRow({
        Name = "Player & Entity Tools",
        Button1Text = "Scan NPCs",
        Button2Text = "Copy Pos",
        Callback1 = function(btn)
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
        end,
        Callback2 = function(btn)
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

    -- Spy: Toggle Record + Copy Button (1 baris)
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
