-- BLACKZ HUB v10.0 RATS DUPE | 100x Clone + Tween + Remote | FIXED 23/2/2026
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
local AutoSteal = false; local MultiClaim = 25; local CollectRadius = 2000; local UseClone = true; local DupeSpeed = 0.05
local AutoDoom = false
local WalkSpeedVal = 50
local RaritySelect = "All"

local TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

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

-- RATS DUPE SUPER FIXED: Tween TP + Clone x5 + Fire 20x Prompt + Alt Touch + Rand Pos
local function dupeObj(part, times)
    local prompt = getPrompt(part.Parent or part)
    local pos = part.Position
    for i = 1, times do
        -- Tween TP Precise
        local tween = TweenService:Create(HRP, TweenInfo, {CFrame = CFrame.new(pos + Vector3.new(math.random(-5,5), 5, math.random(-5,5)))})
        tween:Play(); tween.Completed:Wait()
        
        -- Fire Prompt 20x FAST (Rats method)
        if prompt then
            for _ = 1, 20 do
                pcall(fireproximityprompt, prompt)
                task.wait(0.001)
            end
            print("RATS PROMPT x20: " .. (prompt.Name or "Unknown"))
        end
        
        -- Alt Touch x10
        for _ = 1, 10 do
            firetouchinterest(HRP, part, 0); task.wait(0.01)
            firetouchinterest(HRP, part, 1); task.wait(0.01)
        end
        
        -- Clone x5 (bypass server check)
        if UseClone then
            for _ = 1, 5 do
                local clone = part:Clone()
                clone.Parent = part.Parent
                local cpos = pos + Vector3.new(math.random(-3,3), math.random(1,5), math.random(-3,3))
                clone.CFrame = CFrame.new(cpos)
                task.wait(0.05)
                firetouchinterest(HRP, clone, 0); task.wait(0.02); firetouchinterest(HRP, clone, 1)
                clone:Destroy()
            end
        end
        
        task.wait(DupeSpeed)
    end
end

-- Fly (enhanced speed)
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

-- God/Noclip FAST
spawn(function() while task.wait(0.05) do pcall(function() if Godmode and Char then for _, p in pairs(Char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end) end end)

-- WalkSpeed
spawn(function() while task.wait() do pcall(function() if Hum then Hum.WalkSpeed = WalkSpeedVal; Hum.JumpPower = 100 end end) end end)

-- Delete Wave/Walls FAST 0.1s
spawn(function()
    while task.wait(0.1) do
        if DeleteWave or DeleteWalls then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    if DeleteWave and (name:find("wave") or name:find("tsunami") or name:find("water") or name:find("flood")) then obj:Destroy() end
                    if DeleteWalls and (name:find("wall") or name:find("barrier") or name:find("fence") or name:find("vip")) then obj:Destroy() end
                end
            end
        end
    end
end)

-- Auto Collect Remotes SPAM (Rats extra)
local collectRemotes = {"Collect", "CollectBrainrot", "GetBrainrot", "Claim", "ClaimReward", "CollectCoin", "GetMoney", "CollectAll"}
spawn(function()
    while task.wait(0.5) do
        if AutoCollectRemote then
            for _, name in pairs(collectRemotes) do
                pcall(function()
                    local remote = ReplicatedStorage:FindFirstChild(name, true)
                    if remote and remote:IsA("RemoteEvent") then remote:FireServer(); print("REMOTE SPAM: " .. name) end
                end)
            end
        end
    end
end)

-- Auto Doom ENHANCED
spawn(function()
    while task.wait(0.05) do  -- Faster
        if AutoDoom and HRP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                local prompt = getPrompt(obj)
                if prompt then
                    local fullName = (prompt.Name .. (prompt.Parent.Name or "") .. (prompt.Parent.Parent and prompt.Parent.Parent.Name or "")):lower()
                    if fullName:find("doom") or fullName:find("tower") or fullName:find("machine") then
                        local part = getCollectPart(prompt.Parent)
                        if part and (part.Position - HRP.Position).Magnitude < CollectRadius then
                            local tween = TweenService:Create(HRP, TweenInfo, {CFrame = part.CFrame * CFrame.new(0,6,0)})
                            tween:Play(); tween.Completed:Wait()
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Coin FAST
spawn(function()
    while task.wait(0.08) do
        if AutoCollectCoinSK and HRP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                local part = getCollectPart(obj)
                if part and (obj.Name:lower():find("coin") or obj.Name:lower():find("token") or obj.Name:lower():find("sk") or obj.Name:lower():find("event")) and (part.Position - HRP.Position).Magnitude < CollectRadius then
                    dupeObj(part, MultiClaim)
                    break
                end
            end
        end
    end
end)

-- Auto Brainrot RATS LOOP 0.05s + Rarity
spawn(function()
    while task.wait(DupeSpeed) do  -- Super fast như Rats
        local radius = AutoSteal and CollectRadius * 2 or CollectRadius
        local claims = AutoSteal and MultiClaim * 2 or MultiClaim  -- Double nếu steal
        local targetRarity = AutoCollectBrainrot and RaritySelect or "All"
        if (AutoCollectBrainrot or AutoSteal) and HRP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                local part = getCollectPart(obj)
                local name = obj.Name:lower()
                if part and not part.Parent:FindFirstChild("Humanoid") and matchesRarity(name, targetRarity) and
                   (name:find("brain") or name:find("brainrot") or name:find("divine") or name:find("doom") or name:find("celestial") or 
                    name:find("mythical") or name:find("infinity") or name:find("pet") or name:find("tower")) and
                   (part.Position - HRP.Position).Magnitude < radius then
                    dupeObj(part, claims)
                    break
                end
            end
        end
    end
end)

-- Auto All
spawn(function()
    while task.wait(0.1) do
        if AutoCollectAll and HRP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                local part = getCollectPart(obj)
                if part and not part.Parent:FindFirstChild("Humanoid") and (part.Position - HRP.Position).Magnitude < CollectRadius then
                    dupeObj(part, MultiClaim)
                    break
                end
            end
        end
    end
end)

-- Auto Rebirth
spawn(function() while task.wait(2) do if AutoRebirth then pcall(function() if ReplicatedStorage:FindFirstChild("Rebirth") then ReplicatedStorage.Rebirth:FireServer() end end) end end end)

-- Auto Sell ENHANCED
spawn(function() while task.wait(1) do if AutoSell then
    pcall(function()
        local remotes = {"SellAll", "Sell", "SellBrainrots", "CollectMoney", "SellAllPets"}
        for _, name in pairs(remotes) do
            local remote = ReplicatedStorage:FindFirstChild(name, true)
            if remote and remote:IsA("RemoteEvent") then remote:FireServer(); print("SELL: " .. name) break end
        end
    end)
end end end)

-- RAYFIELD UI V10 RATS STYLE
local Window = Rayfield:CreateWindow({Name = "🧠 BLACKZ v10 RATS DUPE (100x Tween Clone!)", LoadingTitle = "Dupe Doom/Celestial 1s!", LoadingSubtitle = "Fixed lag | Delta best | Quyến OP!"})

local MainTab = Window:CreateTab("🤖 Main Farm"); local DupeTab = Window:CreateTab("💎 Dupe RATS"); local DoomTab = Window:CreateTab("⚡ Doom");
local TPTab = Window:CreateTab("🚀 TP + Rarity"); local AutoTab = Window:CreateTab("🔄 Auto"); local MiscTab = Window:CreateTab("⚙️ Misc");

MainTab:CreateToggle({Name = "Fly (Rats Speed)", CurrentValue = false, Callback = function(v) Fly = v end})
MainTab:CreateToggle({Name = "Auto Up", CurrentValue = true, Callback = function(v) AutoUp = v end})
MainTab:CreateSlider({Name = "Fly Speed", Range = {100, 500}, Increment = 20, Suffix = "", CurrentValue = 150, Callback = function(v) FlySpeed = v end})
MainTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) InfiniteJump = v end})
MainTab:CreateToggle({Name = "Auto Coin/Token/Event", CurrentValue = false, Callback = function(v) AutoCollectCoinSK = v end})
MainTab:CreateToggle({Name = "Auto Brainrot (Rarity)", CurrentValue = false, Callback = function(v) AutoCollectBrainrot = v end})
MainTab:CreateToggle({Name = "Auto All Collect", CurrentValue = false, Callback = function(v) AutoCollectAll = v end})

DupeTab:CreateToggle({Name = "Auto Steal DUPE (4000r FAST)", CurrentValue = false, Callback = function(v) AutoSteal = v end})
DupeTab:CreateSlider({Name = "Multiplier (1-100x RATS)", Range = {1,100}, Increment = 5, Suffix = "x", CurrentValue = 25, Callback = function(v) MultiClaim = v end})
DupeTab:CreateSlider({Name = "Radius (100-5000)", Range = {100,5000}, Increment = 500, Suffix = "", CurrentValue = 2000, Callback = function(v) CollectRadius = v end})
DupeTab:CreateSlider({Name = "Dupe Speed (0.01-0.2s)", Range = {0.01,0.2}, Increment = 0.01, Suffix = "s", CurrentValue = 0.05, Callback = function(v) DupeSpeed = v end})
DupeTab:CreateToggle({Name = "Clone x5 (Bypass)", CurrentValue = true, Callback = function(v) UseClone = v end})
DupeTab:CreateButton({
    Name = "💥 SUPER DUPE Nearest x100 (RATS!)",
    Callback = function()
        local nearest, dist = nil, math.huge
        for _, obj in pairs(Workspace:GetDescendants()) do
            local part = getCollectPart(obj)
            local name = obj.Name:lower()
            if part and (name:find("brainrot") or name:find("doom") or name:find("celestial") or name:find("divine")) and (part.Position - HRP.Position).Magnitude < CollectRadius * 2 then
                local d = (part.Position - HRP.Position).Magnitude
                if d < dist then dist = d; nearest = part end
            end
        end
        if nearest then 
            dupeObj(nearest, 100)
            Rayfield:Notify({Title="RATS SUPER DUPED!", Content="x100! Check inv F9 log", Duration=7, Image="rbxassetid://4483345998"})
        else 
            Rayfield:Notify({Title="No Target", Content="Fly gần brainrot Doom/Celestial!", Duration=5})
        end
    end
})

DoomTab:CreateToggle({Name = "Auto Doom Tower (Tween)", CurrentValue = false, Callback = function(v) AutoDoom = v end})
DoomTab:CreateButton({Name = "🔥 TP + Spam All Doom Prompts", Callback = function()
    local count = 0
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.Name:lower():find("doom") then
            local part = getCollectPart(obj.Parent)
            if part then 
                local tween = TweenService:Create(HRP, TweenInfo, {CFrame = part.CFrame * CFrame.new(0,6,0)})
                tween:Play(); tween.Completed:Wait()
                for _=1,20 do fireproximityprompt(obj) end
                count +=1 
            end
        end
    end
    Rayfield:Notify({Title="DOOM SPAM", Content=count .. "x20 Fired!", Duration=5})
end})

TPTab:CreateDropdown({Name = "Rarity TP/Dupe", Options = {"All","Divine","Celestial","Doom","Mythical","Infinity","Galaxy","Arcane","UFO","Radioactive"}, CurrentOption = {"All"}, Callback = function(Option) RaritySelect = Option[1] end})
TPTab:CreateButton({Name = "🚀 Insta Tween TP + Dupe [Rarity] x50", Callback = function()
    local nearest, minDist = nil, math.huge
    for _, obj in pairs(Workspace:GetDescendants()) do
        local part = getCollectPart(obj)
        local name = obj.Name:lower()
        if part and matchesRarity(name, RaritySelect) and (name:find("brain") or name:find("brainrot") or name:find("tower")) then
            local dist = (part.Position - HRP.Position).Magnitude
            if dist < minDist then minDist = dist; nearest = part end
        end
    end
    if nearest then
        local tween = TweenService:Create(HRP, TweenInfo, {CFrame = nearest.CFrame * CFrame.new(0,5,0)})
        tween:Play(); tween.Completed:Wait()
        dupeObj(nearest, 50)
        Rayfield:Notify({Title="RATS TP + 50x!", Content=RaritySelect .. " DUPED!", Duration=5})
    else
        Rayfield:Notify({Title="No " .. RaritySelect, Content="Chờ spawn hoặc fly tìm!", Duration=4})
    end
end})

AutoTab:CreateToggle({Name = "Auto Rebirth (2s)", CurrentValue = false, Callback = function(v) AutoRebirth = v end})
AutoTab:CreateToggle({Name = "Auto Sell All (1s)", CurrentValue = false, Callback = function(v) AutoSell = v end})
AutoTab:CreateToggle({Name = "Auto Remote Collect Spam", CurrentValue = false, Callback = function(v) AutoCollectRemote = v end})

MiscTab:CreateToggle({Name = "Godmode + Noclip", CurrentValue = false, Callback = function(v) Godmode = v end})
MiscTab:CreateToggle({Name = "Delete VIP Walls", CurrentValue = false, Callback = function(v) DeleteWalls = v end})
MiscTab:CreateToggle({Name = "Delete Tsunami/Wave", CurrentValue = false, Callback = function(v) DeleteWave = v end})
MiscTab:CreateSlider({Name = "WalkSpeed", Range = {16, 300}, Increment = 10, Suffix = "", CurrentValue = 50, Callback = function(v) WalkSpeedVal = v end})

Rayfield:Notify({Title = "BLACKZ v10 RATS Loaded!", Content = "Dupe x100 1s! Bật God+Fly+Auto Brainrot+Celestial → INF! Private Delta", Duration = 8, Image="rbxassetid://4483345998"})
