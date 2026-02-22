--// =====================================================
--//  BLACKZ HUB - REDZ STYLE v6 | FULL SEA 1/2/3 FARM
--//  UI: Rayfield | Auto Quest + Auto Farm + Aura ALL SEAS
--//  Updated: Support all seas quests & mob farming
--// =====================================================

--// LOAD RAYFIELD UI LIBRARY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

--// PLAYER
local LP = Players.LocalPlayer
local Char, Hum, HRP

--// STATE
local AutoFarm = false
local AutoQuest = false
local MobAura = false
local FarmDistance = 18
local SelectedSea = "Sea 1"  -- Default

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
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

--// COMBAT
local function EquipWeapon()
    pcall(function()
        for _, v in pairs(LP.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                Hum:EquipTool(v)
                break
            end
        end
    end)
end

local function Attack()
    VirtualUser:Button1Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(0.12)
    VirtualUser:Button1Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end

--// FULL QUEST DATA (ALL SEAS - Updated 2025/2026)
-- Dựa trên wiki & update mới nhất (có thể cần chỉnh nếu update game)
local QuestData = {
    -- Sea 1 (Level \~0-700)
    {Sea="Sea 1", Min=0, Max=9, Quest="BanditQuest1", Level=1, Mob="Bandit", Island="Pirate Starter"},
    {Sea="Sea 1", Min=10, Max=14, Quest="BanditQuest1", Level=2, Mob="Monkey", Island="Jungle"},
    {Sea="Sea 1", Min=15, Max=29, Quest="JungleQuest", Level=1, Mob="Gorilla", Island="Jungle"},
    {Sea="Sea 1", Min=30, Max=59, Quest="BuggyQuest1", Level=1, Mob="Pirate", Island="Pirate Village"},
    {Sea="Sea 1", Min=60, Max=89, Quest="DesertQuest", Level=1, Mob="Desert Bandit", Island="Desert"},
    {Sea="Sea 1", Min=90, Max=119, Quest="FrozenQuest", Level=1, Mob="Snow Bandit", Island="Frozen Village"},
    {Sea="Sea 1", Min=120, Max=149, Quest="MarineQuest2", Level=1, Mob="Chief Petty Officer", Island="Marine Fortress"},
    {Sea="Sea 1", Min=150, Max=174, Quest="SkyQuest", Level=1, Mob="Royal Squad", Island="Skylands"},
    {Sea="Sea 1", Min=175, Max=199, Quest="PrisonerQuest", Level=1, Mob="Prisoner", Island="Prison"},
    {Sea="Sea 1", Min=200, Max=224, Quest="MagmaQuest", Level=1, Mob="Magma Ninja", Island="Magma Village"},
    {Sea="Sea 1", Min=225, Max=299, Quest="ColosseumQuest", Level=1, Mob="Gladiator", Island="Colosseum"},
    {Sea="Sea 1", Min=300, Max=374, Quest="FountainQuest", Level=1, Mob="Military Soldier", Island="Fountain City"},
    {Sea="Sea 1", Min=375, Max=449, Quest="FountainQuest", Level=2, Mob="Military Spy", Island="Fountain City"},
    {Sea="Sea 1", Min=450, Max=524, Quest="MagmaQuest", Level=2, Mob="Lava Pirate", Island="Magma Village"},
    {Sea="Sea 1", Min=525, Max=624, Quest="ForgottenQuest", Level=1, Mob="God's Guard", Island="Forgotten Island"},
    {Sea="Sea 1", Min=625, Max=699, Quest="ForgottenQuest", Level=2, Mob="Shanda", Island="Forgotten Island"},
    {Sea="Sea 1", Min=700, Max=700, Quest="CitizenQuest", Level=1, Mob="Citizen", Island="Kingdom of Rose"},  -- Transition

    -- Sea 2 (Level \~700-1500)
    {Sea="Sea 2", Min=700, Max=724, Quest="Area1Quest", Level=1, Mob="Raider", Island="Kingdom of Rose"},
    {Sea="Sea 2", Min=725, Max=774, Quest="Area1Quest", Level=2, Mob="Mercenary", Island="Kingdom of Rose"},
    {Sea="Sea 2", Min=775, Max=874, Quest="Area2Quest", Level=1, Mob="Swan Pirate", Island="Green Zone"},
    {Sea="Sea 2", Min=875, Max=949, Quest="Area2Quest", Level=2, Mob="Factory Staff", Island="Green Zone"},
    {Sea="Sea 2", Min=950, Max=974, Quest="Area3Quest", Level=1, Mob="Marine Lieutenant", Island="Cafe"},
    {Sea="Sea 2", Min=975, Max=1049, Quest="Area3Quest", Level=2, Mob="Marine Captain", Island="Cafe"},
    {Sea="Sea 2", Min=1050, Max=1099, Quest="FountainQuest", Level=3, Mob="Zombie", Island="Haunted Castle"},
    {Sea="Sea 2", Min=1100, Max=1149, Quest="FountainQuest", Level=4, Mob="Vampire", Island="Haunted Castle"},
    {Sea="Sea 2", Min=1150, Max=1199, Quest="SnowQuest", Level=1, Mob="Snow Trooper", Island="Snow Mountain"},
    {Sea="Sea 2", Min=1200, Max=1249, Quest="SnowQuest", Level=2, Mob="Winter Warrior", Island="Snow Mountain"},
    {Sea="Sea 2", Min=1250, Max=1324, Quest="LabQuest", Level=1, Mob="Lab Subordinate", Island="Hot and Cold"},
    {Sea="Sea 2", Min=1325, Max=1399, Quest="LabQuest", Level=2, Mob="Horned Man", Island="Hot and Cold"},
    {Sea="Sea 2", Min=1400, Max=1499, Quest="MansionQuest", Level=1, Mob="Dragon Crew Warrior", Island="Cursed Ship"},
    -- Thêm Sea 3 nếu cần (level 1500+), ví dụ Floating Turtle, Hydra Island, Sea of Treats...

    -- Sea 3 (Level 1500+ - chỉ ví dụ, bạn có thể mở rộng)
    {Sea="Sea 3", Min=1500, Max=1574, Quest="TikiQuest", Level=1, Mob="Pirate Millionaire", Island="Floating Turtle"},
    -- ... (thêm tiếp theo wiki nếu cần full)
}

local function GetCurrentQuest()
    local level = LP.Data.Level.Value
    local sea = SelectedSea  -- Hoặc detect sea thật (dùng LP.Data.Island.Value nếu có)

    for _, q in pairs(QuestData) do
        if q.Sea == sea and level >= q.Min and level <= q.Max then
            return q
        end
    end
    return nil
end

local function StartQuest()
    local q = GetCurrentQuest()
    if not q then return end
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", q.Quest, q.Level)
    end)
end

local function GetMob()
    local q = GetCurrentQuest()
    if not q or not Workspace:FindFirstChild("Enemies") then return nil end

    for _, m in pairs(Workspace.Enemies:GetChildren()) do
        local hum = m:FindFirstChild("Humanoid")
        local hrp = m:FindFirstChild("HumanoidRootPart")
        if m.Name == q.Mob and hum and hum.Health > 0 and hrp then
            return m
        end
    end
    return nil
end

--// MOB AURA
local function DoMobAura()
    if not MobAura or not HRP or not Workspace:FindFirstChild("Enemies") then return end
    for _, m in pairs(Workspace.Enemies:GetChildren()) do
        local hum = m:FindFirstChild("Humanoid")
        local hrp = m:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and hrp then
            pcall(function()
                hrp.CFrame = HRP.CFrame * CFrame.new(0, FarmDistance, 0)  -- Điều chỉnh vị trí aura
                hrp.CanCollide = false
            end)
        end
    end
end

--// MAIN LOOP
RunService.Heartbeat:Connect(function()
    pcall(function()
        if AutoQuest then StartQuest() end

        if AutoFarm then
            local mob = GetMob()
            if mob and HRP then
                EquipWeapon()
                HRP.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, FarmDistance)  -- Trên đầu mob
                Attack()
            end
        end

        DoMobAura()
    end)
end)

--// ================= RAYFIELD UI =================
local Window = Rayfield:CreateWindow({
    Name = "BLACKZ HUB - REDZ STYLE",
    LoadingTitle = "Full Sea 1/2/3 Farm",
    LoadingSubtitle = "Auto Quest + Farm All Seas",
    ConfigurationSaving = { Enabled = true, FolderName = "BlackzHub", FileName = "Config" }
})

local MainTab = Window:CreateTab("Main")
local SettingsTab = Window:CreateTab("Settings")

-- Main Features
MainTab:CreateSection("Auto Features")

MainTab:CreateToggle({
    Name = "Auto Quest (All Seas)",
    CurrentValue = false,
    Callback = function(v) AutoQuest = v end
})

MainTab:CreateToggle({
    Name = "Auto Farm Level",
    CurrentValue = false,
    Callback = function(v) AutoFarm = v end
})

MainTab:CreateToggle({
    Name = "Mob Aura",
    CurrentValue = false,
    Callback = function(v) MobAura = v end
})

-- Settings
SettingsTab:CreateSection("Farm Settings")

SettingsTab:CreateDropdown({
    Name = "Select Sea",
    Options = {"Sea 1", "Sea 2", "Sea 3"},
    CurrentOption = "Sea 1",
    Callback = function(v) SelectedSea = v end
})

SettingsTab:CreateSlider({
    Name = "Farm Distance",
    Range = {5, 30},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 18,
    Callback = function(v) FarmDistance = v end
})

Rayfield:LoadConfiguration()
