local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local BountyDataValue = ReplicatedStorage:FindFirstChild("BountyData")
if not BountyDataValue then
    warn("⚠️ 'BountyData' not found in ReplicatedStorage.")
end

local VehiclesFolder = workspace:FindFirstChild("Vehicles")
if not VehiclesFolder then
    warn("⚠️ 'Vehicles' folder not found in Workspace.")
end

local connections = {}
local isMovingToTarget = false 
local pathUpdateConnection = nil 
local aimbotEnabled = false
local aimbotHolding = false
local tripleVelocityEnabled = false
local voltLockEnabled = false
local itemTpEnabled = false
local escapingPrison = false

local GRID_SIZE = 4 
local MAX_SEARCH_DISTANCE = 150 
local NODE_VISUAL_COLOR = Color3.fromRGB(0, 255, 100)
local pathfindVelocitySpeed = 120 
local hoverHeightOffset = 3.5

local function openYield()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    print("Open Yield function executed successfully!")
end

local function createVisualNode(position: Vector3)
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Position = position
    part.Color = NODE_VISUAL_COLOR
    part.Material = Enum.Material.Neon
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false 
    part.Parent = workspace.CurrentCamera 
    return part
end

local function clearVisualNodes()
    workspace.CurrentCamera:ClearAllChildren()
end

local function isPositionWalkable(position: Vector3, objectSize: Vector3, ignoreInstance: Instance): boolean
    local overlapParams = OverlapParams.new()
    overlapParams.FilterType = Enum.RaycastFilterType.Exclude
    overlapParams.FilterDescendantsInstances = {ignoreInstance, workspace.CurrentCamera}
    
    local parts = workspace:GetPartBoundsInBox(CFrame.new(position), objectSize, overlapParams)
    return #parts == 0
end

local function snapToGrid(position: Vector3): Vector3
    return Vector3.new(
        math.round(position.X / GRID_SIZE) * GRID_SIZE,
        math.round(position.Y / GRID_SIZE) * GRID_SIZE,
        math.round(position.Z / GRID_SIZE) * GRID_SIZE
    )
end

local function calculateCustomPath(startPos: Vector3, endPos: Vector3, objectToMove: Instance): {Vector3}
    local startGrid = snapToGrid(startPos)
    local endGrid = snapToGrid(endPos)
    
    local objectSize = objectToMove:IsA("Model") and objectToMove:GetExtentsSize() or (objectToMove:IsA("BasePart") and objectToMove.Size or Vector3.new(4, 5, 4))
    
    local openSet = {}
    local closedSet = {}
    
    local gScore = {}
    local fScore = {}
    local cameFrom = {}
    
    local startKey = tostring(startGrid)
    openSet[startKey] = startGrid
    gScore[startKey] = 0
    fScore[startKey] = (startGrid - endGrid).Magnitude
    
    local directions = {
        Vector3.new(GRID_SIZE, 0, 0), Vector3.new(-GRID_SIZE, 0, 0),
        Vector3.new(0, GRID_SIZE, 0), Vector3.new(0, -GRID_SIZE, 0),
        Vector3.new(0, 0, GRID_SIZE), Vector3.new(0, 0, -GRID_SIZE)
    }
    
    while next(openSet) ~= nil do
        local currentKey = nil
        local currentGrid = nil
        local lowestF = math.huge
        
        for key, node in pairs(openSet) do
            local score = fScore[key] or math.huge
            if score < lowestF then
                lowestF = score
                currentKey = key
                currentGrid = node
            end
        end
        
        if (currentGrid - endGrid).Magnitude < GRID_SIZE then
            local path = {}
            local curr = currentGrid
            while curr do
                table.insert(path, 1, curr)
                curr = cameFrom[tostring(curr)]
            end
            return path
        end
        
        openSet[currentKey] = nil
        closedSet[currentKey] = true
        
        for _, dir in ipairs(directions) do
            local neighbor = currentGrid + dir
            local neighborKey = tostring(neighbor)
            
            if not closedSet[neighborKey] and (neighbor - startGrid).Magnitude <= MAX_SEARCH_DISTANCE then
                if isPositionWalkable(neighbor, objectSize, objectToMove) then
                    local tentativeG = (gScore[currentKey] or math.huge) + GRID_SIZE
                    
                    if tentativeG < (gScore[neighborKey] or math.huge) then
                        cameFrom[neighborKey] = currentGrid
                        gScore[neighborKey] = tentativeG
                        fScore[neighborKey] = tentativeG + (neighbor - endGrid).Magnitude
                        
                        if not openSet[neighborKey] then
                            openSet[neighborKey] = neighbor
                        end
                    end
                end
            end
        end
    end
    
    return {} 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_Menu_Gui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui 

-- COMPACT MENU BAR DESIGN
local MenuBar = Instance.new("Frame")
MenuBar.Name = "MenuBar"
MenuBar.Size = UDim2.new(0, 720, 0, 150)
MenuBar.Position = UDim2.new(0.5, -360, 0, 15)
MenuBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MenuBar.BorderSizePixel = 0
MenuBar.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MenuBar

-- ROW 1 BUTTONS
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleESP"
ToggleButton.Size = UDim2.new(0, 100, 0, 45)
ToggleButton.Position = UDim2.new(0, 10, 0, 15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "ESP: OFF"
ToggleButton.Parent = MenuBar

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

local VehicleButton = Instance.new("TextButton")
VehicleButton.Name = "ToggleVehicle"
VehicleButton.Size = UDim2.new(0, 130, 0, 25)
VehicleButton.Position = UDim2.new(0, 120, 0, 15)
VehicleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
VehicleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VehicleButton.TextSize = 13
VehicleButton.Font = Enum.Font.SourceSansBold
VehicleButton.Text = "Vehicle Boost: OFF"
VehicleButton.Parent = MenuBar

local VehicleCorner = Instance.new("UICorner")
VehicleCorner.CornerRadius = UDim.new(0, 6)
VehicleCorner.Parent = VehicleButton

local SpeedInput = Instance.new("TextBox")
SpeedInput.Name = "SpeedInput"
SpeedInput.Size = UDim2.new(0, 130, 0, 18)
SpeedInput.Position = UDim2.new(0, 120, 0, 42)
SpeedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SpeedInput.PlaceholderText = "Accel (Def: 50)"
SpeedInput.Text = "50"
SpeedInput.TextSize = 11
SpeedInput.Font = Enum.Font.SourceSans
SpeedInput.ClearTextOnFocus = false
SpeedInput.Parent = MenuBar

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 4)
InputCorner.Parent = SpeedInput

local TpBountyButton = Instance.new("TextButton")
TpBountyButton.Name = "TpBountyButton"
TpBountyButton.Size = UDim2.new(0, 120, 0, 45)
TpBountyButton.Position = UDim2.new(0, 260, 0, 15)
TpBountyButton.BackgroundColor3 = Color3.fromRGB(45, 125, 155)
TpBountyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TpBountyButton.TextSize = 13
TpBountyButton.Font = Enum.Font.SourceSansBold
TpBountyButton.Text = "Pathfind Bounty"
TpBountyButton.Parent = MenuBar

local TpCorner = Instance.new("UICorner")
TpCorner.CornerRadius = UDim.new(0, 6)
TpCorner.Parent = TpBountyButton

local AimbotButton = Instance.new("TextButton")
AimbotButton.Name = "ToggleAimbot"
AimbotButton.Size = UDim2.new(0, 120, 0, 45)
AimbotButton.Position = UDim2.new(0, 390, 0, 15)
AimbotButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
AimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotButton.TextSize = 12
AimbotButton.Font = Enum.Font.SourceSansBold
AimbotButton.Text = "Aimbot: OFF\n(R-Click)"
AimbotButton.Parent = MenuBar

local AimCorner = Instance.new("UICorner")
AimCorner.CornerRadius = UDim.new(0, 6)
AimCorner.Parent = AimbotButton

local YieldButton = Instance.new("TextButton")
YieldButton.Name = "OpenYieldButton"
YieldButton.Size = UDim2.new(0, 90, 0, 45)
YieldButton.Position = UDim2.new(0, 520, 0, 15)
YieldButton.BackgroundColor3 = Color3.fromRGB(110, 55, 165)
YieldButton.TextColor3 = Color3.fromRGB(255, 255, 255)
YieldButton.TextSize = 13
YieldButton.Font = Enum.Font.SourceSansBold
YieldButton.Text = "Open Yield"
YieldButton.Parent = MenuBar

local YieldCorner = Instance.new("UICorner")
YieldCorner.CornerRadius = UDim.new(0, 6)
YieldCorner.Parent = YieldButton

local VoltLockButton = Instance.new("TextButton")
VoltLockButton.Name = "VoltLockButton"
VoltLockButton.Size = UDim2.new(0, 90, 0, 45)
VoltLockButton.Position = UDim2.new(0, 620, 0, 15)
VoltLockButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
VoltLockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VoltLockButton.TextSize = 13
VoltLockButton.Font = Enum.Font.SourceSansBold
VoltLockButton.Text = "Volt Lock: OFF"
VoltLockButton.Parent = MenuBar

local VoltLockCorner = Instance.new("UICorner")
VoltLockCorner.CornerRadius = UDim.new(0, 6)
VoltLockCorner.Parent = VoltLockButton

-- ROW 2 BUTTONS (SHIFTED UNDER ROW 1 TO SAVE SPACE)
local EscapePrisonButton = Instance.new("TextButton")
EscapePrisonButton.Name = "EscapePrisonButton"
EscapePrisonButton.Size = UDim2.new(0, 100, 0, 45)
EscapePrisonButton.Position = UDim2.new(0, 10, 0, 80)
EscapePrisonButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
EscapePrisonButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EscapePrisonButton.TextSize = 13
EscapePrisonButton.Font = Enum.Font.SourceSansBold
EscapePrisonButton.Text = "Escape Prison"
EscapePrisonButton.Parent = MenuBar

local EscapeCorner = Instance.new("UICorner")
EscapeCorner.CornerRadius = UDim.new(0, 6)
EscapeCorner.Parent = EscapePrisonButton

local TripleVelocityButton = Instance.new("TextButton")
TripleVelocityButton.Name = "TripleVelocityButton"
TripleVelocityButton.Size = UDim2.new(0, 130, 0, 25)
TripleVelocityButton.Position = UDim2.new(0, 120, 0, 80)
TripleVelocityButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
TripleVelocityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TripleVelocityButton.TextSize = 13
TripleVelocityButton.Font = Enum.Font.SourceSansBold
TripleVelocityButton.Text = "Velocity Mult: OFF"
TripleVelocityButton.Parent = MenuBar

local TripleCorner = Instance.new("UICorner")
TripleCorner.CornerRadius = UDim.new(0, 6)
TripleCorner.Parent = TripleVelocityButton

local VelocityMultInput = Instance.new("TextBox")
VelocityMultInput.Name = "VelocityMultInput"
VelocityMultInput.Size = UDim2.new(0, 130, 0, 18)
VelocityMultInput.Position = UDim2.new(0, 120, 0, 107)
VelocityMultInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
VelocityMultInput.TextColor3 = Color3.fromRGB(255, 255, 255)
VelocityMultInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
VelocityMultInput.PlaceholderText = "Mult (Def: 3)"
VelocityMultInput.Text = "3"
VelocityMultInput.TextSize = 11
VelocityMultInput.Font = Enum.Font.SourceSans
VelocityMultInput.ClearTextOnFocus = false
VelocityMultInput.Parent = MenuBar

local MultInputCorner = Instance.new("UICorner")
MultInputCorner.CornerRadius = UDim.new(0, 4)
MultInputCorner.Parent = VelocityMultInput

local DuplicateButton = Instance.new("TextButton")
DuplicateButton.Name = "DuplicateButton"
DuplicateButton.Size = UDim2.new(0, 120, 0, 25)
DuplicateButton.Position = UDim2.new(0, 260, 0, 80)
DuplicateButton.BackgroundColor3 = Color3.fromRGB(45, 155, 100)
DuplicateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DuplicateButton.TextSize = 12
DuplicateButton.Font = Enum.Font.SourceSansBold
DuplicateButton.Text = "Dup & TP Object"
DuplicateButton.Parent = MenuBar

local DuplicateCorner = Instance.new("UICorner")
DuplicateCorner.CornerRadius = UDim.new(0, 6)
DuplicateCorner.Parent = DuplicateButton

local PathInput = Instance.new("TextBox")
PathInput.Name = "PathInput"
PathInput.Size = UDim2.new(0, 120, 0, 18)
PathInput.Position = UDim2.new(0, 260, 0, 107)
PathInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
PathInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PathInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
PathInput.PlaceholderText = "workspace.Part"
PathInput.Text = ""
PathInput.TextSize = 11
PathInput.Font = Enum.Font.SourceSans
PathInput.ClearTextOnFocus = false
PathInput.Parent = MenuBar

local PathInputCorner = Instance.new("UICorner")
PathInputCorner.CornerRadius = UDim.new(0, 4)
PathInputCorner.Parent = PathInput

local ItemTpButton = Instance.new("TextButton")
ItemTpButton.Name = "ItemTpButton"
ItemTpButton.Size = UDim2.new(0, 120, 0, 25)
ItemTpButton.Position = UDim2.new(0, 390, 0, 80)
ItemTpButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ItemTpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemTpButton.TextSize = 13
ItemTpButton.Font = Enum.Font.SourceSansBold
ItemTpButton.Text = "Fly to Items: OFF"
ItemTpButton.Parent = MenuBar

local ItemTpCorner = Instance.new("UICorner")
ItemTpCorner.CornerRadius = UDim.new(0, 6)
ItemTpCorner.Parent = ItemTpButton

local ItemFlySpeedInput = Instance.new("TextBox")
ItemFlySpeedInput.Name = "ItemFlySpeedInput"
ItemFlySpeedInput.Size = UDim2.new(0, 120, 0, 18)
ItemFlySpeedInput.Position = UDim2.new(0, 390, 0, 107)
ItemFlySpeedInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ItemFlySpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ItemFlySpeedInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
ItemFlySpeedInput.PlaceholderText = "Fly Speed (Def: 150)"
ItemFlySpeedInput.Text = "150"
ItemFlySpeedInput.TextSize = 11
ItemFlySpeedInput.Font = Enum.Font.SourceSans
ItemFlySpeedInput.ClearTextOnFocus = false
ItemFlySpeedInput.Parent = MenuBar

local FlySpeedCorner = Instance.new("UICorner")
FlySpeedCorner.CornerRadius = UDim.new(0, 4)
FlySpeedCorner.Parent = ItemFlySpeedInput

local TpTimeInput = Instance.new("TextBox")
TpTimeInput.Name = "TpTimeInput"
TpTimeInput.Size = UDim2.new(0, 90, 0, 45)
TpTimeInput.Position = UDim2.new(0, 520, 0, 80)
TpTimeInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TpTimeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TpTimeInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
TpTimeInput.PlaceholderText = "Track Secs"
TpTimeInput.Text = "5"
TpTimeInput.TextSize = 12
TpTimeInput.Font = Enum.Font.SourceSans
TpTimeInput.ClearTextOnFocus = false
TpTimeInput.Parent = MenuBar

local TpInputCorner = Instance.new("UICorner")
TpInputCorner.CornerRadius = UDim.new(0, 4)
TpInputCorner.Parent = TpTimeInput

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseMenu"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 85)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 35, 35)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "X"
CloseButton.Parent = MenuBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

local espEnabled = false
local vehicleEnabled = false
local espObjects = {}
local currentAcceleration = 50
local trackingDuration = 5
local customVelocityMultiplier = 3
local currentFlySpeed = 150

SpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
    currentAcceleration = tonumber(SpeedInput.Text) or 0
end)

TpTimeInput:GetPropertyChangedSignal("Text"):Connect(function()
    trackingDuration = tonumber(TpTimeInput.Text) or 5
end)

VelocityMultInput:GetPropertyChangedSignal("Text"):Connect(function()
    customVelocityMultiplier = tonumber(VelocityMultInput.Text) or 0
end)

ItemFlySpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
    currentFlySpeed = tonumber(ItemFlySpeedInput.Text) or 150
end)

local function getBountyTable()
    if not BountyDataValue then BountyDataValue = ReplicatedStorage:FindFirstChild("BountyData") end
    if not BountyDataValue then return nil end
    local success, decodedData = pcall(function() return HttpService:JSONDecode(BountyDataValue.Value) end)
    return (success and type(decodedData) == "table") and decodedData or nil
end

local function getPlayerBounty(playerName)
    local bountyData = getBountyTable()
    if bountyData then
        for _, data in ipairs(bountyData) do
            if data.Name == playerName then return data.Bounty or 0 end
        end
    end
    return 0
end

local function isCriminal(player)
    local teamValueObj = player:FindFirstChild("TeamValue")
    local teamStr = teamValueObj and teamValueObj.Value or ""
    return (teamStr == "Criminal" or teamStr == "Prisoner")
end

local function getTeamColor(player)
    local teamValueObj = player:FindFirstChild("TeamValue")
    local teamStr = teamValueObj and teamValueObj.Value or ""
    if teamStr == "Criminal" or teamStr == "Prisoner" then return Color3.fromRGB(255, 50, 50)
    elseif teamStr == "Police" then return Color3.fromRGB(50, 150, 255)
    else return Color3.fromRGB(255, 255, 255) end
end

local function createESP(player)
    if player == LocalPlayer then return end
    local function onCharacterAdded(character)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if not humanoidRootPart or not humanoid then return end
        
        local bbGui = Instance.new("BillboardGui")
        bbGui.Name = "PlayerESP"
        bbGui.Size = UDim2.new(0, 250, 0, 65)
        bbGui.AlwaysOnTop = true
        bbGui.ExtentsOffset = Vector3.new(0, 3.5, 0)
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextSize = 14
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Parent = bbGui
        
        bbGui.Parent = humanoidRootPart
        espObjects[player] = { Gui = bbGui, Label = textLabel, Root = humanoidRootPart, Hum = humanoid }
    end
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then onCharacterAdded(player.Character) end
end

local function removeESP(player)
    if espObjects[player] then
        if espObjects[player].Gui then espObjects[player].Gui:Destroy() end
        espObjects[player] = nil
    end
end

for _, player in ipairs(Players:GetPlayers()) do createESP(player) end
table.insert(connections, Players.PlayerAdded:Connect(createESP))
table.insert(connections, Players.PlayerRemoving:Connect(removeESP))

local function getClosestVehicle(myRootPos)
    if not VehiclesFolder then VehiclesFolder = workspace:FindFirstChild("Vehicles") end
    if not VehiclesFolder then return nil, nil end
    local closestVehiclePart = nil
    local closestVehicleModel = nil
    local shortestDistance = math.huge
    for _, vehicle in ipairs(VehiclesFolder:GetChildren()) do
        local mainPart = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
        if mainPart then
            local dist = (myRootPos - mainPart.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                closestVehiclePart = mainPart
                closestVehicleModel = vehicle
            end
        end
    end
    return closestVehiclePart, closestVehicleModel
end

local function getClosestCriminalToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isCriminal(player) and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

local renderConnection
renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myCharacter and myCharacter:FindFirstChildOfClass("Humanoid")
    
    for player, data in pairs(espObjects) do
        if espEnabled and data.Root and data.Root.Parent and data.Hum and data.Hum.Health > 0 then
            data.Gui.Enabled = true
            local distance = math.floor((myRoot and (myRoot.Position - data.Root.Position).Magnitude) or 0)
            local health = math.floor(data.Hum.Health)
            local bounty = getPlayerBounty(player.Name)
            
            data.Label.TextColor3 = getTeamColor(player)
            data.Label.Text = string.format("%s\nBounty: $%s\nHP: %d | %d Studs", player.Name, tonumber(bounty) and string.format("%d", bounty) or "0", health, distance)
        else
            data.Gui.Enabled = false
        end
    end
    
    local targetVehiclePart, targetVehicleModel = nil, nil
    if (vehicleEnabled or voltLockEnabled) and myRoot then
        targetVehiclePart, targetVehicleModel = getClosestVehicle(myRoot.Position)
    end
    
    -- ESCAPE PRISON PHYSICS ROUTINE: ONLY moves the Character
    if escapingPrison and myRoot then
        if myRoot.Anchored then myRoot.Anchored = false end
        myRoot.AssemblyLinearVelocity = Vector3.new(myRoot.AssemblyLinearVelocity.X, 100, myRoot.AssemblyLinearVelocity.Z)
    end
    
    if vehicleEnabled and myRoot and myHumanoid and targetVehiclePart and not escapingPrison then
        if myHumanoid.MoveDirection.Magnitude > 0 then
            local additionalVelocity = myHumanoid.MoveDirection * currentAcceleration * deltaTime
            targetVehiclePart.AssemblyLinearVelocity += additionalVelocity
        end
    end
    
    if voltLockEnabled and targetVehiclePart and targetVehicleModel then
        if string.find(targetVehicleModel.Name, "Volt") then
            local camLook = Camera.CFrame.LookVector
            local targetAngle = math.atan2(-camLook.X, -camLook.Z)
            
            if targetVehicleModel.PrimaryPart then
                targetVehicleModel:PivotTo(CFrame.new(targetVehiclePart.Position) * CFrame.Angles(0, targetAngle, 0))
            else
                targetVehiclePart.CFrame = CFrame.new(targetVehiclePart.Position) * CFrame.Angles(0, targetAngle, 0)
            end
        end
    end
    
    if aimbotEnabled and aimbotHolding then
        local targetCriminal = getClosestCriminalToCursor()
        if targetCriminal and targetCriminal.Character then
            local targetHead = targetCriminal.Character:FindFirstChild("Head")
            if targetHead then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
            end
        end
    end

    if tripleVelocityEnabled and myRoot and myHumanoid and not escapingPrison then
        if myHumanoid.MoveDirection.Magnitude > 0 then
            local normalSpeed = myHumanoid.WalkSpeed
            local maxCustomSpeed = normalSpeed * customVelocityMultiplier
            
            local targetVelocityX = myHumanoid.MoveDirection.X * maxCustomSpeed
            local targetVelocityZ = myHumanoid.MoveDirection.Z * maxCustomSpeed
            
            myRoot.AssemblyLinearVelocity = Vector3.new(
                math.clamp(targetVelocityX, -maxCustomSpeed, maxCustomSpeed),
                myRoot.AssemblyLinearVelocity.Y, 
                math.clamp(targetVelocityZ, -maxCustomSpeed, maxCustomSpeed)
            )
        end
    end
end)
table.insert(connections, renderConnection)

table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbotHolding = true
    end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbotHolding = false
    end
end))

ToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ToggleButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    ToggleButton.BackgroundColor3 = espEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

VehicleButton.MouseButton1Click:Connect(function()
    vehicleEnabled = not vehicleEnabled
    VehicleButton.Text = vehicleEnabled and "Vehicle Boost: ON" or "Vehicle Boost: OFF"
    VehicleButton.BackgroundColor3 = vehicleEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

AimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    AimbotButton.Text = aimbotEnabled and "Aimbot: ON\n(Hold Right Click)" or "Aimbot: OFF\n(Hold Right Click)"
    AimbotButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

YieldButton.MouseButton1Click:Connect(function()
    openYield()
end)

TripleVelocityButton.MouseButton1Click:Connect(function()
    tripleVelocityEnabled = not tripleVelocityEnabled
    TripleVelocityButton.Text = tripleVelocityEnabled and "Velocity Mult: ON" or "Velocity Mult: OFF"
    TripleVelocityButton.BackgroundColor3 = tripleVelocityEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

VoltLockButton.MouseButton1Click:Connect(function()
    voltLockEnabled = not voltLockEnabled
    VoltLockButton.Text = voltLockEnabled and "Volt Lock: ON" or "Volt Lock: OFF"
    VoltLockButton.BackgroundColor3 = voltLockEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

EscapePrisonButton.MouseButton1Click:Connect(function()
    if escapingPrison then return end 
    
    local teamValueObj = LocalPlayer:FindFirstChild("TeamValue")
    local teamStr = teamValueObj and teamValueObj.Value or ""
    
    if teamStr == "Prisoner" then
        escapingPrison = true
        EscapePrisonButton.Text = "Escaping..."
        EscapePrisonButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        task.delay(5, function()
            escapingPrison = false
            EscapePrisonButton.Text = "Escape Prison"
            EscapePrisonButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
            
            local myCharacter = LocalPlayer.Character
            local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
            if myRoot then
                myRoot.AssemblyLinearVelocity = Vector3.new(myRoot.AssemblyLinearVelocity.X, 0, myRoot.AssemblyLinearVelocity.Z)
            end
        end)
    else
        EscapePrisonButton.Text = "Not a Prisoner!"
        EscapePrisonButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.delay(1.5, function()
            EscapePrisonButton.Text = "Escape Prison"
            EscapePrisonButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        end)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    for _, connection in ipairs(connections) do
        if connection then connection:Disconnect() end
    end
    if pathUpdateConnection then pathUpdateConnection:Disconnect() end
    clearVisualNodes()
    
    local foundGuis = PlayerGui:GetChildren()
    for _, obj in ipairs(foundGuis) do
        if obj.Name == "ESP_Menu_Gui" then
            obj:Destroy()
        end
    end
end)

---------------------------------------------------------------------------
-- TARGET FOLDER & PHYSICS TRAVERSAL LOGIC
---------------------------------------------------------------------------
local function findCorrectFolder()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Folder") and obj.Name == "Folder" then
            if obj:FindFirstChild("FenceDestructible-Tall") then
                return obj
            end
        end
    end
    return nil
end

local function checkLineOfSight(startPos, endPos, ignoreList)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.IgnoreWater = true
    
    local direction = endPos - startPos
    local raycastResult = workspace:Raycast(startPos, direction, raycastParams)
    
    return raycastResult == nil
end

ItemTpButton.MouseButton1Click:Connect(function()
    itemTpEnabled = not itemTpEnabled
    ItemTpButton.Text = itemTpEnabled and "Fly Items: RUN" or "Fly to Items: OFF"
    ItemTpButton.BackgroundColor3 = itemTpEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    
    if not itemTpEnabled then return end

    task.spawn(function()
        local targetFolder = findCorrectFolder()
        if not targetFolder then
            ItemTpButton.Text = "Folder Not Found!"
            ItemTpButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            itemTpEnabled = false
            task.delay(1.5, function() ItemTpButton.Text = "Fly to Items: OFF" end)
            return
        end

        local items = targetFolder:GetChildren()

        for _, item in ipairs(items) do
            if not itemTpEnabled then break end
            
            local myCharacter = LocalPlayer.Character
            local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
            if not myRoot then continue end
            
            local vehiclePart, vehicleModel = getClosestVehicle(myRoot.Position)
            local physicsPart = vehiclePart or myRoot
            
            local touchInterest = item:FindFirstChild("TouchInterest", true) 
            
            if touchInterest and touchInterest.Parent and touchInterest.Parent:IsA("BasePart") then
                local targetPart = touchInterest.Parent
                local targetPos = targetPart.Position
                
                local ignoreList = {myCharacter, workspace.CurrentCamera, targetFolder}
                if vehicleModel then table.insert(ignoreList, vehicleModel) end
                
                local hasLineOfSight = checkLineOfSight(physicsPart.Position, targetPos, ignoreList)
                if not hasLineOfSight then continue end
                
                if myRoot.Anchored then myRoot.Anchored = false end
                if vehiclePart and vehiclePart.Anchored then vehiclePart.Anchored = false end
                
                while itemTpEnabled and targetPart.Parent and (physicsPart.Position - targetPos).Magnitude > 6 do
                    local direction = (targetPos - physicsPart.Position).Unit
                    physicsPart.AssemblyLinearVelocity = direction * currentFlySpeed
                    task.wait()
                    
                    myCharacter = LocalPlayer.Character
                    myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
                    if not myRoot then break end
                    vehiclePart, vehicleModel = getClosestVehicle(myRoot.Position)
                    physicsPart = vehiclePart or myRoot
                end
                
                if physicsPart then physicsPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
                task.wait(0.05)
            end
        end

        itemTpEnabled = false
        ItemTpButton.Text = "Fly to Items: OFF"
        ItemTpButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end)
end)

---------------------------------------------------------------------------
-- OBJECT DUPLICATION & TRACKING (FINALISED PATH CODES)
---------------------------------------------------------------------------
local function findObjectFromPath(pathString)
    pathString = string.gsub(pathString, "%s*%.%s*", ".") 
    local segments = string.split(pathString, ".")
    local currentObj = game
    
    local startIndex = 1
    if segments[1] == "game" then
        startIndex = 2
    end
    
    for i = startIndex, #segments do
        local name = segments[i]
        if currentObj then
            local nextObj = currentObj:FindFirstChild(name)
            if not nextObj then
                print("Disconnected at: " .. currentObj:GetFullName() .. " missing child: " .. name)
                return nil
            end
            currentObj = nextObj
        else
            return nil
        end
    end
    return currentObj
end

DuplicateButton.MouseButton1Click:Connect(function()
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    
    if not myRoot then 
        DuplicateButton.Text = "No Local Character Root!"
        task.delay(1.5, function() DuplicateButton.Text = "Dup & TP Object" end)
        return 
    end
    
    local pathText = PathInput.Text
    if pathText == "" then
        DuplicateButton.Text = "Path Box Empty!"
        task.delay(1.5, function() DuplicateButton.Text = "Dup & TP Object" end)
        return
    end
    
    local targetObject = findObjectFromPath(pathText)
    
    if targetObject and (targetObject:IsA("BasePart") or targetObject:IsA("Model")) then
        local oldArchivable = targetObject.Archivable
        targetObject.Archivable = true
        
        local success, clonedObj = pcall(function()
            return targetObject:Clone()
        end)
        
        targetObject.Archivable = oldArchivable
        
        if success and clonedObj then
            if clonedObj:IsA("Model") then
                clonedObj:MoveTo(myRoot.Position)
            elseif clonedObj:IsA("BasePart") then
                clonedObj.Position = myRoot.Position
            end
            
            if clonedObj:IsA("Model") then
                for _, part in ipairs(clonedObj:GetDescendants()) do
                    if part:IsA("BasePart") then part.Anchored = true end
                end
            else
                clonedObj.Anchored = true
            end
            
            clonedObj.Parent = workspace
            
            DuplicateButton.Text = "Success!"
            DuplicateButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            task.delay(1.5, function() 
                DuplicateButton.Text = "Dup & TP Object" 
                DuplicateButton.BackgroundColor3 = Color3.fromRGB(45, 155, 100)
            end)
        else
            DuplicateButton.Text = "Clone Failed!"
            task.delay(1.5, function() DuplicateButton.Text = "Dup & TP Object" end)
        end
    else
        DuplicateButton.Text = "Object Invalid!"
        task.delay(1.5, function() DuplicateButton.Text = "Dup & TP Object" end)
    end
end)

TpBountyButton.MouseButton1Click:Connect(function()
    if isMovingToTarget then
        if pathUpdateConnection then 
            pathUpdateConnection:Disconnect() 
            pathUpdateConnection = nil
        end
        return 
    end
    
    local bountyData = getBountyTable()
    if not bountyData then return end
    
    local highestBounty = -1
    local targetPlayerName = nil
    
    for _, entry in ipairs(bountyData) do
        if entry.Bounty and entry.Bounty > highestBounty then
            if Players:FindFirstChild(entry.Name) and Players[entry.Name] ~= LocalPlayer then
                highestBounty = entry.Bounty
                targetPlayerName = entry.Name
            end
        end
    end
    
    local targetPlayer = targetPlayerName and Players:FindFirstChild(targetPlayerName)
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    
    if targetPlayer and myRoot and myCharacter then
        local targetChar = targetPlayer.Character
        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        
        if not targetRoot then
            TpBountyButton.Text = "Target Dead"
            task.delay(1.5, function() TpBountyButton.Text = "Pathfind Bounty" end)
            return
        end

        clearVisualNodes()
        
        local pathNodes = calculateCustomPath(myRoot.Position, targetRoot.Position, myCharacter)
        
        if #pathNodes == 0 then
            TpBountyButton.Text = "Enclosed!"
            TpBountyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.delay(2.5, function()
                TpBountyButton.BackgroundColor3 = Color3.fromRGB(45, 125, 155)
                TpBountyButton.Text = "Pathfind Bounty"
            end)
            return
        end
        
        for _, nodePosition in ipairs(pathNodes) do
            createVisualNode(nodePosition)
        end
        
        isMovingToTarget = true
        TpBountyButton.BackgroundColor3 = Color3.fromRGB(215, 110, 35) 
        TpBountyButton.Text = "Cancel"
        
        local currentWaypointIndex = 1
        local startTime = os.clock()
        
        pathUpdateConnection = RunService.Heartbeat:Connect(function()
            local timeElapsed = os.clock() - startTime
            local currentTargetChar = targetPlayer.Character
            local currentTargetRoot = currentTargetChar and currentTargetChar:FindFirstChild("HumanoidRootPart")
            
            local distanceToTarget = currentTargetRoot and (myRoot.Position - currentTargetRoot.Position).Magnitude or math.huge
            
            if myRoot and myRoot.Parent and currentTargetRoot and currentTargetRoot.Parent and (timeElapsed < trackingDuration) and (distanceToTarget > 4) then
                if currentWaypointIndex <= #pathNodes then
                    local targetWaypointPos = pathNodes[currentWaypointIndex]
                end
            end
        end)
    end
end)
