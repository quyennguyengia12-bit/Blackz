-- BLACKZ HUB | REDZ LOADER
-- Mobile + PC
-- By Nguyễn Quang Anh 😎

local UI = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/quyennguyengia12-bit/Blackz/main/BlackzUILib.lua"
))()

local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local Win = UI:Window({
	Title = "BLACKZ HUB",
})

local loadedRedz = false

-- ===== TAB EXTERNAL =====
local Ext = Win:Tab("External")

Ext:Toggle({
	Name = "Load RedzHub (Official)",
	Default = false,
	Callback = function(v)
		if v and not loadedRedz then
			loadedRedz = true

			pcall(function()
				loadstring(game:HttpGet(
					"https://raw.githubusercontent.com/luacoder-byte/luacoder/refs/heads/main/RedzHub.lua"
				))()
			end)

			-- Ẩn Blackz UI cho gọn màn hình
			for _,gui in pairs(LP.PlayerGui:GetChildren()) do
				if gui.Name == "BlackzHub" then
					gui.Enabled = false
				end
			end
		end
	end
})
