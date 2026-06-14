
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoopTeleportGui"
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 220, 0, 120)
mainFrame.Position = UDim2.new(0.5, -110, 0.8, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = mainFrame

local timeInput = Instance.new("TextBox")
timeInput.Name = "TimeInput"
timeInput.Size = UDim2.new(0, 200, 0, 35)
timeInput.Position = UDim2.new(0.5, -100, 0, 15)
timeInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
timeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
timeInput.TextSize = 14
timeInput.Text = "0.5" 
timeInput.PlaceholderText = "Enter delay (seconds)"
timeInput.Font = Enum.Font.SourceSans
timeInput.Parent = mainFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 6)
inputCorner.Parent = timeInput

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleLoopButton"
toggleButton.Size = UDim2.new(0, 200, 0, 45)
toggleButton.Position = UDim2.new(0.5, -100, 0, 60)
toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Text = "Loop: OFF"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

local isLooping = false
local ResetPlayerData = game:GetService("ReplicatedStorage"):WaitForChild("ResetPlayerData")

toggleButton.MouseButton1Click:Connect(function()
	isLooping = not isLooping
	
	if isLooping then
		toggleButton.Text = "Loop: ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		
		task.spawn(function()
			while isLooping do
				local player = game:GetService("Players").LocalPlayer
				local character = player.Character
				local playerGui = player:FindFirstChild("PlayerGui")
				
				if playerGui then
					local winSound = playerGui:FindFirstChild("WinSound")
					if winSound then
						winSound:Destroy()
					end
				end
				
				if character then
					local hrp = character:FindFirstChild("HumanoidRootPart")
					local winPart = workspace:FindFirstChild("Win Part")
					
					if hrp and winPart and winPart:IsA("BasePart") then
						hrp.CFrame = winPart.CFrame + Vector3.new(0, 3, 0)
					end
				end
				
				local delayTime = tonumber(timeInput.Text) or 0.5
				if delayTime < 0.03 then delayTime = 0.03 end
				
				task.wait(delayTime)
				
				if not isLooping then break end
				
				ResetPlayerData:FireServer()
			end
		end)
	else
		toggleButton.Text = "Loop: OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	end
end)
