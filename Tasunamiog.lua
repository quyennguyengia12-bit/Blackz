-- BLACKZ HUB v8.2 DUPE FIXED FEB 2026 | Priority ProximityPrompt + Doom Tower/Brainrot
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local Char, HRP, Hum

local Fly = false; local FlySpeed = 120; local AutoUp = true
local AutoCollectCoinSK = false; local AutoCollectBrainrot = false; local AutoCollectAll = false
local Godmode = false; local InfiniteJump = false; local AutoRebirth = false
local DeleteWalls = false; local DeleteWave = false

local AutoSteal = false; local MultiClaim = 12; local CollectRadius = 1000; local UseClone = false  -- Clone OFF default (ít detect hơn)
local AutoDoom = false

local function LoadChar() Char = LP.Character or LP.CharacterAdded:Wait(); Hum = Char:WaitForChild("Humanoid"); HRP = Char:WaitForChild("HumanoidRootPart") end
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

-- DUPE FIXED v8.2: Priority Prompt + Touch fallback + random delay
local function dupeObj(part, times)
    for i = 1, times do
        local randX, randY, randZ = math.random(-10,10), math.random(8,20), math.random(-10,10)
        local tpPos = part.Position + Vector3.new(randX, randY, randZ)
        HRP.CFrame = CFrame.new(tpPos)
        task.wait(math.random(8,20)/100)  -- random delay

        local prompt = getPrompt(part.Parent or part)
        if prompt then
            fireproximityprompt(prompt)
            print("🔥 PROMPT FIRED: " .. (prompt.Name or "Unknown") .. " for " .. part.Parent.Name)
        else
            firetouchinterest(HRP, part, 0); task.wait(0.02)
            firetouchinterest(HRP, part, 1); task.wait(0.02)
            print("👐 TOUCH fallback for " .. part.Parent.Name)
        end
    end
end

-- Fly
RunService.RenderStepped:Connect(function(dt)
    pcall(function()
        if Fly and HRP and Hum then Hum.PlatformStand = true
            local cam = Workspace.CurrentCamera; local move = cam.CFrame.LookVector * FlySpeed * dt
            local up = AutoUp and Vector3.new(0, FlySpeed * dt * 2, 0) or Vector3.new()
            HRP.CFrame = HRP.CFrame + move + up; HRP.Velocity = Vector3.new(0,0,0)
        elseif Hum then Hum.PlatformStand = false end
    end)
end)

UserInputService.JumpRequest:Connect(function() if InfiniteJump and Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

spawn(function() while task.wait(0.1) do pcall(function() if Godmode and Char then for _, p in pairs(Char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end) end end)

-- Delete
spawn(function()
    while task.wait(0.15) do
        if DeleteWave or DeleteWalls then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    if DeleteWave and (name:find("wave") or name:find("tsunami") or name:find("water") or name:find("flood")) then obj:Destroy() end
                    if DeleteWalls and (name:find("wall") or name:find("barrier") or name:find("fence") or name:find("invisible")) then obj:Destroy() end
                end
            end
        end
    end
end)

-- Auto Doom Machine v8.2 (FAST prompt + collect)
spawn(function()
    while task.wait(0.08) do
        if AutoDoom and HRP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                local prompt = obj:IsA("ProximityPrompt") and obj or nil
                if prompt then
                    local fullName = (obj.Name .. (obj.Parent.Name or "") .. (obj.Parent.Parent and obj.Parent.Parent.Name or "")):lower()
                    if fullName:find("doom") or fullName:find("tower") or fullName:find("button") or fullName:find("machine") then
                        local part = getCollectPart(obj.Parent or obj)
                        if part and (part.Position - HRP.Position).Magnitude < CollectRadius then
                            HRP.CFrame = part.CFrame * CFrame.new(0,6,0)
                            fireproximityprompt(prompt)
                            print("💀 DOOM PROMPT: " .. obj.Name)
                        end
                    end
                end

                local part = getCollectPart(obj)
                if part and (obj.Name:lower():find("doom") or obj.Name:lower():find("token") or obj.Name:lower():find("coin") and obj.Name:lower():find("doom")) and (part.Position - HRP.Position).Magnitude < CollectRadius then
                    dupeObj(part, MultiClaim)
                    print("💀 DOOM ITEM DUPED x" .. MultiClaim)
                end
            end
        end
    end
end)

-- Auto Coin/Event (prompt priority)
spawn(function()
    while task.wait(0.18) do
        if AutoCollectCoinSK and HRP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                local part = getCollectPart(obj)
                if part and (obj.Name:lower():find("coin") or obj.Name:lower():find("token") or obj.Name:lower():find("sk") or obj.Name:lower():find("event") or obj.Name:lower():find("reward")) and (part.Position - HRP.Position).Magnitude < CollectRadius then
                    dupeObj(part, 1)
                    break
                end
            end
        end
    end
end)

-- Auto Brainrot Dupe v8.2 (+ new names)
spawn(function()
    while task.wait(0.15) do
        local radius = AutoSteal and 1200 or CollectRadius; local claims = AutoSteal and MultiClaim or 1
        if (AutoCollectBrainrot or AutoSteal) and HRP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                local part = getCollectPart(obj)
                local name = obj.Name:lower()
                if part and not part.Parent:FindFirstChild("Humanoid") and
                   (name:find("brain") or name:find("brainrot") or name:find("divine") or name:find("infinity") or name:find("galaxy") or 
                    name:find("arcane") or name:find("ufo") or name:find("doom") or name:find("mythical") or name:find("celestial") or 
                    name:find("radioactive") or name:find("pet") or name:find("meme") or name:find("tower")) and
                   (part.Position - HRP.Position).Magnitude < radius then
                    print("🧠 FOUND: " .. obj.Name .. " | Dist: " .. math.floor((part.Position - HRP.Position).Magnitude))
                    dupeObj(part, claims)
                    if UseClone then
                        local clone = obj:Clone(); clone.Parent = Workspace
                        local cpart = getCollectPart(clone)
                        if cpart then dupeObj(cpart, 3) end
                        clone:Destroy()
                        print("🔄 CLONE EXTRA")
                    end
                    print("🌊 DUPED: " .. obj.Name .. " x" .. claims)
                    break
                end
            end
        end
    end
end)

-- Auto All (prompt priority)
spawn(function()
    while task.wait(0.2) do
        if AutoCollectAll and HRP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                local part = getCollectPart(obj)
                if part and not part.Parent:FindFirstChild("Humanoid") and (part.Position - HRP.Position).Magnitude < CollectRadius then
                    dupeObj(part, 1)
                    break
                end
            end
        end
    end
end)

spawn(function() while task.wait(3) do if AutoRebirth then pcall(function() if ReplicatedStorage:FindFirstChild("Rebirth") then ReplicatedStorage.Rebirth:FireServer() end end) end end end)

-- UI v8.2
local Window = Rayfield:CreateWindow({Name = "BLACKZ v8.2 DUPE FIXED 2026 (Prompt Priority)", LoadingTitle = "Farm Doom/Celestial Max!", LoadingSubtitle = "Chào Quyến! 💀🧠"})

local MainTab = Window:CreateTab("Main"); local DupeTab = Window:CreateTab("Dupe"); local DoomTab = Window:CreateTab("💀 Doom"); local MiscTab = Window:CreateTab("Misc")

MainTab:CreateToggle({Name = "Fly (Xoay + Auto Up)", CurrentValue = false, Callback = function(v) Fly = v end})
MainTab:CreateToggle({Name = "Auto Up", CurrentValue = true, Callback = function(v) AutoUp = v end})
MainTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) InfiniteJump = v end})
MainTab:CreateToggle({Name = "Auto Coin/Token/Event", CurrentValue = false, Callback = function(v) AutoCollectCoinSK = v end})
MainTab:CreateToggle({Name = "Auto Brainrot (Normal)", CurrentValue = false, Callback = function(v) AutoCollectBrainrot = v end})
MainTab:CreateToggle({Name = "Auto All", CurrentValue = false, Callback = function(v) AutoCollectAll = v end})

DupeTab:CreateToggle({Name = "🚀 Auto Steal + Dupe (1200r)", CurrentValue = false, Callback = function(v) AutoSteal = v end})
DupeTab:CreateSlider({Name = "Multiplier", Range = {5,25}, Increment = 1, Suffix = "x", CurrentValue = 12, Callback = function(v) MultiClaim = v end})
DupeTab:CreateToggle({Name = "Use Clone (Extra - but riskier)", CurrentValue = false, Callback = function(v) UseClone = v end})
DupeTab:CreateButton({
    Name = "🧪 Test Dupe Nearest x25 (F9 log)",
    Callback = function()
        local nearest, dist = nil, math.huge
        for _, obj in pairs(Workspace:GetDescendants()) do
            local part = getCollectPart(obj)
            local name = obj.Name:lower()
            if part and (name:find("brainrot") or name:find("divine") or name:find("doom") or name:find("mythical") or name:find("celestial")) and (part.Position - HRP.Position).Magnitude < 1500 then
                local d = (part.Position - HRP.Position).Magnitude
                if d < dist then dist = d; nearest = {obj, part} end
            end
        end
        if nearest then
            local obj, part = nearest[1], nearest[2]
            dupeObj(part, 25)
            print("🧠 TEST DUPED: " .. obj.Name .. " x25 (check inventory/F9)")
            Rayfield:Notify({Title="✅ TEST OK", Content=obj.Name .. " x25 - F9 log!", Duration=5})
        else
            Rayfield:Notify({Title="❌ No Target", Content="Fly gần brainrot/doom/celestial!", Duration=4})
        end
    end
})

DoomTab:CreateToggle({Name = "💀 Auto Doom Tower/Machine (Prompts + Dupe)", CurrentValue = false, Callback = function(v) AutoDoom = v end})
DoomTab:CreateButton({
    Name = "🧪 Test Fire All Doom Prompts",
    Callback = function()
        local count = 0
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and (obj.Name:lower():find("doom") or obj.Parent.Name:lower():find("doom")) then
                local part = getCollectPart(obj.Parent)
                if part then
                    HRP.CFrame = part.CFrame * CFrame.new(0,6,0)
                    fireproximityprompt(obj)
                    count = count + 1
                    print("💀 TEST PROMPT: " .. obj.Name)
                end
            end
        end
        Rayfield:Notify({Title="💀 TEST", Content=count .. " Doom Prompts Fired! Check coins/brainrots", Duration=5})
    end
})

MiscTab:CreateToggle({Name = "Godmode Noclip", CurrentValue = false, Callback = function(v) Godmode = v end})
MiscTab:CreateToggle({Name = "Delete Walls", CurrentValue = false, Callback = function(v) DeleteWalls = v end})
MiscTab:CreateToggle({Name = "Delete Wave/Tsunami", CurrentValue = false, Callback = function(v) DeleteWave = v end})
MiscTab:CreateToggle({Name = "Auto Rebirth", CurrentValue = false, Callback = function(v) AutoRebirth = v end})
MiscTab:CreateSlider({Name = "Fly Speed", Range = {50,400}, Increment = 10, CurrentValue = 120, Callback = function(v) FlySpeed = v end})
MiscTab:CreateSlider({Name = "Radius", Range = {500,1500}, Increment = 50, CurrentValue = 1000, Callback = function(v) CollectRadius = v end})

Rayfield:LoadConfiguration()
print("🌊 BLACKZ v8.2 FIXED Loaded! Prompt Priority Dupe + Doom Auto! Test F9 for logs 💀🚀")
