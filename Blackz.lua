--// BLACKZ HUB - MAIN SCRIPT

-- LOAD UI
local BlackzLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/quyennguyengia12-bit/Blackz/refs/heads/main/BlackzUI.lua"
))()

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- PLAYER
local LP = Players.LocalPlayer
local Char, Hum, HRP

-- STATE
local AutoFarm = false
local AutoQuest = false
local MobAura = false
local FarmDistance = 18

-- LOAD CHAR
local function LoadChar()
    Char = LP.Character or LP.CharacterAdded:Wait()
    Hum = Char:WaitForChild("Humanoid")
    HRP = Char:WaitForChild("HumanoidRootPart")
end
LoadChar()
LP.CharacterAdded:Connect(LoadChar)

-- ANTI AFK
LP.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- COMBAT
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

-- QUEST SEA 1
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
    if q then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer(
                "StartQuest", q.Quest, q.Level
            )
        end)
    end
end

local function GetMob()
    local q = GetQuest()
    if not q or not workspace:FindFirstChild("Enemies") then return end
    for _,m in pairs(workspace.Enemies:GetChildren()) do
        if m.Name == q.Mob and m:FindFirstChild("HumanoidRootPart")
        and m.Humanoid.Health > 0 then
            return m
        end
    end
end

-- MOB AURA
local function DoMobAura()
    if not MobAura or not HRP then return end
    for _,m in pairs(workspace.Enemies:GetChildren()) do
        if m:FindFirstChild("HumanoidRootPart")
        and m:FindFirstChild("Humanoid")
        and m.Humanoid.Health > 0 then
            m.HumanoidRootPart.CFrame = HRP.CFrame * CFrame.new(0,0,-4)
        end
    end
end

-- LOOP
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

-- UI
local Window = BlackzLib:MakeWindow({
    Title = "BLACKZ HUB",
    SubTitle = "REDZ STYLE"
})

local MainTab = Window:AddTab("Main")
local FarmTab = Window:AddTab("Farm")

local MainSec = MainTab:AddSection("Main")
MainSec:AddToggle({Name="Auto Quest",Callback=function(v) AutoQuest=v end})
MainSec:AddToggle({Name="Auto Farm",Callback=function(v) AutoFarm=v end})

local FarmSec = FarmTab:AddSection("Farm")
FarmSec:AddToggle({Name="Mob Aura",Callback=function(v) MobAura=v end})
FarmSec:AddSlider({
    Name="Farm Distance",Min=10,Max=30,Default=FarmDistance,
    Callback=function(v) FarmDistance=v end
})
