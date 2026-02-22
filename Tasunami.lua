-- BLACKZ HUB - SÓNG THẦN BRAINROT v7.5 | FIX LAG + XÓA TƯỜNG + NHẶT MƯỢT (Delta Mobile)
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

local function LoadChar()
    Char = LP.Character or LP.CharacterAdded:Wait()
    Hum = Char:WaitForChild("Humanoid")
    HRP = Char:WaitForChild("HumanoidRootPart")
end
LoadChar()
LP.CharacterAdded:Connect(LoadChar)

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

-- Delete Wave + Delete Walls (xóa tường/chướng ngại)
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

-- Auto Collect Coin SK (Sự Kiện - radius 450, fix lag)
spawn(function()
    while task.wait(0.2) do
        if AutoCollectCoinSK and HRP then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") and
                   (obj.Name:lower():find("coin") or obj.Name:lower():find("event") or obj.Name:lower():find("skin") or obj.Name:lower():find("limited") or obj.Name:lower():find("bonus") or obj.Name:lower():find("reward") or obj.Name:lower():find("sk")) and
                   (obj.Position - HRP.Position).Magnitude < 450 then
                    HRP.CFrame = obj.CFrame * CFrame.new(0, 8, 0)
                    firetouchinterest(HRP, obj, 0)
                    task.wait(0.005)
                    firetouchinterest(HRP, obj, 1)
                    print("Nhặt Coin SK: " .. obj.Name)
                end
            end
        end
    end
end)

-- Tự nhặt Brainrot (radius 450)
spawn(function()
    while task.wait(0.2) do
        if AutoCollectBrainrot and HRP then
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") and
                   (obj.Name:lower():find("brain") or obj.Name:lower():find("brainrot") or obj.Name:lower():find("divine") or obj.Name:lower():find("infinity") or obj.Name:lower():find("pet")) and
                   (obj.Position - HRP.Position).Magnitude < 450 then
                    HRP.CFrame = obj.CFrame * CFrame.new(0, 8, 0)
                    firetouchinterest(HRP, obj, 0)
                    task.wait(0.005)
                    firetouchinterest(HRP, obj, 1)
                    print("Nhặt Brainrot: " .. obj.Name)
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
                if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") then
                    HRP.CFrame = obj.CFrame * CFrame.new(0, 8, 0)
                    firetouchinterest(HRP, obj, 0)
                    task.wait(0.005)
                    firetouchinterest(HRP, obj, 1)
                    print("Nhặt All: " .. obj.Name)
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

-- UI
local Window = Rayfield:CreateWindow({
    Name = "BLACKZ HUB - SÓNG THẦN v7.5 (Fix Lag + Xóa Tường)",
    LoadingTitle = "Loading... Đợi tí Quang Anh nhé",
    LoadingSubtitle = "Delta Mobile OK"
})

local MainTab = Window:CreateTab("Main")

MainTab:CreateToggle({
    Name = "Fly (Xoay màn hình bay theo + auto lên cao)",
    CurrentValue = false,
    Callback = function(v) Fly = v end
})

MainTab:CreateToggle({
    Name = "Auto Fly Up (Né sóng mạnh hơn)",
    CurrentValue = true,
    Callback = function(v) AutoUp = v end
})

MainTab:CreateToggle({
    Name = "Infinite Jump (Nhảy cao né sóng)",
    CurrentValue = false,
    Callback = function(v) InfiniteJump = v end
})

MainTab:CreateToggle({
    Name = "Auto Collect Coin SK (Sự Kiện - Skin/Event)",
    CurrentValue = false,
    Callback = function(v) AutoCollectCoinSK = v end
})

MainTab:CreateToggle({
    Name = "Tự nhặt Brainrot (Pet/Meme)",
    CurrentValue = false,
    Callback = function(v) AutoCollectBrainrot = v end
})

MainTab:CreateToggle({
    Name = "Auto Collect All (Tất cả item)",
    CurrentValue = false,
    Callback = function(v) AutoCollectAll = v end
})

MainTab:CreateToggle({
    Name = "Godmode Noclip",
    CurrentValue = false,
    Callback = function(v) Godmode = v end
})

MainTab:CreateToggle({
    Name = "Delete Walls (Xóa tường/chướng ngại)",
    CurrentValue = false,
    Callback = function(v) DeleteWalls = v end
})

MainTab:CreateToggle({
    Name = "Delete Wave (Xóa sóng thần)",
    CurrentValue = false,
    Callback = function(v) DeleteWave = v end
})

MainTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Callback = function(v) AutoRebirth = v end
})

MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {50, 300},
    Increment = 10,
    CurrentValue = 120,
    Callback = function(v) FlySpeed = v end
})

Rayfield:LoadConfiguration()

print("BLACKZ HUB v7.5 Loaded! Chào Quang Anh - Fix lag + xóa tường + nhặt mượt, farm max 🌊🧠🚀")
