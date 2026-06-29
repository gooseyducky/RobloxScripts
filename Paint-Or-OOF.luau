-- game: https://www.roblox.com/games/91177184562415/Paint-Or-OOF

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local hexBoxPath = "PlayerGui.PaintUI.Panel.Body.HexRow.HexBox"
local success, targetHexBox = pcall(function()
	return player:WaitForChild("PlayerGui")
		:WaitForChild("PaintUI")
		:WaitForChild("Panel")
		:WaitForChild("Body")
		:WaitForChild("HexRow")
		:WaitForChild("HexBox")
end)

local isColorPickerActive = false
local isHighlightActive = false
local isSpeedActive = false
local isBhopActive = false

local activeHighlights = {}
local spacebarHeld = false

local function createUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "UtilityModGui"
	screenGui.ResetOnSpawn = false
	
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0, 140, 0, 200)
	container.Position = UDim2.new(0, 20, 0.5, -100)
	container.BackgroundTransparency = 1
	container.Parent = screenGui
	
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Padding = UDim.new(0, 8)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = container

	local function makeButton(text, order)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 42)
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.SourceSansBold
		btn.TextSize = 13
		btn.BorderSizePixel = 0
		btn.LayoutOrder = order
		btn.Parent = container
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = btn
		return btn
	end

	local pickerBtn = makeButton("Color Picker: OFF", 1)
	local highlightBtn = makeButton("Hider Glow: OFF", 2)
	local speedBtn = makeButton("Speed 100: OFF", 3)
	local bhopBtn = makeButton("BHop: OFF", 4)
	
	screenGui.Parent = player:WaitForChild("PlayerGui")
	return pickerBtn, highlightBtn, speedBtn, bhopBtn
end

local pickerButton, highlightButton, speedButton, bhopButton = createUI()

local function updateWalkSpeed()
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = isSpeedActive and 100 or 16
		end
	end
end

player.CharacterAdded:Connect(function()
	task.wait(0.2)
	updateWalkSpeed()
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.Space then
		spacebarHeld = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space then
		spacebarHeld = false
	end
end)

RunService.RenderStepped:Connect(function()
	if not isBhopActive or not spacebarHeld then return end
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

pickerButton.MouseButton1Click:Connect(function()
	isColorPickerActive = not isColorPickerActive
	if isColorPickerActive then
		pickerButton.Text = "Color Picker: ON"
		pickerButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
	else
		pickerButton.Text = "Color Picker: OFF"
		pickerButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
end)

local function removeHighlightFromPlayer(p)
	if activeHighlights[p] then activeHighlights[p]:Destroy() activeHighlights[p] = nil end
end

local function updatePlayerHighlight(p)
	removeHighlightFromPlayer(p)
	if not isHighlightActive then return end
	if p:GetAttribute("Role") == "HIDER" and p.Character then
		local hl = Instance.new("Highlight")
		hl.FillColor = Color3.fromRGB(255, 0, 100)
		hl.FillTransparency = 0.5
		hl.OutlineColor = Color3.fromRGB(255, 255, 255)
		hl.Adornee = p.Character
		hl.Parent = p.Character
		activeHighlights[p] = hl
	end
end

highlightButton.MouseButton1Click:Connect(function()
	isHighlightActive = not isHighlightActive
	if isHighlightActive then
		highlightButton.Text = "Hider Glow: ON"
		highlightButton.BackgroundColor3 = Color3.fromRGB(235, 60, 0)
		for _, p in ipairs(Players:GetPlayers()) do updatePlayerHighlight(p) end
	else
		highlightButton.Text = "Hider Glow: OFF"
		highlightButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		for p, _ in pairs(activeHighlights) do removeHighlightFromPlayer(p) end
	end
end)

speedButton.MouseButton1Click:Connect(function()
	isSpeedActive = not isSpeedActive
	if isSpeedActive then
		speedButton.Text = "Speed 100: ON"
		speedButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
	else
		speedButton.Text = "Speed 100: OFF"
		speedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
	updateWalkSpeed()
end)

bhopButton.MouseButton1Click:Connect(function()
	isBhopActive = not isBhopActive
	if isBhopActive then
		bhopButton.Text = "BHop: ON"
		bhopButton.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
	else
		bhopButton.Text = "BHop: OFF"
		bhopButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
end)

local function colorToHex(color: Color3): string
	return string.format("#%02X%02X%02X", math.round(color.R * 255), math.round(color.G * 255), math.round(color.B * 255))
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or not isColorPickerActive then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local mouseLocation = UserInputService:GetMouseLocation()
		local unitRay = camera:ScreenPointToRay(mouseLocation.X, mouseLocation.Y)
		
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		if player.Character then params.FilterDescendantsInstances = {player.Character} end
		
		local result = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, params)
		if result and result.Instance and targetHexBox then
			local color = result.Instance:IsA("BasePart") and result.Instance.Color or result.Instance:IsA("Terrain") and result.Instance.Color3
			if color then targetHexBox.Text = colorToHex(color) end
		end
	end
end)

local function hookPlayer(p)
	p:GetAttributeChangedSignal("Role"):Connect(function() updatePlayerHighlight(p) end)
	p.CharacterAdded:Connect(function() task.wait(0.1) updatePlayerHighlight(p) end)
	p.CharacterRemoving:Connect(function() removeHighlightFromPlayer(p) end)
end
for _, p in ipairs(Players:GetPlayers()) do hookPlayer(p) end
Players.PlayerAdded:Connect(hookPlayer)
Players.PlayerRemoving:Connect(removeHighlightFromPlayer)
