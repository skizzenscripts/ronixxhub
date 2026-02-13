--// RONIXX HUB V3 (Animated + Checkmarks) //
-- Best script by Ronixx & Skizzen & Chat GPT 🔥

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local savedPos = nil
local speed = 16
local noclip = false
local infJump = false
local xray = false
local antiRagdoll = false

-- CLICK SOUND
local function click()
	local s = Instance.new("Sound", workspace)
	s.SoundId = "rbxassetid://12221967"
	s.Volume = 1
	s:Play()
	game.Debris:AddItem(s,1)
end

-- BLUR
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "RonixxHub"

-- OPEN BUTTON (DRAGGABLE + ANIM)
local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0,150,0,50)
open.Position = UDim2.new(0.1,0,0.5,0)
open.Text = "Ronixx Hub"
open.BackgroundColor3 = Color3.fromRGB(20,20,20)
open.TextColor3 = Color3.new(1,1,1)
open.Font = Enum.Font.GothamBold
open.TextSize = 18
open.Active = true
open.Draggable = true
Instance.new("UICorner", open).CornerRadius = UDim.new(1,0)

-- Hover Animation
open.MouseEnter:Connect(function()
	TweenService:Create(open,TweenInfo.new(0.15),{Size = UDim2.new(0,165,0,55)}):Play()
end)
open.MouseLeave:Connect(function()
	TweenService:Create(open,TweenInfo.new(0.15),{Size = UDim2.new(0,150,0,50)}):Play()
end)

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,520,0,360)
frame.Position = UDim2.new(0.5,-260,0.5,-180)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.Visible = false
frame.BackgroundTransparency = 1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

-- Fade In Animation
local function showFrame()
	frame.Visible = true
	TweenService:Create(frame,TweenInfo.new(0.25),{BackgroundTransparency = 0}):Play()
	TweenService:Create(blur,TweenInfo.new(0.25),{Size = 18}):Play()
end

local function hideFrame()
	TweenService:Create(frame,TweenInfo.new(0.25),{BackgroundTransparency = 1}):Play()
	TweenService:Create(blur,TweenInfo.new(0.25),{Size = 0}):Play()
	task.wait(0.25)
	frame.Visible = false
end

-- CLOSE BUTTON
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,40,0,40)
close.Position = UDim2.new(1,-45,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(70,0,0)
close.TextColor3 = Color3.new(1,1,1)
close.Font = Enum.Font.GothamBold
Instance.new("UICorner", close).CornerRadius = UDim.new(1,0)

-- TABS
local mainTabBtn = Instance.new("TextButton", frame)
mainTabBtn.Size = UDim2.new(0,120,0,30)
mainTabBtn.Position = UDim2.new(0,10,0,5)
mainTabBtn.Text = "Main"
mainTabBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainTabBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", mainTabBtn)

local creditsBtn = mainTabBtn:Clone()
creditsBtn.Parent = frame
creditsBtn.Position = UDim2.new(0,140,0,5)
creditsBtn.Text = "Credits"

-- SCROLLING MAIN TAB
local mainTab = Instance.new("ScrollingFrame", frame)
mainTab.Size = UDim2.new(1,-20,1,-50)
mainTab.Position = UDim2.new(0,10,0,45)
mainTab.CanvasSize = UDim2.new(0,0,0,800)
mainTab.ScrollBarThickness = 6
mainTab.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", mainTab)
layout.Padding = UDim.new(0,10)

-- CREDITS TAB (FADE ANIM)
local creditsTab = Instance.new("Frame", frame)
creditsTab.Size = mainTab.Size
creditsTab.Position = mainTab.Position
creditsTab.Visible = false
creditsTab.BackgroundTransparency = 1

local creditText = Instance.new("TextLabel", creditsTab)
creditText.Size = UDim2.new(1,0,1,0)
creditText.Text = "🔥 Best script by Ronixx & Skizzen 🔥"
creditText.TextScaled = true
creditText.Font = Enum.Font.GothamBold
creditText.TextColor3 = Color3.new(1,1,1)
creditText.BackgroundTransparency = 1

-- ANIMATED BUTTON CREATOR WITH CHECKMARK
local function toggleButton(name, stateVar, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,45)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.Parent = mainTab
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)

	local function updateText()
		b.Text = name .. (stateVar() and "  ✅" or "  ❌")
	end
	updateText()

	-- Hover Anim
	b.MouseEnter:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b,TweenInfo.new(0.12),{BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
	end)

	b.MouseButton1Click:Connect(function()
		click()
		callback()
		updateText()
		TweenService:Create(b,TweenInfo.new(0.1),{Size = UDim2.new(1,-5,0,48)}):Play()
		task.wait(0.05)
		TweenService:Create(b,TweenInfo.new(0.1),{Size = UDim2.new(1,-10,0,45)}):Play()
	end)
end

-- NORMAL BUTTON (with animation)
local function actionButton(name, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-10,0,45)
	b.Text = name
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.Parent = mainTab
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)

	b.MouseButton1Click:Connect(function()
		click()
		callback()
		TweenService:Create(b,TweenInfo.new(0.1),{Rotation = 2}):Play()
		task.wait(0.05)
		TweenService:Create(b,TweenInfo.new(0.1),{Rotation = 0}):Play()
	end)
end

-- ACTION FEATURES
actionButton("Save Position", function()
	if player.Character then
		savedPos = player.Character.HumanoidRootPart.CFrame
	end
end)

actionButton("TP to Position", function()
	if savedPos and player.Character then
		player.Character.HumanoidRootPart.CFrame = savedPos
	end
end)

actionButton("Increase Speed", function()
	speed += 5
	player.Character.Humanoid.WalkSpeed = speed
end)

actionButton("Decrease Speed", function()
	speed -= 5
	player.Character.Humanoid.WalkSpeed = speed
end)

-- TOGGLE FEATURES WITH ✅
toggleButton("Infinite Jump", function() return infJump end, function()
	infJump = not infJump
end)

toggleButton("Noclip", function() return noclip end, function()
	noclip = not noclip
end)

toggleButton("Anti Ragdoll", function() return antiRagdoll end, function()
	antiRagdoll = not antiRagdoll
end)

toggleButton("X-Ray Vision", function() return xray end, function()
	xray = not xray
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsDescendantOf(player.Character) then
			v.LocalTransparencyModifier = xray and 0.6 or 0
		end
	end
end)

-- LOOPS
UIS.JumpRequest:Connect(function()
	if infJump and player.Character then
		player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

RunService.Stepped:Connect(function()
	if player.Character then
		if noclip then
			for _,v in pairs(player.Character:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
		if antiRagdoll then
			local hum = player.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum:GetState() == Enum.HumanoidStateType.Ragdoll then
				hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end
	end
end)

-- OPEN / CLOSE
open.MouseButton1Click:Connect(function()
	click()
	showFrame()
end)

close.MouseButton1Click:Connect(function()
	click()
	hideFrame()
end)

-- TAB ANIMATION
mainTabBtn.MouseButton1Click:Connect(function()
	click()
	mainTab.Visible = true
	creditsTab.Visible = false
end)

creditsBtn.MouseButton1Click:Connect(function()
	click()
	mainTab.Visible = false
	creditsTab.Visible = true
end)
