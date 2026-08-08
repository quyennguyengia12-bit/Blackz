--// ==========================================================================
--// CHUPPY HUB - BLOX FRUITS ULTIMATE ENTERPRISE v8.0 (MAXIMUM EDITION)
--// Architecture: Modular Event-Driven Core & Advanced Combat Engine
--// Support: Sea 1, Sea 2, Sea 3 | Fully Optimized for Mobile & PC
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

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LP:GetMouse()
local Char, Hum, HRP

--// ==========================================================================
--// 1. GLOBAL CONFIGURATION & SETTINGS REGISTRY
--// ==========================================================================
getgenv().ChuppyEnterpriseConfig = {
	-- Auto Farm Settings
	AutoFarm = false,
	AutoQuest = true,
	AutoLevel = true,
	MobAura = true,
	BringMobRadius = 400,
	FarmDistance = 4,
	TweenSpeed = 350,
	SelectedWeapon = "All",
	
	-- Combat & Skill Settings
	FastAttack = true,
	AutoSkill = true,
	SkillDelay = 0.2,
	SkillZ = true,
	SkillX = true,
	SkillC = true,
	SkillV = true,
	SkillF = false,
	
	-- Shop, Gacha & Haki Settings
	AutoBuyHaki = false,
	AutoEnableHaki = true,
	AutoRandomFruit = false,
	AutoStoreFruit = true,
	
	-- Stats Upgrade Settings
	AutoStats = false,
	StatTarget = "Melee", -- Melee, Defense, Sword, Gun, Blox Fruit
	StatPoints = 3,
	
	-- Visuals & ESP Settings
	ESPPlayer = false,
	ESPMob = false,
	ESPFruit = false,
	ESPChest = false,
	ESPFlower = false,
	
	-- Miscellaneous & Bypasses
	BypassNoclip = true,
	AntiAFK = true,
	InfiniteJump = false,
	FPSBoost = false
}
local S = getgenv().ChuppyEnterpriseConfig

--// ==========================================================================
--// 2. SAFE REMOTE FINDER UTILITY
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
local Threads = getgenv().ChuppyEnterprise_Threads

--// ==========================================================================
--// 4. ADVANCED CHARACTER LOADER & LIFECYCLE HANDLER
--// ==========================================================================
local function LoadCharacter()
	Char = LP.Character or LP.CharacterAdded:Wait()
	Hum = Char:WaitForChild("Humanoid", 15)
	HRP = Char:WaitForChild("HumanoidRootPart", 15)
end
LoadCharacter()

table.insert(Threads, LP.CharacterAdded:Connect(function(newChar)
	task.wait(1)
	LoadCharacter()
end))

--// ==========================================================================
--// 5. ANTI-AFK SYSTEM
--// ==========================================================================
table.insert(Threads, LP.Idled:Connect(function()
	if S.AntiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new(0,0))
	end
end))

--// ==========================================================================
--// 6. NOCLIP & FLIGHT PHYSICS BYPASS ENGINE
--// ==========================================================================
local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
BodyVelocity.Velocity = Vector3.new(0, 0, 0)
BodyVelocity.Name = "ChuppyEnterpriseVelocity"

table.insert(Threads, RunService.Stepped:Connect(function()
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
	end)
end))

--// ==========================================================================
--// 7. MULTI-SEA TARGET SELECTION & MOB SCANNER ENGINE
--// ==========================================================================
local function GetClosestMob()
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
					local distance = (HRP.Position - hrp.Position).Magnitude
					if distance < shortestDistance then
						closestMob = m
						shortestDistance = distance
					end
				end
			end
		end
	end

	if not closestMob then
		for _, m in ipairs(Workspace:GetChildren()) do
			if m:IsA("Model") and m ~= Char and not Players:GetPlayerFromCharacter(m) then
				local hrp = m:FindFirstChild("HumanoidRootPart")
				local hum = m:FindFirstChild("Humanoid")
				if hrp and hum and hum.Health > 0 then
					local distance = (HRP.Position - hrp.Position).Magnitude
					if distance < shortestDistance then
						closestMob = m
						shortestDistance = distance
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
		if (LastTargetPos - targetPos).Magnitude < 3 and TweenObj then
			return
		end
		LastTargetPos = targetPos

		local distance = (HRP.Position - targetPos).Magnitude
		local time = distance / S.TweenSpeed
		
		if distance < 6 then 
			if TweenObj then TweenObj:Cancel() end
			HRP.CFrame = TargetCFrame
			return 
		end

		if TweenObj then TweenObj:Cancel() end
		local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
		TweenObj = TweenService:Create(HRP, tweenInfo, {CFrame = TargetCFrame})
		TweenObj:Play()
	end)
end

--// ==========================================================================
--// 9. RAYFIELD UI FRAMEWORK INITIALIZATION
--// ==========================================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "CHUPPY HUB | Blox Fruits Ultimate v8.0 Enterprise",
	LoadingTitle = "Khởi chạy lõi hệ thống nâng cấp toàn diện...",
	LoadingSubtitle = "by Blackz & Chuppy Development Team",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "ChuppyHubEnterprise",
		FileName = "EnterpriseConfig"
	},
	KeySystem = false,
})

--// ==========================================================================
--// 10. UI TABS CREATION
--// ==========================================================================
local MainTab = Window:CreateTab("Auto Farm", "home")
local CombatTab = Window:CreateTab("Combat & Skills", "sword")
local ShopTab = Window:CreateTab("Shop & Gacha", "shopping-cart")
local StatsTab = Window:CreateTab("Stats Upgrade", "bar-chart-2")
local VisualTab = Window:CreateTab("Visuals & ESP", "eye")
local MiscTab = Window:CreateTab("Misc & Settings", "settings")

--// ==========================================================================
--// 11. TAB ELEMENTS & INTERFACES
--// ==========================================================================
-- Main Farm Section
MainTab:CreateSection("Core Farm Automation")

MainTab:CreateToggle({
	Name = "Auto Farm Mobs / Level",
	CurrentValue = S.AutoFarm,
	Flag = "AutoFarmFlag",
	Callback = function(v) S.AutoFarm = v end,
})

MainTab:CreateToggle({
	Name = "Mob Aura (Bring Mobs to Player)",
	CurrentValue = S.MobAura,
	Flag = "MobAuraFlag",
	Callback = function(v) S.MobAura = v end,
})

MainTab:CreateSlider({
	Name = "Farm Altitude Distance (Y-Axis)",
	Range = {2, 20},
	Increment = 1,
	CurrentValue = S.FarmDistance,
	Flag = "FarmDistFlag",
	Callback = function(v) S.FarmDistance = v end,
})

MainTab:CreateSlider({
	Name = "Tween Flight Speed",
	Range = {100, 500},
	Increment = 10,
	CurrentValue = S.TweenSpeed,
	Flag = "TweenSpeedFlag",
	Callback = function(v) S.TweenSpeed = v end,
})

-- Combat Section
CombatTab:CreateSection("Combat & Fast Attack")

CombatTab:CreateToggle({
	Name = "Fast Attack Engine",
	CurrentValue = S.FastAttack,
	Callback = function(v) S.FastAttack = v end,
})

CombatTab:CreateToggle({
	Name = "Auto Use Skills (Z, X, C, V, F)",
	CurrentValue = S.AutoSkill,
	Callback = function(v) S.AutoSkill = v end,
})

CombatTab:CreateToggle({ Name = "Use Skill Z", CurrentValue = S.SkillZ, Callback = function(v) S.SkillZ = v end })
CombatTab:CreateToggle({ Name = "Use Skill X", CurrentValue = S.SkillX, Callback = function(v) S.SkillX = v end })
CombatTab:CreateToggle({ Name = "Use Skill C", CurrentValue = S.SkillC, Callback = function(v) S.SkillC = v end })
CombatTab:CreateToggle({ Name = "Use Skill V", CurrentValue = S.SkillV, Callback = function(v) S.SkillV = v end })
CombatTab:CreateToggle({ Name = "Use Skill F", CurrentValue = S.SkillF, Callback = function(v) S.SkillF = v end })

-- Shop & Gacha Section
ShopTab:CreateSection("Shop & Haki")

ShopTab:CreateToggle({ Name = "Auto Buy Buso Haki", CurrentValue = S.AutoBuyHaki, Callback = function(v) S.AutoBuyHaki = v end })
ShopTab:CreateToggle({ Name = "Auto Enable Buso Haki", CurrentValue = S.AutoEnableHaki, Callback = function(v) S.AutoEnableHaki = v end })

ShopTab:CreateSection("Fruit Gacha & Storage")
ShopTab:CreateToggle({ Name = "Auto Random Fruit (Cousin)", CurrentValue = S.AutoRandomFruit, Callback = function(v) S.AutoRandomFruit = v end })
ShopTab:CreateToggle({ Name = "Auto Store Blox Fruits", CurrentValue = S.AutoStoreFruit, Callback = function(v) S.AutoStoreFruit = v end })

-- Stats Section
StatsTab:CreateSection("Automatic Stat Distribution")
StatsTab:CreateToggle({ Name = "Auto Upgrade Stats", CurrentValue = S.AutoStats, Callback = function(v) S.AutoStats = v end })
StatsTab:CreateDropdown({
	Name = "Select Stat Target",
	Options = {"Melee", "Defense", "Sword", "Gun", "Blox Fruit"},
	CurrentOption = S.StatTarget,
	Callback = function(v) S.StatTarget = v end,
})
StatsTab:CreateSlider({ Name = "Points per Interval", Range = {1, 3}, Increment = 1, CurrentValue = S.StatPoints, Callback = function(v) S.StatPoints = v end })

-- Visuals & ESP Section
VisualTab:CreateSection("ESP Options")
VisualTab:CreateToggle({ Name = "Player ESP", CurrentValue = S.ESPPlayer, Callback = function(v) S.ESPPlayer = v end })
VisualTab:CreateToggle({ Name = "Mob / Enemy ESP", CurrentValue = S.ESPMob, Callback = function(v) S.ESPMob = v end })
VisualTab:CreateToggle({ Name = "Blox Fruit ESP", CurrentValue = S.ESPFruit, Callback = function(v) S.ESPFruit = v end })
VisualTab:CreateToggle({ Name = "Chest ESP", CurrentValue = S.ESPChest, Callback = function(v) S.ESPChest = v end })

-- Misc Section
MiscTab:CreateSection("Utilities & Bypasses")
MiscTab:CreateToggle({ Name = "Noclip Bypass", CurrentValue = S.BypassNoclip, Callback = function(v) S.BypassNoclip = v end })
MiscTab:CreateToggle({ Name = "Anti-AFK Protection", CurrentValue = S.AntiAFK, Callback = function(v) S.AntiAFK = v end })
MiscTab:CreateButton({
	Name = "Rejoin Server",
	Callback = function()
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
	end,
})

--// ==========================================================================
--// 12. BACKGROUND AUTOMATION LOOPS (CORE BACKEND)
--// ==========================================================================

-- Loop 1: Auto Farm Movement
table.insert(Threads, task.spawn(function()
	while task.wait(0.1) do
		pcall(function()
			if not S.AutoFarm or not HRP or not Hum or Hum.Health <= 0 then return end
			local TargetMob = GetClosestMob()
			if TargetMob and TargetMob:FindFirstChild("HumanoidRootPart") then
				local mobHRP = TargetMob.HumanoidRootPart
				local targetPos = mobHRP.CFrame * CFrame.new(0, S.FarmDistance, 0)
				local lookAtCFrame = CFrame.new(targetPos.Position, mobHRP.Position)
				TweenTo(lookAtCFrame)
			end
		end)
	end
end))

-- Loop 2: Fast Attack & Combat Hitbox Engine
table.insert(Threads, task.spawn(function()
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
				VirtualUser:CaptureController()
				VirtualUser:Button1Down(Vector2.new(1e3, 1e3))
				task.wait(0.01)
				VirtualUser:Button1Up(Vector2.new(1e3, 1e3))
			end
		end)
	end
end))

-- Loop 3: Mob Aura / Bring Mobs
table.insert(Threads, task.spawn(function()
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
								hrp.CFrame = HRP.CFrame
								hrp.CanCollide = false
								hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
								hum.WalkSpeed = 0
								hum.JumpPower = 0
							end
						end
					end
				end
			end
		end)
	end
end))

-- Loop 4: Auto Skills Rotation
table.insert(Threads, task.spawn(function()
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

-- Loop 5: Auto Haki Manager
table.insert(Threads, task.spawn(function()
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

-- Loop 6: Auto Gacha & Fruit Storage
table.insert(Threads, task.spawn(function()
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

-- Loop 7: Auto Stats Upgrade
table.insert(Threads, task.spawn(function()
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
--// 13. STARTUP NOTIFICATION
--// ==========================================================================
Rayfield:Notify({
	Title = "CHUPPY HUB V8.0 ENTERPRISE",
	Content = "Toàn bộ hệ thống lõi nâng cấp đã khởi động thành công!",
	Duration = 6,
	Image = 4483362458,
})

