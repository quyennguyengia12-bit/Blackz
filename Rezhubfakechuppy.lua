--// =====================================================
--// CHUPPY HUB - REDZ STYLE | ULTIMATE v3 (FINAL)
--// Mobile + PC | Blox Fruits
--// Creator: Nguyễn Quang Anh
--// Redz UI + Fixed by ChatGPT 😎
--// =====================================================

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LP = Players.LocalPlayer

-- LOAD REDZ UI
local RedzLib = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/luacoder-byte/luacoder/refs/heads/main/RedzHub.lua"
))()

-- WINDOW
local Window = RedzLib:MakeWindow({
	Title = "CHUPPY HUB",
	SubTitle = "Blox Fruits | REDZ STYLE",
	SaveFolder = "ChuppyHubV3"
})

-- CHARACTER
local Char, Hum, HRP
local function LoadChar()
	Char = LP.Character or LP.CharacterAdded:Wait()
	Hum = Char:WaitForChild("Humanoid")
	HRP = Char:WaitForChild("HumanoidRootPart")
end
LoadChar()
LP.CharacterAdded:Connect(function()
	task.wait(1)
	LoadChar()
end)

-- SETTINGS
local S = {
	AutoFarm = false,
	AutoQuest = false,
	AutoSkill = false,
	MobAura = false,
	FarmDistance = 10
}

-- SEA DETECT
local Sea = 1
if game.PlaceId == 4442272183 then Sea = 2 end
if game.PlaceId == 7449423635 then Sea = 3 end

-- QUEST DATA
local QuestData = {
	[1] = {
		{Min=1,Quest="BanditQuest1"},
		{Min=10,Quest="MonkeyQuest"},
		{Min=30,Quest="BuggyQuest1"}
	},
	[2] = {
		{Min=700,Quest="Area1Quest"},
		{Min=875,Quest="Area2Quest"}
	},
	[3] = {
		{Min=1500,Quest="PiratePortQuest"}
	}
}

local function GetQuest()
	local lvl = LP.Data.Level.Value
	for i = #QuestData[Sea], 1, -1 do
		if lvl >= QuestData[Sea][i].Min then
			return QuestData[Sea][i]
		end
	end
end

-- ================= REDZ UI =================

local MainTab = Window:AddTab("Main", "home")
local FarmSec = MainTab:AddSection("Auto Farm")

FarmSec:AddToggle({
	Name = "Auto Farm",
	Default = false,
	Callback = function(v) S.AutoFarm = v end
})

FarmSec:AddToggle({
	Name = "Auto Quest",
	Default = false,
	Callback = function(v) S.AutoQuest = v end
})

FarmSec:AddToggle({
	Name = "Mob Aura",
	Default = false,
	Callback = function(v) S.MobAura = v end
})

FarmSec:AddToggle({
	Name = "Auto Skill",
	Default = false,
	Callback = function(v) S.AutoSkill = v end
})

FarmSec:AddSlider({
	Name = "Farm Distance",
	Min = 5,
	Max = 25,
	Default = 10,
	Increment = 1,
	Callback = function(v) S.FarmDistance = v end
})

-- ================= AUTO ATTACK (FIX) =================
task.spawn(function()
	while task.wait(0.12) do
		if not S.AutoFarm then continue end
		if not Char or not Hum or Hum.Health <= 0 then continue end

		local tool = Char:FindFirstChildOfClass("Tool")
			or LP.Backpack:FindFirstChildOfClass("Tool")

		if tool then
			pcall(function() Hum:EquipTool(tool) end)
			VirtualUser:CaptureController()
			VirtualUser:Button1Down(Vector2.new(0,0))
			task.wait(0.05)
			VirtualUser:Button1Up(Vector2.new(0,0))
		end
	end
end)

-- ================= AUTO SKILL =================
task.spawn(function()
	while task.wait(0.6) do
		if not S.AutoSkill then continue end
		for _,k in ipairs({"Z","X","C","V","F"}) do
			VirtualUser:CaptureController()
			VirtualUser:SetKeyDown(k)
			task.wait(0.05)
			VirtualUser:SetKeyUp(k)
			task.wait(0.12)
		end
	end
end)

-- ================= MOB AURA =================
task.spawn(function()
	while task.wait(0.2) do
		if not S.MobAura or not HRP then continue end
		for _,m in pairs(workspace.Enemies:GetChildren()) do
			if m:FindFirstChild("HumanoidRootPart") and m.Humanoid.Health > 0 then
				pcall(function()
					m.HumanoidRootPart.CFrame = HRP.CFrame * CFrame.new(0,0,-6)
					m.HumanoidRootPart.CanCollide = false
				end)
			end
		end
	end
end)

-- ================= AUTO FARM MOVE =================
task.spawn(function()
	while task.wait() do
		if not S.AutoFarm or not HRP then continue end
		for _,m in pairs(workspace.Enemies:GetChildren()) do
			if m:FindFirstChild("HumanoidRootPart") and m.Humanoid.Health > 0 then
				HRP.CFrame = m.HumanoidRootPart.CFrame * CFrame.new(0,0,S.FarmDistance)
				break
			end
		end
	end
end)

-- ================= AUTO QUEST =================
task.spawn(function()
	while task.wait(5) do
		if not S.AutoQuest then continue end
		local q = GetQuest()
		if q then
			pcall(function()
				ReplicatedStorage.Remotes.CommF_:InvokeServer(
					"StartQuest", q.Quest, 1
				)
			end)
		end
	end
end)

Window:Notify({
	Title = "CHUPPY HUB",
	Content = "Loaded Successfully | Sea "..Sea,
	Duration = 5
})
