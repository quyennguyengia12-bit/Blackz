local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera
local Char, HRP, Hum
local CORRECT_KEY = "123456789e"
local KeyVerified = false
local MenuLoaded = false
local CONFIG = {
FlySpeed = 80,
WalkSpeed = 25,
StealDelay = 0.8,
HatchDelay = 1.5,
SellInterval = 8,
UpgradeInterval = 10,
TreadmillInterval = 20,
ClaimInterval = 15,
RebirthInterval = 120,
AFKInterval = 60,
MinValueToSteal = 0,
AutoTP = true,
}
local State = {
AutoSteal = false,
AutoHatch = false,
AutoSell = false,
AutoUpgrade = false,
AutoTreadmill = false,
AutoClaim = false,
AutoPlace = false,
AutoRebirth = false,
AutoFarmZone = false,
SpeedBypass = false,
WalkWater = false,
RareHunter = false,
MutationPriority = false,
AutoFuse = false,
AutoEquipBest = false,
Fly = false,
Godmode = false,
Noclip = false,
InfiniteJump = false,
ESPEnabled = false,
AntiAFK = false,
Fullbright = false,
}
local function GetChar()
Char = LP.Character or LP.CharacterAdded:Wait()
HRP = Char:FindFirstChild("HumanoidRootPart")
Hum = Char:FindFirstChild("Humanoid")
end
GetChar()
LP.CharacterAdded:Connect(function() task.wait(1); GetChar() end)
local function CreateSafeScreenGui(name)
local gui = Instance.new("ScreenGui")
gui.Name = name
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = PlayerGui end
return gui
end
local FlyBodyVelocity = nil
local FlyUpInput, FlyDownInput = false, false
local function createFly()
if not HRP then return end
if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
FlyBodyVelocity = Instance.new("BodyVelocity")
FlyBodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
FlyBodyVelocity.P = 1e5
FlyBodyVelocity.Parent = HRP
end
local function destroyFly()
if FlyBodyVelocity then
FlyBodyVelocity:Destroy()
FlyBodyVelocity = nil
end
end
local function updateFly()
if not State.Fly then
destroyFly()
if Hum then Hum.PlatformStand = false; Hum.AutoRotate = true end
return
end
if not HRP then return end
if not FlyBodyVelocity then createFly() end
if not Hum then return end
Hum.PlatformStand = true
Hum.AutoRotate = false
local moveDir = Hum.MoveDirection
local vertical = (FlyUpInput and 1 or 0) - (FlyDownInput and 1 or 0)
local direction = Vector3.new(moveDir.X, vertical, moveDir.Z)
if direction.Magnitude > 0 then
direction = direction.Unit * CONFIG.FlySpeed
else
direction = Vector3.zero
end
FlyBodyVelocity.Velocity = direction
end
RunService.Heartbeat:Connect(function()
if State.Fly then updateFly() end
end)
local function updateWalkSpeed()
if Hum then
if State.SpeedBypass then
Hum.WalkSpeed = 100
else
Hum.WalkSpeed = CONFIG.WalkSpeed
end
end
end
RunService.Heartbeat:Connect(updateWalkSpeed)
local FlyControlsGui = nil
local function CreateFlyControls()
if FlyControlsGui then return end
FlyControlsGui = CreateSafeScreenGui("SE_Fly")
FlyControlsGui.Enabled = false
local function makeBtn(text, posY)
local btn = Instance.new("TextButton", FlyControlsGui)
btn.Size = UDim2.new(0, 40, 0, 40)
btn.Position = UDim2.new(1, -50, posY, 0)
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
btn.BackgroundTransparency = 0.3
btn.Text = text
btn.TextColor3 = Color3.fromRGB(0, 255, 150)
btn.TextSize = 20
btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 255, 150)
return btn
end
local UpBtn = makeBtn("⬆", 0.6)
local DownBtn = makeBtn("⬇", 0.75)
UpBtn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then FlyUpInput = true end
end)
UpBtn.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then FlyUpInput = false end
end)
DownBtn.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then FlyDownInput = true end
end)
DownBtn.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then FlyDownInput = false end
end)
RunService.Heartbeat:Connect(function()
if FlyControlsGui then FlyControlsGui.Enabled = State.Fly end
end)
end
local function CreateMainMenu()
if not KeyVerified or MenuLoaded then return end
MenuLoaded = true
local ScreenGui = CreateSafeScreenGui("SE_Menu")
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 120)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.BackgroundTransparency = 0.2
ToggleBtn.Text = "🥚"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.TextSize = 20
ToggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(0, 255, 150)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)
MainFrame.ClipsDescendants = true
local dragging = false; local dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true; dragStart = input.Position; startPos = MainFrame.Position
end
end)
MainFrame.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - dragStart
MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)
ToggleBtn.Activated:Connect(function()
MainFrame.Visible = not MainFrame.Visible
if MainFrame.Visible then MainFrame:TweenSize(UDim2.new(0, 260, 0, 380), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
else MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true) end
end)
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 30); TitleBar.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0.7, 0, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = "🥚 SE ULTIMATE v8.3"
Title.TextColor3 = Color3.fromRGB(0, 255, 150); Title.TextSize = 13; Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 22, 0, 22); CloseBtn.Position = UDim2.new(1, -26, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); CloseBtn.BackgroundTransparency = 0.5
CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 12; CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0; Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)
CloseBtn.Activated:Connect(function() MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true); MainFrame.Visible = false end)
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 28); TabBar.Position = UDim2.new(0, 0, 0, 30)
TabBar.BackgroundTransparency = 1
local tabs = {"⚡Auto", "🚀Move", "🛡️Misc"}
local currentTab = 1
local Content = Instance.new("ScrollingFrame", MainFrame)
Content.Size = UDim2.new(1, -8, 1, -66); Content.Position = UDim2.new(0, 4, 0, 62)
Content.BackgroundTransparency = 1; Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
local ContentList = Instance.new("UIListLayout", Content)
ContentList.SortOrder = Enum.SortOrder.LayoutOrder; ContentList.Padding = UDim.new(0, 3)
local function MakeToggle(text, getter, setter)
local frame = Instance.new("TextButton", Content)
frame.Size = UDim2.new(1, 0, 0, 26); frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.BackgroundTransparency = 0.3; frame.BorderSizePixel = 0; frame.Text = ""
frame.AutoButtonColor = false; Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(0.7, 0, 1, 0); label.Position = UDim2.new(0, 8, 0, 0)
label.BackgroundTransparency = 1; label.Text = text; label.TextColor3 = Color3.fromRGB(235,235,235)
label.TextSize = 11; label.Font = Enum.Font.GothamMedium; label.TextXAlignment = Enum.TextXAlignment.Left
local switchBg = Instance.new("Frame", frame)
switchBg.Size = UDim2.new(0, 22, 0, 12); switchBg.Position = UDim2.new(1, -26, 0.5, -6)
switchBg.BackgroundColor3 = Color3.fromRGB(40,40,50); switchBg.BorderSizePixel = 0
Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
local dot = Instance.new("Frame", switchBg)
dot.Size = UDim2.new(0, 8, 0, 8); dot.Position = UDim2.new(0, 2, 0.5, -4)
dot.BackgroundColor3 = Color3.fromRGB(100,100,100); dot.BorderSizePixel = 0
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
local state = getter()
local function updateSwitch()
dot.Position = state and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
dot.BackgroundColor3 = state and Color3.fromRGB(0,255,150) or Color3.fromRGB(100,100,100)
switchBg.BackgroundColor3 = state and Color3.fromRGB(0,80,50) or Color3.fromRGB(40,40,50)
end
updateSwitch()
frame.Activated:Connect(function() state = not state; setter(state); updateSwitch() end)
return frame
end
local function MakeSlider(text, min, max, default, callback)
local frame = Instance.new("Frame", Content)
frame.Size = UDim2.new(1, 0, 0, 36); frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.BackgroundTransparency = 0.3; frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, -10, 0, 14); label.Position = UDim2.new(0, 8, 0, 2)
label.BackgroundTransparency = 1; label.Text = text .. ": " .. default
label.TextColor3 = Color3.fromRGB(235,235,235); label.TextSize = 10
label.Font = Enum.Font.GothamMedium; label.TextXAlignment = Enum.TextXAlignment.Left
local bg = Instance.new("Frame", frame)
bg.Size = UDim2.new(1, -16, 0, 5); bg.Position = UDim2.new(0, 8, 0, 22)
bg.BackgroundColor3 = Color3.fromRGB(15,15,20); bg.BorderSizePixel = 0
Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
local fill = Instance.new("Frame", bg)
local defaultRel = (default - min) / (max - min)
fill.Size = UDim2.new(defaultRel, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0,255,150)
fill.BorderSizePixel = 0; Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
local thumb = Instance.new("Frame", bg)
thumb.Size = UDim2.new(0, 10, 0, 10); thumb.Position = UDim2.new(defaultRel, -5, 0.5, -5)
thumb.BackgroundColor3 = Color3.fromRGB(255,255,255); thumb.BorderSizePixel = 0
Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)
local dragging = false
local function updateSlider(x)
local bgAbsSize = bg.AbsoluteSize.X
if bgAbsSize <= 0 then return end
local relX = math.clamp((x - bg.AbsolutePosition.X) / bgAbsSize, 0, 1)
local val = math.floor(min + (max - min) * relX)
fill.Size = UDim2.new(relX, 0, 1, 0); thumb.Position = UDim2.new(relX, -5, 0.5, -5)
label.Text = text .. ": " .. val; callback(val)
end
thumb.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
bg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; updateSlider(input.Position.X) end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input.Position.X) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
return frame
end
local function clearContent()
for _, child in ipairs(Content:GetChildren()) do
if child:IsA("Frame") or child:IsA("TextButton") then
child:Destroy()
end
end
end
local function buildTab1()
clearContent()
MakeToggle("🥚 Auto Steal", function() return State.AutoSteal end, function(v) State.AutoSteal = v end)
MakeToggle("🐣 Auto Hatch", function() return State.AutoHatch end, function(v) State.AutoHatch = v end)
MakeToggle("💰 Auto Sell", function() return State.AutoSell end, function(v) State.AutoSell = v end)
MakeToggle("⬆️ Auto Upgrade", function() return State.AutoUpgrade end, function(v) State.AutoUpgrade = v end)
MakeToggle("🏃 Auto Treadmill", function() return State.AutoTreadmill end, function(v) State.AutoTreadmill = v end)
MakeToggle("🎁 Auto Claim", function() return State.AutoClaim end, function(v) State.AutoClaim = v end)
MakeToggle("📦 Auto Place", function() return State.AutoPlace end, function(v) State.AutoPlace = v end)
MakeToggle("🔄 Auto Rebirth", function() return State.AutoRebirth end, function(v) State.AutoRebirth = v end)
MakeToggle("🏔️ Auto Farm Zone", function() return State.AutoFarmZone end, function(v) State.AutoFarmZone = v end)
MakeSlider("⏱️ Steal Delay", 0.3, 5, CONFIG.StealDelay, function(v) CONFIG.StealDelay = v end)
updateCanvas()
end
local function buildTab2()
clearContent()
MakeToggle("🚀 FLY (Bật để bay)", function() return State.Fly end, function(v)
State.Fly = v
if v then
CreateFlyControls()
createFly()
print("🛫 Fly ON! Dùng WASD + ⬆️⬇️")
else
destroyFly()
if Hum then Hum.PlatformStand = false; Hum.AutoRotate = true end
print("🛬 Fly OFF!")
end
end)
MakeSlider("✈️ Fly Speed", 20, 400, CONFIG.FlySpeed, function(v)
CONFIG.FlySpeed = v
end)
MakeSlider("🏃 Walk Speed", 16, 300, CONFIG.WalkSpeed, function(v)
CONFIG.WalkSpeed = v
updateWalkSpeed()
print("🚶 Walk Speed = " .. v)
end)
MakeToggle("🦘 Infinite Jump", function() return State.InfiniteJump end, function(v) State.InfiniteJump = v end)
MakeToggle("👻 Noclip", function() return State.Noclip end, function(v) State.Noclip = v end)
MakeToggle("⚡ Speed Bypass", function() return State.SpeedBypass end, function(v)
State.SpeedBypass = v
updateWalkSpeed()
end)
MakeToggle("🌊 Walk on Water", function() return State.WalkWater end, function(v) State.WalkWater = v end)
MakeToggle("⏳ Anti AFK", function() return State.AntiAFK end, function(v) State.AntiAFK = v end)
updateCanvas()
end
local function buildTab3()
clearContent()
MakeToggle("🛡️ God Mode", function() return State.Godmode end, function(v) State.Godmode = v end)
MakeToggle("👁️ ESP", function() return State.ESPEnabled end, function(v) State.ESPEnabled = v end)
MakeToggle("🔦 Fullbright", function() return State.Fullbright end, function(v)
State.Fullbright = v
pcall(function() Lighting.Brightness = v and 2 or 1; Lighting.GlobalShadows = not v end)
end)
MakeToggle("⭐ Rare Hunter", function() return State.RareHunter end, function(v) State.RareHunter = v end)
MakeToggle("🧬 Mutation Priority", function() return State.MutationPriority end, function(v) State.MutationPriority = v end)
MakeToggle("🔮 Auto Fuse", function() return State.AutoFuse end, function(v) State.AutoFuse = v end)
MakeToggle("⚔️ Auto Equip Best", function() return State.AutoEquipBest end, function(v) State.AutoEquipBest = v end)
MakeToggle("🔄 Auto TP", function() return CONFIG.AutoTP end, function(v) CONFIG.AutoTP = v end)
updateCanvas()
end
local function updateContent()
if currentTab == 1 then buildTab1()
elseif currentTab == 2 then buildTab2()
elseif currentTab == 3 then buildTab3() end
end
local tabBtns = {}
for i, name in ipairs(tabs) do
local btn = Instance.new("TextButton", TabBar)
btn.Size = UDim2.new(1/3, 0, 1, 0); btn.Position = UDim2.new((i-1)/3, 0, 0, 0)
btn.BackgroundColor3 = i==1 and Color3.fromRGB(0,50,30) or Color3.fromRGB(20,20,25)
btn.BackgroundTransparency = 0.3
btn.Text = name; btn.TextColor3 = i==1 and Color3.fromRGB(0,255,150) or Color3.fromRGB(180,180,180)
btn.TextSize = 10; btn.Font = Enum.Font.GothamBold
btn.BorderSizePixel = 0; btn.AutoButtonColor = false
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
btn.Activated:Connect(function()
currentTab = i
for j, b in ipairs(tabBtns) do
b.BackgroundColor3 = j==i and Color3.fromRGB(0,50,30) or Color3.fromRGB(20,20,25)
b.TextColor3 = j==i and Color3.fromRGB(0,255,150) or Color3.fromRGB(180,180,180)
end
updateContent()
end)
tabBtns[i] = btn
end
local function updateCanvas()
local count = 0
for _, child in ipairs(Content:GetChildren()) do
if child:IsA("Frame") or child:IsA("TextButton") then
count = count + 1
end
end
Content.CanvasSize = UDim2.new(0, 0, 0, count * 29 + 10)
end
updateContent()
print("✅ SE ULTIMATE v8.3 loaded! Tab Move + Misc đã sửa.")
end
local function CreateKeyGUI()
local ScreenGui = CreateSafeScreenGui("SE_Key")
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 120)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 150)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 28); Title.BackgroundTransparency = 1
Title.Text = "🔑 SE ULTIMATE v8.3"; Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.TextSize = 14; Title.Font = Enum.Font.GothamBold
local KeyBox = Instance.new("TextBox", MainFrame)
KeyBox.Size = UDim2.new(0.8, 0, 0, 28); KeyBox.Position = UDim2.new(0.1, 0, 0, 36)
KeyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35); KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.TextSize = 12; KeyBox.Font = Enum.Font.GothamMedium
KeyBox.PlaceholderText = "Nhập Key..."; KeyBox.ClearTextOnFocus = false
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)
local SubmitBtn = Instance.new("TextButton", MainFrame)
SubmitBtn.Size = UDim2.new(0.35, 0, 0, 28); SubmitBtn.Position = UDim2.new(0.325, 0, 0, 78)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150); SubmitBtn.Text = "OK"
SubmitBtn.TextColor3 = Color3.fromRGB(10, 10, 15); SubmitBtn.TextSize = 12
SubmitBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)
local ErrorLabel = Instance.new("TextLabel", MainFrame)
ErrorLabel.Size = UDim2.new(1, 0, 0, 18); ErrorLabel.Position = UDim2.new(0, 0, 0, 108)
ErrorLabel.BackgroundTransparency = 1; ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(255, 50, 50); ErrorLabel.TextSize = 10
ErrorLabel.Font = Enum.Font.GothamMedium
local function submitKey()
if KeyBox.Text == CORRECT_KEY then
KeyVerified = true; ScreenGui:Destroy(); CreateMainMenu()
else
ErrorLabel.Text = "❌ Sai Key! Nhập: " .. CORRECT_KEY
KeyBox.Text = ""; KeyBox:CaptureFocus()
end
end
SubmitBtn.Activated:Connect(submitKey)
KeyBox.FocusLost:Connect(function(enter) if enter then submitKey() end end)
end
task.wait(1.5)
CreateKeyGUI()
print("🔑 SE ULTIMATE v8.3 | Key: 123456789e")
print("📌 Hướng dẫn: Nhấn 🥚 -> tab 🚀Move -> Bật Fly + kéo Walk Speed")
