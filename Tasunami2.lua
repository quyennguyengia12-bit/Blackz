-- BLACKZ HUB - SÓNG THẦN BRAINROT v7.6 DUPE | FIX LAG + XÓA TƯỜNG + NHẶT MƯỢT + DUPE BRAINROT 5X (Delta Mobile OK 100%)
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

-- DUPE NEW v7.6
local AutoSteal = false
local MultiClaim = 5
local CollectRadius = 450

local function LoadChar()
    Char = LP.Character or LP.CharacterAdded:Wait()
    Hum = Char:WaitForChild("Humanoid")
    HRP = Char:WaitForChild("HumanoidRootPart")
end
LoadChar()
LP.CharacterAdded:Connect(LoadChar)

-- Fly Mobile Fix (theo cam + auto up né sóng)
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

-- Auto Collect Coin SK (Event/Skin - radius 450)
spawn(function()
    while task.wait(0.15) do  -- Fix lag
        if AutoCollectCoinSK and HRP then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") and
                   (obj.Name:lower():find("coin") or obj.Name:lower():find("event") or obj.Name:lower():find("skin") or obj.Name:lower():find("limited") or obj.Name:lower():find("bonus") or obj.Name:lower():find("reward") or obj.Name:lower():find("sk")) and
                   (obj.Position - HRP.Position).Magnitude < CollectRadius then
                    HRP.CFrame = obj.CFrame * CFrame.new(0, 8, 0)
                    firetouchinterest(HRP, obj, 0)
                    task.wait(0.005)
                    firetouchinterest(HRP, obj, 1)
                end
            end
        end
    end
end)

-- Auto Collect Brainrot + DUPE/STEAL (radius 450/600 + MultiClaim 1-10x)
spawn(function()
    while task.wait(0.15) do  -- Fix lag Delta
        local radius = AutoSteal and 600 or CollectRadius
        local claims = AutoSteal and MultiClaim or 1
        if (AutoCollectBrainrot or AutoSteal) and HRP then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") and
                   (obj.Name:lower():find("brain") or obj.Name:lower():find("brainrot") or obj.Name:lower():find("divine") or obj.Name:lower():find("infinity") or obj.Name:lower():find("pet") or obj.Name:lower():find("meme")) and
                   (obj.Position - HRP.Position).Magnitude < radius then
                    HRP.CFrame = obj.CFrame * CFrame.new(0, 8, 0)
                    for i = 1, claims do
                        firetouchinterest(HRP, obj, 0)
                        task.wait(0.003)
                        firetouchinterest(HRP, obj, 1)
                        task.wait(0.003)
                    end
                    if AutoSteal then print("DUPE STEAL: " .. obj.Name .. " x" .. claims) end
                end
            end
        end
    end
end)

-- Auto Collect All
spawn(function()
    while task.wait(0.2) do
        if AutoCollectAll and HRP then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") and (obj.Position - HRP.Position).Magnitude < CollectRadius then
                    HRP.CFrame = obj.CFrame * CFrame.new(0, 8, 0)
                    firetouchinterest(HRP, obj, 0)
                    task.wait(0.005)
                    firetouchinterest(HRP, obj, 1)
                end
            end
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
    Name = "🧠 BLACKZ HUB - TSUNAMI v7.6 DUPE BRAINROT (Delta Fix)",
    LoadingTitle = "Loading DUPE... Chào Quang Anh!",
    LoadingSubtitle = "Farm infinity max speed 🌊"
})

local MainTab = Window:CreateTab("🌊 Main (Fly + Collect)")
local DupeTab = Window:CreateTab("💰 Dupe/Steal")
local MiscTab = Window:CreateTab("⚙️ Misc")

MainTab:CreateToggle({
    Name = "Fly (Xoay cam bay + auto lên né sóng)",
    CurrentValue = false,
    Callback = function(v) Fly = v end
})

MainTab:CreateToggle({
    Name = "Auto Fly Up (Né sóng bá)",
    CurrentValue = true,
    Callback = function(v) AutoUp = v end
})

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v) InfiniteJump = v end
})

MainTab:CreateToggle({
    Name = "Auto Collect Coin SK/Event/Skin",
    CurrentValue = false,
    Callback = function(v) AutoCollectCoinSK = v end
})

MainTab:CreateToggle({
    Name = "Auto Collect Brainrot (Pet/Divine)",
    CurrentValue = false,
    Callback = function(v) AutoCollectBrainrot = v end
})

MainTab:CreateToggle({
    Name = "Auto Collect All",
    CurrentValue = false,
    Callback = function(v) AutoCollectAll = v end
})

-- DUPE TAB
DupeTab:CreateToggle({
    Name = "🚀 Auto Steal + Dupe Brainrot (600r 5x claim)",
    CurrentValue = false,
    Callback = function(v) AutoSteal = v end
})

DupeTab:CreateSlider({
    Name = "Dupe Multiplier",
    Range = {1, 10},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 5,
    Callback = function(v) MultiClaim = v end
})

DupeTab:CreateButton({
    Name = "🧪 Test Clone Nearest (1x5)",
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
                HRP.CFrame = nearest.CFrame
                for i=1,5 do firetouchinterest(HRP, nearest, 0) task.wait(0.01) firetouchinterest(HRP, nearest, 1) end
                Rayfield:Notify({Title="DUPE", Content="Cloned x5: " .. nearest.Name, Duration=3})
            end
        end
    end
})

-- MISC
MiscTab:CreateToggle({
    Name = "Godmode Noclip",
    CurrentValue = false,
    Callback = function(v) Godmode = v end
})

MiscTab:CreateToggle({
    Name = "Delete Walls/Tường",
    CurrentValue = false,
    Callback = function(v) DeleteWalls = v end
})

MiscTab:CreateToggle({
    Name = "Delete Wave/Sóng Thần",
    CurrentValue = false,
    Callback = function(v) DeleteWave = v end
})

MiscTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Callback = function(v) AutoRebirth = v end
})

MiscTab:CreateSlider({
    Name = "Fly Speed",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 120,
    Callback = function(v) FlySpeed = v end
})

MiscTab:CreateSlider({
    Name = "Collect Radius",
    Range = {200, 800},
    Increment = 50,
    CurrentValue = 450,
    Callback = function(v) CollectRadius = v end
})

Rayfield:LoadConfiguration()

print("BLACKZ HUB v7.6 Loaded! Chào Quang Anh - DUPE STEAL x5 + Fix lag Delta, farm divine max 🌊🧠🚀")
