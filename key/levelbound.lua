local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SEISEN HUB | Levelbound",
   LoadingTitle = "Seisen Hub v1.0",
   LoadingSubtitle = "Levelbound Script",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SeisenHubLevelbound",
      FileName = "Levelbound_Config"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

----------------------------------------------------------------------
-- TABS
----------------------------------------------------------------------
local TabMain = Window:CreateTab("Main Features", "zap") -- Icon can be changed using Lucide icons
local TabVisuals = Window:CreateTab("Visuals", "eye")
local TabInvasion = Window:CreateTab("Invasion", "shield")
local TabTeleport = Window:CreateTab("Teleport", "map-pin")
local TabModifiers = Window:CreateTab("Modifiers", "settings")
local TabAdmin = Window:CreateTab("Admin", "shield-alert")

----------------------------------------------------------------------
-- 1. MAIN FEATURES
----------------------------------------------------------------------
local SectionMain = TabMain:CreateSection("Main Features")

TabMain:CreateToggle({
   Name = "Kill Aura Range",
   CurrentValue = false,
   Flag = "KillAuraRange",
   Callback = function(Value)
      -- [PLACEHOLDER] Ganti dengan FireServer/InvokeServer dari hasil remote spy
      if Value then
         print("[Auto] Kill Aura Range: ON")
      else
         print("[Auto] Kill Aura Range: OFF")
      end
   end,
})

local KillAuraConnection
TabMain:CreateToggle({
   Name = "Kill Aura Melee",
   CurrentValue = false,
   Flag = "KillAuraMelee",
   Callback = function(Value)
      if Value then
         local placeId = game.PlaceId
         if placeId == 74848159470277 or placeId == 128981447330754 then
            local Event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("AttackV2")
            print("[Auto] Kill Aura Melee Levelbound: ON")
            
            KillAuraConnection = game:GetService("RunService").Heartbeat:Connect(function()
               local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
               if hrp then
                  -- Find closest enemy
                  local closestEnemy = nil
                  local shortestDist = 20 -- radius 20 studs
                  
                  for _, obj in pairs(workspace:GetDescendants()) do
                     if obj:IsA("Humanoid") and obj.Parent and obj.Parent ~= game.Players.LocalPlayer.Character then
                        local enemyHrp = obj.Parent:FindFirstChild("HumanoidRootPart")
                        if enemyHrp and obj.Health > 0 then
                           local dist = (hrp.Position - enemyHrp.Position).Magnitude
                           if dist < shortestDist then
                              shortestDist = dist
                              closestEnemy = obj.Parent
                           end
                        end
                     end
                  end
                  
                  if closestEnemy then
                     -- Kita asumsikan 'target' butuh Instance musuh atau ID musuh. Untuk amannya kirim model musuh
                     Event:FireServer(1, 1)
                     Event:FireServer(2, 1, {closestEnemy})
                     Event:FireServer(2, 1, {closestEnemy})
                     Event:FireServer(2, 1, {closestEnemy})
                     Event:FireServer(3, 1)
                  end
               end
            end)
         else
            print("[Auto] Kill Aura Melee: ON (Not Levelbound)")
            -- Implementasi default untuk game lain jika diperlukan
         end
      else
         print("[Auto] Kill Aura Melee: OFF")
         if KillAuraConnection then
            KillAuraConnection:Disconnect()
            KillAuraConnection = nil
         end
      end
   end,
})

TabMain:CreateToggle({
   Name = "Auto Claim Daily Quest",
   CurrentValue = false,
   Flag = "AutoClaimDaily",
   Callback = function(Value)
      -- [PLACEHOLDER] Remote untuk nge-claim /nge-loop cek daily
   end,
})

TabMain:CreateToggle({
   Name = "Auto Skill",
   CurrentValue = false,
   Flag = "AutoSkill",
   Callback = function(Value)
      -- [PLACEHOLDER] Remote loop fire skill
   end,
})

TabMain:CreateSlider({
   Name = "Hitbox Size",
   Range = {1, 20},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = 2,
   Flag = "HitboxSize",
   Callback = function(Value)
      -- [PLACEHOLDER] Update size dari local variable atau ganti properti Size hitbox
   end,
})

TabMain:CreateToggle({
   Name = "Hitbox Expander",
   CurrentValue = false,
   Flag = "HitboxExpander",
   Callback = function(Value)
      -- [PLACEHOLDER] Enable/Disable root part size iteration
   end,
})

----------------------------------------------------------------------
-- 2. VISUALS
----------------------------------------------------------------------
local SectionVisuals = TabVisuals:CreateSection("Visuals")

TabVisuals:CreateSlider({
   Name = "ESP Range",
   Range = {10, 500},
   Increment = 10,
   Suffix = "studs",
   CurrentValue = 100,
   Flag = "ESPRange",
   Callback = function(Value)
      -- [PLACEHOLDER] Jarak maksimum ESP di-render
   end,
})

TabVisuals:CreateToggle({
   Name = "Chest ESP",
   CurrentValue = false,
   Flag = "ChestESP",
   Callback = function(Value)
      -- [PLACEHOLDER] Toggle drawing kotak/ntext ESP untuk chest
   end,
})

TabVisuals:CreateToggle({
   Name = "Enemy ESP",
   CurrentValue = false,
   Flag = "EnemyESP",
   Callback = function(Value)
   end,
})

TabVisuals:CreateToggle({
   Name = "Ruby ESP",
   CurrentValue = false,
   Flag = "RubyESP",
   Callback = function(Value)
   end,
})

TabVisuals:CreateToggle({
   Name = "Altar ESP",
   CurrentValue = false,
   Flag = "AltarESP",
   Callback = function(Value)
   end,
})

----------------------------------------------------------------------
-- 3. INVASION
----------------------------------------------------------------------
local SectionInvasion = TabInvasion:CreateSection("Invasion")

TabInvasion:CreateButton({
   Name = "Join Dungeon as PK",
   Callback = function()
      -- [PLACEHOLDER] Remote FireServer untuk masuk matchmaking dungeon mode PK (Player Kill)
      print("[Action] Joining Dungeon as PK...")
   end,
})

TabInvasion:CreateToggle({
   Name = "Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarmInvasion",
   Callback = function(Value)
      -- [PLACEHOLDER] Loop pathfinding / tele farming di dungeon/invasion
   end,
})

----------------------------------------------------------------------
-- 4. TELEPORT
----------------------------------------------------------------------
local SectionTeleport = TabTeleport:CreateSection("Teleport Config")

TabTeleport:CreateDropdown({
   Name = "Dungeon Location",
   Options = {"Orc Lands (1-10)", "Goblin Cave (10-20)", "Skeleton Crypt (20-30)"}, -- Placeholder areas
   CurrentOption = {"Orc Lands (1-10)"},
   MultipleOptions = false,
   Flag = "DungeonLocation",
   Callback = function(Option)
      -- [PLACEHOLDER] Update variabel lokasi untuk join dungeon
   end,
})

TabTeleport:CreateDropdown({
   Name = "Difficulty",
   Options = {"Easy", "Normal", "Hard", "Nightmare"},
   CurrentOption = {"Easy"},
   MultipleOptions = false,
   Flag = "DungeonDifficulty",
   Callback = function(Option)
      -- [PLACEHOLDER] Update variabel difficulty
   end,
})

local SectionTeleportModifiers = TabTeleport:CreateSection("Dungeon Modifiers")

local tpToggles = {"Lucky Dungeon", "Invasions", "Ghostified", "Private Group", "Solo Mode"}
for _, name in ipairs(tpToggles) do
   TabTeleport:CreateToggle({
      Name = name,
      CurrentValue = false,
      Flag = name:gsub(" ", ""),
      Callback = function(Value)
         -- [PLACEHOLDER] Set param group dungeon
      end,
   })
end

TabTeleport:CreateButton({
   Name = "Create Dungeon Group",
   Callback = function()
      -- [PLACEHOLDER] Kirim InvokeServer dengan params dari dropdown dan toggle di atas
      print("[Action] Creating Dungeon Group...")
   end,
})

----------------------------------------------------------------------
-- 5. MODIFIERS
----------------------------------------------------------------------
local SectionModifiers = TabModifiers:CreateSection("Modifiers")

local gameModifiers = {
   "No EXP Lose", 
   "Elite Enemies Only", 
   "Mobs 2x HP", 
   "No Campfires", 
   "Reduce Damage By...", 
   "Damage 2x"
}

for _, modName in ipairs(gameModifiers) do
   TabModifiers:CreateToggle({
      Name = modName,
      CurrentValue = false,
      Flag = modName:gsub(" ", ""),
      Callback = function(Value)
         -- [PLACEHOLDER] Modifier remote atau table param update
      end,
   })
end

----------------------------------------------------------------------
-- 6. ADMIN
----------------------------------------------------------------------
local SectionAdmin = TabAdmin:CreateSection("Admin Tools")

TabAdmin:CreateButton({
   Name = "Load CobaltSpy",
   Callback = function()
      -- Memuat CobaltSpy.lua dari repository GitHub ini langsung menggunakan HttpGet
      loadstring(game:HttpGet("https://raw.githubusercontent.com/kndrckm/kndrckm.github.io/main/key/CobaltSpy.lua"))()
      print("[Admin] CobaltSpy Berhasil Dimuat!")
   end,
})

----------------------------------------------------------------------
-- INIT
----------------------------------------------------------------------
Rayfield:LoadConfiguration()
