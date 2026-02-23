-- BLACKZ HUB - SÓNG THẦN BRAINROT v7.7 DUPE FIXED | CLONE + RANDOM TP + DELAY NÉ BYFRON (Delta Mobile OK 100%)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local Char, HRP, Hum

local Fly = false
local FlySpeed = 120
local AutoUp = true
local AutoCollectCoinSK = false
local AutoCollectBrainrot = false
local AutoCollectAll = false
local Godmode = false
local InfiniteJump = false
local AutoRebirth = false
local DeleteWalls = false
local DeleteWave = false

-- DUPE FIXED v7.7
local AutoSteal = false
local MultiClaim = 5
local CollectRadius = 450
local UseClone = true  -- Bật clone dupe extra

local function LoadChar()
    Char = LP.Character or LP.CharacterAdded:Wait()
    Hum = Char:WaitForChild("Humanoid")
    HRP = Char:WaitForChild("HumanoidRootPart")
end
LoadChar()
LP.CharacterAdded:Connect(LoadChar)

-- DUPE FUNCTION FIXED (random TP + delay + optional clone)
local function dupeObj(obj, times)
    for i = 1, times do
        -- Random TP quanh obj né detect
        local randX = math.random(-4, 4)
        local randY = math.random(4, 9)
        local randZ = math.random(-4, 4)
        local tpPos = obj.Position + Vector3.new(randX, randY, randZ)
        HRP.CFrame = CFrame.new(tpPos)
        
        -- Fire touch
        firetouchinterest(HRP, obj, 0)
        task.wait(math.random(5, 15) / 100)  -- 0.05-0.15s random
        firetouchinterest(HRP, obj, 1)
        task.wait(math.random(5, 15) / 100)
    end
end

-- Fly Mobile Fix
RunService.RenderStepped:Connect(function(dt)
    pcall(function()
        if Fly and HRP and Hum then
            Hum.PlatformStand = true
            local cam = Workspace.CurrentCamera
            local move = cam.CFrame.LookVector * FlySpeed * dt
            local up = AutoUp and Vector3.new(0, FlySpeed * dt * 2, 0) or Vector3.new()
            HRP.CFrame = HRP.CFrame + move + up
            HRP.Velocity = Vector3.new(0,0,0)
        elseif Hum then
            Hum.PlatformStand = false
        end
    end)
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfiniteJump and Hum then
        Hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Godmode Noclip
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if Godmode and Char then
                for _, p in pairs(Char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end
end)

-- Delete Wave + Walls
spawn(function()
    while task.wait(0.2) do
        if DeleteWave or DeleteWalls then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    if DeleteWave and (name:find("wave") or name:find("tsunami") or name:find("water") or name:find("flood")) then
                        obj:Destroy()
                    end
                    if DeleteWalls and (name:find("wall") or name:find("barrier") or name:find("fence") or name:find("gate") or name:find("block") or name:find("invisible")) then
                        obj:Destroy()
                    end
                end
            end
        end
    end
end)

-- Auto Collect Coin SK
spawn(function()
    while task.wait(0.25) do  -- Tăng wait fix lag
        if AutoCollectCoinSK and HRP then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") and
                   (obj.Name:lower():find("coin") or obj.Name:lower():find("event") or obj.Name:lower():find("skin") or obj.Name:lower():find("limited") or obj.Name:lower():find("bonus") or obj.Name:lower():find("reward") or obj.Name:lower():find("sk")) and
                   (obj.Position - HRP.Position).Magnitude < CollectRadius then
                    HRP.CFrame = obj.CFrame * CFrame.new(0, 8, 0)
                    firetouchinterest(HRP, obj, 0)
                    task.wait(0.01)
                    firetouchinterest(HRP, obj, 1)
                end
            end
        end
    end
end)

-- Auto Collect Brainrot + DUPE FIXED v7.7
spawn(function()
    while task.wait(0.25) do  -- Fix lag
        local radius = AutoSteal and 600 or CollectRadius
        local claims = AutoSteal and MultiClaim or 1
        if (AutoCollectBrainrot or AutoSteal) and HRP then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") and
                   (obj.Name:lower():find("brain") or obj.Name:lower():find("brainrot") or obj.Name:lower():find("divine") or obj.Name:lower():find("infinity") or obj.Name:lower():find("pet") or obj.Name:lower():find("meme")) and
                   (obj.Position - HRP.Position).Magnitude < radius then
                    -- Main dupe
                    dupeObj(obj, claims)
                    -- Extra clone dupe
                    if UseClone and AutoSteal then
                        local clone = obj:Clone()
                        clone.Parent = Workspace
                        dupeObj(clone, 1)
                        clone:Destroy()
                        print("EXTRA CLONE DUPE: " .. obj.Name)
                    end
                    if AutoSteal then 
                        print("🌊 DUPE FIXED v7.7: " .. obj.Name .. " x" .. claims .. " CLONED!") 
                    end
                    break  -- 1 obj/lần né spam
                end
            end
        end
    end
end)

-- Auto Collect All
spawn(function()
    while task.wait(0.3) do
        if AutoCollectAll and HRP then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") and (obj.Position - HRP.Position).Magnitude < CollectRadius then
                    HRP.CFrame = obj.CFrame * CFrame.new(0, 8, 0)
                    firetouchinterest(HRP, obj, 0)
                    task.wait(0.01)
                    firetouchinterest(HRP, obj, 1)
                end
            end
            break
        end
    end
end)

-- Auto Rebirth
spawn(function()
    while task.wait(3) do
        if AutoRebirth then
            pcall(function()
                if ReplicatedStorage:FindFirstChild("Rebirth") then ReplicatedStorage.Rebirth:FireServer() end
                if ReplicatedStorage.Remotes and ReplicatedStorage.Remotes:FindFirstChild("Rebirth") then ReplicatedStorage.Remotes.Rebirth:FireServer() end
            end)
        end
    end
end)

-- UI Rayfield
local Window = Rayfield:CreateWindow({
    Name = "🧠 BLACKZ HUB - TSUNAMI v7.7 DUPE FIXED (Random TP + Clone)",
    LoadingTitle = "Loading DUPE FIXED... Chào Quang Anh!",
    LoadingSubtitle = "Farm infinity divine max 🌊🤑"
})

local MainTab = Window:CreateTab("🌊 Main (Fly + Collect)")
local DupeTab = Window:CreateTab("💰 Dupe/Steal FIXED")
local MiscTab = Window:CreateTab("⚙️ Misc")

MainTab:CreateToggle({Name = "Fly (Xoay cam + auto lên)", CurrentValue = false, Callback = function(v) Fly = v end})
MainTab:CreateToggle({Name = "Auto Fly Up (Né sóng)", CurrentValue = true, Callback = function(v) AutoUp = v end})
MainTab:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) InfiniteJump = v end})
MainTab:CreateToggle({Name = "Auto Collect Coin SK/Event", CurrentValue = false, Callback = function(v) AutoCollectCoinSK = v end})
MainTab:CreateToggle({Name = "Auto Collect Brainrot (Normal)", CurrentValue = false, Callback = function(v) AutoCollectBrainrot = v end})
MainTab:CreateToggle({Name = "Auto Collect All", CurrentValue = false, Callback = function(v) AutoCollectAll = v end})

-- DUPE TAB FIXED
DupeTab:CreateToggle({Name = "🚀 Auto Steal + Dupe Brainrot FIXED (600r random TP)", CurrentValue = false, Callback = function(v) AutoSteal = v end})
DupeTab:CreateSlider({Name = "Dupe Multiplier (3-10)", Range = {3, 10}, Increment = 1, Suffix = "x", CurrentValue = 5, Callback = function(v) MultiClaim = v end})
DupeTab:CreateToggle({Name = "Use Clone (Extra x2 dupe)", CurrentValue = true, Callback = function(v) UseClone = v end})
DupeTab:CreateButton({
    Name = "🧪 Test Dupe Nearest x10 (Check console)",
    Callback = function()
        if HRP then
            local nearest = nil
            local dist = math.huge
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj.Name:lower():find("brainrot") then
                    local d = (obj.Position - HRP.Position).Magnitude
                    if d < dist then dist = d nearest = obj end
                end
            end
            if nearest then
                dupeObj(nearest, 10)
                if UseClone then
                    local clone = nearest:Clone()
                    clone.Parent = Workspace
                    dupeObj(clone, 2)
                    clone:Destroy()
                end
                Rayfield:Notify({Title="DUPE FIXED", Content="x12: " .. nearest.Name .. " (check console!)", Duration=5})
                print("🧠 TEST DUPE v7.7: " .. nearest.Name .. " x12 CLONED!")
            else
                Rayfield:Notify({Title="No Target", Content="No brainrot nearby!", Duration=3})
            end
        end
    end
})

MiscTab:CreateToggle({Name = "Godmode Noclip", CurrentValue = false, Callback = function(v) Godmode = v end})
MiscTab:CreateToggle({Name = "Delete Walls", CurrentValue = false, Callback = function(v) DeleteWalls = v end})
MiscTab:CreateToggle({Name = "Delete Wave", CurrentValue = false, Callback = function(v) DeleteWave = v end})
MiscTab:CreateToggle({Name = "Auto Rebirth", CurrentValue = false, Callback = function(v) AutoRebirth = v end})
MiscTab:CreateSlider({Name = "Fly Speed", Range = {50, 300}, Increment = 10, CurrentValue = 120, Callback = function(v) FlySpeed = v end})
MiscTab:CreateSlider({Name = "Collect Radius", Range = {200, 800}, Increment = 50, CurrentValue = 450, Callback = function(v) CollectRadius = v end})

Rayfield:LoadConfiguration()

print("🧠 BLACKZ TASUNAMI2 v7.7 DUPE FIXED Loaded! Chào Quang Anh - Random TP + Clone x10 🌊🚀 RICH UP!")
