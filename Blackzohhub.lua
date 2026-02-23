-- BLACKZ TASUNAMI HUB v14.0 - INSTANT BRAINROT 100% (ProximityPrompt ONLY) | Feb 24 2026
local TweenService = game:GetService("TweenService")
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer
local Char, HRP, Hum

local Fly = false; local FlySpeed = 180; local AutoUp = true
local AutoCollectBrainrot = false; local AutoSteal = false
local MultiClaim = 30; local CollectRadius = 7000
local DeleteWalls = true; local DeleteWave = true
local Godmode = false; local UseClone = true; local DupeSpeed = 0.09

local function LoadChar()
    Char = LP.Character or LP.CharacterAdded:Wait()
    Hum = Char:WaitForChild("Humanoid")
    HRP = Char:WaitForChild("HumanoidRootPart")
end
LoadChar(); LP.CharacterAdded:Connect(LoadChar)

local function getRootPart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    return obj:FindFirstChildWhichIsA("BasePart") or obj.PrimaryPart or obj:FindFirstChild("Handle") or obj.Parent:FindFirstAncestorWhichIsA("BasePart") or obj
end

local function instantSteal(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") or not prompt.Enabled then return false end
    prompt.HoldDuration = 0
    local root = getRootPart(prompt.Parent)
    if not root or not root:IsA("BasePart") or not HRP then return false end
    
    local targetCFrame = root.CFrame * CFrame.new(0, 6, -3) * CFrame.Angles(0, math.rad(180), 0)
    HRP.CFrame = targetCFrame
    task.wait(0.015)
    
    for i = 1, 30 do  -- burst mạnh
        pcall(fireproximityprompt, prompt)
        task.wait(0.004)
    end
    return true
end

-- FLY + GOD + TASUNAMI
RunService.RenderStepped:Connect(function(dt)
    if Fly and HRP and Hum then
        Hum.PlatformStand = true
        local cam = Workspace.CurrentCamera
        local move = cam.CFrame.LookVector * FlySpeed * dt * 1.8
        local up = AutoUp and Vector3.new(0, FlySpeed * dt * 4, 0) or Vector3.new()
        HRP.CFrame = HRP.CFrame + move + up
        HRP.Velocity = Vector3.new(0,0,0)
    elseif Hum then Hum.PlatformStand = false end
end)

spawn(function() while task.wait(0.05) do
    if Godmode and Char then for _, p in pairs(Char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
end end)

spawn(function() while task.wait(0.07) do
    if DeleteWave or DeleteWalls then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local n = obj.Name:lower()
                if (DeleteWave and (n:find("wave") or n:find("tsunami") or n:find("water") or n:find("flood"))) or
                   (DeleteWalls and (n:find("wall") or n:find("vip") or n:find("barrier"))) then
                    obj:Destroy()
                end
            end
        end
    end
end end)

-- ███████ AUTO BRAINROT v14.0 - CHỈ DÙNG PROMPT "STEAL" + DEBUG ███████
spawn(function()
    Workspace.DescendantAdded:Connect(function(desc)
        if AutoCollectBrainrot and desc:IsA("ProximityPrompt") and desc.ActionText:lower():find("steal") then
            task.wait(0.08)
            print("DEBUG: New Brainrot spawned! " .. (desc.ObjectText or "Unknown"))
            if instantSteal(desc) then
                Rayfield:Notify({Title="✅ INSTANT STEAL NEW!", Content= (desc.ObjectText or "Brainrot"), Duration=2})
            end
        end
    end)
    
    while task.wait(0.06) do
        if (AutoCollectBrainrot or AutoSteal) and HRP then
            local radius = AutoSteal and CollectRadius * 1.7 or CollectRadius
            for _, prompt in ipairs(Workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.ActionText:lower():find("steal") and prompt.Enabled then
                    print("DEBUG: Found Steal prompt nearby: " .. (prompt.ObjectText or "Unknown"))  -- F9 sẽ thấy
                    local root = getRootPart(prompt.Parent)
                    if root and root:IsA("BasePart") then
                        local dist = (root.Position - HRP.Position).Magnitude
                        if dist <= radius then
                            if instantSteal(prompt) then
                                Rayfield:Notify({Title="✅ AUTO NHẶT THÀNH CÔNG!", Content=(prompt.ObjectText or "Brainrot").." ("..math.floor(dist).." studs)", Duration=3})
                                print("SUCCESS: Stole " .. (prompt.ObjectText or "Unknown"))
                                task.wait(0.35)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- UI v14.0
local Window = Rayfield:CreateWindow({Name = "🧠 BLACKZ TASUNAMI v14.0 - INSTANT BRAINROT 100%", LoadingTitle = "ProximityPrompt ONLY + Debug F9", LoadingSubtitle = "GitHub updated!", Icon = "zap"})

local MainTab = Window:CreateTab("🤖 Main")
local MiscTab = Window:CreateTab("⚙️ Misc")

MainTab:CreateToggle({Name = "Auto Brainrot (Instant)", CurrentValue = false, Callback = function(v) AutoCollectBrainrot = v end})
MainTab:CreateToggle({Name = "Auto Steal Dupe", CurrentValue = false, Callback = function(v) AutoSteal = v end})
MainTab:CreateSlider({Name = "Radius", Range = {1000,10000}, Increment = 500, CurrentValue = 7000, Callback = function(v) CollectRadius = v end})
MainTab:CreateSlider({Name = "Multiplier", Range = {1,100}, Increment = 5, CurrentValue = 30, Callback = function(v) MultiClaim = v end})
MainTab:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(v) Fly = v end})
MainTab:CreateSlider({Name = "Fly Speed", Range = {100,500}, Increment = 25, CurrentValue = 180, Callback = function(v) FlySpeed = v end})

MiscTab:CreateToggle({Name = "God + Noclip", CurrentValue = false, Callback = function(v) Godmode = v end})
MiscTab:CreateToggle({Name = "Delete Walls", CurrentValue = true, Callback = function(v) DeleteWalls = v end})
MiscTab:CreateToggle({Name = "Delete Wave / Tsunami", CurrentValue = true, Callback = function(v) DeleteWave = v end})

MainTab:CreateButton({Name = "🧪 TEST: List All Steal Prompts (F9 check)", Callback = function()
    print("=== TEST STEAL PROMPTS ===")
    local count = 0
    for _, p in ipairs(Workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.ActionText:lower():find("steal") then
            count = count + 1
            print("Prompt #"..count..": " .. (p.ObjectText or "No name") .. " | Distance: " .. (getRootPart(p.Parent) and math.floor((getRootPart(p.Parent).Position - HRP.Position).Magnitude) or "N/A"))
        end
    end
    print("Tìm thấy " .. count .. " Steal prompt(s). Nếu =0 thì server không có brainrot gần.")
    Rayfield:Notify({Title="Test Done", Content="Mở F9 xem chi tiết!", Duration=5})
end})

Rayfield:Notify({Title = "v14.0 LOADED!", Content = "Upload GitHub rồi test Auto Brainrot + mở F9 ngay!", Duration = 10})
