--========================================================--
--                    PANEL CNP
--                  STUDIO EDITION
--========================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local PASSWORD = "sam2027"
local ALLOWED_USERS = {7762231858, 1937297119, 9297922648}
local ALLOWED_NAMES = {"Jerehzxs", "cloudd7qo", "jerxhshy"}

local IS_PC = UserInputService.KeyboardEnabled and UserInputService.MouseEnabled
local minimizeKey = Enum.KeyCode.M

local BLUE = Color3.fromRGB(0,122,255)
local WHITE = Color3.fromRGB(255,255,255)
local GRAY = Color3.fromRGB(165,165,170)
local DARK = Color3.fromRGB(15,15,15)

local PANEL_FONT = Enum.Font.Arcade

-- Verificar si el usuario está permitido
local isAllowed = false
for _, userId in ipairs(ALLOWED_USERS) do
	if Player.UserId == userId then
		isAllowed = true
		break
	end
end

if not isAllowed then
	local playerNameLower = Player.Name:lower()
	for _, userName in ipairs(ALLOWED_NAMES) do
		if playerNameLower == userName:lower() then
			isAllowed = true
			break
		end
	end
end

if not isAllowed and Player.Name:lower():find("jereh") then
	isAllowed = true
end

-- Limpiar versiones anteriores
for _, name in ipairs({"PanelCnpUI","PanelCnpLogin","PanelCnpDenied"}) do
	local old = PlayerGui:FindFirstChild(name)
	if old then old:Destroy() end
end

local T = {
	HOME = "HOME",
	SETTINGS = "SETTINGS",
	SCRIPTS = "SCRIPTS",
	THEME = "SELECT A COLOR",
	PC = "PC SETTINGS",
	MINIMIZE_KEY = "MINIMIZE KEY",
	PASSWORD = "PASSWORD",
	UNLOCK = "ENTER",
	WRONG_PASSWORD = "WRONG PASSWORD",
	FLING_PLAYERS = "FLING PLAYERS",
	EQUALIZER = "EQUALIZER",
	MADE_BY = "MADE BY SAMLPZX ON TIKTOK",
	ACCESS_DENIED = "ACCESS DENIED",
	NOT_ALLOWED = "YOU ARE NOT ALLOWED TO USE THIS PANEL"
}

local function corner(object, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0,radius)
	c.Parent = object
	return c
end

local function stroke(object, color, transparency, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Transparency = transparency or 0
	s.Thickness = thickness or 1
	s.Parent = object
	return s
end

local function makeDraggable(object)
	local dragging = false
	local dragStart, startPos, dragInput
	object.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = object.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	object.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local function showDenied()
	local deniedGui = Instance.new("ScreenGui")
	deniedGui.Name = "PanelCnpDenied"
	deniedGui.ResetOnSpawn = false
	deniedGui.IgnoreGuiInset = true
	deniedGui.Parent = PlayerGui

	local deniedFrame = Instance.new("Frame")
	deniedFrame.Size = UDim2.fromOffset(350,150)
	deniedFrame.Position = UDim2.new(.5,-175,.5,-75)
	deniedFrame.BackgroundColor3 = Color3.fromRGB(18,18,22)
	deniedFrame.Parent = deniedGui
	corner(deniedFrame,18)
	stroke(deniedFrame,Color3.fromRGB(255,60,60),0,2)

	local deniedTitle = Instance.new("TextLabel")
	deniedTitle.Size = UDim2.new(1,-30,0,35)
	deniedTitle.Position = UDim2.fromOffset(15,20)
	deniedTitle.BackgroundTransparency = 1
	deniedTitle.Text = T.ACCESS_DENIED
	deniedTitle.TextColor3 = Color3.fromRGB(255,60,60)
	deniedTitle.Font = PANEL_FONT
	deniedTitle.TextSize = 24
	deniedTitle.Parent = deniedFrame

	local deniedText = Instance.new("TextLabel")
	deniedText.Size = UDim2.new(1,-30,0,50)
	deniedText.Position = UDim2.fromOffset(15,65)
	deniedText.BackgroundTransparency = 1
	deniedText.Text = T.NOT_ALLOWED
	deniedText.TextColor3 = WHITE
	deniedText.Font = PANEL_FONT
	deniedText.TextSize = 14
	deniedText.TextWrapped = true
	deniedText.Parent = deniedFrame

	task.delay(5, function()
		if deniedGui then deniedGui:Destroy() end
	end)
end

if not isAllowed then
	showDenied()
	return
end

-- LOGIN SCREEN
local loginGui = Instance.new("ScreenGui")
loginGui.Name = "PanelCnpLogin"
loginGui.ResetOnSpawn = false
loginGui.IgnoreGuiInset = true
loginGui.Parent = PlayerGui

local login = Instance.new("Frame")
login.Size = UDim2.fromOffset(330,190)
login.Position = UDim2.new(.5,-165,.5,-95)
login.BackgroundColor3 = Color3.fromRGB(18,18,22)
login.Parent = loginGui
corner(login,18)
stroke(login,Color3.fromRGB(70,70,80),.25,1)

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1,-30,0,35)
loginTitle.Position = UDim2.fromOffset(15,15)
loginTitle.BackgroundTransparency = 1
loginTitle.Text = "PANEL CNP"
loginTitle.TextColor3 = WHITE
loginTitle.Font = PANEL_FONT
loginTitle.TextSize = 20
loginTitle.Parent = login

local passwordBox = Instance.new("TextBox")
passwordBox.Size = UDim2.new(1,-40,0,40)
passwordBox.Position = UDim2.fromOffset(20,60)
passwordBox.BackgroundColor3 = Color3.fromRGB(30,30,35)
passwordBox.TextColor3 = WHITE
passwordBox.PlaceholderText = T.PASSWORD
passwordBox.PlaceholderColor3 = GRAY
passwordBox.Text = ""
passwordBox.ClearTextOnFocus = false
passwordBox.TextSize = 15
passwordBox.Font = PANEL_FONT
passwordBox.Parent = login
corner(passwordBox,10)

local enterButton = Instance.new("TextButton")
enterButton.Size = UDim2.new(1,-40,0,40)
enterButton.Position = UDim2.fromOffset(20,112)
enterButton.BackgroundColor3 = BLUE
enterButton.Text = T.UNLOCK
enterButton.TextColor3 = WHITE
enterButton.Font = PANEL_FONT
enterButton.TextSize = 15
enterButton.Parent = login
corner(enterButton,10)

local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(1,-30,0,22)
errorLabel.Position = UDim2.fromOffset(15,158)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.TextColor3 = Color3.fromRGB(255,80,80)
errorLabel.Font = PANEL_FONT
errorLabel.TextSize = 12
errorLabel.Parent = login

-- MAIN GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PanelCnpUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Enabled = false
screenGui.Parent = PlayerGui

local reopenButton = Instance.new("TextButton")
reopenButton.Size = UDim2.fromOffset(45,45)
reopenButton.Position = UDim2.new(.05,0,.4,0)
reopenButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
reopenButton.Text = "CNP"
reopenButton.TextColor3 = WHITE
reopenButton.Font = PANEL_FONT
reopenButton.TextSize = 12
reopenButton.Visible = false
reopenButton.Parent = screenGui
corner(reopenButton,12)
makeDraggable(reopenButton)

if IS_PC then reopenButton.Visible = false end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.fromOffset(380,260)
mainFrame.Position = UDim2.new(.5,-190,.5,-130)
mainFrame.BackgroundColor3 = DARK
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Parent = screenGui
corner(mainFrame,18)

local mainGradient = Instance.new("UIGradient")
mainGradient.Enabled = false
mainGradient.Parent = mainFrame

makeDraggable(mainFrame)

-- TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1,0,0,38)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-70,0,25)
title.Position = UDim2.fromOffset(15,7)
title.BackgroundTransparency = 1
title.Text = "PANEL CNP"
title.TextColor3 = WHITE
title.Font = PANEL_FONT
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local controls = Instance.new("Frame")
controls.Size = UDim2.fromOffset(58,28)
controls.Position = UDim2.new(1,-65,0,5)
controls.BackgroundTransparency = 1
controls.Parent = topBar

local minimizeButton
if not IS_PC then
	minimizeButton = Instance.new("TextButton")
	minimizeButton.Size = UDim2.fromOffset(24,24)
	minimizeButton.Position = UDim2.fromOffset(0,2)
	minimizeButton.BackgroundColor3 = Color3.fromRGB(120,120,120)
	minimizeButton.BackgroundTransparency = .2
	minimizeButton.Text = "-"
	minimizeButton.TextColor3 = WHITE
	minimizeButton.Font = PANEL_FONT
	minimizeButton.TextSize = 15
	minimizeButton.Parent = controls
	corner(minimizeButton,6)
end

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(24,24)
closeButton.Position = UDim2.fromOffset(30,2)
closeButton.BackgroundColor3 = Color3.fromRGB(255,60,60)
closeButton.BackgroundTransparency = .15
closeButton.Text = "×"
closeButton.TextColor3 = WHITE
closeButton.Font = PANEL_FONT
closeButton.TextSize = 16
closeButton.Parent = controls
corner(closeButton,6)

-- CONTENT
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromOffset(90,210)
sidebar.Position = UDim2.fromOffset(10,43)
sidebar.BackgroundTransparency = 1
sidebar.Parent = mainFrame

local content = Instance.new("Frame")
content.Size = UDim2.new(1,-115,1,-50)
content.Position = UDim2.fromOffset(105,43)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- HOME PAGE
local homePage = Instance.new("ScrollingFrame")
homePage.Size = UDim2.new(1,0,1,0)
homePage.BackgroundTransparency = 1
homePage.BorderSizePixel = 0
homePage.ScrollBarThickness = 3
homePage.CanvasSize = UDim2.new()
homePage.AutomaticCanvasSize = Enum.AutomaticSize.Y
homePage.Parent = content

local homeLayout = Instance.new("UIListLayout")
homeLayout.Padding = UDim.new(0,7)
homeLayout.SortOrder = Enum.SortOrder.LayoutOrder
homeLayout.Parent = homePage

-- FLING PAGE
local flingPage = Instance.new("ScrollingFrame")
flingPage.Size = UDim2.new(1,0,1,0)
flingPage.BackgroundTransparency = 1
flingPage.BorderSizePixel = 0
flingPage.ScrollBarThickness = 3
flingPage.CanvasSize = UDim2.new()
flingPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
flingPage.Visible = false
flingPage.Parent = content

local flingLayout = Instance.new("UIListLayout")
flingLayout.Padding = UDim.new(0,5)
flingLayout.SortOrder = Enum.SortOrder.LayoutOrder
flingLayout.Parent = flingPage

-- EQUALIZER PAGE
local eqPage = Instance.new("ScrollingFrame")
eqPage.Size = UDim2.new(1,0,1,0)
eqPage.BackgroundTransparency = 1
eqPage.BorderSizePixel = 0
eqPage.ScrollBarThickness = 3
eqPage.CanvasSize = UDim2.new()
eqPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
eqPage.Visible = false
eqPage.Parent = content

local eqLayout = Instance.new("UIListLayout")
eqLayout.Padding = UDim.new(0,7)
eqLayout.SortOrder = Enum.SortOrder.LayoutOrder
eqLayout.Parent = eqPage

-- PROFILE
local profile = Instance.new("Frame")
profile.Size = UDim2.new(1,-5,0,55)
profile.BackgroundColor3 = Color3.fromRGB(255,255,255)
profile.BackgroundTransparency = .93
profile.LayoutOrder = 1
profile.Parent = homePage
corner(profile,12)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.fromOffset(40,40)
avatar.Position = UDim2.fromOffset(7,7)
avatar.BackgroundColor3 = Color3.fromRGB(35,35,40)
avatar.Parent = profile
corner(avatar,20)

pcall(function()
	avatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local username = Instance.new("TextLabel")
username.Size = UDim2.new(1,-55,0,20)
username.Position = UDim2.fromOffset(55,5)
username.BackgroundTransparency = 1
username.Text = Player.Name:upper()
username.TextColor3 = WHITE
username.Font = PANEL_FONT
username.TextSize = 14
username.TextXAlignment = Enum.TextXAlignment.Left
username.Parent = profile

-- SCRIPTS TITLE
local scriptsTitle = Instance.new("TextLabel")
scriptsTitle.Size = UDim2.new(1,-5,0,24)
scriptsTitle.BackgroundTransparency = 1
scriptsTitle.Text = T.SCRIPTS
scriptsTitle.TextColor3 = WHITE
scriptsTitle.Font = PANEL_FONT
scriptsTitle.TextSize = 16
scriptsTitle.TextXAlignment = Enum.TextXAlignment.Left
scriptsTitle.LayoutOrder = 3
scriptsTitle.Parent = homePage

-- SWITCH FACTORY
local function createSwitch(parent, text, callback, layoutOrder)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1,-5,0,38)
	button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	button.BackgroundTransparency = .91
	button.Text = ""
	button.AutoButtonColor = false
	button.LayoutOrder = layoutOrder or 10
	button.Parent = parent
	corner(button,9)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,-70,1,0)
	label.Position = UDim2.fromOffset(12,0)
	label.BackgroundTransparency = 1
	label.Text = text:upper()
	label.TextColor3 = WHITE
	label.Font = PANEL_FONT
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = button

	local switch = Instance.new("Frame")
	switch.Size = UDim2.fromOffset(42,24)
	switch.Position = UDim2.new(1,-52,.5,-12)
	switch.BackgroundColor3 = Color3.fromRGB(70,70,75)
	switch.Parent = button
	corner(switch,20)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.fromOffset(20,20)
	knob.Position = UDim2.fromOffset(2,2)
	knob.BackgroundColor3 = WHITE
	knob.Parent = switch
	corner(knob,20)

	local active = false
	local function update()
		switch.BackgroundColor3 = active and BLUE or Color3.fromRGB(70,70,75)
		TweenService:Create(knob, TweenInfo.new(.15), {
			Position = active and UDim2.new(1,-22,.5,-10) or UDim2.fromOffset(2,2)
		}):Play()
		callback(active)
	end

	button.Activated:Connect(function()
		active = not active
		update()
	end)

	return button
end

-- SPEED 1 (ORIGINAL)
local speedActive = false
local offsetAmount = Vector3.new(0,0,5.2)
local weightMass = 20.6
local weightName = "CoMWeight_Object"
local currentRotSpeed = 0
local lastLook = workspace.CurrentCamera.CFrame.LookVector

local function applyWeight(character)
	local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart",5)
	if not root then return end
	local existing = character:FindFirstChild(weightName)
	if existing then existing:Destroy() end
	local weight = Instance.new("Part")
	weight.Name = weightName
	weight.Size = Vector3.new(1,1,1)
	weight.Transparency = 1
	weight.CanCollide = false
	weight.CanQuery = false
	weight.Massless = false
	weight.Parent = character
	weight.CustomPhysicalProperties = PhysicalProperties.new(weightMass,.3,.5)
	local weld = Instance.new("Weld")
	weld.Part0 = root
	weld.Part1 = weight
	weld.C0 = CFrame.new(offsetAmount)
	weld.Parent = weight
end

local function removeWeight()
	local character = Player.Character
	if not character then return end
	local existing = character:FindFirstChild(weightName)
	if existing then existing:Destroy() end
end

local speedSwitch = createSwitch(homePage, "SPEED", function(state)
	speedActive = state
	if state then
		if Player.Character then applyWeight(Player.Character) end
	else
		removeWeight()
	end
end, 10)

RunService.RenderStepped:Connect(function(dt)
	local cam = workspace.CurrentCamera
	if not cam then return end
	local currentLook = cam.CFrame.LookVector
	currentRotSpeed = (currentLook-lastLook).Magnitude / math.max(dt,.001)
	lastLook = currentLook
	if not speedActive then return end
	local character = Player.Character
	if not character then return end
	local root = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid then return end
	local moveDir = humanoid.MoveDirection
	if moveDir.Magnitude > .1 then
		local isMovingBack = moveDir:Dot(currentLook) < -.35
		if isMovingBack and currentRotSpeed > 8 then
			local boostPower = math.clamp(currentRotSpeed * 1.15,0,52)
			root.AssemblyLinearVelocity = root.AssemblyLinearVelocity + (moveDir.Unit * boostPower * dt * 42)
		end
	end
end)

Player.CharacterAdded:Connect(function(character)
	task.wait(.5)
	if speedActive then applyWeight(character) end
end)

-- C4 BOMB (ORIGINAL)
local c4Active = false
local c4Tool
local c4Cooldown = 2
local currentBomb

local function buildC4()
	local part = Instance.new("Part")
	part.Name = "Handle"
	part.Size = Vector3.new(1.8,.7,1.2)
	part.Color = Color3.fromRGB(255,180,50)
	part.Material = Enum.Material.Metal
	part.CanCollide = true
	return part
end

local function createC4Tool()
	if c4Tool then c4Tool:Destroy() end
	local tool = Instance.new("Tool")
	tool.Name = "Gold C4 Bomb"
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	tool.Grip = CFrame.new(0,-.2,.2) * CFrame.Angles(0,math.rad(180),0)
	local handle = buildC4()
	handle.Parent = tool
	tool.Activated:Connect(function()
		if not c4Active then return end
		local character = Player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not root then return end
		if currentBomb then currentBomb:Destroy() end
		local bomb = buildC4()
		bomb.CFrame = root.CFrame * CFrame.new(0,-3.2,0)
		bomb.Parent = workspace
		currentBomb = bomb
		local camera = workspace.CurrentCamera
		local direction = camera and camera.CFrame.LookVector or root.CFrame.LookVector
		bomb.AssemblyLinearVelocity = direction * 25 + Vector3.new(0,10,0)
		task.delay(.1,function()
			if bomb and bomb.Parent then bomb.AssemblyLinearVelocity = Vector3.zero end
		end)
		for _,part in ipairs(tool:GetChildren()) do
			if part:IsA("BasePart") then part.Transparency = 1 end
		end
		task.delay(c4Cooldown,function()
			if currentBomb == bomb then currentBomb = nil end
			if bomb then bomb:Destroy() end
			for _,part in ipairs(tool:GetChildren()) do
				if part:IsA("BasePart") then part.Transparency = 0 end
			end
		end)
	end)
	tool.Parent = Player.Backpack
	c4Tool = tool
end

local c4Switch = createSwitch(homePage, "C4 BOMB", function(state)
	c4Active = state
	if state then
		createC4Tool()
	else
		if c4Tool then c4Tool:Destroy() c4Tool = nil end
		if currentBomb then currentBomb:Destroy() currentBomb = nil end
	end
end, 11)

-- HALLOWEEN FOG
local halloweenFogSwitch = createSwitch(homePage, "HALLOWEEN FOG", function(state)
	if state then
		Lighting.FogStart = 5
		Lighting.FogEnd = 120
		Lighting.FogColor = Color3.fromRGB(45, 45, 45)
		Lighting.Brightness = 1
		Lighting.Ambient = Color3.fromRGB(35, 35, 35)
		Lighting.OutdoorAmbient = Color3.fromRGB(50, 50, 50)
	else
		Lighting.FogStart = 0
		Lighting.FogEnd = 100000
		Lighting.FogColor = Color3.fromRGB(255, 255, 255)
		Lighting.Brightness = 2
		Lighting.Ambient = Color3.fromRGB(70, 70, 70)
		Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
	end
end, 12)

-- FPS BOOSTER
local fpsBoostActive = false

local function OptimizeFPS()
	if not fpsBoostActive then return end
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") then
			obj.Rate = math.min(obj.Rate, 8)
		elseif obj:IsA("Trail") then
			obj.Lifetime = math.min(obj.Lifetime, 0.25)
		elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
			obj.Shadows = false
		end
	end
end

local fpsBoostSwitch = createSwitch(homePage, "FPS BOOSTER", function(state)
	fpsBoostActive = state
	if state then OptimizeFPS() end
end, 13)

task.spawn(function()
	while true do
		if fpsBoostActive then OptimizeFPS() end
		task.wait(5)
	end
end)

-- OLD SOUND (ORIGINAL)
local oldSoundActive = false
local EQUIP_SOUND_ID = "rbxassetid://88992967391455"
local UNEQUIP_SOUND_ID = "rbxassetid://81868760863307"
local TARGET_TOOL_NAME = "Gun"
local COOLDOWN_DURATION = 5

local equipSound = Instance.new("Sound")
equipSound.Name = "PekoraEquipSound"
equipSound.SoundId = EQUIP_SOUND_ID
equipSound.Volume = 4
equipSound.Parent = SoundService

local unequipSound = Instance.new("Sound")
unequipSound.Name = "PekoraUnequipSound"
unequipSound.SoundId = UNEQUIP_SOUND_ID
unequipSound.Volume = 2
unequipSound.Parent = SoundService

local gunConnections = {}
local gunLastUnequippedTime = 0

local function setupGunSystem(character)
	for _,connection in ipairs(gunConnections) do
		if connection then connection:Disconnect() end
	end
	table.clear(gunConnections)
	if not oldSoundActive then return end
	local humanoid = character:WaitForChild("Humanoid",10)
	local animator = humanoid and humanoid:WaitForChild("Animator",10)
	if animator then
		table.insert(gunConnections, animator.AnimationPlayed:Connect(function(track)
			if not oldSoundActive then return end
			local tool = character:FindFirstChildOfClass("Tool")
			local isHoldingGun = tool and tool.Name == TARGET_TOOL_NAME
			local timeSinceUnequip = tick() - gunLastUnequippedTime
			local withinCooldown = timeSinceUnequip <= COOLDOWN_DURATION
			if isHoldingGun or withinCooldown then
				if track.Priority == Enum.AnimationPriority.Action then track:Stop() end
			end
		end))
	end
	table.insert(gunConnections, character.ChildAdded:Connect(function(child)
		if not oldSoundActive then return end
		if child:IsA("Tool") and child.Name == TARGET_TOOL_NAME then equipSound:Play() end
	end))
	table.insert(gunConnections, character.ChildRemoved:Connect(function(child)
		if not oldSoundActive then return end
		if child:IsA("Tool") and child.Name == TARGET_TOOL_NAME then
			unequipSound:Play()
			gunLastUnequippedTime = tick()
		end
	end))
end

local oldSoundSwitch = createSwitch(homePage, "OLD SOUND", function(state)
	oldSoundActive = state
	if state then
		if Player.Character then setupGunSystem(Player.Character) end
	else
		for _,connection in ipairs(gunConnections) do
			if connection then connection:Disconnect() end
		end
		table.clear(gunConnections)
		equipSound:Stop()
		unequipSound:Stop()
		equipSound.Volume = 0
		unequipSound.Volume = 0
	end
	if state then
		equipSound.Volume = 4
		unequipSound.Volume = 2
	end
end, 14)

Player.CharacterAdded:Connect(function(character)
	if oldSoundActive then
		task.wait(.5)
		if oldSoundActive then setupGunSystem(character) end
	end
end)

-- TOOL EMOTES (ORIGINAL)
local emotesActive = false
local EMOTES_TOOL_NAME = "Emotes"

local function removeEmotes()
	local backpack = Player:FindFirstChild("Backpack")
	if backpack then
		for _,item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") and item.Name == EMOTES_TOOL_NAME then item:Destroy() end
		end
	end
	local character = Player.Character
	if character then
		for _,item in ipairs(character:GetChildren()) do
			if item:IsA("Tool") and item.Name == EMOTES_TOOL_NAME then item:Destroy() end
		end
	end
end

local function createEmotes()
	removeEmotes()
	local backpack = Player:WaitForChild("Backpack")
	local tool = Instance.new("Tool")
	tool.Name = EMOTES_TOOL_NAME
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.ToolTip = "Emotes"
	tool.Parent = backpack
end

local emotesSwitch = createSwitch(homePage, "TOOL EMOTES", function(state)
	emotesActive = state
	if state then createEmotes() else removeEmotes() end
end, 15)

Player.CharacterAdded:Connect(function()
	if emotesActive then
		task.wait(.5)
		if emotesActive then createEmotes() end
	end
end)

-- SNOWBALL TOOL (ORIGINAL)
local snowballActive = false
local SNOWBALL_IMAGE_ID = "rbxassetid://88471480185615"
local THROW_ANIMATION_ID = "rbxassetid://18324269091"
local THROW_COOLDOWN = 2

local function removeSnowballTool()
	local backpack = Player:FindFirstChild("Backpack")
	if backpack then
		local tool = backpack:FindFirstChild("Snowball2020")
		if tool then tool:Destroy() end
	end
	if Player.Character then
		local tool = Player.Character:FindFirstChild("Snowball2020")
		if tool then tool:Destroy() end
	end
end

local function createSnowballTool()
	removeSnowballTool()
	local backpack = Player:WaitForChild("Backpack")
	local tool = Instance.new("Tool")
	tool.Name = "Snowball2020"
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	tool.TextureId = SNOWBALL_IMAGE_ID
	tool.Grip = CFrame.new(0,-.2,0) * CFrame.Angles(0,math.rad(90),0)
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1.1,1.1,1.1)
	handle.Shape = Enum.PartType.Ball
	handle.Color = Color3.fromRGB(250,250,250)
	handle.Material = Enum.Material.SmoothPlastic
	handle.CanCollide = false
	handle.Parent = tool
	local throwTrack = nil
	local function loadAnimationTrack()
		local character = Player.Character
		if not character then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid
			local throwAnimation = Instance.new("Animation")
			throwAnimation.AnimationId = THROW_ANIMATION_ID
			pcall(function() throwTrack = animator:LoadAnimation(throwAnimation) end)
		end
	end
	loadAnimationTrack()
	local onCooldown = false
	tool.Activated:Connect(function()
		if onCooldown then return end
		onCooldown = true
		if throwTrack then
			throwTrack:Play()
		else
			local character = Player.Character
			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid
					local throwAnimation = Instance.new("Animation")
					throwAnimation.AnimationId = THROW_ANIMATION_ID
					local tempTrack = animator:LoadAnimation(throwAnimation)
					tempTrack:Play()
				end
			end
		end
		task.delay(THROW_COOLDOWN, function() onCooldown = false end)
	end)
	tool.Parent = backpack
end

local snowballSwitch = createSwitch(homePage, "SNOWBALL TOOL", function(state)
	snowballActive = state
	if state then createSnowballTool() else removeSnowballTool() end
end, 16)

Player.CharacterAdded:Connect(function()
	if snowballActive then
		task.wait(.5)
		if snowballActive then createSnowballTool() end
	end
end)

-- ANTI-CLICK (ORIGINAL)
local antiClickActive = false
local antiClickSwitch = createSwitch(homePage, "ANTI-CLICK", function(state)
	antiClickActive = state
end, 17)

-- NO RELOAD (ORIGINAL)
local noReloadActive = false
local noReloadSwitch = createSwitch(homePage, "NO RELOAD", function(state)
	noReloadActive = state
end, 18)

RunService.RenderStepped:Connect(function()
	local char = Player.Character
	if not char then return end
	local tool = char:FindFirstChildOfClass("Tool")
	if tool then
		if antiClickActive then
			tool.Enabled = false
			for _,v in pairs(tool:GetDescendants()) do
				if v:IsA("BasePart") then v.CanTouch = false end
			end
		else
			tool.Enabled = true
		end
		if noReloadActive then
			for _,obj in pairs(tool:GetDescendants()) do
				if obj.Name == "Reloading" or obj.Name == "Debounce" or obj.Name == "Delay" then
					if obj:IsA("BoolValue") then obj.Value = false end
					if obj:IsA("NumberValue") then obj.Value = 0 end
				end
			end
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				for _,anim in pairs(hum:GetPlayingAnimationTracks()) do
					if string.find(string.lower(anim.Name), "reload") then anim:Stop() end
				end
			end
		end
	end
end)

-- SPEED 2 (ORIGINAL)
local speed2Active = false
local speed2Connections = {}
local speed2Items = {WaterBalloon2024 = true, SnowballToy2020 = true, IceCream = true}

local function disconnectSpeed2()
	for _,connection in ipairs(speed2Connections) do
		if connection then connection:Disconnect() end
	end
	table.clear(speed2Connections)
	local character = Player.Character
	if character then
		local glitchPart = character:FindFirstChild("GlitchPart")
		if glitchPart then glitchPart:Destroy() end
	end
end

local function applySpeed2(character)
	disconnectSpeed2()
	if not speed2Active then return end
	local humanoid = character:WaitForChild("Humanoid",10)
	local rootPart = character:WaitForChild("HumanoidRootPart",10)
	if not humanoid or not rootPart then return end
	local oldPart = character:FindFirstChild("GlitchPart")
	if oldPart then oldPart:Destroy() end
	local glitchPart = Instance.new("Part")
	glitchPart.Name = "GlitchPart"
	glitchPart.Size = Vector3.new(2,2,2)
	glitchPart.Transparency = 1
	glitchPart.CanCollide = false
	glitchPart.CanTouch = false
	glitchPart.CanQuery = false
	glitchPart.Parent = character
	local weld = Instance.new("Weld")
	weld.Part0 = rootPart
	weld.Part1 = glitchPart
	weld.Parent = glitchPart
	local function setOffset(z) weld.C0 = CFrame.new(0,0,z) end
	local emoteAtual = nil
	local efeitoAtivo = false
	local offsetAtual = 0
	local toolAtual = nil
	local modoEscalada = false
	local aguardandoMudancaTool = false
	local terminouComTool = false
	local emotes = {
		["http://www.roblox.com/asset/?id=15609995579"] = "normal",
		["rbxassetid://15609995579"] = "normal",
		["rbxassetid://107481557610007"] = "forte"
	}
	local function ativar(offset)
		efeitoAtivo = true
		offsetAtual = offset
		glitchPart.Transparency = 1
		setOffset(offset)
	end
	local function desativar()
		efeitoAtivo = false
		modoEscalada = false
		offsetAtual = 0
		aguardandoMudancaTool = false
		terminouComTool = false
		glitchPart.Transparency = 1
		setOffset(0)
	end
	table.insert(speed2Connections, humanoid.AnimationPlayed:Connect(function(track)
		if not speed2Active then return end
		if track.Animation then
			local tipo = emotes[track.Animation.AnimationId]
			if tipo then
				emoteAtual = tipo
				offsetAtual = 0
				aguardandoMudancaTool = false
				terminouComTool = false
				track.Stopped:Connect(function()
					if not speed2Active then return end
					emoteAtual = nil
					aguardandoMudancaTool = true
					terminouComTool = toolAtual ~= nil
				end)
			end
		end
	end))
	table.insert(speed2Connections, character.ChildRemoved:Connect(function(obj)
		if not speed2Active then return end
		if speed2Items[obj.Name] then
			if emoteAtual == "normal" then offsetAtual = 9.5
			elseif emoteAtual == "forte" then offsetAtual = 11.5 end
			if efeitoAtivo then setOffset(offsetAtual) end
		end
		if obj:IsA("Tool") then
			if obj == toolAtual then
				toolAtual = nil
				if aguardandoMudancaTool and terminouComTool then
					aguardandoMudancaTool = false
					terminouComTool = false
					desativar()
				elseif not emoteAtual and not speed2Items[obj.Name] then
					desativar()
				end
			end
		end
	end))
	table.insert(speed2Connections, character.ChildAdded:Connect(function(obj)
		if not speed2Active then return end
		if obj:IsA("Tool") then
			toolAtual = obj
			if aguardandoMudancaTool and not terminouComTool then
				aguardandoMudancaTool = false
				desativar()
				return
			end
			local escalando = humanoid:GetState() == Enum.HumanoidStateType.Climbing
			if escalando then
				modoEscalada = true
				efeitoAtivo = true
				setOffset(3.5)
			elseif emoteAtual == "normal" then
				if offsetAtual > 0 then ativar(offsetAtual) else ativar(7.5) end
			elseif emoteAtual == "forte" then
				if offsetAtual > 0 then ativar(offsetAtual) else ativar(10.5) end
			end
		end
	end))
	task.spawn(function()
		while speed2Active and character.Parent and glitchPart.Parent do
			task.wait(.05)
			if efeitoAtivo then
				if modoEscalada then setOffset(3.5) else setOffset(offsetAtual) end
			end
		end
	end)
end

local speed2Switch = createSwitch(homePage, "SPEED 2", function(state)
	speed2Active = state
	if state then
		if Player.Character then applySpeed2(Player.Character) end
	else
		disconnectSpeed2()
	end
end, 19)

Player.CharacterAdded:Connect(function(character)
	if speed2Active then
		task.wait(.5)
		if speed2Active then applySpeed2(character) end
	end
end)

-- TOOL CARREG (ORIGINAL)
local carregActive = false
local CARREG_TOOL_NAME = "Carreg.\nBrinq..."

local function removeCarregTool()
	local function clean(parent)
		if not parent then return end
		for _,obj in ipairs(parent:GetChildren()) do
			if obj:IsA("Tool") and (obj.Name:find("Carreg") or obj.Name:find("Brinqued")) then
				obj:Destroy()
			end
		end
	end
	clean(Player.Backpack)
	clean(Player.Character)
end

local function createCarregTool()
	removeCarregTool()
	local backpack = Player:WaitForChild("Backpack")
	local dummyTool = Instance.new("Tool")
	dummyTool.Name = CARREG_TOOL_NAME
	dummyTool.RequiresHandle = false
	dummyTool.CanBeDropped = false
	dummyTool.Equipped:Connect(function()
		local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid:UnequipTools() end
	end)
	dummyTool.Parent = backpack
end

local carregSwitch = createSwitch(homePage, "TOOL CARREG", function(state)
	carregActive = state
	if state then createCarregTool() else removeCarregTool() end
end, 20)

Player.CharacterAdded:Connect(function()
	if carregActive then
		task.wait(2.5)
		if carregActive then createCarregTool() end
	end
end)

-- CANDY TOOLS (ORIGINAL)
local candyActive = false
local CANDY_ICON_ID = "rbxassetid://75322375368971"
local CANDY_TOOL_NAME = "Color Candy"
local CANDY_COLORS = {Color3.fromRGB(255,220,0),Color3.fromRGB(255,20,147),Color3.fromRGB(0,170,255)}

local function removeCandyTool()
	local backpack = Player:FindFirstChild("Backpack")
	if backpack then
		local tool = backpack:FindFirstChild(CANDY_TOOL_NAME)
		if tool then tool:Destroy() end
	end
	if Player.Character then
		local tool = Player.Character:FindFirstChild(CANDY_TOOL_NAME)
		if tool then tool:Destroy() end
	end
end

local function createCandyTool()
	removeCandyTool()
	local backpack = Player:WaitForChild("Backpack")
	local tool = Instance.new("Tool")
	tool.Name = CANDY_TOOL_NAME
	tool.RequiresHandle = true
	tool.CanBeDropped = false
	tool.TextureId = CANDY_ICON_ID
	tool.Grip = CFrame.new(0,-.3,.2)
	local currentColorIndex = 1
	local handle = Instance.new("Part")
	handle.Name = "Handle"
	handle.Size = Vector3.new(1.7,1.7,1.7)
	handle.Shape = Enum.PartType.Ball
	handle.Color = CANDY_COLORS[currentColorIndex]
	handle.Material = Enum.Material.SmoothPlastic
	handle.CanCollide = false
	handle.Parent = tool
	local ring = Instance.new("Part")
	ring.Shape = Enum.PartType.Cylinder
	ring.Size = Vector3.new(.17,1.8,1.8)
	ring.Color = handle.Color
	ring.Material = Enum.Material.SmoothPlastic
	ring.CanCollide = false
	ring.CFrame = handle.CFrame * CFrame.Angles(0,0,math.rad(90))
	ring.Parent = tool
	local ringWeld = Instance.new("WeldConstraint")
	ringWeld.Part0 = handle
	ringWeld.Part1 = ring
	ringWeld.Parent = handle
	local fire = Instance.new("Fire")
	fire.Size = 3
	fire.Heat = 5
	fire.Enabled = false
	fire.Parent = handle
	local interactionCount = 0
	local function changeToNextColor()
		local newIndex
		repeat
			newIndex = math.random(1,#CANDY_COLORS)
		until newIndex ~= currentColorIndex or #CANDY_COLORS == 1
		currentColorIndex = newIndex
		local newColor = CANDY_COLORS[currentColorIndex]
		handle.Color = newColor
		ring.Color = newColor
		return newColor
	end
	tool.Equipped:Connect(function()
		interactionCount = interactionCount + 1
		local currentColor = changeToNextColor()
		if interactionCount >= 10 then
			fire.Color = currentColor
			fire.SecondaryColor = currentColor
			fire.Enabled = true
		end
	end)
	tool.Unequipped:Connect(function()
		interactionCount = interactionCount + 1
		changeToNextColor()
		if fire.Enabled then
			fire.Enabled = false
			interactionCount = 0
		end
	end)
	tool.Parent = backpack
end

local candySwitch = createSwitch(homePage, "CANDY TOOLS", function(state)
	candyActive = state
	if state then createCandyTool() else removeCandyTool() end
end, 21)

Player.CharacterAdded:Connect(function()
	if candyActive then
		task.wait(.5)
		if candyActive then
			if Player.Backpack then createCandyTool() end
		end
	end
end)

-- TIMER (ORIGINAL)
local timerActive = false
local timerConnections = {}
local movedParents = {}
local movedLabels = {}

local function disconnectTimer()
	for _,connection in ipairs(timerConnections) do
		if connection then connection:Disconnect() end
	end
	table.clear(timerConnections)
end

local function configureTimerObject(obj)
	if not timerActive then return end
	if not obj:IsA("TextLabel") then return end
	local function atualizar()
		if not timerActive then return end
		if string.find(obj.Text:lower(), "xp") then
			local pai = obj.Parent
			if pai and pai:IsA("GuiObject") and not movedParents[pai] then
				movedParents[pai] = true
				pai.Position = pai.Position + UDim2.new(0,0,0,35)
			end
		end
		if string.match(obj.Text, "%dm%s*%d+s") and not movedLabels[obj] then
			movedLabels[obj] = true
			obj.Position = obj.Position + UDim2.new(0,0,0,35)
		end
	end
	table.insert(timerConnections, obj:GetPropertyChangedSignal("Text"):Connect(atualizar))
	atualizar()
end

local function startTimer()
	disconnectTimer()
	table.clear(movedParents)
	table.clear(movedLabels)
	for _,v in ipairs(PlayerGui:GetDescendants()) do configureTimerObject(v) end
	table.insert(timerConnections, PlayerGui.DescendantAdded:Connect(configureTimerObject))
end

local timerSwitch = createSwitch(homePage, "TIMER", function(state)
	timerActive = state
	if state then startTimer() else disconnectTimer() table.clear(movedParents) table.clear(movedLabels) end
end, 22)

-- DEPENDENCIAS
local dependencies = {
	{"SHADERS / RTX","https://rawscripts.net/raw/Universal-Script-Shaders-Like-Ray-tracing-and-RTX-239458"},
	{"VERTEX","https://rawscripts.net/raw/Murder-Mystery-2-nexus-updated-15270"},
	{"PAINEL CNP","https://raw.githubusercontent.com/ZoeWarOnTop/Painel-Cnp/refs/heads/main/Painel-Cnp"},
	{"ANTI COINS MM2","https://raw.githubusercontent.com/oipdrin971-source/mm2-script/main/anti_coins_mm2.lua"},
	{"GAE SIMPLIFIED","https://rawscripts.net/raw/Universal-Script-GAE-SIMPLIFIED-27193"},
	{"EMOTE GUI","https://rawscripts.net/raw/Universal-Script-Emote-Gui-75782"},
	{"CURSORES","https://pastefy.app/RVclAKyp/raw"},
	{"PANEL DE ELIAS","https://pastefy.app/3y6DxwWg/raw"},
	{"YARHM","https://rawscripts.net/raw/Universal-Script-YARHM-12403"}
}

for _,data in ipairs(dependencies) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1,-5,0,38)
	button.BackgroundColor3 = Color3.fromRGB(255,255,255)
	button.BackgroundTransparency = .92
	button.Text = "  " .. data[1]
	button.TextColor3 = WHITE
	button.Font = PANEL_FONT
	button.TextSize = 13
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.AutoButtonColor = false
	button.LayoutOrder = 100
	button.Parent = homePage
	corner(button,8)

	button.Activated:Connect(function()
		task.spawn(function()
			pcall(function()
				loadstring(game:HttpGet(data[2]))()
			end)
		end)
	end)
end

-- SETTINGS PAGE
local settingsPage = Instance.new("ScrollingFrame")
settingsPage.Size = UDim2.new(1,0,1,0)
settingsPage.BackgroundTransparency = 1
settingsPage.BorderSizePixel = 0
settingsPage.ScrollBarThickness = 3
settingsPage.CanvasSize = UDim2.new()
settingsPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
settingsPage.Visible = false
settingsPage.Parent = content

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.Padding = UDim.new(0,7)
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Parent = settingsPage

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1,-5,0,25)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = T.SETTINGS
settingsTitle.TextColor3 = WHITE
settingsTitle.Font = PANEL_FONT
settingsTitle.TextSize = 18
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.LayoutOrder = 1
settingsTitle.Parent = settingsPage

-- THEME LABEL
local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1,-5,0,25)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = T.THEME
themeLabel.TextColor3 = GRAY
themeLabel.Font = PANEL_FONT
themeLabel.TextSize = 13
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.LayoutOrder = 2
themeLabel.Parent = settingsPage

-- COLORES SÓLIDOS
local solidColorScroll = Instance.new("ScrollingFrame")
solidColorScroll.Size = UDim2.new(1,-5,0,50)
solidColorScroll.BackgroundTransparency = 1
solidColorScroll.BorderSizePixel = 0
solidColorScroll.ScrollBarThickness = 2
solidColorScroll.CanvasSize = UDim2.new(0, 900, 0, 0)
solidColorScroll.ScrollingDirection = Enum.ScrollingDirection.XY
solidColorScroll.LayoutOrder = 3
solidColorScroll.Parent = settingsPage

local solidColorLayout = Instance.new("UIListLayout")
solidColorLayout.FillDirection = Enum.FillDirection.Horizontal
solidColorLayout.Padding = UDim.new(0,5)
solidColorLayout.SortOrder = Enum.SortOrder.LayoutOrder
solidColorLayout.Parent = solidColorScroll

local themes = {
	Color3.fromRGB(15,15,15), Color3.fromRGB(30,20,25), Color3.fromRGB(45,10,15),
	Color3.fromRGB(10,25,45), Color3.fromRGB(15,40,20), Color3.fromRGB(35,15,40),
	Color3.fromRGB(50,30,10), Color3.fromRGB(20,40,40), Color3.fromRGB(40,40,20),
	Color3.fromRGB(15,15,35), Color3.fromRGB(35,10,35), Color3.fromRGB(5,30,30),
	Color3.fromRGB(30,15,10), Color3.fromRGB(25,25,25), Color3.fromRGB(60,0,0),
	Color3.fromRGB(0,60,60), Color3.fromRGB(60,60,0), Color3.fromRGB(60,0,60),
	Color3.fromRGB(0,0,60), Color3.fromRGB(60,30,0), Color3.fromRGB(0,30,60),
	Color3.fromRGB(30,60,0), Color3.fromRGB(60,0,30), Color3.fromRGB(0,60,30),
	Color3.fromRGB(30,0,60)
}

for _,color in ipairs(themes) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.fromOffset(35,35)
	button.BackgroundColor3 = color
	button.Text = ""
	button.AutoButtonColor = false
	button.LayoutOrder = 1
	button.Parent = solidColorScroll
	corner(button,7)
	button.Activated:Connect(function()
		mainGradient.Enabled = false
		mainFrame.BackgroundColor3 = color
	end)
end

-- DEGRADADOS
local gradientScroll = Instance.new("ScrollingFrame")
gradientScroll.Size = UDim2.new(1,-5,0,50)
gradientScroll.BackgroundTransparency = 1
gradientScroll.BorderSizePixel = 0
gradientScroll.ScrollBarThickness = 2
gradientScroll.CanvasSize = UDim2.new(0, 900, 0, 0)
gradientScroll.ScrollingDirection = Enum.ScrollingDirection.XY
gradientScroll.LayoutOrder = 4
gradientScroll.Parent = settingsPage

local gradientLayout = Instance.new("UIListLayout")
gradientLayout.FillDirection = Enum.FillDirection.Horizontal
gradientLayout.Padding = UDim.new(0,5)
gradientLayout.SortOrder = Enum.SortOrder.LayoutOrder
gradientLayout.Parent = gradientScroll

local gradients = {
	ColorSequence.new(Color3.fromRGB(15,15,15),Color3.fromRGB(80,0,100)),
	ColorSequence.new(Color3.fromRGB(5,15,40),Color3.fromRGB(0,100,120)),
	ColorSequence.new(Color3.fromRGB(50,5,10),Color3.fromRGB(120,30,0)),
	ColorSequence.new(Color3.fromRGB(10,35,10),Color3.fromRGB(0,110,50)),
	ColorSequence.new(Color3.fromRGB(40,0,50),Color3.fromRGB(110,0,60)),
	ColorSequence.new(Color3.fromRGB(10,10,10),Color3.fromRGB(70,70,70)),
	ColorSequence.new(Color3.fromRGB(50,25,0),Color3.fromRGB(120,80,0)),
	ColorSequence.new(Color3.fromRGB(25,0,35),Color3.fromRGB(0,75,95)),
	ColorSequence.new(Color3.fromRGB(0,50,80),Color3.fromRGB(80,0,50)),
	ColorSequence.new(Color3.fromRGB(80,50,0),Color3.fromRGB(0,80,50)),
	ColorSequence.new(Color3.fromRGB(50,0,80),Color3.fromRGB(0,50,0)),
	ColorSequence.new(Color3.fromRGB(0,0,80),Color3.fromRGB(80,0,0)),
	ColorSequence.new(Color3.fromRGB(0,80,80),Color3.fromRGB(80,80,0)),
	ColorSequence.new(Color3.fromRGB(80,0,80),Color3.fromRGB(0,80,0)),
	ColorSequence.new(Color3.fromRGB(40,40,40),Color3.fromRGB(0,0,0)),
	ColorSequence.new(Color3.fromRGB(80,40,0),Color3.fromRGB(0,0,40))
}

for _,sequence in ipairs(gradients) do
	local button = Instance.new("TextButton")
	button.Size = UDim2.fromOffset(35,35)
	button.BackgroundColor3 = WHITE
	button.Text = ""
	button.AutoButtonColor = false
	button.LayoutOrder = 1
	button.Parent = gradientScroll
	corner(button,7)
	local gradient = Instance.new("UIGradient")
	gradient.Color = sequence
	gradient.Rotation = 45
	gradient.Parent = button
	button.Activated:Connect(function()
		mainFrame.BackgroundColor3 = WHITE
		mainGradient.Enabled = true
		mainGradient.Color = sequence
		mainGradient.Rotation = 45
	end)
end

-- PC SETTINGS
local pcTitle = Instance.new("TextLabel")
pcTitle.Size = UDim2.new(1,-5,0,25)
pcTitle.BackgroundTransparency = 1
pcTitle.Text = T.PC
pcTitle.TextColor3 = WHITE
pcTitle.Font = PANEL_FONT
pcTitle.TextSize = 16
pcTitle.TextXAlignment = Enum.TextXAlignment.Left
pcTitle.LayoutOrder = 5
pcTitle.Parent = settingsPage

local keyButton = Instance.new("TextButton")
keyButton.Size = UDim2.new(1,-5,0,42)
keyButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
keyButton.BackgroundTransparency = .91
keyButton.Text = T.MINIMIZE_KEY .. ":  " .. minimizeKey.Name
keyButton.TextColor3 = WHITE
keyButton.Font = PANEL_FONT
keyButton.TextSize = 13
keyButton.LayoutOrder = 6
keyButton.Parent = settingsPage
corner(keyButton,9)

if not IS_PC then
	keyButton.Text = "PC: NOT DETECTED"
	keyButton.AutoButtonColor = false
end

local waitingForKey = false
keyButton.Activated:Connect(function()
	if not IS_PC then return end
	waitingForKey = true
	keyButton.Text = "PRESS A KEY..."
	local connection
	connection = UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			minimizeKey = input.KeyCode
			keyButton.Text = T.MINIMIZE_KEY .. ":  " .. minimizeKey.Name
			waitingForKey = false
			connection:Disconnect()
		end
	end)
end)

-- WATERMARK
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(1,-5,0,35)
watermark.BackgroundTransparency = 1
watermark.Text = T.MADE_BY
watermark.TextColor3 = Color3.fromRGB(100,100,100)
watermark.Font = PANEL_FONT
watermark.TextSize = 14
watermark.TextXAlignment = Enum.TextXAlignment.Center
watermark.LayoutOrder = 7
watermark.Parent = settingsPage

-- FPS COUNTER
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1,0,0,20)
fpsLabel.Position = UDim2.fromOffset(0,150)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 60"
fpsLabel.TextColor3 = GRAY
fpsLabel.Font = PANEL_FONT
fpsLabel.TextSize = 10
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsLabel.Parent = sidebar

local frameCount = 0
local fpsTimer = 0
RunService.RenderStepped:Connect(function(dt)
	frameCount = frameCount + 1
	fpsTimer = fpsTimer + dt
	if fpsTimer >= 1 then
		fpsLabel.Text = "FPS: " .. frameCount
		frameCount = 0
		fpsTimer = 0
	end
end)

-- NAVIGATION
local navButtons = {}
local function nav(name,y,target)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1,0,0,32)
	button.Position = UDim2.fromOffset(0,y)
	button.BackgroundColor3 = WHITE
	button.BackgroundTransparency = target == homePage and .85 or .95
	button.Text = name
	button.TextColor3 = WHITE
	button.Font = PANEL_FONT
	button.TextSize = 13
	button.Parent = sidebar
	corner(button,8)
	button.Activated:Connect(function()
		homePage.Visible = target == homePage
		settingsPage.Visible = target == settingsPage
		flingPage.Visible = target == flingPage
		eqPage.Visible = target == eqPage
		for _,b in ipairs(navButtons) do b.BackgroundTransparency = .95 end
		button.BackgroundTransparency = .85
	end)
	table.insert(navButtons, button)
end

nav(T.HOME,0,homePage)
nav(T.FLING_PLAYERS,38,flingPage)
nav(T.EQUALIZER,76,eqPage)
nav(T.SETTINGS,114,settingsPage)

-- EQUALIZER (FUNCIONA DIRECTAMENTE)
local eqTitleLabel = Instance.new("TextLabel")
eqTitleLabel.Size = UDim2.new(1,-5,0,25)
eqTitleLabel.BackgroundTransparency = 1
eqTitleLabel.Text = "EQUALIZER"
eqTitleLabel.TextColor3 = WHITE
eqTitleLabel.Font = PANEL_FONT
eqTitleLabel.TextSize = 18
eqTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
eqTitleLabel.LayoutOrder = 1
eqTitleLabel.Parent = eqPage

-- Audio Controller
local controlledSounds = {}
local PROTECTION_ON = true
local SAFE_VOLUME = 0.65
local EQ_MIN = -10
local EQ_MAX = 10
local bassValue = 0
local midValue = 0
local trebleValue = 0
local userVolume = 0.65

local function setupSound(sound)
	if not sound:IsA("Sound") then return end
	if controlledSounds[sound] then return end
	controlledSounds[sound] = true

	local eq = sound:FindFirstChild("LocalPlayerEqualizer")
	if not eq then
		eq = Instance.new("EqualizerSoundEffect")
		eq.Name = "LocalPlayerEqualizer"
		eq.Parent = sound
	end
	eq.LowGain = bassValue
	eq.MidGain = midValue
	eq.HighGain = trebleValue

	local compressor = sound:FindFirstChild("LocalHearingProtector")
	if not compressor then
		compressor = Instance.new("CompressorSoundEffect")
		compressor.Name = "LocalHearingProtector"
		compressor.Parent = sound
	end
	compressor.Threshold = -8
	compressor.Ratio = 8
	compressor.Attack = 0.01
	compressor.Release = 0.15
	compressor.GainMakeup = 0
	compressor.Enabled = PROTECTION_ON
end

for _, object in ipairs(game:GetDescendants()) do
	if object:IsA("Sound") then setupSound(object) end
end

game.DescendantAdded:Connect(function(object)
	if object:IsA("Sound") then setupSound(object) end
end)

local function updateEqualizers()
	for sound in pairs(controlledSounds) do
		if sound and sound.Parent then
			local eq = sound:FindFirstChild("LocalPlayerEqualizer")
			if eq then
				eq.LowGain = bassValue
				eq.MidGain = midValue
				eq.HighGain = trebleValue
			end
		end
	end
end

local function updateProtection()
	for sound in pairs(controlledSounds) do
		if sound and sound.Parent then
			local compressor = sound:FindFirstChild("LocalHearingProtector")
			if compressor then
				compressor.Enabled = PROTECTION_ON
			end
		end
	end
end

local function setVolume(value)
	userVolume = math.clamp(value, 0, 1)
	for sound in pairs(controlledSounds) do
		if sound and sound.Parent then
			if sound:GetAttribute("OriginalAudioVolume") == nil then
				sound:SetAttribute("OriginalAudioVolume", sound.Volume)
			end
			local original = sound:GetAttribute("OriginalAudioVolume")
			local finalVolume = original * userVolume
			if PROTECTION_ON then
				finalVolume = math.min(finalVolume, SAFE_VOLUME)
			end
			sound.Volume = finalVolume
		end
	end
end

-- SLIDER FUNCTION
local function eqSlider(name, min, max, default, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,-10,0,55)
	container.BackgroundTransparency = 1
	container.LayoutOrder = 10
	container.Parent = eqPage

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(.65,0,0,22)
	label.BackgroundTransparency = 1
	label.Text = name:upper()
	label.TextColor3 = WHITE
	label.Font = PANEL_FONT
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(.35,0,0,22)
	valueLabel.Position = UDim2.new(.65,0,0,0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.TextColor3 = GRAY
	valueLabel.Font = PANEL_FONT
	valueLabel.TextSize = 13
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = container

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1,0,0,7)
	bar.Position = UDim2.fromOffset(0,33)
	bar.BackgroundColor3 = Color3.fromRGB(65,65,70)
	bar.Parent = container
	corner(bar,10)

	local fill = Instance.new("Frame")
	fill.BackgroundColor3 = BLUE
	fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
	fill.Parent = bar
	corner(fill,10)

	local knob = Instance.new("TextButton")
	knob.Size = UDim2.fromOffset(20,20)
	knob.AnchorPoint = Vector2.new(.5,.5)
	knob.Position = UDim2.new((default-min)/(max-min),0,.5,0)
	knob.BackgroundColor3 = WHITE
	knob.Text = ""
	knob.Parent = bar
	corner(knob,20)

	valueLabel.Text = tostring(default)

	local draggingSlider = false
	local function setValue(x)
		local percent = math.clamp((x-bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		local value = math.round(min + (max-min)*percent)
		local p = (value-min) / (max-min)
		fill.Size = UDim2.new(p,0,1,0)
		knob.Position = UDim2.new(p,0,.5,0)
		valueLabel.Text = tostring(value)
		callback(value)
	end

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
			setValue(input.Position.X)
		end
	end)

	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
			setValue(input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			setValue(input.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end)

	return function(value)
		local p = (value-min)/(max-min)
		fill.Size = UDim2.new(p,0,1,0)
		knob.Position = UDim2.new(p,0,.5,0)
		valueLabel.Text = tostring(value)
		callback(value)
	end
end

-- BASS, MID, TREBLE
local setBass = eqSlider("BASS", EQ_MIN, EQ_MAX, 0, function(v) bassValue = v updateEqualizers() end)
local setMid = eqSlider("MID", EQ_MIN, EQ_MAX, 0, function(v) midValue = v updateEqualizers() end)
local setTreble = eqSlider("TREBLE", EQ_MIN, EQ_MAX, 0, function(v) trebleValue = v updateEqualizers() end)

-- PROTECTION BUTTON
local protectionBtn = Instance.new("TextButton")
protectionBtn.Size = UDim2.new(1,-10,0,42)
protectionBtn.BackgroundColor3 = Color3.fromRGB(35, 100, 60)
protectionBtn.Text = "EAR PROTECTION: ON"
protectionBtn.TextColor3 = WHITE
protectionBtn.Font = PANEL_FONT
protectionBtn.TextSize = 14
protectionBtn.TextXAlignment = Enum.TextXAlignment.Left
protectionBtn.LayoutOrder = 20
protectionBtn.Parent = eqPage
corner(protectionBtn,11)

protectionBtn.Activated:Connect(function()
	PROTECTION_ON = not PROTECTION_ON
	updateProtection()
	setVolume(userVolume)
	if PROTECTION_ON then
		protectionBtn.Text = "EAR PROTECTION: ON"
		protectionBtn.BackgroundColor3 = Color3.fromRGB(35, 100, 60)
	else
		protectionBtn.Text = "EAR PROTECTION: OFF"
		protectionBtn.BackgroundColor3 = Color3.fromRGB(100, 45, 45)
	end
end)

-- RESET BUTTON
local resetEqBtn = Instance.new("TextButton")
resetEqBtn.Size = UDim2.new(1,-10,0,40)
resetEqBtn.BackgroundColor3 = BLUE
resetEqBtn.Text = "RESET"
resetEqBtn.TextColor3 = WHITE
resetEqBtn.Font = PANEL_FONT
resetEqBtn.TextSize = 14
resetEqBtn.LayoutOrder = 21
resetEqBtn.Parent = eqPage
corner(resetEqBtn,11)

resetEqBtn.Activated:Connect(function()
	setBass(0)
	setMid(0)
	setTreble(0)
	PROTECTION_ON = true
	protectionBtn.Text = "EAR PROTECTION: ON"
	protectionBtn.BackgroundColor3 = Color3.fromRGB(35, 100, 60)
	updateProtection()
end)

-- FLING PLAYERS UI
local SelectedTarget = nil
local PlayerCheckboxes = {}
local FlingActive = false
getgenv().OldPos = nil
getgenv().FPDH = workspace.FallenPartsDestroyHeight

local flingTitle = Instance.new("TextLabel")
flingTitle.Size = UDim2.new(1,-5,0,25)
flingTitle.BackgroundTransparency = 1
flingTitle.Text = "FLING PLAYERS"
flingTitle.TextColor3 = WHITE
flingTitle.Font = PANEL_FONT
flingTitle.TextSize = 16
flingTitle.TextXAlignment = Enum.TextXAlignment.Left
flingTitle.LayoutOrder = 1
flingTitle.Parent = flingPage

local flingStatus = Instance.new("TextLabel")
flingStatus.Size = UDim2.new(1,-5,0,25)
flingStatus.BackgroundTransparency = 1
flingStatus.Text = "SELECT A TARGET TO FLING"
flingStatus.TextColor3 = GRAY
flingStatus.Font = PANEL_FONT
flingStatus.TextSize = 12
flingStatus.TextXAlignment = Enum.TextXAlignment.Left
flingStatus.LayoutOrder = 2
flingStatus.Parent = flingPage

local flingSelectionFrame = Instance.new("Frame")
flingSelectionFrame.Size = UDim2.new(1,-5,0,130)
flingSelectionFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
flingSelectionFrame.BackgroundTransparency = .93
flingSelectionFrame.LayoutOrder = 3
flingSelectionFrame.Parent = flingPage
corner(flingSelectionFrame,10)

local flingPlayerScroll = Instance.new("ScrollingFrame")
flingPlayerScroll.Size = UDim2.new(1,-10,1,-10)
flingPlayerScroll.Position = UDim2.fromOffset(5,5)
flingPlayerScroll.BackgroundTransparency = 1
flingPlayerScroll.BorderSizePixel = 0
flingPlayerScroll.ScrollBarThickness = 4
flingPlayerScroll.CanvasSize = UDim2.new()
flingPlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
flingPlayerScroll.Parent = flingSelectionFrame

local flingPlayerLayout = Instance.new("UIListLayout")
flingPlayerLayout.Padding = UDim.new(0,5)
flingPlayerLayout.SortOrder = Enum.SortOrder.LayoutOrder
flingPlayerLayout.Parent = flingPlayerScroll

local flingButtonsContainer = Instance.new("Frame")
flingButtonsContainer.Size = UDim2.new(1,-5,0,40)
flingButtonsContainer.BackgroundTransparency = 1
flingButtonsContainer.LayoutOrder = 4
flingButtonsContainer.Parent = flingPage

local flingStartButton = Instance.new("TextButton")
flingStartButton.Size = UDim2.new(0.48,0,1,0)
flingStartButton.Position = UDim2.new(0,0,0,0)
flingStartButton.BackgroundColor3 = Color3.fromRGB(0,180,0)
flingStartButton.Text = "START"
flingStartButton.TextColor3 = WHITE
flingStartButton.Font = PANEL_FONT
flingStartButton.TextSize = 11
flingStartButton.Parent = flingButtonsContainer
corner(flingStartButton,8)

local flingStopButton = Instance.new("TextButton")
flingStopButton.Size = UDim2.new(0.48,0,1,0)
flingStopButton.Position = UDim2.new(0.52,0,0,0)
flingStopButton.BackgroundColor3 = Color3.fromRGB(180,0,0)
flingStopButton.Text = "STOP"
flingStopButton.TextColor3 = WHITE
flingStopButton.Font = PANEL_FONT
flingStopButton.TextSize = 11
flingStopButton.Parent = flingButtonsContainer
corner(flingStopButton,8)

local antiFlingButton = Instance.new("TextButton")
antiFlingButton.Size = UDim2.new(1,-5,0,38)
antiFlingButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
antiFlingButton.BackgroundTransparency = .91
antiFlingButton.Text = "  ANTI FLING"
antiFlingButton.TextColor3 = WHITE
antiFlingButton.Font = PANEL_FONT
antiFlingButton.TextSize = 13
antiFlingButton.TextXAlignment = Enum.TextXAlignment.Left
antiFlingButton.AutoButtonColor = false
antiFlingButton.LayoutOrder = 5
antiFlingButton.Parent = flingPage
corner(antiFlingButton,8)

antiFlingButton.Activated:Connect(function()
	task.spawn(function()
		pcall(function()
			loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-anti-fling-script-241540"))()
		end)
	end)
end)

local function RefreshFlingPlayerList()
	for _, child in pairs(flingPlayerScroll:GetChildren()) do
		if child ~= flingPlayerLayout then child:Destroy() end
	end
	PlayerCheckboxes = {}
	local PlayerList = Players:GetPlayers()
	table.sort(PlayerList, function(a, b) return a.Name:lower() < b.Name:lower() end)
	local layoutOrder = 1
	for _, player in ipairs(PlayerList) do
		if player ~= Player then
			local PlayerEntry = Instance.new("Frame")
			PlayerEntry.Size = UDim2.new(1,-5,0,30)
			PlayerEntry.BackgroundColor3 = Color3.fromRGB(50,50,50)
			PlayerEntry.LayoutOrder = layoutOrder
			PlayerEntry.Parent = flingPlayerScroll
			corner(PlayerEntry,7)
			
			local Checkbox = Instance.new("TextButton")
			Checkbox.Size = UDim2.fromOffset(24,24)
			Checkbox.Position = UDim2.fromOffset(3,3)
			Checkbox.BackgroundColor3 = Color3.fromRGB(70,70,70)
			Checkbox.Text = ""
			Checkbox.Parent = PlayerEntry
			corner(Checkbox,5)
			
			local Checkmark = Instance.new("TextLabel")
			Checkmark.Size = UDim2.new(1,0,1,0)
			Checkmark.BackgroundTransparency = 1
			Checkmark.Text = "✓"
			Checkmark.TextColor3 = Color3.fromRGB(0,255,0)
			Checkmark.TextSize = 16
			Checkmark.Font = Enum.Font.SourceSansBold
			Checkmark.Visible = SelectedTarget == player
			Checkmark.Parent = Checkbox
			
			local NameLabel = Instance.new("TextLabel")
			NameLabel.Size = UDim2.new(1,-35,1,0)
			NameLabel.Position = UDim2.fromOffset(30,0)
			NameLabel.BackgroundTransparency = 1
			NameLabel.Text = player.Name:upper()
			NameLabel.TextColor3 = WHITE
			NameLabel.TextSize = 13
			NameLabel.Font = PANEL_FONT
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.Parent = PlayerEntry
			
			local ClickArea = Instance.new("TextButton")
			ClickArea.Size = UDim2.new(1,0,1,0)
			ClickArea.BackgroundTransparency = 1
			ClickArea.Text = ""
			ClickArea.ZIndex = 2
			ClickArea.Parent = PlayerEntry
			
			ClickArea.MouseButton1Click:Connect(function()
				if SelectedTarget == player then
					SelectedTarget = nil
					Checkmark.Visible = false
				else
					if SelectedTarget then
						local oldCheckbox = PlayerCheckboxes[SelectedTarget.Name]
						if oldCheckbox then oldCheckbox.Checkmark.Visible = false end
					end
					SelectedTarget = player
					Checkmark.Visible = true
				end
				UpdateFlingStatus()
			end)
			
			PlayerCheckboxes[player.Name] = {Entry = PlayerEntry, Checkmark = Checkmark}
			layoutOrder = layoutOrder + 1
		end
	end
end

local function UpdateFlingStatus()
	if FlingActive then
		if SelectedTarget then
			flingStatus.Text = "FLINGING: " .. SelectedTarget.Name:upper()
			flingStatus.TextColor3 = Color3.fromRGB(255,80,80)
		else
			flingStatus.Text = "NO TARGET SELECTED"
			flingStatus.TextColor3 = Color3.fromRGB(255,80,80)
		end
	else
		if SelectedTarget then
			flingStatus.Text = "TARGET: " .. SelectedTarget.Name:upper()
			flingStatus.TextColor3 = Color3.fromRGB(0,255,0)
		else
			flingStatus.Text = "SELECT A TARGET TO FLING"
			flingStatus.TextColor3 = GRAY
		end
	end
end

local function FlingMessage(TitleMsg, TextMsg, Time)
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = TitleMsg,
		Text = TextMsg,
		Duration = Time or 5
	})
end

local function SkidFling(TargetPlayer)
	local Character = Player.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Humanoid and Humanoid.RootPart
	local TCharacter = TargetPlayer.Character
	if not TCharacter then return end
	local THumanoid, TRootPart, THead, Accessory, Handle
	if TCharacter:FindFirstChildOfClass("Humanoid") then THumanoid = TCharacter:FindFirstChildOfClass("Humanoid") end
	if THumanoid and THumanoid.RootPart then TRootPart = THumanoid.RootPart end
	if TCharacter:FindFirstChild("Head") then THead = TCharacter.Head end
	if TCharacter:FindFirstChildOfClass("Accessory") then Accessory = TCharacter:FindFirstChildOfClass("Accessory") end
	if Accessory and Accessory:FindFirstChild("Handle") then Handle = Accessory.Handle end
	if Character and Humanoid and RootPart then
		if RootPart.Velocity.Magnitude < 50 then getgenv().OldPos = RootPart.CFrame end
		if THumanoid and THumanoid.Sit then return FlingMessage("Error", TargetPlayer.Name .. " is sitting", 2) end
		if THead then workspace.CurrentCamera.CameraSubject = THead
		elseif Handle then workspace.CurrentCamera.CameraSubject = Handle
		elseif THumanoid and TRootPart then workspace.CurrentCamera.CameraSubject = THumanoid end
		if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end
		local FPos = function(BasePart, Pos, Ang)
			RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
			Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
			RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
			RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
		end
		local SFBasePart = function(BasePart)
			local TimeToWait = 2
			local Time = tick()
			local Angle = 0
			repeat
				if RootPart and THumanoid then
					if BasePart.Velocity.Magnitude < 50 then
						Angle = Angle + 100
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
						task.wait()
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
						task.wait()
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle),0 ,0))
						task.wait()
						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
					else
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
						FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
						task.wait()
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()
					end
				end
			until Time + TimeToWait < tick() or not FlingActive
		end
		workspace.FallenPartsDestroyHeight = 0/0
		local BV = Instance.new("BodyVelocity")
		BV.Parent = RootPart
		BV.Velocity = Vector3.new(0, 0, 0)
		BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		if TRootPart then SFBasePart(TRootPart)
		elseif THead then SFBasePart(THead)
		elseif Handle then SFBasePart(Handle)
		else return FlingMessage("Error", TargetPlayer.Name .. " has no valid parts", 2) end
		BV:Destroy()
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = Humanoid
		if getgenv().OldPos then
			repeat
				RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
				Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
				Humanoid:ChangeState("GettingUp")
				for _, part in pairs(Character:GetChildren()) do
					if part:IsA("BasePart") then part.Velocity, part.RotVelocity = Vector3.new(), Vector3.new() end
				end
				task.wait()
			until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
			workspace.FallenPartsDestroyHeight = getgenv().FPDH
		end
	else
		return FlingMessage("Error", "Your character is not ready", 2)
	end
end

local function StartFling()
	if FlingActive then return end
	if not SelectedTarget then
		flingStatus.Text = "NO TARGET SELECTED!"
		flingStatus.TextColor3 = Color3.fromRGB(255,80,80)
		task.wait(1)
		UpdateFlingStatus()
		return
	end
	FlingActive = true
	UpdateFlingStatus()
	FlingMessage("Started", "Flinging " .. SelectedTarget.Name, 2)
	task.spawn(function()
		while FlingActive and SelectedTarget and SelectedTarget.Parent do
			SkidFling(SelectedTarget)
			task.wait(0.5)
		end
		if FlingActive then
			FlingActive = false
			UpdateFlingStatus()
		end
	end)
end

local function StopFling()
	if not FlingActive then return end
	FlingActive = false
	UpdateFlingStatus()
	FlingMessage("Stopped", "Fling has been stopped", 2)
end

flingStartButton.Activated:Connect(StartFling)
flingStopButton.Activated:Connect(StopFling)

Players.PlayerAdded:Connect(function() RefreshFlingPlayerList() UpdateFlingStatus() end)
Players.PlayerRemoving:Connect(function(player)
	if SelectedTarget == player then SelectedTarget = nil StopFling() end
	RefreshFlingPlayerList()
	UpdateFlingStatus()
end)

RefreshFlingPlayerList()
UpdateFlingStatus()

-- MINIMIZE / REOPEN
local minimized = false
local animationBusy = false
local normalSize = UDim2.fromOffset(380,260)
local minimizedSize = UDim2.fromOffset(0,0)

local function minimize()
	if minimized or animationBusy then return end
	animationBusy = true
	minimized = true
	local tween = TweenService:Create(mainFrame, TweenInfo.new(.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = minimizedSize})
	tween:Play()
	tween.Completed:Connect(function()
		mainFrame.Visible = false
		if not IS_PC then reopenButton.Visible = true end
		animationBusy = false
	end)
end

local function reopen()
	if not minimized or animationBusy then return end
	animationBusy = true
	minimized = false
	reopenButton.Visible = false
	mainFrame.Visible = true
	mainFrame.Size = minimizedSize
	local tween = TweenService:Create(mainFrame, TweenInfo.new(.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = normalSize})
	tween:Play()
	tween.Completed:Connect(function() animationBusy = false end)
end

if minimizeButton then minimizeButton.Activated:Connect(minimize) end
reopenButton.Activated:Connect(reopen)

if IS_PC then
	UserInputService.InputBegan:Connect(function(input,processed)
		if processed then return end
		if input.KeyCode == minimizeKey then
			if minimized then reopen() else minimize() end
		end
	end)
end

closeButton.Activated:Connect(function()
	StopFling()
	screenGui.Enabled = false
	mainFrame.Visible = false
	reopenButton.Visible = false
end)

-- LOGIN LOGIC
local function unlock()
	if passwordBox.Text == PASSWORD then
		loginGui:Destroy()
		screenGui.Enabled = true
		mainFrame.Visible = true
	else
		errorLabel.Text = T.WRONG_PASSWORD
		passwordBox.Text = ""
		task.delay(2, function()
			if errorLabel then errorLabel.Text = "" end
		end)
	end
end

enterButton.Activated:Connect(unlock)
passwordBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then unlock() end
end)

print("MADE BY SAM")
