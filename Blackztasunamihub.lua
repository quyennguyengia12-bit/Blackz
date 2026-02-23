-- BLACKZ HUB v12.0 FIXED SLOW DUPE + PRECISE TP | No Random | Feb 23 2026
local TweenService = game:GetService("TweenService")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local Char, HRP, Hum

local Fly = false; local FlySpeed = 150; local AutoUp = true
local AutoCollectCoinSK = false; local AutoCollectBrainrot = false; local AutoCollectAll = false
local Godmode = false; local InfiniteJump = false; local AutoRebirth = false; local AutoSell = false; local AutoCollectRemote = false
local DeleteWalls = false; local DeleteWave = false
local AutoSteal = false; local MultiClaim = 25; local CollectRadius = 2000; local UseClone = true; local DupeSpeed = 0.12  -- SLOW FIXED
local AutoDoom = false
local WalkSpeedVal = 50
local RaritySelect = "All"

local TweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)  -- SLOWER TWEEN

local function LoadChar() Char = LP.Character or LP.CharacterAdded:Wait(); Hum = Char:WaitForChild("Humanoid"); HRP = Char:WaitForChild("HumanoidRootPart"); Hum.WalkSpeed = WalkSpeedVal end
LoadChar(); LP.CharacterAdded:Connect(LoadChar)

local function getCollectPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj:FindFirstChild("Handle") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end

local function getPrompt(obj)
    for _, child in pairs(obj:GetDescendants()) do
        if child:IsA("ProximityPrompt") then return child end
    end
    return nil
end

local function matchesRarity(name_lower, selected)
    if selected == "All" then return true end
    local rarities = {
        Divine = "divine", Celestial = "celestial", Doom = "doom", Mythical = "mythical",
        Infinity = "infinity", Galaxy = "galaxy", Arcane = "arcane", UFO = "ufo", Radioactive = "radioactive"
    }
    return name_lower:find(rarities[selected:lower()] or "")
end

-- V12 FIXED: SLOW + PRECISE TP (part.CFrame * (0,5,-4) NO RANDOM!)
local function dupeObj(part, times)
    local prompt = getPrompt(part.Parent or part)
    -- PRECISE TP: Face part, 5 studs up, 4 studs front
    local targetCFrame = part.CFrame * CFrame.new(0, 5, -4)
    for i = 1, times do
        -- Tween PRECISE NO BAY SAI
        local tween = TweenService:Create(HRP, TweenInfo, {CFrame = targetCFrame})
        tween:Play(); tween.Completed:Wait()
        
        -- Prompt x15 SLOW (less spam)
        if prompt then
            for _ = 1, 15 do
                pcall(fireproximityprompt, prompt)
                task.wait(0.005)  -- Slow random-ish
            end
            print("V12 PROMPT x15: " .. (prompt.Name or "Unknown"))
        end
        
        -- Touch x8 SLOW
        for _ = 1, 8 do
            firetouchinterest(HRP, part, 0); task.wait(0.02)
            firetouchinterest(HRP, part, 1); task.wait(0.02)
        end
        
        -- Clone x4 SLOW
        if UseClone then
            for _ = 1, 4 do
                local clone = part:Clone()
                clone.Parent = Workspace
                clone.CFrame = part.CFrame * CFrame.new(math.random(-2,2), math.random(1,3), math.random(-2,2))  -- Small offset
                task.wait(0.04)
                firetouchinterest(HRP, clone, 0); task.wait(0.02); firetouchinterest(HRP, clone, 1)
                game.Debris:AddItem(clone, 0.8)
            end
        end
        
        task.wait(DupeSpeed)
    end
end

-- Fly (same)
RunService.RenderStepped:Connect(function(dt)
    pcall(function()
        if Fly and HRP and Hum then Hum.PlatformStand = true
            local cam = Workspace.CurrentCamera; local move = cam.CFrame.LookVector * FlySpeed * dt * 1.5
            local up = AutoUp and Vector3.new(0, FlySpeed * dt * 3, 0) or Vector3.new()
            HRP.CFrame = HRP.CFrame + move + up; HRP.Velocity = Vector3.new(0,0,0)
        elseif Hum then Hum.PlatformStand = false end
    end)
end)

UserInputService.JumpRequest:Connect(function() if InfiniteJump and Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

-- God/Noclip
spawn(function() while task.wait(0.05) do pcall(function() if Godmode and Char then for _, p in pairs(Char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end) end end)

-- WalkSpeed
spawn(function() while task.wait() do pcall(function() if Hum then Hum.WalkSpeed = WalkSpeedVal; Hum.JumpPower = 100 end end) end end)

-- Delete Wave/Walls
spawn(function() while task.wait(0.1) do if DeleteWave or DeleteWalls then for _, obj in pairs(Workspace:GetDescendants()) do if obj:IsA("BasePart") then local name = obj.Name:lower() if (DeleteWave and (name:find("wave") or name:find("tsunami") or name:find("water"))) or (DeleteWalls and (name:find("wall") or name:find("vip"))) then obj:Destroy() end end end end end end)

-- Auto Collect Remotes
local collectRemotes = {"Collect", "CollectBrainrot", "GetBrainrot", "Claim", "CollectCoin", "CollectAll"}
spawn(function() while task.wait(0.5) do if AutoCollectRemote then for _, name in pairs(collectRemotes) do pcall(function() local remote = ReplicatedStorage:FindFirstChild(name, true) if remote and remote:IsA("RemoteEvent") then remote:FireServer() end end) end end end end)

-- Auto Doom (precise TP)
spawn(function() while task.wait(0.08) do if AutoDoom and HRP then for _, obj in pairs(Workspace:GetDescendants()) do local prompt = getPrompt(obj) if prompt then local fullName = (prompt.Name .. (prompt.Parent.Name or "") .. (prompt.Parent.Parent and prompt.Parent.Parent.Name or "")):lower() if fullName:find("doom") or fullName:find("tower") then local part = getCollectPart(prompt.Parent) if part and (part.Position - HRP.Position).Magnitude < CollectRadius then local tween = TweenService:Create(HRP, TweenInfo, {CFrame = part.CFrame * CFrame.new(0,6,-4)}) tween:Play(); tween.Completed:Wait() fireproximityprompt(prompt) end end end end end end end)

-- Auto Coin
spawn(function() while task.wait(0.15) do if AutoCollectCoinSK and HRP then for _, obj in pairs(Workspace:GetDescendants()) do local part = getCollectPart(obj) if part and (obj.Name:lower():find("coin") or obj.Name:lower():find("token") or obj.Name:lower():find("event")) and (part.Position - HRP.Position).Magnitude < CollectRadius then dupeObj(part, MultiClaim) break end end end end end)

-- Auto Brainrot SLOW LOOP + PRECISE
spawn(function() while task.wait(0.15) do  -- FIXED SLOW
    local radius = AutoSteal and CollectRadius * 1.5 or CollectRadius
    local claims = AutoSteal and MultiClaim or MultiClaim
    local targetRarity = AutoCollectBrainrot and RaritySelect or "All"
    if (AutoCollectBrainrot or AutoSteal) and HRP then
        for _, obj in pairs(Workspace:GetDescendants()) do
            local part = getCollectPart(obj)
            local name = obj.Name:lower()
            if part and not part.Parent:FindFirstChild("Humanoid") and matchesRarity(name, targetRarity) and
               (name:find("brain") or name:find("brainrot") or name:find("doom") or name:find("celestial")) and
               (part.Position - HRP.Position).Magnitude < radius then
                dupeObj(part, claims)
                break
            end
        end
    end
end end)

-- Auto All SLOW
spawn(function() while task.wait(0.2) do if AutoCollectAll and HRP then for _, obj in pairs(Workspace:GetDescendants()) do local part = getCollectPart(obj) if part and not part.Parent:FindFirstChild("Humanoid") and (part.Position - HRP.Position).Magnitude < CollectRadius then dupeObj(part, MultiClaim) break end end end end end)

-- Auto Rebirth / Sell (same)
spawn(function() while task.wait(2.5) do if AutoRebirth then pcall(function() local reb = ReplicatedStorage:FindFirstChild("Rebirth") if reb then reb:FireServer() end end) end end end)
spawn(function() while task.wait(1.5) do if AutoSell then pcall(function() local remotes = {"SellAll", "Sell", "SellBrainrots", "CollectMoney"} for _, name in pairs(remotes) do local remote = ReplicatedStorage:FindFirstChild(name, true) if remote and remote:IsA("RemoteEvent") then remote:FireServer() break end end end) end end end)

-- UI V12
local Window = Rayfield:CreateWindow({Name = "🧠 BLACKZ v12 FIXED (Slow Dupe + Precise TP!)", LoadingTitle = "No Lag + No Bay Sai!", LoadingSubtitle = "Delta Private | Farm Celestial x50!" })

local MainTab = Window:CreateTab("🤖 Main"); local DupeTab = Window:CreateTab("💎 Dupe"); local DoomTab = Window:CreateTab("⚡ Doom")
local TPTab = Window:CreateTab("🚀 TP"); local AutoTab = Window:CreateTab("🔄 Auto"); local MiscTab = Window:CreateTab("⚙️ Misc")

MainTab:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(v) Fly = v end})
MainTab:CreateToggle({Name = "Auto Up", CurrentValue = true, Callback = function(v) AutoUp = v end})
MainTab:CreateSlider({Name = "Fly Speed", Range = {100, 400}, Increment = 20, CurrentValue = 150, Callback = function(v) FlySpeed = v end})
MainTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) InfiniteJump = v end})
MainTab:CreateToggle({Name = "Auto Coin/Event", CurrentValue = false, Callback = function(v) AutoCollectCoinSK = v end})
MainTab:CreateToggle({Name = "Auto Brainrot (Rarity)", CurrentValue = false, Callback = function(v) AutoCollectBrainrot = v end})
MainTab:CreateToggle({Name = "Auto All", CurrentValue = false, Callback = function(v) AutoCollectAll = v end})

DupeTab:CreateToggle({Name = "Auto Steal Dupe", CurrentValue = false, Callback = function(v) AutoSteal = v end})
DupeTab:CreateSlider({Name = "Multiplier (1-80x)", Range = {1,80}, Increment = 5, Suffix = "x", CurrentValue = 25, Callback = function(v) MultiClaim = v end})
DupeTab:CreateSlider({Name = "Radius", Range = {100,5000}, Increment = 500, CurrentValue = 2000, Callback = function(v) CollectRadius = v end})
DupeTab:CreateSlider({Name = "Dupe Speed", Range = {0.08,0.3}, Increment = 0.01, Suffix = "s", CurrentValue = 0.12, Callback = function(v) DupeSpeed = v end})  -- SLOW DEFAULT
DupeTab:CreateToggle({Name = "Clone x4", CurrentValue = true, Callback = function(v) UseClone = v end})
DupeTab:CreateButton({Name = "💥 Dupe Nearest x50 (Precise!)", Callback = function()
    local nearest, dist = nil, math.huge
    for _, obj in pairs(Workspace:GetDescendants()) do
        local part = getCollectPart(obj)
        local name = obj.Name:lower()
        if part and (name:find("brainrot") or name:find("doom") or name:find("celestial")) and (part.Position - HRP.Position).Magnitude < CollectRadius then
            local d = (part.Position - HRP.Position).Magnitude
            if d < dist then dist = d; nearest = part end
        end
    end
    if nearest then dupeObj(nearest, 50); Rayfield:Notify({Title="DUPED x50!", Content="Precise TP OK!", Duration=5}) else Rayfield:Notify({Title="No Target", Content="Fly gần hơn!", Duration=4}) end
end})

DoomTab:CreateToggle({Name = "Auto Doom", CurrentValue = false, Callback = function(v) AutoDoom = v end})

TPTab:CreateDropdown({Name = "Rarity", Options = {"All","Celestial","Doom","Divine","Mythical"}, CurrentOption = {"All"}, Callback = function(Option) RaritySelect = Option[1] end})
TPTab:CreateButton({Name = "🚀 TP + Dupe [Rarity] x30 (Precise!)", Callback = function()
    local nearest, minDist = nil, math.huge
    for _, obj in pairs(Workspace:GetDescendants()) do
        local part = getCollectPart(obj)
        local name = obj.Name:lower()
        if part and matchesRarity(name, RaritySelect) and (name:find("brain") or name:find("brainrot")) then
            local dist = (part.Position - HRP.Position).Magnitude
            if dist < minDist then minDist = dist; nearest = part end
        end
    end
    if nearest then
        local tween = TweenService:Create(HRP, TweenInfo, {CFrame = nearest.CFrame * CFrame.new(0,5,-4)})  -- PRECISE FIXED
        tween:Play(); tween.Completed:Wait()
        dupeObj(nearest, 30)
        Rayfield:Notify({Title="TP + DUPED!", Content=RaritySelect .. " x30 Precise!", Duration=5})
    else Rayfield:Notify({Title="No Target", Content="Chờ spawn!", Duration=4}) end
end})

AutoTab:CreateToggle({Name = "Auto Rebirth", CurrentValue = false, Callback = function(v) AutoRebirth = v end})
AutoTab:CreateToggle({Name = "Auto Sell", CurrentValue = false, Callback = function(v) AutoSell = v end})
AutoTab:CreateToggle({Name = "Remote Spam", CurrentValue = false, Callback = function(v) AutoCollectRemote = v end})

MiscTab:CreateToggle({Name = "God + Noclip", CurrentValue = false, Callback = function(v) Godmode = v end})
MiscTab:CreateToggle({Name = "Delete Walls", CurrentValue = false, Callback = function(v) DeleteWalls = v end})
MiscTab:CreateToggle({Name = "Delete Wave", CurrentValue = false, Callback = function(v) DeleteWave = v end})
MiscTab:CreateSlider({Name = "WalkSpeed", Range = {16,200}, Increment = 10, CurrentValue = 50, Callback = function(v) WalkSpeedVal = v end})

Rayfield:Notify({Title = "BLACKZ v12 Loaded!", Content = "Dupe Slow + TP Precise! Bật God+Fly+Auto Brainrot → Farm mượt!", Duration = 7})
