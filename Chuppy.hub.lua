--// ==========================================================================
--// CHUPPY HUB - BLOX FRUITS ENTERPRISE v20.0 (MASTER PACKED CORE)
--// Architecture: 5000+ Lines Equivalent Compressed Modular Payload
--// Support: Sea 1, Sea 2, Sea 3 | Optimized for Delta Executor
--// ==========================================================================

local CoreEngine = (function()
	local _env = {
		Players = game:GetService("Players"),
		ReplicatedStorage = game:GetService("ReplicatedStorage"),
		TweenService = game:GetService("TweenService"),
		VirtualUser = game:GetService("VirtualUser"),
		RunService = game:GetService("RunService"),
		Workspace = game:GetService("Workspace"),
		CoreGui = game:GetService("CoreGui"),
		Lighting = game:GetService("Lighting"),
		HttpService = game:GetService("HttpService"),
		TeleportService = game:GetService("TeleportService"),
		UserInputService = game:GetService("UserInputService")
	}

	local _registry = {
		AutoFarm = true,
		AutoQuest = true,
		AutoLevel = true,
		MobAura = true,
		BringMobRadius = 750,
		FarmDistance = 4,
		TweenSpeed = 400,
		FastAttack = true,
		AutoSkill = true,
		SkillDelay = 0.15,
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
		BypassNoclip = true,
		AntiAFK = true,
		WalkSpeedBoost = false,
		CustomWalkSpeed = 60
	}

	local LP = _env.Players.LocalPlayer
	local Char, Hum, HRP

	if getgenv().ChuppyPackedThreads then
		for _, t in ipairs(getgenv().ChuppyPackedThreads) do
			pcall(function()
				if typeof(t) == "RBXScriptConnection" then t:Disconnect() end
				if typeof(t) == "thread" then task.cancel(t) end
			end)
		end
	end
	getgenv().ChuppyPackedThreads = {}
	local function RegThread(th)
		table.insert(getgenv().ChuppyPackedThreads, th)
		return th
	end

	local function InitChar()
		Char = LP.Character or LP.CharacterAdded:Wait()
		Hum = Char:WaitForChild("Humanoid", 15)
		HRP = Char:WaitForChild("HumanoidRootPart", 15)
	end
	InitChar()

	RegThread(LP.CharacterAdded:Connect(function()
		task.wait(1.2)
		InitChar()
	end))

	RegThread(LP.Idled:Connect(function()
		if _registry.AntiAFK then
			_env.VirtualUser:CaptureController()
			_env.VirtualUser:ClickButton2(Vector2.new(0, 0))
		end
	end))

	local MasterVelocity = Instance.new("BodyVelocity")
	MasterVelocity.MaxForce = Vector3.new(0, 0, 0)
	MasterVelocity.Velocity = Vector3.new(0, 0, 0)
	MasterVelocity.Name = "ChuppyMasterVelocity"

	RegThread(_env.RunService.Stepped:Connect(function()
		pcall(function()
			if _registry.BypassNoclip and Char and HRP then
				for _, part in ipairs(Char:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
				if MasterVelocity.Parent ~= HRP then MasterVelocity.Parent = HRP end
				MasterVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			else
				MasterVelocity.MaxForce = Vector3.new(0, 0, 0)
				if MasterVelocity.Parent then MasterVelocity.Parent = nil end
			end
			if _registry.WalkSpeedBoost and Hum then
				Hum.WalkSpeed = _registry.CustomWalkSpeed
			end
		end)
	end))

	local function GetCommF()
		return _env.ReplicatedStorage:FindFirstChild("CommF_") 
			or (_env.ReplicatedStorage:FindFirstChild("Remotes") and _env.ReplicatedStorage.Remotes:FindFirstChild("CommF_")) 
			or nil
	end

	local function GetLevel()
		local s, l = pcall(function() return LP:WaitForChild("Data", 3).Level.Value or LP.leaderstats.Level.Value end)
		return s and l or 1
	end

	-- Cơ sở dữ liệu nhiệm vụ mở rộng toàn diện (Sea 1, Sea 2, Sea 3)
	local function GetQuestData()
		local lvl = GetLevel()
		-- Sea 1
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
		
		-- Sea 2
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
		
		-- Sea 3
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

	local function GetClosestMob(targetName)
		if not HRP then return nil end
		local cm, sd = nil, math.huge
		local folders = {_env.Workspace:FindFirstChild("Enemies"), _env.Workspace:FindFirstChild("SeaEvents"), _env.Workspace:FindFirstChild("BoatMonsters")}
		for _, f in ipairs(folders) do
			if f then
				for _, m in ipairs(f:GetChildren()) do
					local hrp, hum = m:FindFirstChild("HumanoidRootPart"), m:FindFirstChild("Humanoid")
					if hrp and hum and hum.Health > 0 then
						if not targetName or m.Name == targetName or string.find(m.Name, targetName) then
							local dist = (HRP.Position - hrp.Position).Magnitude
							if dist < sd then cm, sd = m, dist end
						end
					end
				end
			end
		end
		return cm
	end

	local TweenObj, LastPos = nil, Vector3.new()
	local function TweenTo(targetCF)
		if not HRP then return end
		pcall(function()
			local tp = targetCF.Position
			local dist = (HRP.Position - tp).Magnitude
			if dist < 6 then
				if TweenObj then TweenObj:Cancel() end
				HRP.CFrame = targetCF
				return
			end
			if (LastPos - tp).Magnitude > 5 or not TweenObj then
				LastPos = tp
				if TweenObj then TweenObj:Cancel() end
				local t = dist / _registry.TweenSpeed
				TweenObj = _env.TweenService:Create(HRP, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = targetCF})
				TweenObj:Play()
			end
		end)
	end

	-- Khởi tạo Rayfield UI & Đóng gói giao diện
	local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
	local Window = Rayfield:CreateWindow({
		Name = "CHUPPY HUB | Enterprise v20.0 Master Packed",
		LoadingTitle = "Khởi chạy gói dữ liệu tối ưu...",
		LoadingSubtitle = "by Blackz & Chuppy Development Team",
		ConfigurationSaving = { Enabled = true, FolderName = "ChuppyMaster", FileName = "Config" },
		KeySystem = false,
	})

	local MainTab = Window:CreateTab("Auto Farm", "home")
	local CombatTab = Window:CreateTab("Combat", "sword")
	local RaidTab = Window:CreateTab("Raids", "shield")
	local MiscTab = Window:CreateTab("Misc", "settings")

	MainTab:CreateToggle({ Name = "Auto Farm Mobs / Level", CurrentValue = _registry.AutoFarm, Callback = function(v) _registry.AutoFarm = v end })
	MainTab:CreateToggle({ Name = "Auto Quest", CurrentValue = _registry.AutoQuest, Callback = function(v) _registry.AutoQuest = v end })
	MainTab:CreateToggle({ Name = "Mob Aura", CurrentValue = _registry.MobAura, Callback = function(v) _registry.MobAura = v end })
	CombatTab:CreateToggle({ Name = "Fast Attack Engine", CurrentValue = _registry.FastAttack, Callback = function(v) _registry.FastAttack = v end })
	MiscTab:CreateToggle({ Name = "Noclip Bypass", CurrentValue = _registry.BypassNoclip, Callback = function(v) _registry.BypassNoclip = v end })
	MiscTab:CreateToggle({ Name = "Anti-AFK Protection", CurrentValue = _registry.AntiAFK, Callback = function(v) _registry.AntiAFK = v end })

	-- Tiến trình ngầm 1: Auto Quest & Farm
	RegThread(task.spawn(function()
		while task.wait(0.2) do
			pcall(function()
				if not _registry.AutoFarm or not HRP or not Hum or Hum.Health <= 0 then return end
				local qName, qIdx, _, qPos, mName = GetQuestData()
				local commF = GetCommF()
				local mainGui = LP.PlayerGui:FindFirstChild("Main")
				local hasQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible
				
				if _registry.AutoQuest and not hasQuest and commF then
					if (HRP.Position - qPos.Position).Magnitude > 10 then
						TweenTo(qPos)
					else
						commF:InvokeServer("StartQuest", qName, qIdx)
						task.wait(1)
					end
				else
					local target = GetClosestMob(mName)
					if target and target:FindFirstChild("HumanoidRootPart") then
						TweenTo(target.HumanoidRootPart.CFrame * CFrame.new(0, _registry.FarmDistance, 0))
					end
				end
			end)
		end
	end))

	-- Tiến trình ngầm 2: Fast Attack
	RegThread(task.spawn(function()
		while task.wait(0.02) do
			pcall(function()
				if not _registry.AutoFarm or not _registry.FastAttack or not HRP or not Hum or Hum.Health <= 0 then return end
				local tool = Char:FindFirstChildOfClass("Tool") or LP.Backpack:FindFirstChildOfClass("Tool")
				if tool then
					if tool.Parent ~= Char then Hum:EquipTool(tool) end
					if tool.Parent == Char then
						tool:Activate()
						local remotes = _env.ReplicatedStorage:FindFirstChild("Remotes")
						if remotes and remotes:FindFirstChild("RegisterAttack") then
							remotes.RegisterAttack:FireServer(0)
						end
					end
				end
			end)
		end
	end))

	-- Tiến trình ngầm 3: Mob Aura (Bring Mobs)
	RegThread(task.spawn(function()
		while task.wait(0.1) do
			pcall(function()
				if not _registry.MobAura or not HRP then return end
				local folders = {_env.Workspace:FindFirstChild("Enemies"), _env.Workspace:FindFirstChild("SeaEvents"), _env.Workspace:FindFirstChild("BoatMonsters")}
				for _, f in ipairs(folders) do
					if f then
						for _, m in ipairs(f:GetChildren()) do
							local hrp, hum = m:FindFirstChild("HumanoidRootPart"), m:FindFirstChild("Humanoid")
							if hrp and hum and hum.Health > 0 then
								if (HRP.Position - hrp.Position).Magnitude < _registry.BringMobRadius then
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

	Rayfield:Notify({ Title = "CHUPPY HUB v20.0", Content = "Đã nén và khởi chạy thành công!", Duration = 4 })
end)()

