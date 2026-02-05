--// BLACKZ UI LIB - REDZ STYLE (SIMPLE & STABLE)

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local BlackzLib = {}

function BlackzLib:MakeWindow(cfg)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BlackzUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.fromScale(0.45, 0.55)
    Main.Position = UDim2.fromScale(0.275, 0.2)
    Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1,0,0,40)
    Title.Text = cfg.Title or "BLACKZ HUB"
    Title.TextColor3 = Color3.fromRGB(255,0,0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.new(0,120,1,-40)
    Tabs.Position = UDim2.new(0,0,0,40)
    Tabs.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Tabs.BorderSizePixel = 0

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.new(1,-120,1,-40)
    Pages.Position = UDim2.new(0,120,0,40)
    Pages.BackgroundTransparency = 1

    Instance.new("UIListLayout", Tabs).Padding = UDim.new(0,6)

    local Window = {}

    function Window:AddTab(name)
        local Btn = Instance.new("TextButton", Tabs)
        Btn.Size = UDim2.new(1,-10,0,36)
        Btn.Text = name
        Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        Btn.TextColor3 = Color3.new(1,1,1)
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.fromScale(1,1)
        Page.CanvasSize = UDim2.new(0,0,0,0)
        Page.ScrollBarImageTransparency = 1
        Page.Visible = false

        local List = Instance.new("UIListLayout", Page)
        List.Padding = UDim.new(0,6)
        List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.new(0,0,0,List.AbsoluteContentSize.Y + 10)
        end)

        Btn.MouseButton1Click:Connect(function()
            for _,v in pairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            Page.Visible = true
        end)

        local Tab = {}

        function Tab:AddSection(title)
            local Section = Instance.new("Frame", Page)
            Section.Size = UDim2.new(1,-10,0,35)
            Section.BackgroundColor3 = Color3.fromRGB(30,30,30)
            Instance.new("UICorner", Section).CornerRadius = UDim.new(0,10)

            local Label = Instance.new("TextLabel", Section)
            Label.Size = UDim2.new(1,0,0,30)
            Label.Text = title
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255,0,0)
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 14

            local Y = 30
            local API = {}

            function API:AddToggle(opt)
                local B = Instance.new("TextButton", Section)
                B.Size = UDim2.new(1,-10,0,30)
                B.Position = UDim2.new(0,5,0,Y)
                B.BackgroundColor3 = Color3.fromRGB(40,40,40)
                B.TextColor3 = Color3.new(1,1,1)
                B.Font = Enum.Font.Gotham
                B.TextSize = 13

                local state = opt.Default or false
                B.Text = opt.Name .. (state and " : ON" or " : OFF")

                B.MouseButton1Click:Connect(function()
                    state = not state
                    B.Text = opt.Name .. (state and " : ON" or " : OFF")
                    pcall(opt.Callback, state)
                end)

                Y += 35
                Section.Size = UDim2.new(1,-10,0,Y)
            end

            function API:AddSlider(opt)
                local Box = Instance.new("TextBox", Section)
                Box.Size = UDim2.new(1,-10,0,30)
                Box.Position = UDim2.new(0,5,0,Y)
                Box.BackgroundColor3 = Color3.fromRGB(40,40,40)
                Box.TextColor3 = Color3.new(1,1,1)
                Box.Font = Enum.Font.Gotham
                Box.TextSize = 13
                Box.Text = opt.Name .. ": " .. opt.Default

                Box.FocusLost:Connect(function()
                    local v = tonumber(Box.Text:match("%d+"))
                    if v then
                        v = math.clamp(v, opt.Min, opt.Max)
                        Box.Text = opt.Name .. ": " .. v
                        pcall(opt.Callback, v)
                    end
                end)

                Y += 35
                Section.Size = UDim2.new(1,-10,0,Y)
            end

            return API
        end

        Page.Visible = true
        return Tab
    end

    return Window
end

return BlackzLib
