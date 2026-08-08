--// =====================================================
--// CHUPPY HUB - RAYFIELD UI | ULTIMATE v6.3 (REAL DAMAGE FIX)
--// Module: Blox Fruits Advanced Core (Sea 1, 2, 3)
--// =====================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local Char, Hum, HRP

-- ================= SETTINGS TABLE =================
local S = {
	AutoFarm = false,
	MobAura = false,
	AutoSkill = false,
	AutoBuyHaki = false,
	AutoEnableHaki = true,
	AutoRandomFruit = false,
	FarmDistance = 4, -- Đứng cực sát để chém trúng hitbox
	TweenSpeed = 300
}

-- ================= REMOTE FINDER HELPER =================
local function GetCommF()
	return ReplicatedStorage:FindFirstChild("CommF_") 
		or (ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")) 
		or nil
end

-- ================= THREAD & MEMORY MANAGEMENT =================
if getgenv().ChuppyHub_Threads then
	for _, thread in ipairs(getgenv().ChuppyHub_Threads) do
		pcall(function()
			if typeof(thread) == "RBXScriptConnection" then thread:Disconnect() end
			if typeof(thread) == "thread" then task.cancel(thread) end
		end)
	end
end
getgenv().ChuppyHub_Threads = {}
local Threads = getgenv().ChuppyHub_Threads

-- ================= CHARACTER LOAD =================
local function LoadChar()
	Char = LP.Character or LP.CharacterAdded:Wait()
	Hum = Char:WaitForChild("Humanoid")
	HRP = Char:WaitForChild("HumanoidRootPart")
end
LoadChar()

table.insert(Threads, LP.CharacterAdded:Connect(function(newChar)
	task.wait(0.5)
	LoadChar()
end))

-- ================= LOAD RAYFIELD UI =================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "CHUPPY HUB | Blox Fruits V6.3",
	LoadingTitle = "Chuppy Hub đang khởi động...",
	LoadingSubtitle = "by Blackz",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "ChuppyHubV63",
		FileName = "Config"
	},
	KeySystem = false,
})

-- ================= TABS =================
local MainTab = Window:CreateTab("Main Farm", "home")
local MiscTab = Window:CreateTab("Misc & Shop", "settings")

-- ================= SECTIONS & ELEMENTS =================
local FarmSec = MainTab:CreateSection("Auto Farm Core")

FarmSec:CreateToggle({
	Name = "Auto Farm",
	CurrentValue = false,
	Flag = "AutoFarmToggle",
	Callback = function(v)
		S.AutoFarm = v
	end,
})

FarmSec:CreateToggle({
	Name = "Mob Aura (Bring Mobs)",
	CurrentValue = false,
	Flag = "MobAuraToggle",
	Callback = function(v)
		S.MobAura = v
	end,
})

FarmSec:CreateToggle({
	Name = "Auto Skill (Z, X, C, V)",
	CurrentValue = false,
	Flag = "AutoSkillToggle",
	Callback = function(v)
		S.AutoSkill = v
	end,
})

FarmSec:CreateSlider({
	Name = "Farm Distance (Y-Axis)",
	Range = {2, 15},
	Increment = 1,
	CurrentValue = 4,
	Flag = "FarmDistSlider",
	Callback = function(v)
		S.FarmDistance = v
	end,
})

local ShopSec = MiscTab:CreateSection("Shop & Gacha")

ShopSec:CreateToggle({
	Name = "Auto Buy Buso Haki",
	CurrentValue = false,
	Flag = "AutoBuyHakiToggle",
	Callback = function(v)
		S.AutoBuyHaki = v
	end,
})

ShopSec:CreateToggle({
	Name = "Auto Enable Haki",
	CurrentValue = true,
	Flag = "AutoEnableHakiToggle",
	Callback = function(v)
		S.AutoEnableHaki = v
	end,
})

ShopSec:CreateToggle({
	Name = "Auto Random Fruit",
	CurrentValue = false,
	Flag = "AutoRandomFruitToggle",
	Callback = function(v)
		S.AutoRandomFruit = v
	end,
})

-- ================= CORE BYPASS: NOCLIP & ANTI-GRAVITY =================
local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
BodyVelocity.Velocity = Vector3.new(0, 0, 0)

table.insert(Threads, RunService.Stepped:Connect(function()
	pcall(function()
		if S.AutoFarm and Char and HRP then
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

-- ================= MULTI-SEA TARGET SELECTION =================
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

-- ================= TWEEN ENGINE =================
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

-- ================= AUTO FARM MOVEMENT =================
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

-- ================= REAL FAST ATTACK ENGINE (FIXED DAMAGE) =================
table.insert(Threads, task.spawn(function()
	while task.wait(0.02) do
		pcall(function()
			if not S.AutoFarm or not HRP or not Hum or Hum.Health <= 0 then return end
			
			local tool = Char:FindFirstChildOfClass("Tool") or LP.Backpack:FindFirstChildOfClass("Tool")
			if tool then
				if tool.Parent ~= Char then
					Hum:EquipTool(tool)
				end
				
				if tool.Parent == Char then
					tool:Activate()
					-- Gửi yêu cầu sát thương trực tiếp qua RegisterAttack nếu game hỗ trợ
					local remotes = ReplicatedStorage:FindFirstChild("Remotes")
					if remotes and remotes:FindFirstChild("RegisterAttack") then
						remotes.RegisterAttack:FireServer(0)
					end
				end
				
				VirtualUser:CaptureController()
				VirtualUser:Button1Down(Vector2.new(1e3, 1e3))
				VirtualUser:Button1Up(Vector2.new(1e3, 1e3))
			end
		end)
	end
end))

-- ================= MOB AURA / BRING MOBS (LOCKED TO PLAYER) =================
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
							if dist < 450 then
								-- Khóa chặt vị trí quái đè thẳng vào người chơi để chắc chắn nhận sát thương
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

-- ================= AUTO SKILL =================
table.insert(Threads, task.spawn(function()
	while task.wait(0.3) do
		pcall(function()
			if not S.AutoSkill then return end
			for _, k in ipairs({"Z", "X", "C", "V"}) do
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[k], false, game)
				task.wait(0.02)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[k], false, game)
				task.wait(0.05)
			end
		end)
	end
end))

-- ================= AUTO ENABLE HAKI =================
table.insert(Threads, task.spawn(function()
	while task.wait(5) do
		pcall(function()
			if S.AutoEnableHaki and Char then
				local commF = GetCommF()
				if commF then
					commF:InvokeServer("Buso")
				end
			end
		end)
	end
end))

-- ================= AUTO BUY HAKI =================
table.insert(Threads, task.spawn(function()
	while task.wait(10) do
		pcall(function()
			if S.AutoBuyHaki then
				local commF = GetCommF()
				if commF then
					commF:InvokeServer("BuyHaki", "Buso")
				end
			end
		end)
	end
end))

-- ================= AUTO RANDOM FRUIT =================
table.insert(Threads, task.spawn(function()
	while task.wait(15) do
		pcall(function()
			if S.AutoRandomFruit and HRP then
				local commF = GetCommF()
				if commF then
					commF:InvokeServer("Cousin", "Buy")
				end
			end
		end)
	end
end))

Rayfield:Notify({
	Title = "CHUPPY HUB V6.3",
	Content = "Đã fix cơ chế đánh quái mất máu thành công!",
	Duration = 5,
	Image = 4483362458,
})

