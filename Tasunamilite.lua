-- BLACKZ HUB - TSUNAMI BRAINROT v7.8 ULTRA LOW LAG | DUPE FIXED + 1 LOOP ONLY (Delta Mobile OK 100%)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local Char, HRP, Hum

local Fly = false
local FlySpeed = 100
local AutoUp = true
local AutoSteal = false
local MultiClaim = 4
local CollectRadius = 350
local LowLagMode = true  -- Bật mặc định giảm lag
local Godmode = false
local InfiniteJump = false
local AutoRebirth = false

local function LoadChar()
    Char = LP.Character or LP.CharacterAdded:Wait()
    Hum = Char:WaitForChild("Humanoid")
    HRP = Char:WaitForChild("HumanoidRootPart")
end
LoadChar()
LP.CharacterAdded:Connect(LoadChar)

-- DUPE FUNCTION ULTRA LIGHT
local function dupeObj(obj, times)
    for i = 1, times do
        local randX = math.random(-3,3)
        local randY = math.random(5,8)
        local randZ = math.random(-3,3)
        HRP.CFrame = CFrame.new(obj.Position + Vector3.new(randX, randY, randZ))
        
        firetouchinterest(HRP, obj, 0)
        task.wait(math.random(6,14)/100)
        firetouchinterest(HRP, obj, 1)
        task.wait(math.random(6,14)/100)
    end
end

-- SINGLE MAIN LOOP (siêu nhẹ)
task.spawn(function()
    while task.wait(LowLagMode and 0.45 or 0.35) do
        if not (AutoSteal or HRP) then continue end
        
        local radius = LowLagMode and CollectRadius or 500
        local claims = LowLagMode and math.min(MultiClaim, 4) or MultiClaim
        
        local nearest = nil
        local minDist = math.huge
        
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("BasePart") and obj:FindFirstChild("TouchInterest") then
                local nameLow = obj.Name:lower()
                if nameLow:find("brain") or nameLow:find("brainrot") or nameLow:find("divine") or nameLow:find("infinity") or nameLow:find("pet") or nameLow:find("meme") then
                    local dist = (obj.Position - HRP.Position).Magnitude
                    if dist < radius and dist < minDist then
                        minDist = dist
                        nearest = obj
                    end
                end
            end
        end
        
        if nearest then
            dupeObj(nearest, claims)
            print("🌊 DUPE v7.8 LOWLAG: " .. nearest.Name .. " x" .. claims)
            task.wait(0.2) -- nghỉ sau khi dupe 1 obj
        end
    end
end)

-- DELETE EVENT (không scan nữa)
local function DeleteCheck(obj)
    if not obj:IsA("BasePart") then return end
    local n = obj.Name:lower()
    if (n:find("wave") or n:find("tsunami") or n:find("water") or n:find("flood")) then
        obj:Destroy()
    elseif (n:find("wall") or n:find("barrier") or n:find("fence") or n:find("gate") or n:find("block") or n:find("invisible")) then
        obj:Destroy()
    end
end
Workspace.ChildAdded:Connect(DeleteCheck)
for _, v in ipairs(Workspace:GetChildren()) do DeleteCheck(v) end

-- Fly Heartbeat (mượt mobile)
RunService.Heartbeat:Connect(function(dt)
    pcall(function()
        if Fly and HRP and Hum then
            Hum.PlatformStand = true
            local cam = Workspace.CurrentCamera
            local move = cam.CFrame.LookVector * FlySpeed * dt * 1.8
            local up = AutoUp and Vector3.new(0, FlySpeed * dt * 2.2, 0) or Vector3.new()
            HRP.CFrame += move + up
            HRP.Velocity = Vector3.new()
        elseif Hum then
            Hum.PlatformStand = false
        end
    end)
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfiniteJump and Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- Godmode
task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            if Godmode and Char then
                for _, p in ipairs(Char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end)
    end
end)

-- Auto Rebirth
task.spawn(function()
    while task.wait(3.5) do
        if AutoRebirth then
            pcall(function()
                local rem = ReplicatedStorage:FindFirstChild("Rebirth") or (ReplicatedStorage.Remotes and ReplicatedStorage.Remotes:FindFirstChild("Rebirth"))
                if rem then rem:FireServer() end
            end)
        end
    end
end)

-- UI
local Window = Rayfield:CreateWindow({
    Name = "🧠 BLACKZ HUB v7.8 ULTRA LOW LAG",
    LoadingTitle = "Loading siêu nhẹ cho pe...",
    LoadingSubtitle = "Quang Anh farm infinity max 🌊🚀"
})

local Main = Window:CreateTab("🌊 Main")
local Dupe = Window:CreateTab("💰 Dupe")
local Misc = Window:CreateTab("⚙️ Misc")

Main:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(v) Fly = v end})
Main:CreateToggle({Name = "Auto Fly Up", CurrentValue = true, Callback = function(v) AutoUp = v end})
Main:CreateToggle({Name = "Infinite Jump", CurrentValue = false, Callback = function(v) InfiniteJump = v end})
Main:CreateToggle({Name = "Low Lag Mode (khuyến nghị bật)", CurrentValue = true, Callback = function(v) LowLagMode = v end})

Dupe:CreateToggle({Name = "🚀 Auto Steal + Dupe Brainrot (low lag)", CurrentValue = false, Callback = function(v) AutoSteal = v end})
Dupe:CreateSlider({Name = "Multiplier", Range = {1,8}, Increment = 1, Suffix = "x", CurrentValue = 4, Callback = function(v) MultiClaim = v end})
Dupe:CreateSlider({Name = "Collect Radius", Range = {150,450}, Increment = 50, Suffix = " studs", CurrentValue = 350, Callback = function(v) CollectRadius = v end})

Misc:CreateToggle({Name = "Godmode Noclip", CurrentValue = false, Callback = function(v) Godmode = v end})
Misc:CreateToggle({Name = "Auto Rebirth", CurrentValue = false, Callback = function(v) AutoRebirth = v end})
Misc:CreateSlider({Name = "Fly Speed", Range = {60,250}, Increment = 10, CurrentValue = 100, Callback = function(v) FlySpeed = v end})

Rayfield:LoadConfiguration()

print("🧠 BLACKZ v7.8 ULTRA LOW LAG LOADED! Chào Quang Anh - 1 loop + event delete = mượt max 🌊🤑")
