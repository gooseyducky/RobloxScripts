-- this is stupid 


-- game link: https://www.roblox.com/games/98142438728826/Swing-Obby-for-Pony

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGuiSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local windowFrame = Instance.new("Frame")
windowFrame.Name = "MainWindow"
windowFrame.Size = UDim2.new(0, 250, 0, 190)
windowFrame.Position = UDim2.new(0.5, -125, 0.5, -95)
windowFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
windowFrame.BorderSizePixel = 0
windowFrame.Parent = screenGui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 8)
windowCorner.Parent = windowFrame

local headerBar = Instance.new("Frame")
headerBar.Name = "HeaderBar"
headerBar.Size = UDim2.new(1, 0, 0, 35)
headerBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
headerBar.BorderSizePixel = 0
headerBar.Parent = windowFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = headerBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 16
titleLabel.Text = "goosey's cheat for mlp shoit"
titleLabel.Parent = headerBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.TextColor3 = Color3.fromRGB(255, 95, 95)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Text = "X"
closeButton.Parent = headerBar

local tpButton = Instance.new("TextButton")
tpButton.Name = "TpButton"
tpButton.Size = UDim2.new(0, 210, 0, 45)
tpButton.Position = UDim2.new(0.5, -105, 0, 55)
tpButton.BackgroundColor3 = Color3.fromRGB(0, 165, 115)
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.Font = Enum.Font.SourceSansBold
tpButton.TextSize = 16
tpButton.Text = "Teleport to Best Item"
tpButton.Parent = windowFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = tpButton

local firstBaseButton = Instance.new("TextButton")
firstBaseButton.Name = "FirstBaseButton"
firstBaseButton.Size = UDim2.new(0, 210, 0, 45)
firstBaseButton.Position = UDim2.new(0.5, -105, 0, 115)
firstBaseButton.BackgroundColor3 = Color3.fromRGB(35, 115, 235)
firstBaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
firstBaseButton.Font = Enum.Font.SourceSansBold
firstBaseButton.TextSize = 16
firstBaseButton.Text = "Teleport to Base Start"
firstBaseButton.Parent = windowFrame

local firstBtnCorner = Instance.new("UICorner")
firstBtnCorner.CornerRadius = UDim.new(0, 6)
firstBtnCorner.Parent = firstBaseButton

local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    windowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

headerBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = windowFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

headerBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local function getEarningsValue(textLabel)
    if not textLabel or not textLabel.Text then return 0 end
    local numberString = string.match(textLabel.Text, "%+(%d+)/s")
    if numberString then
        return tonumber(numberString) or 0
    end
    return 0
end

local function teleportToHighestEarner()
    character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local itemSpawns = Workspace:FindFirstChild("ItemSpawns")
    if not itemSpawns then return end

    local highestValue = -1
    local targetItem = nil

    for _, item in ipairs(itemSpawns:GetChildren()) do
        if item.Name == "SpawnedItem" then
            local infoGui = item:FindFirstChild("InfoGUI")
            local textLabels = infoGui and infoGui:FindFirstChild("TextLabels")
            local earningsLabel = textLabels and textLabels:FindFirstChild("Earnings")

            if earningsLabel then
                local value = getEarningsValue(earningsLabel)
                if value > highestValue then
                    highestValue = value
                    targetItem = item
                end
            end
        end
    end

    if targetItem then
        local targetCFrame = targetItem:IsA("Model") and (targetItem.PrimaryPart and targetItem.PrimaryPart.CFrame or targetItem:GetPivot()) or targetItem.CFrame
        rootPart.CFrame = targetCFrame + Vector3.new(0, 3, 0)
    end
end

local function teleportToFirstBasePart()
    character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local plotName = "Plot_" .. player.Name
    local targetPlot = Workspace:FindFirstChild(plotName)
    
    if not targetPlot then
        warn(plotName .. " could not be found in Workspace!")
        return
    end

    local floor1 = targetPlot:FindFirstChild("Floor1")
    local buildFolder = floor1 and floor1:FindFirstChild("Build")
    
    if buildFolder then
        local children = buildFolder:GetChildren()
        local targetObject = children[1]

        if targetObject then
            local targetCFrame = targetObject:IsA("Model") and (targetObject.PrimaryPart and targetObject.PrimaryPart.CFrame or targetObject:GetPivot()) or targetObject.CFrame
            rootPart.CFrame = targetCFrame + Vector3.new(0, 3, 0)
            print("Teleported to the first item in the Build folder.")
        else
            warn("The Build folder is empty. Nothing to teleport to!")
        end
    else
        warn("Floor1 or Build folder layout missing inside plot layout.")
    end
end

tpButton.MouseButton1Click:Connect(teleportToHighestEarner)
firstBaseButton.MouseButton1Click:Connect(teleportToFirstBasePart)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
