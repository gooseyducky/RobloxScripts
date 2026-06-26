-- use the new menu has a decent chunk of the stuff here but other new stuff. this will not be updated any more.

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JBClientGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local player = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local suspensionActive = false
local flyActive = false
local neonActive = false
local rainbowActive = false
local espActive = false
local handlingActive = false
local flyIntensity = 0.5
local handlingIntensity = 0.1

local notificationContainer = Instance.new("Frame")
notificationContainer.Name = "NotificationContainer"
notificationContainer.Size = UDim2.new(0, 250, 1, 0)
notificationContainer.Position = UDim2.new(1, -260, 0, 10)
notificationContainer.BackgroundTransparency = 1
notificationContainer.Parent = screenGui

local notificationLayout = Instance.new("UIListLayout")
notificationLayout.Padding = UDim.new(0, 10)
notificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
notificationLayout.Parent = notificationContainer

local function showNotification(title, message)
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(1, 0, 0, 60)
	notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	notif.BackgroundTransparency = 0.1
	notif.LayoutOrder = #notificationContainer:GetChildren()
	notif.Parent = notificationContainer

	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 8)
	notifCorner.Parent = notif

	local notifStroke = Instance.new("UIStroke")
	notifStroke.Color = Color3.fromRGB(255, 102, 0)
	notifStroke.Thickness = 1.5
	notifStroke.Parent = notif

	local titleTxt = Instance.new("TextLabel")
	titleTxt.Size = UDim2.new(1, -20, 0, 20)
	titleTxt.Position = UDim2.new(0, 10, 0, 8)
	titleTxt.BackgroundTransparency = 1
	titleTxt.Text = title
	titleTxt.TextColor3 = Color3.fromRGB(255, 102, 0)
	titleTxt.Font = Enum.Font.GothamBold
	titleTxt.TextSize = 13
	titleTxt.TextXAlignment = Enum.TextXAlignment.Left
	titleTxt.Parent = notif

	local msgTxt = Instance.new("TextLabel")
	msgTxt.Size = UDim2.new(1, -20, 0, 25)
	msgTxt.Position = UDim2.new(0, 10, 0, 26)
	msgTxt.BackgroundTransparency = 1
	msgTxt.Text = message
	msgTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
	msgTxt.Font = Enum.Font.Gotham
	msgTxt.TextSize = 11
	msgTxt.TextXAlignment = Enum.TextXAlignment.Left
	msgTxt.TextWrapped = true
	msgTxt.Parent = notif

	notif.Position = UDim2.new(1, 0, 0, 0)
	notif:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)

	task.delay(3, function()
		if notif and notif.Parent then
			notif:TweenPosition(UDim2.new(1, 10, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.25, true, function()
				notif:Destroy()
			end)
		end
	end)
end

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 320, 0, 320) 
frame.Position = UDim2.new(0.5, -160, 0.35, -160)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0 
frame.ClipsDescendants = false
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = frame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 102, 0)
uiStroke.Thickness = 2 
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Parent = frame

local resizeHandle = Instance.new("ImageButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 16, 0, 16)
resizeHandle.Position = UDim2.new(1, -16, 1, -16)
resizeHandle.BackgroundTransparency = 1
resizeHandle.Image = "rbxassetid://6031094067"
resizeHandle.ImageColor3 = Color3.fromRGB(255, 102, 0)
resizeHandle.ZIndex = 10
resizeHandle.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -80, 0, 30)
titleLabel.Position = UDim2.new(0, 15, 0, 15)
titleLabel.BackgroundTransparency = 1 
titleLabel.Text = "JB client"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) 
titleLabel.Font = Enum.Font.GothamBold 
titleLabel.TextSize = 24
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = frame

local subtextLabel = Instance.new("TextLabel")
subtextLabel.Name = "SubtextLabel"
subtextLabel.Size = UDim2.new(1, -80, 0, 15)
subtextLabel.Position = UDim2.new(0, 15, 0, 45)
subtextLabel.BackgroundTransparency = 1 
subtextLabel.Text = "by @.gooseyduck on discord"
subtextLabel.TextColor3 = Color3.fromRGB(180, 180, 180) 
subtextLabel.Font = Enum.Font.Gotham
subtextLabel.TextSize = 12
subtextLabel.TextXAlignment = Enum.TextXAlignment.Left
subtextLabel.Parent = frame

local vehicleDisplayLabel = Instance.new("TextLabel")
vehicleDisplayLabel.Name = "VehicleDisplayLabel"
vehicleDisplayLabel.Size = UDim2.new(0.9, 0, 0, 30)
vehicleDisplayLabel.Position = UDim2.new(0.05, 0, 0, 70)
vehicleDisplayLabel.BackgroundTransparency = 1 
vehicleDisplayLabel.Text = "Closest Vehicle: None"
vehicleDisplayLabel.TextColor3 = Color3.fromRGB(255, 150, 50) 
vehicleDisplayLabel.Font = Enum.Font.GothamSemibold
vehicleDisplayLabel.TextSize = 14
vehicleDisplayLabel.TextWrapped = true
vehicleDisplayLabel.Parent = frame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ButtonContainer"
scrollingFrame.Size = UDim2.new(0.9, 0, 1, -130) 
scrollingFrame.Position = UDim2.new(0.05, 0, 0, 110)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 4
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 102, 0) 
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 1225)
scrollingFrame.Parent = frame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 10) 
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = scrollingFrame

local function createButton(name, text, color, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0.95, 0, 0, 45) 
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.LayoutOrder = order
	btn.Parent = scrollingFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	return btn
end

local scanButton = createButton("ScanButton", "Get Closest Vehicle", Color3.fromRGB(255, 102, 0), 1)
local tpButton = createButton("TeleportButton", "Teleport to Vehicle", Color3.fromRGB(230, 126, 34), 2)
local suspensionButton = createButton("SuspensionButton", "Max Suspension: OFF", Color3.fromRGB(40, 40, 40), 3)
local setSuspensionButton = createButton("SetSuspensionButton", "Set Suspension Height", Color3.fromRGB(255, 102, 0), 4)

local inputTextBox = Instance.new("TextBox")
inputTextBox.Name = "SuspensionInputBox"
inputTextBox.Size = UDim2.new(0.95, 0, 0, 35)
inputTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputTextBox.PlaceholderText = "Enter height number here"
inputTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
inputTextBox.Font = Enum.Font.Gotham
inputTextBox.TextSize = 13
inputTextBox.Text = ""
inputTextBox.LayoutOrder = 5
inputTextBox.Parent = scrollingFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = inputTextBox

local inputBorder = Instance.new("UIStroke")
inputBorder.Color = Color3.fromRGB(100, 100, 100)
inputBorder.Thickness = 1
inputBorder.Parent = inputTextBox

local flyButton = createButton("SpeedButton", "Vehicle Speed: OFF", Color3.fromRGB(40, 40, 40), 6)

local flyTextBox = Instance.new("TextBox")
flyTextBox.Name = "SpeedIntensityBox"
flyTextBox.Size = UDim2.new(0.95, 0, 0, 35)
flyTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
flyTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
flyTextBox.PlaceholderText = "Speed Intensity (Default: 0.5)"
flyTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
flyTextBox.Font = Enum.Font.Gotham
flyTextBox.TextSize = 13
flyTextBox.Text = "0.5"
flyTextBox.LayoutOrder = 7
flyTextBox.Parent = scrollingFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyTextBox

local flyBorder = Instance.new("UIStroke")
flyBorder.Color = Color3.fromRGB(100, 100, 100)
flyBorder.Thickness = 1
flyBorder.Parent = flyTextBox

local freezeButton = createButton("FreezeButton", "Emergency Stop / Freeze", Color3.fromRGB(231, 76, 60), 8)
local jumpButton = createButton("JumpButton", "Launch Upward (Jump)", Color3.fromRGB(52, 152, 219), 9)
local spinButton = createButton("SpinButton", "Spin Vehicle", Color3.fromRGB(155, 89, 182), 10)
local flattenButton = createButton("FlattenButton", "Flatten Vehicle (2D)", Color3.fromRGB(39, 174, 96), 11)
local colorButton = createButton("ColorButton", "Random Vehicle Color", Color3.fromRGB(255, 102, 0), 12)
local neonButton = createButton("NeonButton", "Toggle Neon Material: OFF", Color3.fromRGB(40, 40, 40), 13)
local rainbowButton = createButton("RainbowButton", "Toggle Rainbow Loop: OFF", Color3.fromRGB(40, 40, 40), 14)
local glassButton = createButton("GlassButton", "Make Vehicle Glass / Transparent", Color3.fromRGB(0, 180, 216), 15)
local espButton = createButton("EspButton", "Player ESP: OFF", Color3.fromRGB(40, 40, 40), 16)
local handlingButton = createButton("HandlingButton", "Better Handling: OFF", Color3.fromRGB(40, 40, 40), 17)

local handlingTextBox = Instance.new("TextBox")
handlingTextBox.Name = "HandlingIntensityBox"
handlingTextBox.Size = UDim2.new(0.95, 0, 0, 35)
handlingTextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
handlingTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
handlingTextBox.PlaceholderText = "Handling Intensity (Default: 0.1)"
handlingTextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
handlingTextBox.Font = Enum.Font.Gotham
handlingTextBox.TextSize = 13
handlingTextBox.Text = "0.1"
handlingTextBox.LayoutOrder = 18
handlingTextBox.Parent = scrollingFrame

local handlingCorner = Instance.new("UICorner")
handlingCorner.CornerRadius = UDim.new(0, 6)
handlingCorner.Parent = handlingTextBox

local handlingBorder = Instance.new("UIStroke")
handlingBorder.Color = Color3.fromRGB(100, 100, 100)
handlingBorder.Thickness = 1
handlingBorder.Parent = handlingTextBox

local maxSeasonButton = createButton("MaxSeasonButton", "Max Season Level", Color3.fromRGB(230, 126, 34), 19)
local dupMarkerButton = createButton("DupMarkerButton", "Duplicate World Marker", Color3.fromRGB(142, 68, 173), 20)
local addCashButton = createButton("AddCashButton", "Add $100M Cash", Color3.fromRGB(46, 204, 113), 21)
local giveItemButton = createButton("GiveItemButton", "Give Tom Pearl Item", Color3.fromRGB(155, 89, 182), 22)

local giveDonutButton = createButton("GiveDonutButton", "Give Donut", Color3.fromRGB(233, 30, 99), 23)

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -65, 0, 10)
minimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 16
minimizeButton.Parent = frame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeButton

local minStroke = Instance.new("UIStroke")
minStroke.Color = Color3.fromRGB(255, 102, 0)
minStroke.Thickness = 1
minStroke.Parent = minimizeButton

local unloadButton = Instance.new("TextButton")
unloadButton.Name = "UnloadButton"
unloadButton.Size = UDim2.new(0, 25, 0, 25)
unloadButton.Position = UDim2.new(1, -35, 0, 10)
unloadButton.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
unloadButton.Text = "X"
unloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadButton.Font = Enum.Font.GothamBold
unloadButton.TextSize = 14
unloadButton.Parent = frame

local unloadCorner = Instance.new("UICorner")
unloadCorner.CornerRadius = UDim.new(0, 4)
unloadCorner.Parent = unloadButton

local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 110, 0, 35)
openButton.Position = UDim2.new(0, 10, 0.35, -17) 
openButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openButton.Text = "Open JB Client"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 12
openButton.Visible = false
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 6)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(255, 102, 0)
openStroke.Thickness = 2
openStroke.Parent = openButton

local unloadHint = Instance.new("TextLabel")
unloadHint.Name = "UnloadHint"
unloadHint.Size = UDim2.new(0, 100, 0, 15)
unloadHint.Position = UDim2.new(1, -110, 0, -15)
unloadHint.BackgroundTransparency = 1
unloadHint.Text = "unload menu"
unloadHint.TextColor3 = Color3.fromRGB(150, 150, 150)
unloadHint.Font = Enum.Font.Gotham
unloadHint.TextSize = 10
unloadHint.TextXAlignment = Enum.TextXAlignment.Right
unloadHint.Parent = frame

local dragging, dragInput, dragStart, startPosition
local resizing, resizeStartSize

local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(
		startPosition.X.Scale, 
		startPosition.X.Offset + delta.X, 
		startPosition.Y.Scale, 
		startPosition.Y.Offset + delta.Y
	)
end

local function updateResize(input)
	local delta = input.Position - dragStart
	local newWidth = math.max(260, resizeStartSize.X + delta.X)
	local newHeight = math.max(200, resizeStartSize.Y + delta.Y)
	frame.Size = UDim2.new(0, newWidth, 0, newHeight)
end

frame.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not resizing then
		dragging = true
		dragStart = input.Position
		startPosition = frame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

resizeHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		resizing = true
		dragStart = input.Position
		resizeStartSize = Vector2.new(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				resizing = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput then
		if dragging then
			update(input)
		elseif resizing then
			updateResize(input)
		end
	end
end)

local function findAnyPartDeep(instance)
	if instance:IsA("BasePart") then return instance end
	for _, child in ipairs(instance:GetChildren()) do
		local found = findAnyPartDeep(child)
		if found then return found end
	end
	return nil
end

local function flattenPartsDeep(instance)
	if instance:IsA("BasePart") then
		instance.Size = Vector3.new(instance.Size.X, instance.Size.Y, 0.05)
	end
	for _, child in ipairs(instance:GetChildren()) do
		flattenPartsDeep(child)
	end
end

local function colorAllPartsDeep(instance, newColor)
	if instance:IsA("BasePart") then instance.Color = newColor end
	for _, child in ipairs(instance:GetChildren()) do colorAllPartsDeep(child, newColor) end
end

local function setMaterialAllPartsDeep(instance, material)
	if instance:IsA("BasePart") then instance.Material = material end
	for _, child in ipairs(instance:GetChildren()) do setMaterialAllPartsDeep(child, material) end
end

local function setGlassPropertiesDeep(instance)
	if instance:IsA("BasePart") then
		instance.Material = Enum.Material.Glass
		instance.Transparency = 0.4
	end
	for _, child in ipairs(instance:GetChildren()) do setGlassPropertiesDeep(child) end
end

local function findClosestVehicleInstance()
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
	local vehiclesFolder = workspace:FindFirstChild("Vehicles")
	if not vehiclesFolder then return nil end
	
	local myPos = character.HumanoidRootPart.Position
	local closestVehicle = nil
	local shortestDistance = math.huge
	
	for _, vehicle in ipairs(vehiclesFolder:GetChildren()) do
		local targetPart = findAnyPartDeep(vehicle)
		if targetPart then
			local distance = (myPos - targetPart.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closestVehicle = vehicle
			end
		end
	end
	return closestVehicle, shortestDistance
end

local function createEspUi(targetPlayer)
	if targetPlayer == player then return end
	local function addUi(character)
		local head = character:WaitForChild("Head", 5)
		if not head then return end
		if head:FindFirstChild("PlayerEspTag") then head.PlayerEspTag:Destroy() end
		
		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = "PlayerEspTag"
		billboardGui.Size = UDim2.new(0, 100, 0, 30)
		billboardGui.AlwaysOnTop = true
		billboardGui.ExtentsOffset = Vector3.new(0, 2, 0)
		billboardGui.Enabled = espActive
		billboardGui.Parent = head
		
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = targetPlayer.Name
		textLabel.TextColor3 = Color3.fromRGB(255, 102, 0)
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 14
		textLabel.TextStrokeTransparency = 0
		textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel.Parent = billboardGui
	end
	if targetPlayer.Character then addUi(targetPlayer.Character) end
	targetPlayer.CharacterAdded:Connect(addUi)
end

local function removeEspUi()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Head") then
			local tag = p.Character.Head:FindFirstChild("PlayerEspTag")
			if tag then tag:Destroy() end
		end
	end
end

local function updateEspVisibility()
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild("Head") then
			local tag = p.Character.Head:FindFirstChild("PlayerEspTag")
			if tag then tag.Enabled = espActive end
		end
	end
end

scanButton.MouseButton1Click:Connect(function()
	local vehicle, distance = findClosestVehicleInstance()
	if vehicle then
		vehicleDisplayLabel.Text = string.format("Closest Vehicle: %s (%.1f studs)", vehicle.Name, distance)
		showNotification("Vehicle Scan", "Found closest vehicle: " .. vehicle.Name)
	else
		vehicleDisplayLabel.Text = "Closest Vehicle: None found"
		showNotification("Vehicle Scan", "No vehicles found in area.")
	end
end)

tpButton.MouseButton1Click:Connect(function()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local vehicle = findClosestVehicleInstance()
		if vehicle then
			local physicalPart = findAnyPartDeep(vehicle)
			if physicalPart then
				character.HumanoidRootPart.CFrame = physicalPart.CFrame * CFrame.new(0, 4, 0)
				showNotification("Teleport Success", "Teleported to " .. vehicle.Name)
			end
		else
			vehicleDisplayLabel.Text = "Error: No vehicle found to TP to!"
			showNotification("Teleport Error", "No vehicle nearby to teleport to.")
		end
	end
end)

suspensionButton.MouseButton1Click:Connect(function()
	suspensionActive = not suspensionActive
	if suspensionActive then
		suspensionButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113) 
		suspensionButton.Text = "Max Suspension: ON"
		local vehicle = findClosestVehicleInstance()
		if vehicle and vehicle:GetAttribute("GarageSuspensionHeight") ~= nil then
			vehicle:SetAttribute("GarageSuspensionHeight", 3)
		end
		showNotification("Suspension Mod", "Max Suspension Height activated.")
	else
		suspensionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) 
		suspensionButton.Text = "Max Suspension: OFF"
		local vehicle = findClosestVehicleInstance()
		if vehicle and vehicle:GetAttribute("GarageSuspensionHeight") ~= nil then
			vehicle:SetAttribute("GarageSuspensionHeight", 1)
		end
		showNotification("Suspension Mod", "Suspension reset to defaults.")
	end
end)

setSuspensionButton.MouseButton1Click:Connect(function()
	local numericValue = tonumber(inputTextBox.Text)
	if numericValue then
		local vehicle = findClosestVehicleInstance()
		if vehicle then
			if vehicle:GetAttribute("GarageSuspensionHeight") ~= nil then
				vehicle:SetAttribute("GarageSuspensionHeight", numericValue)
				inputTextBox.BorderStroke.Color = Color3.fromRGB(46, 204, 113)
				showNotification("Suspension Height", "Custom height set to: " .. numericValue)
				task.wait(0.5)
				inputTextBox.BorderStroke.Color = Color3.fromRGB(100, 100, 100)
			else
				vehicleDisplayLabel.Text = "Error: Attribute missing on vehicle!"
			end
		else
			vehicleDisplayLabel.Text = "Error: No vehicle nearby!"
		end
	else
		inputTextBox.Text = ""
		inputTextBox.PlaceholderText = "Invalid number!"
		inputTextBox.BorderStroke.Color = Color3.fromRGB(255, 30, 30)
		task.wait(1)
		inputTextBox.PlaceholderText = "Enter height number here"
		inputTextBox.BorderStroke.Color = Color3.fromRGB(100, 100, 100)
	end
end)

flyButton.MouseButton1Click:Connect(function()
	flyActive = not flyActive
	if flyActive then
		flyButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113) 
		flyButton.Text = "Vehicle Speed: ON"
		showNotification("Speed Mod", "Vehicle Speed multi-vector active.")
	else
		flyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40) 
		flyButton.Text = "Vehicle Speed: OFF"
		showNotification("Speed Mod", "Vehicle Speed deactivated.")
	end
end)

flyTextBox:GetPropertyChangedSignal("Text"):Connect(function()
	local value = tonumber(flyTextBox.Text)
	if value then
		flyIntensity = value
		flyTextBox.BorderStroke.Color = Color3.fromRGB(100, 100, 100)
	else
		flyTextBox.BorderStroke.Color = Color3.fromRGB(255, 30, 30) 
	end
end)

freezeButton.MouseButton1Click:Connect(function()
	local vehicle = findClosestVehicleInstance()
	if vehicle then
		local physicalPart = findAnyPartDeep(vehicle)
		if physicalPart then
			physicalPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			physicalPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			showNotification("Emergency Brake", "Vehicle momentum killed cleanly.")
		end
	end
end)

jumpButton.MouseButton1Click:Connect(function()
	local vehicle = findClosestVehicleInstance()
	if vehicle then
		local physicalPart = findAnyPartDeep(vehicle)
		if physicalPart then
			physicalPart.AssemblyLinearVelocity = physicalPart.AssemblyLinearVelocity + Vector3.new(0, 50, 0)
			showNotification("Action", "Applied vertical upward impulse.")
		end
	end
end)

spinButton.MouseButton1Click:Connect(function()
	local vehicle = findClosestVehicleInstance()
	if vehicle then
		local physicalPart = findAnyPartDeep(vehicle)
		if physicalPart then
			physicalPart.AssemblyAngularVelocity = physicalPart.AssemblyAngularVelocity + Vector3.new(0, 15, 0)
			showNotification("Action", "Applied angular yaw impulse.")
		end
	end
end)

flattenButton.MouseButton1Click:Connect(function()
	local vehicle = findClosestVehicleInstance()
	if vehicle then
		flattenPartsDeep(vehicle)
		showNotification("Visual Mod", "Crushed vehicle dimension matrix.")
	end
end)

colorButton.MouseButton1Click:Connect(function()
	local vehicle = findClosestVehicleInstance()
	if vehicle then
		local randomColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
		colorAllPartsDeep(vehicle, randomColor)
		showNotification("Visual Mod", "Random color configuration finalized.")
	end
end)

neonButton.MouseButton1Click:Connect(function()
	neonActive = not neonActive
	local vehicle = findClosestVehicleInstance()
	if vehicle then
		if neonActive then
			neonButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
			neonButton.Text = "Toggle Neon Material: ON"
			setMaterialAllPartsDeep(vehicle, Enum.Material.Neon)
			showNotification("Visual Mod", "Neon emissive rendering enabled.")
		else
			neonButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			neonButton.Text = "Toggle Neon Material: OFF"
			setMaterialAllPartsDeep(vehicle, Enum.Material.Plastic)
			showNotification("Visual Mod", "Neon texture loop closed.")
		end
	end
end)

rainbowButton.MouseButton1Click:Connect(function()
	rainbowActive = not rainbowActive
	if rainbowActive then
		rainbowButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		rainbowButton.Text = "Toggle Rainbow Loop: ON"
		showNotification("Visual Mod", "Active color loop initialized.")
	else
		rainbowButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		rainbowButton.Text = "Toggle Rainbow Loop: OFF"
		showNotification("Visual Mod", "Color iteration terminated.")
	end
end)

glassButton.MouseButton1Click:Connect(function()
	local vehicle = findClosestVehicleInstance()
	if vehicle then
		setGlassPropertiesDeep(vehicle)
		showNotification("Visual Mod", "Applied refractive glass surface layer.")
	end
end)

espButton.MouseButton1Click:Connect(function()
	espActive = not espActive
	if espActive then
		espButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		espButton.Text = "Player ESP: ON"
		updateEspVisibility()
		showNotification("ESP System", "Biometric trackers updated.")
	else
		espButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		espButton.Text = "Player ESP: OFF"
		updateEspVisibility()
		showNotification("ESP System", "Trackers dark.")
	end
end)

handlingButton.MouseButton1Click:Connect(function()
	handlingActive = not handlingActive
	if handlingActive then
		handlingButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		handlingButton.Text = "Better Handling: ON"
		showNotification("Handling Assist", "Friction torque adjustment: On.")
	else
		handlingButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		handlingButton.Text = "Better Handling: OFF"
		showNotification("Handling Assist", "Friction compensation disabled.")
	end
end)

handlingTextBox:GetPropertyChangedSignal("Text"):Connect(function()
	local value = tonumber(handlingTextBox.Text)
	if value then
		handlingIntensity = value
		handlingTextBox.BorderStroke.Color = Color3.fromRGB(100, 100, 100)
	else
		handlingTextBox.BorderStroke.Color = Color3.fromRGB(255, 30, 30)
	end
end)

maxSeasonButton.MouseButton1Click:Connect(function()
	local localPlayer = game:GetService("Players").LocalPlayer
	if localPlayer then
		pcall(function()
			localPlayer.Level = 10
			localPlayer.Exp = 825
			showNotification("Profile Config", "Profile metrics locally overwritten.")
		end)
	end
end)

dupMarkerButton.MouseButton1Click:Connect(function()
	local localPlayer = game:GetService("Players").LocalPlayer
	if localPlayer and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
		pcall(function()
			local markersGui = localPlayer:WaitForChild("PlayerGui"):WaitForChild("WorldMarkersGui")
			local targets = markersGui:GetChildren()
			if #targets >= 19 then
				local targetMarker = targets[19]
				local clonedMarker = targetMarker:Clone()
				
				if clonedMarker:IsA("GuiObject") then
					clonedMarker.Position = UDim2.new(0.5, 0, 0.5, 0)
				end
				
				clonedMarker.Parent = markersGui
				showNotification("Marker Utility", "World Marker index 19 successfully duplicated locally.")
			else
				showNotification("Marker Error", "WorldMarkerGui contains fewer than 19 target elements.")
			end
		end)
	end
end)

addCashButton.MouseButton1Click:Connect(function()
	local localPlayer = game:GetService("Players").LocalPlayer
	if localPlayer then
		pcall(function()
			local stats = localPlayer:WaitForChild("leaderstats", 5)
			local moneyValue = stats and stats:FindFirstChild("Money")
			
			if moneyValue and moneyValue:IsA("ValueBase") then
				moneyValue.Value = moneyValue.Value + 100000000
				
				local cashGuiLabel = localPlayer:WaitForChild("PlayerGui")
					:WaitForChild("CashGui")
					:WaitForChild("Container")
					:WaitForChild("Content")
					:WaitForChild("ContainerTop")
					:WaitForChild("ContainerRight")
					:WaitForChild("ContainerCash")
					:WaitForChild("TextLabel")
				
				if cashGuiLabel and cashGuiLabel:IsA("TextLabel") then
					cashGuiLabel.Text = "$" .. tostring(moneyValue.Value)
				end
				
				showNotification("Economy Hack", "$100,000,000 injected into local display variables.")
			else
				showNotification("Economy Error", "Leaderstats data array or 'Money' identifier missing.")
			end
		end)
	end
end)

giveItemButton.MouseButton1Click:Connect(function()
	local localPlayer = game:GetService("Players").LocalPlayer
	if localPlayer then
		pcall(function()
			local targetBackpack = localPlayer:WaitForChild("Backpack", 3)
			if targetBackpack then
				if targetBackpack:FindFirstChild("tom pearl") then
					showNotification("Inventory Status", "Item 'tom pearl' is already present inside your inventory.")
					return
				end
				
				local customTool = Instance.new("Tool")
				customTool.Name = "tom pearl"
				customTool.RequiresHandle = false
				customTool.Tooltip = "Custom Client Added Item Instance"
				
				local starterGear = localPlayer:FindFirstChild("StarterGear")
				if starterGear then
					local toolGearCopy = customTool:Clone()
					toolGearCopy.Parent = starterGear
				end
				
				customTool.Parent = targetBackpack
				showNotification("Inventory Mod", "Successfully added item 'tom pearl' locally into backpack storage container array.")
			else
				showNotification("Inventory Error", "Unable to establish baseline hook into LocalPlayer backpack structure.")
			end
		end)
	end
end)

giveDonutButton.MouseButton1Click:Connect(function()
	pcall(function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local binder = require(ReplicatedStorage:WaitForChild("DonutExchanger"):WaitForChild("DonutExchangerBinder"))
		if binder and binder.Start then
			binder:Start()
			showNotification("Donut Dispenser", "Successfully triggered the Donut Exchanger module.")
		else
			showNotification("Donut Error", "DonutExchangerBinder layout structure could not be mapped properly.")
		end
	end)
end)

minimizeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	openButton.Visible = true
	showNotification("Client UI", "Window collapsed to side tray.")
end)

openButton.MouseButton1Click:Connect(function()
	openButton.Visible = false
	frame.Visible = true
	showNotification("Client UI", "Control terminal restored.")
end)

for _, p in ipairs(Players:GetPlayers()) do createEspUi(p) end
local playerAddedConnection = Players.PlayerAdded:Connect(createEspUi)

local loopConnection
loopConnection = RunService.Heartbeat:Connect(function(deltaTime)
	local vehicle = findClosestVehicleInstance()
	if vehicle then
		if rainbowActive then
			local hue = (tick() % 5) / 5
			colorAllPartsDeep(vehicle, Color3.fromHSV(hue, 1, 1))
		end

		local physicalPart = findAnyPartDeep(vehicle)
		if physicalPart then
			local isA = UserInputService:IsKeyDown(Enum.KeyCode.A)
			local isD = UserInputService:IsKeyDown(Enum.KeyCode.D)
			
			if handlingActive then
				if isA then
					physicalPart.AssemblyAngularVelocity = physicalPart.AssemblyAngularVelocity + Vector3.new(0, handlingIntensity, 0)
				elseif isD then
					physicalPart.AssemblyAngularVelocity = physicalPart.AssemblyAngularVelocity + Vector3.new(0, -handlingIntensity, 0)
				end
			end

			if flyActive then
				local character = player.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					local moveDirection = Vector3.new(0, 0, 0)
					local forwardVector = character.HumanoidRootPart.CFrame.LookVector
					local rightVector = character.HumanoidRootPart.CFrame.RightVector
					
					local isW = UserInputService:IsKeyDown(Enum.KeyCode.W)
					local isS = UserInputService:IsKeyDown(Enum.KeyCode.S)
					
					if isW then moveDirection = moveDirection + forwardVector
					elseif isS then moveDirection = moveDirection - forwardVector end
					
					if isA then
						local leftVector = -rightVector
						if isW or isS then
							moveDirection = ((isW and forwardVector or -forwardVector) + leftVector) / 2
						else moveDirection = leftVector end
					elseif isD then
						if isW or isS then
							moveDirection = ((isW and forwardVector or -forwardVector) + rightVector) / 2
						else moveDirection = rightVector end
					end
					
					if moveDirection.Magnitude > 0 then
						physicalPart.AssemblyLinearVelocity = physicalPart.AssemblyLinearVelocity + (moveDirection.Unit * flyIntensity)
					end
				end
			end
		end
	end
end)

unloadButton.MouseButton1Click:Connect(function()
	flyActive = false 
	rainbowActive = false
	espActive = false
	handlingActive = false
	if loopConnection then loopConnection:Disconnect() end
	if playerAddedConnection then playerAddedConnection:Disconnect() end
	removeEspUi()
	screenGui:Destroy()
end)
