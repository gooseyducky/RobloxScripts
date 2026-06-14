local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false 
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Name = "TeleportButton"
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.8, -25)
button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 18
button.Font = Enum.Font.SourceSansBold
button.Text = "Unlock max checkpoint"
button.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = button

local function teleportTo(targetPart)
	local character = localPlayer.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)
	end
end

button.MouseButton1Click:Connect(function()
	local checkpoint60 = Workspace:FindFirstChild("Checkpoints") and Workspace.Checkpoints:FindFirstChild("Checkpoints") and Workspace.Checkpoints.Checkpoints:FindFirstChild("60")
	local spawnPart = Workspace:FindFirstChild("ImportantWorkspace") and Workspace.ImportantWorkspace:FindFirstChild("SpawnPositionPart")
	
	if checkpoint60 then
		button.Text = "Teleported!"
		teleportTo(checkpoint60)
		task.wait(2)
		
		if spawnPart then
			button.Text = "Returning..."
			teleportTo(spawnPart)
			task.wait(1)
			button.Text = "Unlock max checkpoint"
		else
			warn("SpawnPositionPart could not be found in Workspace.ImportantWorkspace")
			button.Text = "Error: No Spawn"
		end
	else
		warn("Checkpoint 60 could not be found in Workspace.Checkpoints.Checkpoints")
		button.Text = "Error: No Checkpoint"
	end
end)
