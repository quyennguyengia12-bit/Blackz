--// =====================================================
--//  BLACKZ HUB - REDZ STYLE v5.1 | FULL MAX
--// =====================================================

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local UIS = game:GetService("UserInputService")

--// PLAYER
local LP = Players.LocalPlayer
local Char, Hum, HRP
local Mouse = LP:GetMouse()

--// STATE
local AutoFarm = false
local AutoQuest = false
local MobAura = false
local FarmDistance = 18

--// LOAD CHARACTER
local function LoadChar()
    Char = LP.Character or LP.CharacterAdded:Wait()
    Hum = Char:WaitForChild("Humanoid")
    HRP = Char:WaitForChild("HumanoidRootPart")
end
LoadChar()
LP.CharacterAdded:Connect(LoadChar)

--// ANTI AFK
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

--// COMBAT
local function EquipWeapon()
    for _,v in pairs(LP.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            Hum:EquipTool(v)
            break
        end
    end
end

local function Attack()
    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.12)
    VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end

--// QUEST DATA SEA 1
local QuestData = {
    {Min=1,Max=9,Quest="BanditQuest1",Level=1,Mob="Bandit"},
    {Min=10,Max=14,Quest="BanditQuest1",Level=2,Mob="Monkey"},
    {Min=15,Max=29,Quest="JungleQuest",Level=1,Mob="Gorilla"},
    {Min=30,Max=39,Quest="BuggyQuest1",Level=1,Mob="Pirate"},
    {Min=40,Max=59,Quest="BuggyQuest1",Level=2,Mob="Brute"},
    {Min=60,Max=74,Quest="DesertQuest",Level=1,Mob="Desert Bandit"},
    {Min=75,Max=89,Quest="DesertQuest",Level=2,Mob="Desert Officer"},
}

local function GetQuest()
    local lvl = LP.Data.Level.Value
    for _,q in pairs(QuestData) do
        if lvl >= q.Min and lvl <= q.Max then
            return q
        end
    end
end

local function StartQuest()
    local q = GetQuest()
    if not q then return end
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer(
            "StartQuest", q.Quest, q.Level
        )
    end)
end

local function GetMob()
    local q = GetQuest()
    if not q or not workspace:FindFirstChild("Enemies") then return end
    for _,m in pairs(workspace.Enemies:GetChildren()) do
        if m.Name == q.Mob
        and m:FindFirstChild("Humanoid")
        and m.Humanoid.Health > 0
        and m:FindFirstChild("HumanoidRootPart") then
            return m
        end
    end
end

--// MOB AURA
local function DoMobAura()
    if not MobAura or not HRP then return end
    for _,m in pairs(workspace.Enemies:GetChildren()) do
        if m:FindFirstChild("Humanoid")
        and m.Humanoid.Health > 0
        and m:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                m.HumanoidRootPart.CFrame = HRP.CFrame * CFrame.new(0,0,-4)
                m.HumanoidRootPart.CanCollide = false
            end)
        end
    end
end

--// MAIN LOOP
RunService.Heartbeat:Connect(function()
    if AutoQuest then StartQuest() end
    if AutoFarm then
        local mob = GetMob()
        if mob and HRP then
            EquipWeapon()
            HRP.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,0,FarmDistance)
            Attack()
        end
    end
    DoMobAura()
end)

--// ================= UI REDZ STYLE (FIXED & GỘP) =================

local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "BlackzHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,360,0,380)
main.Position = UDim2.new(0.5,-180,0.5,-190)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,14)

-- HEADER
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,55)
header.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", header).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "🖤 BLACKZ HUB | REDZ STYLE"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,65,65)

-- CONTAINER
local container = Instance.new("Frame", main)
container.Position = UDim2.new(0,0,0,65)
container.Size = UDim2.new(1,0,1,-65)
container.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0,12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- TOGGLE
local function CreateToggle(text, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0,300,0,42)
    btn.Text = text.." : OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text..(state and " : ON" or " : OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(180,50,50) or Color3.fromRGB(45,45,45)
        callback(state)
    end)
end

CreateToggle("Auto Quest", function(v) AutoQuest=v end)
CreateToggle("Auto Farm", function(v) AutoFarm=v end)
CreateToggle("Mob Aura", function(v) MobAura=v end)

-- SLIDER (REAL)
local sliderFrame = Instance.new("Frame", container)
sliderFrame.Size = UDim2.new(0,300,0,42)
sliderFrame.BackgroundColor3 = Color3.fromRGB(45,45,45)
Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0,10)

local sliderFill = Instance.new("Frame", sliderFrame)
sliderFill.Size = UDim2.new((FarmDistance-10)/20,0,1,0)
sliderFill.BackgroundColor3 = Color3.fromRGB(180,50,50)
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0,10)

local sliderText = Instance.new("TextLabel", sliderFrame)
sliderText.Size = UDim2.new(1,0,1,0)
sliderText.BackgroundTransparency = 1
sliderText.Text = "Farm Distance : "..FarmDistance
sliderText.Font = Enum.Font.GothamBold
sliderText.TextSize = 14
sliderText.TextColor3 = Color3.new(1,1,1)

local dragging = false
sliderFrame.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true end
end)
sliderFrame.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local x = math.clamp(
            (Mouse.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X,
            0,1
        )
        sliderFill.Size = UDim2.new(x,0,1,0)
        FarmDistance = math.floor(10 + x*20)
        sliderText.Text = "Farm Distance : "..FarmDistance
    end
end)
