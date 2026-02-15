-- Ronixx Instant Steal | Stable Fixed Full Build (No Deletions Logic)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- SAFE CHARACTER FUNCTIONS (ORIGINAL STYLE PRESERVED)
local function getChar()
	local char = LocalPlayer.Character
	if not char then
		char = LocalPlayer.CharacterAdded:Wait()
	end
	return char
end

local function getHRP()
	return getChar():WaitForChild("HumanoidRootPart")
end

local function getHumanoid()
	return getChar():WaitForChild("Humanoid")
end

-- GUI ROOT (SAFE)
local gui = Instance.new("ScreenGui")
gui.Name = "RonixxInstantSteal"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- MAIN FRAME (MEDIUM SIZE - B)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 360)
main.Position = UDim2.new(0.5, -210, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(18,18,22)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 20)

-- GLOW STROKE (CLEAN)
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(120,140,255)
stroke.Transparency = 0.2
stroke.Parent = main

-- CLEAN MINIMAL BACKGROUND WAVES (FIXED NO BUG)
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundTransparency = 1
bg.ZIndex = 0
bg.Parent = main

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,35)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35,35,55)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20,20,30))
}
grad.Rotation = 0
grad.Parent = bg

RunService.RenderStepped:Connect(function()
	grad.Rotation = (grad.Rotation + 0.05) % 360
end)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "Ronixx Instant Steal"
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = main

-- CLOSE BUTTON (A STYLE)
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,40,0,40)
toggle.Position = UDim2.new(1,-45,0,5)
toggle.Text = "_"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 18
toggle.BackgroundColor3 = Color3.fromRGB(35,35,45)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Parent = main
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1,0)

local hidden = false
toggle.MouseButton1Click:Connect(function()
	hidden = not hidden
	if hidden then
		main:TweenSize(UDim2.new(0,420,0,45),"Out","Quad",0.25,true)
	else
		main:TweenSize(UDim2.new(0,420,0,360),"Out","Quad",0.25,true)
	end
end)

-- TAB BAR (FIXED NO OVERFLOW)
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,-10,0,40)
tabBar.Position = UDim2.new(0,5,0,50)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local function createTab(name, pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.5,-5,1,0)
	b.Position = pos
	b.Text = name
	b.Font = Enum.Font.GothamBold
	b.TextSize = 15
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(30,30,40)
	b.Parent = tabBar
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

local posesTab = createTab("Poses", UDim2.new(0,0,0,0))
local stealingTab = createTab("Stealing", UDim2.new(0.5,5,0,0))

-- PAGES (FIXED CLIPPING)
local posesPage = Instance.new("Frame")
posesPage.Size = UDim2.new(1,-10,1,-100)
posesPage.Position = UDim2.new(0,5,0,95)
posesPage.BackgroundTransparency = 1
posesPage.ClipsDescendants = true
posesPage.Parent = main

local stealingPage = posesPage:Clone()
stealingPage.Visible = false
stealingPage.Parent = main

-- POSES SYSTEM (NO CHECKMARKS, WORKING TP)
local poses = {}

local addPose = Instance.new("TextButton")
addPose.Size = UDim2.new(1,0,0,38)
addPose.Text = "Add Pose (0/5)"
addPose.Font = Enum.Font.GothamBold
addPose.TextColor3 = Color3.new(1,1,1)
addPose.BackgroundColor3 = Color3.fromRGB(40,40,50)
addPose.Parent = posesPage
Instance.new("UICorner", addPose).CornerRadius = UDim.new(0,12)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,0,1,-45)
scroll.Position = UDim2.new(0,0,0,45)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.Parent = posesPage

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,6)

local function refreshPoses()
	for _,v in pairs(scroll:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end

	for i,cf in ipairs(poses) do
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1,-5,0,36)
		frame.BackgroundColor3 = Color3.fromRGB(28,28,35)
		frame.Parent = scroll
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

		local tpBtn = Instance.new("TextButton")
		tpBtn.Size = UDim2.new(0.7,0,1,0)
		tpBtn.Text = "TP to Pose "..i
		tpBtn.Font = Enum.Font.GothamBold
		tpBtn.TextColor3 = Color3.new(1,1,1)
		tpBtn.BackgroundTransparency = 1
		tpBtn.Parent = frame

		local delBtn = Instance.new("TextButton")
		delBtn.Size = UDim2.new(0.3,-5,1,-6)
		delBtn.Position = UDim2.new(0.7,5,0,3)
		delBtn.Text = "Delete"
		delBtn.Font = Enum.Font.GothamBold
		delBtn.TextSize = 12
		delBtn.TextColor3 = Color3.new(1,1,1)
		delBtn.BackgroundColor3 = Color3.fromRGB(80,30,30)
		delBtn.Parent = frame
		Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0,8)

		tpBtn.MouseButton1Click:Connect(function()
			local hrp = getHRP()
			hrp.CFrame = cf
		end)

		delBtn.MouseButton1Click:Connect(function()
			table.remove(poses, i)
			addPose.Text = "Add Pose ("..#poses.."/5)"
			refreshPoses()
		end)
	end

	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end

addPose.MouseButton1Click:Connect(function()
	if #poses >= 5 then return end
	table.insert(poses, getHRP().CFrame)
	addPose.Text = "Add Pose ("..#poses.."/5)"
	refreshPoses()
end)

-- STEALING TAB (ALL BUTTONS RESTORED + NEW ONES)
local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(1,0,0,38)
autoBtn.Text = "Auto TP (1-3)"
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
autoBtn.Parent = stealingPage
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0,12)

local autoRunning = false
autoBtn.MouseButton1Click:Connect(function()
	if autoRunning then return end
	autoRunning = true
	task.spawn(function()
		for i = 1,3 do
			if poses[i] then
				getHRP().CFrame = poses[i]
				task.wait(0.4)
			end
		end
		autoRunning = false
	end)
end)

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(1,0,0,36)
speedBox.Position = UDim2.new(0,0,0,45)
speedBox.PlaceholderText = "Set Speed (number)"
speedBox.Text = ""
speedBox.Font = Enum.Font.Gotham
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.BackgroundColor3 = Color3.fromRGB(35,35,45)
speedBox.Parent = stealingPage
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,10)

speedBox.FocusLost:Connect(function()
	local num = tonumber(speedBox.Text)
	if num then
		getHumanoid().WalkSpeed = num
	end
end)

local gravityBox = speedBox:Clone()
gravityBox.Position = UDim2.new(0,0,0,90)
gravityBox.PlaceholderText = "Set Gravity"
gravityBox.Parent = stealingPage

gravityBox.FocusLost:Connect(function()
	local num = tonumber(gravityBox.Text)
	if num then
		workspace.Gravity = num
	end
end)

-- TP FORWARD
local tpForward = autoBtn:Clone()
tpForward.Position = UDim2.new(0,0,0,135)
tpForward.Text = "TP Forward"
tpForward.Parent = stealingPage

tpForward.MouseButton1Click:Connect(function()
	local hrp = getHRP()
	hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 12)
end)

-- RESET SPEED
local resetSpeed = autoBtn:Clone()
resetSpeed.Position = UDim2.new(0,0,0,180)
resetSpeed.Text = "Reset Speed (16)"
resetSpeed.Parent = stealingPage

resetSpeed.MouseButton1Click:Connect(function()
	getHumanoid().WalkSpeed = 16
end)

-- RESET GRAVITY
local resetGravity = autoBtn:Clone()
resetGravity.Position = UDim2.new(0,0,0,225)
resetGravity.Text = "Reset Gravity (196.2)"
resetGravity.Parent = stealingPage

resetGravity.MouseButton1Click:Connect(function()
	workspace.Gravity = 196.2
end)

-- TAB SWITCH (FIXED)
posesTab.MouseButton1Click:Connect(function()
	posesPage.Visible = true
	stealingPage.Visible = false
end)

stealingTab.MouseButton1Click:Connect(function()
	posesPage.Visible = false
	stealingPage.Visible = true
end)
-- ===== SAFE GUI FIX (DOES NOT DELETE ANYTHING) =====
task.spawn(function()
    local player = game:GetService("Players").LocalPlayer
    local guiName = "RonixxInstantSteal"

    -- ищем твой существующий GUI
    local gui = game:GetService("CoreGui"):FindFirstChild(guiName) 
        or player:WaitForChild("PlayerGui"):FindFirstChild(guiName)

    if gui then
        -- сначала полностью скрываем всё (чтобы кнопки не вылезали раньше)
        gui.Enabled = false

        for _, v in ipairs(gui:GetDescendants()) do
            if v:IsA("Frame") or v:IsA("TextButton") or v:IsA("TextLabel") then
                v.Visible = false
            end
        end

        -- ждём пока скрипт полностью создаст GUI
        task.wait(0.4)

        -- показываем GUI нормально
        gui.Enabled = true

        for _, v in ipairs(gui:GetDescendants()) do
            if v:IsA("Frame") or v:IsA("TextButton") or v:IsA("TextLabel") then
                v.Visible = true
            end
        end
    end
end)

-- ===== TP FORWARD BUTTON (AUTO ADD TO STEALING TAB, NO DELETES) =====
task.spawn(function()
    task.wait(0.6)

    local player = game:GetService("Players").LocalPlayer
    local gui = game:GetService("CoreGui"):FindFirstChild("RonixxInstantSteal") 
        or player:WaitForChild("PlayerGui"):FindFirstChild("RonixxInstantSteal")

    if not gui then return end

    -- ищем вкладку Stealing (НЕ ломая структуру)
    local stealingPage
    for _, v in ipairs(gui:GetDescendants()) do
        if v.Name:lower():find("steal") and v:IsA("Frame") then
            stealingPage = v
            break
        end
    end

    if not stealingPage then return end

    -- создаём кнопку Tp Forward (не заменяет старые кнопки)
    local tpForward = Instance.new("TextButton")
    tpForward.Name = "TpForward"
    tpForward.Size = UDim2.new(1, -10, 0, 35)
    tpForward.Position = UDim2.new(0, 5, 0, 270)
    tpForward.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tpForward.Text = "Tp Forward"
    tpForward.TextColor3 = Color3.fromRGB(255,255,255)
    tpForward.Font = Enum.Font.GothamBold
    tpForward.TextSize = 14
    tpForward.BorderSizePixel = 0
    tpForward.Parent = stealingPage

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = tpForward

    -- функция телепорта вперёд (не трогает твои позы и авто тп)
    tpForward.MouseButton1Click:Connect(function()
        local char = player.Character
        if not char then return end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 20)
    end)
end)
