--// =====================================================
--// BLACKZ UI LIBRARY
--// Clean • Minimal • Stable
--// Creator: Nguyễn Quang Anh
--// =====================================================

local BlackzLib = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- THEME
local Theme = {
	Background = Color3.fromRGB(15,15,15),
	Secondary = Color3.fromRGB(25,25,25),
	Accent = Color3.fromRGB(120,0,180),
	Text = Color3.fromRGB(255,255,255)
}

-- UTILS
local function Create(inst, props)
	local obj = Instance.new(inst)
	for i,v in pairs(props) do obj[i] = v end
	return obj
end

-- WINDOW
function BlackzLib:MakeWindow(cfg)
	local ScreenGui = Create("ScreenGui", {
		Name = "BlackzHub",
		ResetOnSpawn = false,
		Parent = LP:WaitForChild("PlayerGui")
	})

	local Main = Create("Frame", {
		Parent = ScreenGui,
		BackgroundColor3 = Theme.Background,
		Size = UDim2.fromScale(0.45,0.55),
		Position = UDim2.fromScale(0.275,0.22)
	})
	Create("UICorner",{CornerRadius=UDim.new(0,14),Parent=Main})

	local Title = Create("TextLabel",{
		Parent = Main,
		Text = cfg.Title or "BLACKZ HUB",
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 20,
		BackgroundTransparency = 1,
		Size = UDim2.new(1,0,0,40)
	})

	local Sub = Create("TextLabel",{
		Parent = Main,
		Text = cfg.SubTitle or "BLACKZ STYLE",
		TextColor3 = Theme.Accent,
		Font = Enum.Font.Gotham,
		TextSize = 13,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0,32),
		Size = UDim2.new(1,0,0,25)
	})

	local Tabs = Create("Frame",{
		Parent = Main,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10,65),
		Size = UDim2.new(1,-20,1,-75)
	})

	local UIList = Create("UIListLayout",{
		Parent = Tabs,
		Padding = UDim.new(0,10)
	})

	local Window = {}

	-- TAB
	function Window:AddTab(name,icon)
		local Tab = Create("Frame",{
			Parent = Tabs,
			BackgroundColor3 = Theme.Secondary,
			Size = UDim2.new(1,0,0,200)
		})
		Create("UICorner",{CornerRadius=UDim.new(0,12),Parent=Tab})

		local T = Create("TextLabel",{
			Parent = Tab,
			Text = name,
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 16,
			BackgroundTransparency = 1,
			Size = UDim2.new(1,0,0,35)
		})

		local Holder = Create("Frame",{
			Parent = Tab,
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(10,40),
			Size = UDim2.new(1,-20,1,-45)
		})

		local List = Create("UIListLayout",{
			Parent = Holder,
			Padding = UDim.new(0,8)
		})

		local TabFunc = {}

		-- SECTION
		function TabFunc:AddSection(text)
			local Section = {}

			local L = Create("TextLabel",{
				Parent = Holder,
				Text = text,
				TextColor3 = Theme.Accent,
				Font = Enum.Font.GothamBold,
				TextSize = 14,
				BackgroundTransparency = 1,
				Size = UDim2.new(1,0,0,20)
			})

			-- TOGGLE
			function Section:AddToggle(cfg)
				local Tgl = Create("TextButton",{
					Parent = Holder,
					Text = cfg.Name,
					TextColor3 = Theme.Text,
					Font = Enum.Font.Gotham,
					TextSize = 14,
					BackgroundColor3 = Theme.Background,
					Size = UDim2.new(1,0,0,32)
				})
				Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=Tgl})

				local state = cfg.Default or false
				Tgl.MouseButton1Click:Connect(function()
					state = not state
					Tgl.BackgroundColor3 = state and Theme.Accent or Theme.Background
					pcall(cfg.Callback,state)
				end)
			end

			-- SLIDER
			function Section:AddSlider(cfg)
				local Sld = Create("TextLabel",{
					Parent = Holder,
					Text = cfg.Name.." : "..cfg.Default,
					TextColor3 = Theme.Text,
					Font = Enum.Font.Gotham,
					TextSize = 14,
					BackgroundColor3 = Theme.Background,
					Size = UDim2.new(1,0,0,32)
				})
				Create("UICorner",{CornerRadius=UDim.new(0,8),Parent=Sld})
				pcall(cfg.Callback,cfg.Default)
			end

			return Section
		end

		return TabFunc
	end

	-- NOTIFY
	function Window:Notify(cfg)
		warn("[BLACKZ HUB]",cfg.Title,cfg.Content)
	end

	return Window
end

return BlackzLib
