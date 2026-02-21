local Players = game:GetService("Players")
local player = Players.LocalPlayer
local WHITELISTED_ADMINS = {
    [4871650676] = true, -- UserId User (Akses Admin Utama)
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
