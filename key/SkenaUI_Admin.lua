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
    
    if not getgenv()._SKENA_SPY_HOOKED then
        local success, err = pcall(function()
            local function LogRemote(self, method, args)
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
                            local tStr = typeof(v)
                            local vStr = tostring(v)
                            if tStr == "string" then vStr = '"' .. vStr .. '"' end
                            logLine = logLine .. string.format("\n  [%d] = %s  (%s)", i, vStr, tStr)
                        end
                        table.insert(getgenv()._SKENA_SPY_LOGS, logLine)
                    end)
                end)
            end

            -- 1. Hook via Namecall (Metode Umum)
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if getgenv()._SKENA_IS_SPYING and (method == "FireServer" or method == "InvokeServer") then
                    LogRemote(self, method, {...})
                end
                return oldNamecall(self, ...)
            end)
            
            -- 2. Hook via Function Closure (Direct / Bypassed Namecall)
            local dummyEvent = Instance.new("RemoteEvent")
            local dummyFunc = Instance.new("RemoteFunction")
            
            local oldFireServer
            oldFireServer = hookfunction(dummyEvent.FireServer, function(self, ...)
                if getgenv()._SKENA_IS_SPYING then LogRemote(self, "FireServer", {...}) end
                return oldFireServer(self, ...)
            end)
            
            local oldInvokeServer
            oldInvokeServer = hookfunction(dummyFunc.InvokeServer, function(self, ...)
                if getgenv()._SKENA_IS_SPYING then LogRemote(self, "InvokeServer", {...}) end
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
        Callback = function(btn)
            local logs = getgenv()._SKENA_SPY_LOGS
            if not logs or #logs == 0 then
                warn("Belum ada tindakan rahasia yang direkam/tertangkap.")
                animateBtn(btn, false)
                return
            end
            local finalStr = "=== SKENA REMOTE SPY DUMP ===" .. table.concat(logs, "\n-------------------")
            if setclipboard then
                setclipboard(finalStr)
                warn("Data Spy dicopy ke clipboard PC Anda!")
                animateBtn(btn, true)
            else
                print(finalStr)
                warn("Cek F9 Console untuk melihat rekaman Spy.")
                animateBtn(btn, false)
            end
        end
    })
    
    -- Modul Ekstra: Scan & Record Semua Tombol Fisik (TouchInterest + Script)
    TabAdmin:CreateButtonRow({
        Name = "Scan & Copy TouchInterests",
        ButtonText = "Scan",
        Callback = function(btn)
            local ok, errMsg = pcall(function()
                local lines = {"=== SKENA TOUCHINTEREST SCAN ==="}
                local seen = {}
                local count = 0
                
                -- Scan 1: TouchInterest langsung
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
                
                -- Scan 2: BasePart yang punya child Script (biasanya tombol tycoon)
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
                    warn("[Scan] Tidak ada TouchInterest atau tombol script yang ditemukan.")
                    animateBtn(btn, false)
                    return
                end
                
                local finalStr = table.concat(lines, "\n")
                if setclipboard then
                    setclipboard(finalStr)
                    warn("[Scan] Berhasil copy " .. count .. " objek ke clipboard!")
                    animateBtn(btn, true)
                else
                    print(finalStr)
                    warn("[Scan] Cetak ke F9 Console. (setclipboard tidak didukung)")
                    animateBtn(btn, false)
                end
            end)
            
            if not ok then
                warn("[Scan ERROR] " .. tostring(errMsg))
                animateBtn(btn, false)
            end
        end
    })

    -- Modul Ekstra: Scan Semua Remote di ReplicatedStorage
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
                        local tag = obj.ClassName
                        lines[#lines + 1] = "[" .. count .. "] (" .. tag .. ") " .. obj.Name .. " | " .. obj:GetFullName()
                    end
                end
                
                if count == 0 then
                    warn("[Scan] Tidak ada Remote ditemukan di ReplicatedStorage.")
                    animateBtn(btn, false)
                    return
                end
                
                local finalStr = table.concat(lines, "\n")
                if setclipboard then
                    setclipboard(finalStr)
                    warn("[Scan] Berhasil copy " .. count .. " Remote ke clipboard!")
                    animateBtn(btn, true)
                else
                    print(finalStr)
                    warn("[Scan] Cetak ke F9 Console.")
                    animateBtn(btn, false)
                end
            end)
            
            if not ok then
                warn("[Scan Remote ERROR] " .. tostring(errMsg))
                animateBtn(btn, false)
            end
        end
    })

    -- Modul Ekstra: Auto-Touch (Brute-force Tycoon/Simulator)
    TabAdmin:CreateToggleRow({
        Name = "Auto-Touch All (Brute-force)",
        OnToggle = function(state)
            getgenv()._SKENA_AUTO_TOUCH = state
            if state then
                task.spawn(function()
                    local player = game.Players.LocalPlayer
                    while getgenv()._SKENA_AUTO_TOUCH do
                        local char = player.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp and firetouchinterest then
                            for _, obj in ipairs(workspace:GetDescendants()) do
                                if obj:IsA("TouchInterest") and obj.Parent then
                                    pcall(function()
                                        firetouchinterest(hrp, obj.Parent, 0)
                                        task.wait(0.01)
                                        firetouchinterest(hrp, obj.Parent, 1)
                                    end)
                                end
                            end
                        elseif not firetouchinterest then
                            warn("Executor Anda tidak mendukung firetouchinterest!")
                            getgenv()._SKENA_AUTO_TOUCH = false
                            break
                        end
                        task.wait(1)
                    end
                end)
            end
        end
    })

    -- Modul 1: Dump ESP Data (Tampil Universal)
    TabAdmin:CreateButtonRow({
        Name = "Copy Captured ESP Data",
        ButtonText = "Copy to Clipboard",
        Callback = function(btn)
            local paths = (DebugData and DebugData.CapturedPaths) or {}
            
            -- Count elements
            local count = 0
            for _ in pairs(paths) do count = count + 1 end
            
            if count == 0 then
                warn("Game ini tidak mendaftarkan ESP Data / Belum ada data ditangkap di layar.")
                animateBtn(btn, false)
                return
            end

            local lines = {"=== ESP RAW DATA DUMP ==="}
            for path, cN in pairs(paths) do
                table.insert(lines, "[" .. tostring(cN) .. "]  =>  " .. tostring(path))
            end
            local finalStr = table.concat(lines, "\n")
            if setclipboard then
                setclipboard(finalStr)
                animateBtn(btn, true)
            else
                print(finalStr)
                warn("Executor tidak mendukung setclipboard. Cek menu console (F9)!")
                animateBtn(btn, false)
            end
        end
    })
end

return SkenaAdmin
