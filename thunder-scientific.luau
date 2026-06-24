-- tunder scientific script my frend wanted me to make. prob wont get too much updates but its here so i might do stuff with it

if not game:GetService("RunService"):IsClient() then
	return
end

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

if not localPlayer:WaitForChild("PlayerGui", 10) then
	return
end

local existingGui = localPlayer.PlayerGui:FindFirstChild("PositionMultiplierGui")
if existingGui then
	existingGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PositionMultiplierGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = localPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 320)
frame.Position = UDim2.new(0.1, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 180, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleButton.Text = "Position Shift: OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.Parent = frame

local inputField = Instance.new("TextBox")
inputField.Size = UDim2.new(0, 180, 0, 35)
inputField.Position = UDim2.new(0, 10, 0, 55)
inputField.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
inputField.Text = "0.5"
inputField.TextColor3 = Color3.fromRGB(255, 255, 255)
inputField.Font = Enum.Font.SourceSans
inputField.TextSize = 14
inputField.PlaceholderText = "Enter boost amount..."
inputField.Parent = frame

local wardrobeButton = Instance.new("TextButton")
wardrobeButton.Size = UDim2.new(0, 180, 0, 40)
wardrobeButton.Position = UDim2.new(0, 10, 0, 120)
wardrobeButton.BackgroundColor3 = Color3.fromRGB(55, 92, 255)
wardrobeButton.Text = "Equip Nearest Uniform"
wardrobeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
wardrobeButton.Font = Enum.Font.SourceSansBold
wardrobeButton.TextSize = 14
wardrobeButton.Parent = frame

local teamButton = Instance.new("TextButton")
teamButton.Size = UDim2.new(0, 180, 0, 40)
teamButton.Position = UDim2.new(0, 10, 0, 170)
teamButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
teamButton.Text = "Set Team: Admin"
teamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teamButton.Font = Enum.Font.SourceSansBold
teamButton.TextSize = 14
teamButton.Parent = frame

local collisionButton = Instance.new("TextButton")
collisionButton.Size = UDim2.new(0, 180, 0, 40)
collisionButton.Position = UDim2.new(0, 10, 0, 220)
collisionButton.BackgroundColor3 = Color3.fromRGB(128, 0, 128)
collisionButton.Text = "Disable Door Collisions"
collisionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
collisionButton.Font = Enum.Font.SourceSansBold
collisionButton.TextSize = 14
collisionButton.Parent = frame

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0, 180, 0, 40)
espButton.Position = UDim2.new(0, 10, 0, 270)
espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
espButton.Text = "ESP: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.SourceSansBold
espButton.TextSize = 16
espButton.Parent = frame

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local isEnabled = false
local espEnabled = false

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local CISWardrobeChange = Remotes and Remotes:WaitForChild("CISWardrobeChange", 5)

toggleButton.MouseButton1Click:Connect(function()
	isEnabled = not isEnabled
	if isEnabled then
		toggleButton.Text = "Position Shift: ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	else
		toggleButton.Text = "Position Shift: OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	end
end)

RunService.Heartbeat:Connect(function()
	if not isEnabled then return end
	local character = localPlayer.Character
	if not character then return end
	
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not rootPart or not humanoid then return end
	
	local boostAmount = tonumber(inputField.Text) or 0
	if humanoid.MoveDirection.Magnitude > 0 then
		rootPart.CFrame = rootPart.CFrame + (humanoid.MoveDirection * boostAmount)
	end
end)

local function getNearestWardrobe(playerRoot)
	local closestWardrobe = nil
	local shortestDistance = math.huge
	
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj:FindFirstChild("PromptPart") then
			local distance = (playerRoot.Position - obj.PromptPart.Position).Magnitude
			if distance < shortestDistance then
				shortestDistance = distance
				closestWardrobe = obj
			end
		end
	end
	return closestWardrobe
end

wardrobeButton.MouseButton1Click:Connect(function()
	if not CISWardrobeChange then
		wardrobeButton.Text = "Remote Object Missing!"
		task.wait(1)
		wardrobeButton.Text = "Equip Nearest Uniform"
		return
	end

	local character = localPlayer.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local cisValues = localPlayer:FindFirstChild("CisValuesUniform")
	local removeHatsVal = cisValues and cisValues:FindFirstChild("RemoveHats") and cisValues.RemoveHats.Value or ""
	local paintHatsVal = cisValues and cisValues:FindFirstChild("PaintHats") and cisValues.PaintHats.Value or ""

	local targetWardrobe = getNearestWardrobe(rootPart)
	
	if targetWardrobe then
		local wardrobeData = {
			Group = targetWardrobe.Name,
			RemoveHats = removeHatsVal,
			PaintHats = paintHatsVal
		}
		
		CISWardrobeChange:FireServer(targetWardrobe, wardrobeData)
		wardrobeButton.Text = "Uniform Requested!"
		task.wait(1)
		wardrobeButton.Text = "Equip Nearest Uniform"
	else
		wardrobeButton.Text = "No Wardrobe Nearby!"
		task.wait(1)
		wardrobeButton.Text = "Equip Nearest Uniform"
	end
end)

teamButton.MouseButton1Click:Connect(function()
	local configPath = ReplicatedStorage:FindFirstChild("Configurations")
	local teamsConfig = configPath and configPath:FindFirstChild("Teams")
	local targetTeamObj = teamsConfig and teamsConfig:FindFirstChild("Administrative Department")

	if targetTeamObj then
		local teamService = game:GetService("Teams")
		local actualTeam = teamService:FindFirstChild("Administrative Department") or teamService:FindFirstChild(targetTeamObj.Name)
		
		if actualTeam then
			localPlayer.Team = actualTeam
			teamButton.Text = "Team Assigned!"
		else
			local teamRemote = Remotes and (Remotes:FindFirstChild("ChangeTeam") or Remotes:FindFirstChild("SetTeam"))
			if teamRemote and teamRemote:IsA("RemoteEvent") then
				teamRemote:FireServer(targetTeamObj.Name)
				teamButton.Text = "Server Request Sent!"
			else
				teamButton.Text = "Team Local Set Done"
			end
		end
	else
		teamButton.Text = "Config Path Missing!"
	end
	
	task.wait(1)
	teamButton.Text = "Set Team: Admin"
end)

collisionButton.MouseButton1Click:Connect(function()
	local count = 0
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "UpdatedDoubleDoors" or obj.Name == "UpdatedHeavyDoor" or obj.Name == "UpdatedHeavyLiftDoor" then
			if obj:IsA("BasePart") then
				obj.CanCollide = false
				count = count + 1
			else
				for _, child in ipairs(obj:GetDescendants()) do
					if child:IsA("BasePart") then
						child.CanCollide = false
						count = count + 1
					end
				end
			end
		end
	end
	collisionButton.Text = "Bypassed " .. tostring(count) .. " Parts!"
	task.wait(1.5)
	collisionButton.Text = "Disable Door Collisions"
end)

local function applyESP(player)
	if player == localPlayer then return end
	
	local function setupHighlight(character)
		if not espEnabled then return end
		if character:FindFirstChild("ESPHighlight") then return end
		
		local highlight = Instance.new("Highlight")
		highlight.Name = "ESPHighlight"
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.FillTransparency = 0.5
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.OutlineTransparency = 0
		highlight.Adornee = character
		highlight.Parent = character
	end

	if player.Character then
		setupHighlight(player.Character)
	end
	player.CharacterAdded:Connect(setupHighlight)
end

local function cleanESP()
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("ESPHighlight") then
			player.Character.ESPHighlight:Destroy()
		end
	end
end

espButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		espButton.Text = "ESP: ON"
		espButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		
		for _, player in ipairs(Players:GetPlayers()) do
			applyESP(player)
		end
		Players.PlayerAdded:Connect(applyESP)
	else
		espButton.Text = "ESP: OFF"
		espButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		cleanESP()
	end
end)
