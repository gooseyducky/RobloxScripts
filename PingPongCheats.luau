-- script by @.gooseyduck on discord

-- steal = skid = bum


local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local targetUniverseId = 9488359634

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PingPongGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

if game.GameId ~= targetUniverseId then
	local warnFrame = Instance.new("Frame")
	warnFrame.Name = "WarnFrame"
	warnFrame.Size = UDim2.new(0, 250, 0, 150)
	warnFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
	warnFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	warnFrame.BorderSizePixel = 0
	warnFrame.Active = true
	warnFrame.Parent = screenGui

	local warnCorner = Instance.new("UICorner")
	warnCorner.CornerRadius = UDim.new(0, 12)
	warnCorner.Parent = warnFrame

	local warnStroke = Instance.new("UIStroke")
	warnStroke.Color = Color3.fromRGB(255, 102, 0)
	warnStroke.Thickness = 3
	warnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	warnStroke.Parent = warnFrame

	local closeXButton = Instance.new("TextButton")
	closeXButton.Name = "CloseXButton"
	closeXButton.Size = UDim2.new(0, 25, 0, 25)
	closeXButton.Position = UDim2.new(1, -30, 0, 5)
	closeXButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
	closeXButton.BorderSizePixel = 0
	closeXButton.Text = "X"
	closeXButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeXButton.TextSize = 14
	closeXButton.Font = Enum.Font.SourceSansBold
	closeXButton.Parent = warnFrame

	local xCorner = Instance.new("UICorner")
	xCorner.CornerRadius = UDim.new(0, 6)
	xCorner.Parent = closeXButton

	closeXButton.MouseButton1Click:Connect(function()
		screenGui:Destroy()
	end)

	local warnLabel = Instance.new("TextLabel")
	warnLabel.Name = "WarnLabel"
	warnLabel.Size = UDim2.new(1, -20, 1, -40)
	warnLabel.Position = UDim2.new(0, 10, 0, 35)
	warnLabel.BackgroundTransparency = 1
	warnLabel.Text = "This game is not supported! please go to " .. tostring(targetUniverseId) .. " to use this menu."
	warnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	warnLabel.TextSize = 16
	warnLabel.Font = Enum.Font.SourceSansBold
	warnLabel.TextWrapped = true
	warnLabel.TextXAlignment = Enum.TextXAlignment.Center
	warnLabel.TextYAlignment = Enum.TextYAlignment.Center
	warnLabel.Parent = warnFrame

	local dragging = false
	local dragInput, dragStart, startPos

	warnFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = warnFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	warnFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			warnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	return
end

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 102, 0)
mainStroke.Thickness = 3
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, -55)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Ping Pong Client"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = mainFrame

local creditsLabel = Instance.new("TextLabel")
creditsLabel.Name = "CreditsLabel"
creditsLabel.Size = UDim2.new(1, 0, 0, 20)
creditsLabel.Position = UDim2.new(0, 0, 0, -23)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text = "By @.gooseyduck on discord"
creditsLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
creditsLabel.TextSize = 14
creditsLabel.Font = Enum.Font.SourceSans
creditsLabel.TextXAlignment = Enum.TextXAlignment.Center
creditsLabel.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ButtonScroller"
scrollingFrame.Size = UDim2.new(1, -10, 1, -20)
scrollingFrame.Position = UDim2.new(0, 5, 0, 10)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 102, 0)
scrollingFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollingFrame
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local countLabel = Instance.new("TextLabel")
countLabel.Name = "CountLabel"
countLabel.Size = UDim2.new(0, 180, 0, 30)
countLabel.BackgroundTransparency = 1
countLabel.Text = "ClientBalls Found: 0"
countLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
countLabel.TextSize = 16
countLabel.Font = Enum.Font.SourceSansBold
countLabel.TextXAlignment = Enum.TextXAlignment.Center
countLabel.LayoutOrder = 1
countLabel.Parent = scrollingFrame

local ballToggleButton = Instance.new("TextButton")
ballToggleButton.Name = "BallToggleButton"
ballToggleButton.Size = UDim2.new(0, 180, 0, 45)
ballToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ballToggleButton.BorderSizePixel = 0
ballToggleButton.Text = "Autohit ping pong balls: OFF"
ballToggleButton.TextColor3 = Color3.fromRGB(160, 160, 160)
ballToggleButton.TextSize = 14
ballToggleButton.Font = Enum.Font.SourceSansBold
ballToggleButton.LayoutOrder = 2
ballToggleButton.Parent = scrollingFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = ballToggleButton

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 102, 0)
toggleStroke.Thickness = 2
toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
toggleStroke.Parent = ballToggleButton

local flyToggleButton = Instance.new("TextButton")
flyToggleButton.Name = "FlyToggleButton"
flyToggleButton.Size = UDim2.new(0, 180, 0, 45)
flyToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyToggleButton.BorderSizePixel = 0
flyToggleButton.Text = "Fly: OFF"
flyToggleButton.TextColor3 = Color3.fromRGB(160, 160, 160)
flyToggleButton.TextSize = 14
flyToggleButton.Font = Enum.Font.SourceSansBold
flyToggleButton.LayoutOrder = 3
flyToggleButton.Parent = scrollingFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyToggleButton

local flyStroke = Instance.new("UIStroke")
flyStroke.Color = Color3.fromRGB(255, 102, 0)
flyStroke.Thickness = 2
flyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
flyStroke.Parent = flyToggleButton

local noclipButton = Instance.new("TextButton")
noclipButton.Name = "NoclipButton"
noclipButton.Size = UDim2.new(0, 180, 0, 45)
noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
noclipButton.BorderSizePixel = 0
noclipButton.Text = "Noclip: OFF"
noclipButton.TextColor3 = Color3.fromRGB(160, 160, 160)
noclipButton.TextSize = 14
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.LayoutOrder = 4
noclipButton.Parent = scrollingFrame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipButton

local noclipStroke = Instance.new("UIStroke")
noclipStroke.Color = Color3.fromRGB(255, 102, 0)
noclipStroke.Thickness = 2
noclipStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
noclipStroke.Parent = noclipButton

local gooseToolButton = Instance.new("TextButton")
gooseToolButton.Name = "GooseToolButton"
gooseToolButton.Size = UDim2.new(0, 180, 0, 45)
gooseToolButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
gooseToolButton.BorderSizePixel = 0
gooseToolButton.Text = "Goose Tool: OFF"
gooseToolButton.TextColor3 = Color3.fromRGB(160, 160, 160)
gooseToolButton.TextSize = 14
gooseToolButton.Font = Enum.Font.SourceSansBold
gooseToolButton.LayoutOrder = 5
gooseToolButton.Parent = scrollingFrame

local gooseCorner = Instance.new("UICorner")
gooseCorner.CornerRadius = UDim.new(0, 8)
gooseCorner.Parent = gooseToolButton

local gooseStroke = Instance.new("UIStroke")
gooseStroke.Color = Color3.fromRGB(255, 102, 0)
gooseStroke.Thickness = 2
gooseStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
gooseStroke.Parent = gooseToolButton

local destroyPopupsButton = Instance.new("TextButton")
destroyPopupsButton.Name = "DestroyPopupsButton"
destroyPopupsButton.Size = UDim2.new(0, 180, 0, 45)
destroyPopupsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
destroyPopupsButton.BorderSizePixel = 0
destroyPopupsButton.Text = "Destroy Popups"
destroyPopupsButton.TextColor3 = Color3.fromRGB(160, 160, 160)
destroyPopupsButton.TextSize = 14
destroyPopupsButton.Font = Enum.Font.SourceSansBold
destroyPopupsButton.LayoutOrder = 6
destroyPopupsButton.Parent = scrollingFrame

local popupsCorner = Instance.new("UICorner")
popupsCorner.CornerRadius = UDim.new(0, 8)
popupsCorner.Parent = destroyPopupsButton

local popupsStroke = Instance.new("UIStroke")
popupsStroke.Color = Color3.fromRGB(255, 102, 0)
popupsStroke.Thickness = 2
popupsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
popupsStroke.Parent = destroyPopupsButton

local addCoinsButton = Instance.new("TextButton")
addCoinsButton.Name = "AddCoinsButton"
addCoinsButton.Size = UDim2.new(0, 180, 0, 45)
addCoinsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
addCoinsButton.BorderSizePixel = 0
addCoinsButton.Text = "add 5M coins"
addCoinsButton.TextColor3 = Color3.fromRGB(160, 160, 160)
addCoinsButton.TextSize = 14
addCoinsButton.Font = Enum.Font.SourceSansBold
addCoinsButton.LayoutOrder = 7
addCoinsButton.Parent = scrollingFrame

local coinsCorner = Instance.new("UICorner")
coinsCorner.CornerRadius = UDim.new(0, 8)
coinsCorner.Parent = addCoinsButton

local coinsStroke = Instance.new("UIStroke")
coinsStroke.Color = Color3.fromRGB(255, 102, 0)
coinsStroke.Thickness = 2
coinsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
coinsStroke.Parent = addCoinsButton

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 180, 0, 45)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "Unload menu"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.LayoutOrder = 8
closeButton.Parent = scrollingFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = closeButton

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(255, 102, 0)
buttonStroke.Thickness = 2
buttonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
buttonStroke.Parent = closeButton

local function updateAbsoluteSize()
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
end
uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateAbsoluteSize)
updateAbsoluteSize()

local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local flyConnection = nil

local function startFlying()
	local character = localPlayer.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not rootPart or not humanoid then return end

	flying = true
	flyToggleButton.Text = "Fly: ON"
	flyToggleButton.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
	flyToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	humanoid.PlatformStand = true

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = rootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bodyGyro.CFrame = rootPart.CFrame
	bodyGyro.Parent = rootPart

	local camera = workspace.CurrentCamera

	flyConnection = RunService.RenderStepped:Connect(function()
		if not character or not character.Parent or not rootPart or not bodyVelocity or not bodyGyro then
			flying = false
			flyToggleButton.Text = "Fly: OFF"
			flyToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			flyToggleButton.TextColor3 = Color3.fromRGB(160, 160, 160)
			if flyConnection then flyConnection:Disconnect() end
			return
		end

		local direction = Vector3.new(0, 0, 0)
		
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			direction = direction + camera.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			direction = direction - camera.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			direction = direction - camera.CFrame.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			direction = direction + camera.CFrame.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			direction = direction + Vector3.new(0, 1, 0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			direction = direction - Vector3.new(0, 1, 0)
		end

		if direction.Magnitude > 0 then
			bodyVelocity.Velocity = direction.Unit * flySpeed
		else
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		end

		bodyGyro.CFrame = camera.CFrame
	end)
end

local function stopFlying()
	flying = false
	flyToggleButton.Text = "Fly: OFF"
	flyToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	flyToggleButton.TextColor3 = Color3.fromRGB(160, 160, 160)

	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	if bodyVelocity then
		bodyVelocity:Destroy()
		bodyVelocity = nil
	end

	if bodyGyro then
		bodyGyro:Destroy()
		bodyGyro = nil
	end

	local character = localPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
		end
	end
end

flyToggleButton.MouseButton1Click:Connect(function()
	if flying then
		stopFlying()
	else
		startFlying()
	end
end)

local noclipActive = false
local noclipConnection = nil

local function startNoclip()
	noclipActive = true
	noclipButton.Text = "Noclip: ON"
	noclipButton.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
	noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	
	noclipConnection = RunService.Stepped:Connect(function()
		local character = localPlayer.Character
		if character and noclipActive then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end)
end

local function stopNoclip()
	noclipActive = false
	noclipButton.Text = "Noclip: OFF"
	noclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	noclipButton.TextColor3 = Color3.fromRGB(160, 160, 160)
	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end
end

noclipButton.MouseButton1Click:Connect(function()
	if noclipActive then
		stopNoclip()
	else
		startNoclip()
	end
end)

local gooseToolActive = false
local currentTool = nil
local toolConnection = nil

local function createGooseTool()
	local tool = Instance.new("Tool")
	tool.Name = "goose"
	tool.RequiresHandle = false
	
	toolConnection = tool.Activated:Connect(function()
		local character = localPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid.PlatformStand = true
				task.wait(2)
				if humanoid and humanoid.Parent then
					humanoid.PlatformStand = false
				end
			end
		end
	end)
	
	tool.Parent = localPlayer:WaitForChild("Backpack")
	currentTool = tool
end

local function removeGooseTool()
	if toolConnection then
		toolConnection:Disconnect()
		toolConnection = nil
	end
	if currentTool then
		currentTool:Destroy()
		currentTool = nil
	end
	
	local character = localPlayer.Character
	if character then
		local equippedTool = character:FindFirstChild("goose")
		if equippedTool then
			equippedTool:Destroy()
		end
	end
end

gooseToolButton.MouseButton1Click:Connect(function()
	gooseToolActive = not gooseToolActive
	if gooseToolActive then
		gooseToolButton.Text = "Goose Tool: ON"
		gooseToolButton.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
		gooseToolButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		createGooseTool()
	else
		gooseToolButton.Text = "Goose Tool: OFF"
		gooseToolButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		gooseToolButton.TextColor3 = Color3.fromRGB(160, 160, 160)
		removeGooseTool()
	end
end)

closeButton.MouseButton1Click:Connect(function()
	stopFlying()
	stopNoclip()
	removeGooseTool()
	screenGui:Destroy()
end)

destroyPopupsButton.MouseButton1Click:Connect(function()
	local playerGui = localPlayer:FindFirstChild("PlayerGui")
	if playerGui then
		local gameUI = playerGui:FindFirstChild("GameUI")
		if gameUI then
			local monetization = gameUI:FindFirstChild("Monetization")
			if monetization then
				monetization:Destroy()
			end
		end
	end
end)

addCoinsButton.MouseButton1Click:Connect(function()
	local leaderstats = localPlayer:FindFirstChild("leaderstats")
	if leaderstats then
		local coins = leaderstats:FindFirstChild("Coins")
		if coins and (coins:IsA("IntValue") or coins:IsA("NumberValue")) then
			coins.Value = coins.Value + 5000000
		end
	end
end)

local ballsActive = false

local function updateBallCount()
	local count = 0
	for _, object in ipairs(workspace:GetDescendants()) do
		if object.Name == "ClientBall" and object:IsA("BasePart") then
			count = count + 1
		end
	end
	countLabel.Text = "ClientBalls Found: " .. tostring(count)
end

ballToggleButton.MouseButton1Click:Connect(function()
	ballsActive = not ballsActive
	updateBallCount()
	
	if ballsActive then
		ballToggleButton.Text = "Autohit ping pong balls: ON"
		ballToggleButton.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
		ballToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		for _, object in ipairs(workspace:GetDescendants()) do
			if object.Name == "ClientBall" and object:IsA("BasePart") then
				object.Size = Vector3.new(1000, 1000, 1000)
				object.Transparency = 1
			end
		end
	else
		ballToggleButton.Text = "Autohit ping pong balls: OFF"
		ballToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		ballToggleButton.TextColor3 = Color3.fromRGB(160, 160, 160)
		for _, object in ipairs(workspace:GetDescendants()) do
			if object.Name == "ClientBall" and object:IsA("BasePart") then
				object.Size = Vector3.new(0.5, 0.5, 0.5)
				object.Transparency = 0
			end
		end
	end
end)

task.spawn(function()
	while task.wait(1) do
		if screenGui and screenGui.Parent then
			updateBallCount()
		else
			break
		end
	end
end)

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
