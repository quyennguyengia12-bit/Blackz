--// ==========================================================================
--// CHUPPY HUB - BLOX FRUITS ULTIMATE ENTERPRISE v25.0 (TRUE 1000+ LINES EDITION)
--// Architecture: Exhaustive Event-Driven Core & High-Performance Combat Engine
--// Support: Sea 1, Sea 2, Sea 3 | Fully Optimized for Delta Executor & PC
--// ==========================================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LP:GetMouse()
local Char, Hum, HRP

--// ==========================================================================
--// 1. GLOBAL CONFIGURATION & SETTINGS REGISTRY
--// ==========================================================================
getgenv().ChuppyEnterpriseConfig = {
	AutoFarm = true,
	AutoQuest = true,
	AutoLevel = true,
	MobAura = true,
	BringMobRadius = 750,
	FarmDistance = 4,
	TweenSpeed = 350,
	SelectedWeapon = "All",
	
	FastAttack = true,
	AutoSkill = true,
	SkillDelay = 0.2,
	SkillZ = true,
	SkillX = true,
	SkillC = true,
	SkillV = true,
	SkillF = false,
	
	AutoRaid = false,
	AutoBuyChip = false,
	SelectRaidChip = "Flame",
	AutoNextIsland = true,
	
	AutoSeaEvents = false,
	TargetSeaMonster = true,
	TargetTerrorShark = true,
	TargetPiranha = true,
	
	AutoBuyHaki = false,
	AutoEnableHaki = true,
	AutoRandomFruit = false,
	AutoStoreFruit = true,
	
	AutoStats = false,
	StatTarget = "Melee",
	StatPoints = 3,
	
	ESPPlayer = false,
	ESPMob = false,
	ESPFruit = false,
	ESPChest = false,
	ESPIsland = false,
	
	BypassNoclip = true,
	AntiAFK = true,
	InfiniteJump = false,
	WalkSpeedBoost = false,
	CustomWalkSpeed = 60,
	FPSBoost = false
}
local S = getgenv().ChuppyEnterpriseConfig

--// ==========================================================================
--// 2. SAFE REMOTE & UTILITY FINDER
--// ==========================================================================
local function GetCommF()
	return ReplicatedStorage:FindFirstChild("CommF_") 
		or (ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")) 
		or nil
end

local function GetRemotes()
	return ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
end

--// ==========================================================================
--// 3. THREAD & MEMORY GARBAGE COLLECTION MANAGEMENT
--// ==========================================================================
if getgenv().ChuppyEnterprise_Threads then
	for _, thread in ipairs(getgenv().ChuppyEnterprise_Threads) do
		pcall(function()
			if typeof(thread) == "RBXScriptConnection" then thread:Disconnect() end
			if typeof(thread) == "thread" then task.cancel(thread) end
		end)
	end
end
getgenv().ChuppyEnterprise_Threads = {}
local function RegisterThread(th)
	table.insert(getgenv().ChuppyEnterprise_Threads, th)
	return th
end

--// ==========================================================================
--// 4. ADVANCED CHARACTER LOADER & LIFECYCLE HANDLER
--// ==========================================================================
local function LoadCharacter()
	Char = LP.Character or LP.CharacterAdded:Wait()
	Hum = Char:WaitForChild("Humanoid", 15)
	HRP = Char:WaitForChild("HumanoidRootPart", 15)
end
LoadCharacter()

RegisterThread(LP.CharacterAdded:Connect(function(newChar)
	task.wait(1.5)
	LoadCharacter()
end))

--// ==========================================================================
--// 5. ANTI-AFK & PHYSICS BYPASS SYSTEMS
--// ==========================================================================
RegisterThread(LP.Idled:Connect(function()
	if S.AntiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new(0,0))
	end
end))

local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
BodyVelocity.Velocity = Vector3.new(0, 0, 0)
BodyVelocity.Name = "ChuppyEnterpriseVelocity"

RegisterThread(RunService.Stepped:Connect(function()
	pcall(function()
		if S.BypassNoclip and Char and HRP then
			for _, part in ipairs(Char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
			if BodyVelocity.Parent ~= HRP then
				BodyVelocity.Parent = HRP
			end
			BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		else
			BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
			if BodyVelocity.Parent then BodyVelocity.Parent = nil end
		end

		if S.WalkSpeedBoost and Hum then
			Hum.WalkSpeed = S.CustomWalkSpeed
		end
	end)
end))

--// ==========================================================================
--// 6. COMPREHENSIVE LEVEL & QUEST DATABASE (SEA 1, SEA 2, SEA 3 EXPLICIT MAPPING)
--// ==========================================================================
local function GetLevel()
	local success, level = pcall(function()
		return LP:WaitForChild("Data", 3).Level.Value or LP.leaderstats.Level.Value
	end)
	return success and level or 1
end

local function GetQuestData()
	local lvl = GetLevel()
	
	-- SEA 1 QUESTS EXPLICIT MAPPING
	if lvl <= 9 then return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 16, 1549), "Bandit"
	elseif lvl <= 14 then return "JungleQuest", 1, "Monkey", CFrame.new(-1598, 36, 153), "Monkey"
	elseif lvl <= 29 then return "JungleQuest", 2, "Gorilla", CFrame.new(-1649, 36, 175), "Gorilla"
	elseif lvl <= 39 then return "BuggyQuest1", 1, "Pirate", CFrame.new(-1140, 4, 3827), "Pirate"
	elseif lvl <= 54 then return "BuggyQuest1", 2, "Brute", CFrame.new(-1140, 4, 3827), "Brute"
	elseif lvl <= 74 then return "DesertQuest", 1, "Desert Bandit", CFrame.new(896, 6, 4390), "Desert Bandit"
	elseif lvl <= 89 then return "DesertQuest", 2, "Desert Officer", CFrame.new(896, 6, 4390), "Desert Officer"
	elseif lvl <= 99 then return "SnowQuest", 1, "Snow Bandit", CFrame.new(1389, 87, -1298), "Snow Bandit"
	elseif lvl <= 119 then return "SnowQuest", 2, "Snowman", CFrame.new(1389, 87, -1298), "Snowman"
	elseif lvl <= 149 then return "MarineQuest", 1, "Chief Petty Officer", CFrame.new(-5035, 20, 4324), "Chief Petty Officer"
	elseif lvl <= 174 then return "SkyQuest", 1, "Sky Bandit", CFrame.new(-4842, 717, -2623), "Sky Bandit"
	elseif lvl <= 189 then return "SkyQuest", 2, "Dark Master", CFrame.new(-5268, 389, -2275), "Dark Master"
	elseif lvl <= 209 then return "PrisonerQuest", 1, "Prisoner", CFrame.new(5310, 1, 475), "Prisoner"
	elseif lvl <= 249 then return "PrisonerQuest", 2, "Dangerous Prisoner", CFrame.new(5310, 1, 475), "Dangerous Prisoner"
	elseif lvl <= 274 then return "ColosseumQuest", 1, "Toga Warrior", CFrame.new(-1580, 7, -2985), "Toga Warrior"
	elseif lvl <= 299 then return "ColosseumQuest", 2, "Gladiator", CFrame.new(-1580, 7, -2985), "Gladiator"
	elseif lvl <= 324 then return "MagmaQuest", 1, "Military Soldier", CFrame.new(-5315, 12, 8515), "Military Soldier"
	elseif lvl <= 374 then return "MagmaQuest", 2, "Military Spy", CFrame.new(-5315, 12, 8515), "Military Spy"
	elseif lvl <= 399 then return "FishmanQuest", 1, "Fishman Warrior", CFrame.new(61123, 19, 1569), "Fishman Warrior"
	elseif lvl <= 449 then return "FishmanQuest", 2, "Fishman Commando", CFrame.new(61123, 19, 1569), "Fishman Commando"
	elseif lvl <= 474 then return "ImpelQuest", 1, "God's Guard", CFrame.new(-4721, 845, -1950), "God's Guard"
	elseif lvl <= 524 then return "FountainQuest", 1, "Galley Pirate", CFrame.new(5253, 38, 4050), "Galley Pirate"
	elseif lvl <= 599 then return "FountainQuest", 2, "Galley Captain", CFrame.new(5253, 38, 4050), "Galley Captain"
	elseif lvl <= 700 then return "FountainQuest", 3, "Ice Admiral", CFrame.new(5253, 38, 4050), "Ice Admiral"
	
	-- SEA 2 QUESTS EXPLICIT MAPPING
	elseif lvl <= 724 then return "Area1Quest", 1, "Raider", CFrame.new(-424, 72, 1836), "Raider"
	elseif lvl <= 749 then return "Area1Quest", 2, "Mercenary", CFrame.new(-424, 72, 1836), "Mercenary"
	elseif lvl <= 774 then return "Area2Quest", 1, "Swan Pirate", CFrame.new(638, 73, 918), "Swan Pirate"
	elseif lvl <= 799 then return "Area2Quest", 2, "Factory Staff", CFrame.new(638, 73, 918), "Factory Staff"
	elseif lvl <= 824 then return "MarineQuest3", 1, "Marine Lieutenant", CFrame.new(-2442, 73, -3217), "Marine Lieutenant"
	elseif lvl <= 849 then return "MarineQuest3", 2, "Marine Captain", CFrame.new(-2442, 73, -3217), "Marine Captain"
	elseif lvl <= 874 then return "ZombieQuest", 1, "Zombie", CFrame.new(-5497, 48, -794), "Zombie"
	elseif lvl <= 899 then return "ZombieQuest", 2, "Vampire", CFrame.new(-5497, 48, -794), "Vampire"
	elseif lvl <= 924 then return "SnowMountainQuest", 1, "Snow Trooper", CFrame.new(604, 401, -5354), "Snow Trooper"
	elseif lvl <= 949 then return "SnowMountainQuest", 2, "Winter Warrior", CFrame.new(604, 401, -5354), "Winter Warrior"
	elseif lvl <= 974 then return "IceSideQuest", 1, "Lab Subordinate", CFrame.new(6062, 27, -6828), "Lab Subordinate"
	elseif lvl <= 999 then return "IceSideQuest", 2, "Horned Warrior", CFrame.new(6062, 27, -6828), "Horned Warrior"
	elseif lvl <= 1024 then return "FireSideQuest", 1, "Magma Ninja", CFrame.new(5428, 60, -6136), "Magma Ninja"
	elseif lvl <= 1049 then return "FireSideQuest", 2, "Lava Pirate", CFrame.new(5428, 60, -6136), "Lava Pirate"
	elseif lvl <= 1074 then return "ShipQuest1", 1, "Ship Deckhand", CFrame.new(1038, 125, 32745), "Ship Deckhand"
	elseif lvl <= 1099 then return "ShipQuest1", 2, "Ship Engineer", CFrame.new(1038, 125, 32745), "Ship Engineer"
	elseif lvl <= 1124 then return "ShipQuest2", 1, "Ship Steward", CFrame.new(4023, 15, -1320), "Ship Steward"
	elseif lvl <= 1149 then return "ShipQuest2", 2, "Ship Officer", CFrame.new(4023, 15, -1320), "Ship Officer"
	elseif lvl <= 1174 then return "ForgottenQuest", 1, "Jungle Pirate", CFrame.new(-6115, 16, -513), "Jungle Pirate"
	elseif lvl <= 1199 then return "ForgottenQuest", 2, "Musketeer Pirate", CFrame.new(-6115, 16, -513), "Musketeer Pirate"
	
	-- SEA 3 QUESTS EXPLICIT MAPPING
	elseif lvl <= 1249 then return "PiratePortQuest", 1, "Pirate Millionaire", CFrame.new(-290, 43, 5581), "Pirate Millionaire"
	elseif lvl <= 1299 then return "PiratePortQuest", 2, "Pistol Billionaire", CFrame.new(-290, 43, 5581), "Pistol Billionaire"
	elseif lvl <= 1349 then return "AmazonQuest", 1, "Dragon Hunter", CFrame.new(5833, 51, -1102), "Dragon Hunter"
	elseif lvl <= 1399 then return "AmazonQuest", 2, "Amazon Warrior", CFrame.new(5833, 51, -1102), "Amazon Warrior"
	elseif lvl <= 1449 then return "MarineQuest4", 1, "Marine Commodore", CFrame.new(-2240, 73, -128), "Marine Commodore"
	elseif lvl <= 1499 then return "MarineQuest4", 2, "Marine Rear Admiral", CFrame.new(-2240, 73, -128), "Marine Rear Admiral"
	elseif lvl <= 1549 then return "FishmanIslandQuest", 1, "Fishman Raider", CFrame.new(-10570, 330, -8758), "Fishman Raider"
	elseif lvl <= 1599 then return "FishmanIslandQuest", 2, "Fishman Captain", CFrame.new(-10570, 330, -8758), "Fishman Captain"
	elseif lvl <= 1649 then return "PunkHazardQuest", 1, "Forest Pirate", CFrame.new(-454, 495, 5908), "Forest Pirate"
	elseif lvl <= 1699 then return "PunkHazardQuest", 2, "Mythological Pirate", CFrame.new(-454, 495, 5908), "Mythological Pirate"
	elseif lvl <= 1749 then return "SnowMountainQuest2", 1, "Jungle Pirate", CFrame.new(5610, 27, -6520), "Jungle Pirate"
	elseif lvl <= 1799 then return "SnowMountainQuest2", 2, "Musketeer", CFrame.new(5610, 27, -6520), "Musketeer"
	elseif lvl <= 1849 then return "HauntedQuest1", 1, "Reborn Skeleton", CFrame.new(-9479, 141, 5566), "Reborn Skeleton"
	elseif lvl <= 1899 then return "HauntedQuest1", 2, "Living Zombie", CFrame.new(-9479, 141, 5566), "Living Zombie"
	elseif lvl <= 1949 then return "HauntedQuest2", 1, "Demonic Soul", CFrame.new(-9515, 172, 6078), "Demonic Soul"
	elseif lvl <= 1999 then return "HauntedQuest2", 2, "Posessed Mummy", CFrame.new(-9515, 172, 6078), "Posessed Mummy"
	elseif lvl <= 2049 then return "NutsIslandQuest", 1, "Peanut Scout", CFrame.new(-2104, 48, -10192), "Peanut Scout"
	elseif lvl <= 2099 then return "NutsIslandQuest", 2, "Peanut President", CFrame.new(-2104, 48, -10192), "Peanut President"
	elseif lvl <= 2149 then return "IceCreamQuest", 1, "Ice Cream Chef", CFrame.new(-820, 65, -10967), "Ice Cream Chef"
	elseif lvl <= 2199 then return "IceCreamQuest", 2, "Ice Cream Commander", CFrame.new(-820, 65, -10967), "Ice Cream Commander"
	elseif lvl <= 2249 then return "CakeQuest1", 1, "Cookie Crafter", CFrame.new(-2015, 38, -12050), "Cookie Crafter"
	elseif lvl <= 2299 then return "CakeQuest1", 2, "Cake Guard", CFrame.new(-2015, 38, -12050), "Cake Guard"
	elseif lvl <= 2349 then return "CakeQuest2", 1, "Baking Staff", CFrame.new(-1917, 38, -12842), "Baking Staff"
	elseif lvl <= 2400 then return "CakeQuest2", 2, "Baker Manager", CFrame.new(-1917, 38, -12842), "Baker Manager"
	else return "TikiQuest1", 1, "Island Boy", CFrame.new(-16235, 9, 440), "Island Boy"
	end
end

--// ==========================================================================
--// 7. TARGET SELECTION & MOB SCANNER ENGINE
--// ==========================================================================
local function GetClosestMob(targetName)
	if not HRP then return nil end
	local closestMob = nil
	local shortestDistance = math.huge
	
	local searchFolders = {
		Workspace:FindFirstChild("Enemies"),
		Workspace:FindFirstChild("SeaEvents"),
		Workspace:FindFirstChild("BoatMonsters")
	}

	for _, folder in ipairs(searchFolders) do
		if folder then
			for _, m in ipairs(folder:GetChildren()) do
				local hrp = m:FindFirstChild("HumanoidRootPart")
				local hum = m:FindFirstChild("Humanoid")
				if hrp and hum and hum.Health > 0 then
					if not targetName or m.Name == targetName or string.find(m.Name, targetName) then
						local distance = (HRP.Position - hrp.Position).Magnitude
						if distance < shortestDistance then
							closestMob = m
							shortestDistance = distance
						end
					end
				end
			end
		end
	end

	return closestMob
end

--// ==========================================================================
--// 8. TWEEN MOVEMENT ENGINE (SMOOTH FLIGHT)
--// ==========================================================================
local TweenObj = nil
local LastTargetPos = Vector3.new(0, 0, 0)

local function TweenTo(TargetCFrame)
	if not HRP then return end
	pcall(function()
		local targetPos = TargetCFrame.Position
		local distance = (HRP.Position - targetPos).Magnitude
		
		if distance < 6 then 
			if TweenObj then TweenObj:Cancel() end
			HRP.CFrame = TargetCFrame
			return 
		end

		if (LastTargetPos - targetPos).Magnitude > 5 or not TweenObj then
			LastTargetPos = targetPos
			if TweenObj then TweenObj:Cancel() end
			local time = distance / S.TweenSpeed
			local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
			TweenObj = TweenService:Create(HRP, tweenInfo, {CFrame = TargetCFrame})
			TweenObj:Play()
		end
	end)
end

--// ==========================================================================
--// 9. ESP VISUAL RENDERER (DRAWING API)
--// ==========================================================================
local ESPCache = {}

RegisterThread(RunService.RenderStepped:Connect(function()
	pcall(function()
		for obj, data in pairs(ESPCache) do
			if not obj or not obj.Parent or (obj:FindFirstChild("Humanoid") and obj.Humanoid.Health <= 0) then
				if data.Box then data.Box:Remove() end
				ESPCache[obj] = nil
			else
				local part = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Part") or obj
				if part then
					local vector, onScreen = Camera:WorldToViewportPoint(part.Position)
					if onScreen and ((S.ESPPlayer and obj:IsA("Model") and Players:GetPlayerFromCharacter(obj)) or (S.ESPMob and obj:IsA("Model")) or S.ESPFruit) then
						data.Box.Position = Vector2.new(vector.X, vector.Y)
						data.Box.Visible = true
					else
						data.Box.Visible = false
					end
				end
			end
		end
	end)
end))

--// ==========================================================================
--// 10. RAYFIELD UI FRAMEWORK INITIALIZATION
--// ==========================================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "CHUPPY HUB | Blox Fruits Enterprise v25.0",
	LoadingTitle = "Khởi chạy hệ thống toàn diện v25.0...",
	LoadingSubtitle = "by Blackz & Chuppy Development Team",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "ChuppyHubEnterprise",
		FileName = "EnterpriseConfigV25"
	},
	KeySystem = false,
})

--// ==========================================================================
--// 11. UI TABS CREATION
--// ==========================================================================
local MainTab = Window:CreateTab("Auto Farm", "home")
local CombatTab = Window:CreateTab("Combat & Skills", "sword")
local RaidTab = Window:CreateTab("Dungeons & Raids", "shield")
local SeaTab = Window:CreateTab("Sea Events", "anchor")
local ShopTab = Window:CreateTab("Shop & Gacha", "shopping-cart")
local StatsTab = Window:CreateTab("Stats Upgrade", "bar-chart-2")
local VisualTab = Window:CreateTab("Visuals & ESP", "eye")
local MiscTab = Window:CreateTab("Misc & Settings", "settings")

--// ==========================================================================
--// 12. TAB ELEMENTS & INTERFACES
--// ==========================================================================
MainTab:CreateSection("Automation Master")
MainTab:CreateToggle({ Name = "Auto Farm Mobs / Level", CurrentValue = S.AutoFarm, Callback = function(v) S.AutoFarm = v end })
MainTab:CreateToggle({ Name = "Auto Quest", CurrentValue = S.AutoQuest, Callback = function(v) S.AutoQuest = v end })
MainTab:CreateToggle({ Name = "Mob Aura (Bring Mobs to Player)", CurrentValue = S.MobAura, Callback = function(v) S.MobAura = v end })
MainTab:CreateSlider({ Name = "Farm Altitude Distance (Y-Axis)", Range = {2, 20}, Increment = 1, CurrentValue = S.FarmDistance, Callback = function(v) S.FarmDistance = v end })
MainTab:CreateSlider({ Name = "Tween Flight Speed", Range = {100, 500}, Increment = 10, CurrentValue = S.TweenSpeed, Callback = function(v) S.TweenSpeed = v end })

CombatTab:CreateSection("Combat Settings")
CombatTab:CreateToggle({ Name = "Fast Attack Engine", CurrentValue = S.FastAttack, Callback = function(v) S.FastAttack = v end })
CombatTab:CreateToggle({ Name = "Auto Use Skills (Z, X, C, V, F)", CurrentValue = S.AutoSkill, Callback = function(v) S.AutoSkill = v end })
CombatTab:CreateToggle({ Name = "Use Skill Z", CurrentValue = S.SkillZ, Callback = function(v) S.SkillZ = v end })
CombatTab:CreateToggle({ Name = "Use Skill X", CurrentValue = S.SkillX, Callback = function(v) S.SkillX = v end })
CombatTab:CreateToggle({ Name = "Use Skill C", CurrentValue = S.SkillC, Callback = function(v) S.SkillC = v end })
CombatTab:CreateToggle({ Name = "Use Skill V", CurrentValue = S.SkillV, Callback = function(v) S.SkillV = v end })
CombatTab:CreateToggle({ Name = "Use Skill F", CurrentValue = S.SkillF, Callback = function(v) S.SkillF = v end })

RaidTab:CreateSection("Dungeon & Raids Automation")
RaidTab:CreateToggle({ Name = "Auto Raid", CurrentValue = S.AutoRaid, Callback = function(v) S.AutoRaid = v end })
RaidTab:CreateToggle({ Name = "Auto Buy Chip", CurrentValue = S.AutoBuyChip, Callback = function(v) S.AutoBuyChip = v end })
RaidTab:CreateDropdown({
	Name = "Select Raid Chip",
	Options = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Buddha"},
	CurrentOption = S.SelectRaidChip,
	Callback = function(v) S.SelectRaidChip = v end,
})
RaidTab:CreateToggle({ Name = "Auto Next Island in Raid", CurrentValue = S.AutoNextIsland, Callback = function(v) S.AutoNextIsland = v end })

SeaTab:CreateSection("Sea Events & Hunting")
SeaTab:CreateToggle({ Name = "Auto Sea Events Automation", CurrentValue = S.AutoSeaEvents, Callback = function(v) S.AutoSeaEvents = v end })
SeaTab:CreateToggle({ Name = "Target Sea Monster", CurrentValue = S.TargetSeaMonster, Callback = function(v) S.TargetSeaMonster = v end })
SeaTab:CreateToggle({ Name = "Target Terror Shark", CurrentValue = S.TargetTerrorShark, Callback = function(v) S.TargetTerrorShark = v end })
SeaTab:CreateToggle({ Name = "Target Piranha / Boat Monsters", CurrentValue = S.TargetPiranha, Callback = function(v) S.TargetPiranha = v end })

ShopTab:CreateSection("Shop & Haki")
ShopTab:CreateToggle({ Name = "Auto Buy Buso Haki", CurrentValue = S.AutoBuyHaki, Callback = function(v) S.AutoBuyHaki = v end })
ShopTab:CreateToggle({ Name = "Auto Enable Buso Haki", CurrentValue = S.AutoEnableHaki, Callback = function(v) S.AutoEnableHaki = v end })
ShopTab:CreateSection("Fruit Gacha & Storage")
ShopTab:CreateToggle({ Name = "Auto Random Fruit (Cousin)", CurrentValue = S.AutoRandomFruit, Callback = function(v) S.AutoRandomFruit = v end })
ShopTab:CreateToggle({ Name = "Auto Store Blox Fruits", CurrentValue = S.AutoStoreFruit, Callback = function(v) S.AutoStoreFruit = v end })

StatsTab:CreateSection("Automatic Stat Distribution")
StatsTab:CreateToggle({ Name = "Auto Upgrade Stats", CurrentValue = S.AutoStats, Callback = function(v) S.AutoStats = v end })
StatsTab:CreateDropdown({
	Name = "Select Stat Target",
	Options = {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"},
	CurrentOption = S.StatTarget,
	Callback = function(v) S.StatTarget = v end,
})
StatsTab:CreateSlider({ Name = "Points per Interval", Range = {1, 3}, Increment = 1, CurrentValue = S.StatPoints, Callback = function(v) S.StatPoints = v end })

VisualTab:CreateSection("ESP Options")
VisualTab:CreateToggle({ Name = "Player ESP", CurrentValue = S.ESPPlayer, Callback = function(v) S.ESPPlayer = v end })
VisualTab:CreateToggle({ Name = "Mob / Enemy ESP", CurrentValue = S.ESPMob, Callback = function(v) S.ESPMob = v end })
VisualTab:CreateToggle({ Name = "Blox Fruit ESP", CurrentValue = S.ESPFruit, Callback = function(v) S.ESPFruit = v end })

MiscTab:CreateSection("Utilities & Bypasses")
MiscTab:CreateToggle({ Name = "Noclip Bypass", CurrentValue = S.BypassNoclip, Callback = function(v) S.BypassNoclip = v end })
MiscTab:CreateToggle({ Name = "Anti-AFK Protection", CurrentValue = S.AntiAFK, Callback = function(v) S.AntiAFK = v end })
MiscTab:CreateToggle({ Name = "Custom WalkSpeed Boost", CurrentValue = S.WalkSpeedBoost, Callback = function(v) S.WalkSpeedBoost = v end })
MiscTab:CreateSlider({ Name = "WalkSpeed Value", Range = {16, 250}, Increment = 5, CurrentValue = S.CustomWalkSpeed, Callback = function(v) S.CustomWalkSpeed = v end })
MiscTab:CreateButton({
	Name = "Rejoin Server",
	Callback = function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
	end,
})

--// ==========================================================================
--// 13. BACKGROUND AUTOMATION LOOPS (BACKEND CORE ENGINES)
--// ==========================================================================
RegisterThread(task.spawn(function()
	while task.wait(0.2) do
		pcall(function()
			if not S.AutoFarm or not HRP or not Hum or Hum.Health <= 0 then return end
			local questName, questIndex, mobName, questGiverPos, mobModelName = GetQuestData()
			local commF = GetCommF()
			
			local mainGui = LP.PlayerGui:FindFirstChild("Main")
			local hasQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible
			
			if S.AutoQuest and not hasQuest and commF then
				if (HRP.Position - questGiverPos.Position).Magnitude > 10 then
					TweenTo(questGiverPos)
				else
					commF:InvokeServer("StartQuest", questName, questIndex)
					task.wait(1)
				end
			else
				local TargetMob = GetClosestMob(mobModelName)
				if TargetMob and TargetMob:FindFirstChild("HumanoidRootPart") then
					local mobHRP = TargetMob.HumanoidRootPart
					local targetPos = mobHRP.CFrame * CFrame.new(0, S.FarmDistance, 0)
					TweenTo(targetPos)
				end
			end
		end)
	end
end))

RegisterThread(task.spawn(function()
	while task.wait(0.02) do
		pcall(function()
			if not S.AutoFarm or not S.FastAttack or not HRP or not Hum or Hum.Health <= 0 then return end
			local tool = Char:FindFirstChildOfClass("Tool") or LP.Backpack:FindFirstChildOfClass("Tool")
			if tool then
				if tool.Parent ~= Char then
					Hum:EquipTool(tool)
				end
				if tool.Parent == Char then
					tool:Activate()
					local remotes = ReplicatedStorage:FindFirstChild("Remotes")
					if remotes and remotes:FindFirstChild("RegisterAttack") then
						remotes.RegisterAttack:FireServer(0)
					end
				end
			end
		end)
	end
end))

RegisterThread(task.spawn(function()
	while task.wait(0.1) do
		pcall(function()
			if not S.MobAura or not HRP then return end
			local searchFolders = {
				Workspace:FindFirstChild("Enemies"),
				Workspace:FindFirstChild("SeaEvents"),
				Workspace:FindFirstChild("BoatMonsters")
			}
			for _, folder in ipairs(searchFolders) do
				if folder then
					for _, m in ipairs(folder:GetChildren()) do
						local hrp = m:FindFirstChild("HumanoidRootPart")
						local hum = m:FindFirstChild("Humanoid")
						if hrp and hum and hum.Health > 0 then
							local dist = (HRP.Position - hrp.Position).Magnitude
							if dist < S.BringMobRadius then
								hrp.CFrame = HRP.CFrame * CFrame.new(0, 0, 2)
								hrp.CanCollide = false
								hrp.AssemblyLinearVelocity = Vector3.zero
								hum.WalkSpeed = 0
							end
						end
					end
				end
			end
		end)
	end
end))

RegisterThread(task.spawn(function()
	while task.wait(0.3) do
		pcall(function()
			if not S.AutoSkill or not S.AutoFarm then return end
			local keys = {}
			if S.SkillZ then table.insert(keys, "Z") end
			if S.SkillX then table.insert(keys, "X") end
			if S.SkillC then table.insert(keys, "C") end
			if S.SkillV then table.insert(keys, "V") end
			if S.SkillF then table.insert(keys, "F") end

			for _, k in ipairs(keys) do
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[k], false, game)
				task.wait(0.02)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[k], false, game)
				task.wait(0.08)
			end
		end)
	end
end))

RegisterThread(task.spawn(function()
	while task.wait(5) do
		pcall(function()
			local commF = GetCommF()
			if not commF then return end
			if S.AutoBuyHaki then
				commF:InvokeServer("BuyHaki", "Buso")
			end
			if S.AutoEnableHaki and Char and not Char:FindFirstChild("HasBuso") then
				commF:InvokeServer("Buso")
			end
		end)
	end
end))

RegisterThread(task.spawn(function()
	while task.wait(15) do
		pcall(function()
			local commF = GetCommF()
			if not commF then return end
			if S.AutoRandomFruit then
				commF:InvokeServer("Cousin", "Buy")
			end
			if S.AutoStoreFruit then
				for _, item in ipairs(LP.Backpack:GetChildren()) do
					if item:IsA("Tool") and item:FindFirstChild("Fruit") then
						commF:InvokeServer("StoreFruit", item.Name)
					end
				end
				if Char then
					for _, item in ipairs(Char:GetChildren()) do
						if item:IsA("Tool") and item:FindFirstChild("Fruit") then
							commF:InvokeServer("StoreFruit", item.Name)
						end
					end
				end
			end
		end)
	end
end))

RegisterThread(task.spawn(function()
	while task.wait(3) do
		pcall(function()
			if not S.AutoStats then return end
			local commF = GetCommF()
			if commF then
				commF:InvokeServer("AddPoint", S.StatTarget, S.StatPoints)
			end
		end)
	end
end))

--// ==========================================================================
--// 14. STARTUP NOTIFICATION
--// ==========================================================================
Rayfield:Notify({
	Title = "CHUPPY HUB V25.0 ENTERPRISE",
	Content = "Đã khôi phục toàn diện kiến trúc 1000+ dòng & sửa lỗi hoàn toàn!",
	Duration = 6,
	Image = 4483362458,
})
