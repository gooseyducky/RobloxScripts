local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Check if the Key object exists in the local player
local keys = localPlayer:FindFirstChild("Keys")
local hasKeys = keys ~= nil

local GooseClient = Instance.new("ScreenGui")
GooseClient.Name = "GooseClient"
GooseClient.ResetOnSpawn = false
GooseClient.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GooseClient.Parent = playerGui

local Frame = Instance.new("Frame")
Frame.Name = "Frame"
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.37, 0, 0.62, 0)
Frame.Size = UDim2.new(0, 260, 0, 450)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = GooseClient

local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 20)
UICorner_Main.Parent = Frame

local UIStroke_Main = Instance.new("UIStroke")
UIStroke_Main.Color = Color3.fromRGB(255, 120, 0)
UIStroke_Main.Thickness = 3
UIStroke_Main.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke_Main.Parent = Frame

-- Window Dragging Logic
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ButtonContainer"
ScrollingFrame.Position = UDim2.new(0.04, 0, 0.05, 0)
ScrollingFrame.Size = UDim2.new(0.92, 0, 0.9, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 120, 0)
ScrollingFrame.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createButton(name, text, order)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0.92, 0, 0, 35)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.BorderSizePixel = 0
	button.Font = Enum.Font.SourceSansBold
	button.Text = text
	button.TextColor3 = Color3.fromRGB(230, 140, 10)
	button.TextSize = 14
	button.LayoutOrder = order
	button.Parent = ScrollingFrame

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 8)
	buttonCorner.Parent = button

	return button
end

local function createTextBox(name, placeholder, order)
	local textBox = Instance.new("TextBox")
	textBox.Name = name
	textBox.Size = UDim2.new(0.92, 0, 0, 35)
	textBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	textBox.BorderSizePixel = 0
	textBox.Font = Enum.Font.SourceSans
	textBox.PlaceholderText = placeholder
	textBox.Text = ""
	textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	textBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
	textBox.TextSize = 14
	textBox.LayoutOrder = order
	textBox.Parent = ScrollingFrame

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 8)
	boxCorner.Parent = textBox

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Color = Color3.fromRGB(80, 80, 80)
	boxStroke.Thickness = 1
	boxStroke.Parent = textBox

	return textBox
end

-- Config Variables
local flySpeed = 50
local scytheDashForce = 180
local scytheUpwardForce = 35
local currentOrder = 1

-- Base Toggles/Buttons (Conditionally rendered based on Key object availability)
local addkey, addsuperkey, addbricks, addvision
if hasKeys then
	addkey = createButton("addkey", "Add Key", currentOrder) currentOrder += 1
	addsuperkey = createButton("addsuperkey", "Add Super Key (max 1)", currentOrder) currentOrder += 1
	addbricks = createButton("addbricks", "Add 5k Bricks", currentOrder) currentOrder += 1
	addvision = createButton("addvision", "Add a Vision", currentOrder) currentOrder += 1
end

local destroy_barriers = createButton("destroybarriers", "Destroy Level Barriers", currentOrder) currentOrder += 1

-- Character Movement Buttons
local toggle_speed = createButton("togglespeed", "Speed 100: OFF", currentOrder) currentOrder += 1
local toggle_jump = createButton("togglejump", "JumpPower 120: OFF", currentOrder) currentOrder += 1
local toggle_fly = createButton("togglefly", "Fly: OFF", currentOrder) currentOrder += 1
local toggle_clicktp = createButton("toggleclicktp", "Ctrl+Click TP: OFF", currentOrder) currentOrder += 1
local toggle_noclip = createButton("togglenoclip", "Noclip: OFF", currentOrder) currentOrder += 1
local toggle_infjump = createButton("toggleinfjump", "Infinite Jump: OFF", currentOrder) currentOrder += 1
local toggle_float = createButton("togglefloat", "Float Pad: OFF", currentOrder) currentOrder += 1
local toggle_lowgrav = createButton("togglelowgrav", "Low Gravity: OFF", currentOrder) currentOrder += 1
local toggle_bhop = createButton("togglebhop", "Bunnyhop Auto: OFF", currentOrder) currentOrder += 1
local toggle_spin = createButton("togglespin", "Spin Bot: OFF", currentOrder) currentOrder += 1
local toggle_tpwalk = createButton("toggletpwalk", "TP Walk (Click & Go): OFF", currentOrder) currentOrder += 1
local toggle_highjump = createButton("togglehighjump", "Super High-Jump Boost: OFF", currentOrder) currentOrder += 1
local toggle_speeddash = createButton("togglespeeddash", "Q Key Dash Active: OFF", currentOrder) currentOrder += 1

-- original Tools System
local toggle_scythe = createButton("togglescythe", "Tool: Admin Scythe [OFF]", currentOrder) currentOrder += 1
local toggle_grapple = createButton("togglegrapple", "Tool: Web Grapple [OFF]", currentOrder) currentOrder += 1
local toggle_push = createButton("togglepush", "Tool: Repulsion Blaster [OFF]", currentOrder) currentOrder += 1
local toggle_glider = createButton("toggleglider", "Tool: Jet Glider [OFF]", currentOrder) currentOrder += 1
local toggle_anchor = createButton("toggleanchor", "Tool: Gravity Anchor [OFF]", currentOrder) currentOrder += 1

-- 10 New Advantage Movement Tools
local toggle_blink = createButton("toggleblink", "Tool: Phase Blink [OFF]", currentOrder) currentOrder += 1
local toggle_rewind = createButton("togglerewind", "Tool: Time Rewinder [OFF]", currentOrder) currentOrder += 1
local toggle_vault = createButton("togglevault", "Tool: Pole Vault [OFF]", currentOrder) currentOrder += 1
local toggle_magnet = createButton("togglemagnet", "Tool: Player Magnet [OFF]", currentOrder) currentOrder += 1
local toggle_hover = createButton("togglehover", "Tool: Hover Board [OFF]", currentOrder) currentOrder += 1
local toggle_slingshot = createButton("toggleslingshot", "Tool: Slingshot [OFF]", currentOrder) currentOrder += 1
local toggle_boostpad = createButton("toggleboostpad", "Tool: Instant Pad [OFF]", currentOrder) currentOrder += 1
local toggle_charge_btn = createButton("togglecharge", "Tool: Kinetic Charge [OFF]", currentOrder) currentOrder += 1
local toggle_swap = createButton("toggleswap", "Tool: Position Swapper [OFF]", currentOrder) currentOrder += 1
local toggle_vortex = createButton("togglevortex", "Tool: Tailwind Vortex [OFF]", currentOrder) currentOrder += 1

-- Customization Fields
local input_fly = createTextBox("inputfly", "Set Fly Speed (Current: 50)", currentOrder) currentOrder += 1
local input_scythe_dash = createTextBox("inputscythedash", "Scythe Dash Speed (Current: 180)", currentOrder) currentOrder += 1
local input_scythe_up = createTextBox("inputscytheup", "Scythe Upward Force (Current: 35)", currentOrder) currentOrder += 1

local dest_button = createButton("destroyui", "Destroy UI", currentOrder)
dest_button.TextColor3 = Color3.fromRGB(255, 50, 50)

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
end)

local title1 = Instance.new("TextLabel")
title1.Name = "title"
title1.Position = UDim2.new(0.5, -130, 0, -65)
title1.Size = UDim2.new(0, 260, 0, 35)
title1.BackgroundTransparency = 1
title1.Font = Enum.Font.FredokaOne
title1.Text = "GRACE CLIENT"
title1.TextColor3 = Color3.fromRGB(0, 0, 0)
title1.TextSize = 34
title1.Parent = Frame

local title2 = Instance.new("TextLabel")
title2.Name = "title (2)"
title2.Position = UDim2.new(0.5, -130, 0, -35)
title2.Size = UDim2.new(0, 260, 0, 20)
title2.BackgroundTransparency = 1
title2.Font = Enum.Font.SourceSansBold
title2.Text = "BY @.GOOSEYDUCK ON DISCORD"
title2.TextColor3 = Color3.fromRGB(130, 70, 170)
title2.TextSize = 13
title2.Parent = Frame

if not (title2.Text == "BY @.GOOSEYDUCK ON DISCORD") then
	GooseClient:Destroy()
	return
end

-- Input Handlers
input_fly.FocusLost:Connect(function()
	local val = tonumber(input_fly.Text)
	if val then flySpeed = val end
end)

input_scythe_dash.FocusLost:Connect(function()
	local val = tonumber(input_scythe_dash.Text)
	if val then scytheDashForce = val end
end)

input_scythe_up.FocusLost:Connect(function()
	local val = tonumber(input_scythe_up.Text)
	if val then scytheUpwardForce = val end
end)

-- Hookup Lobby Actions only if elements exist
if hasKeys then
	addkey.MouseButton1Click:Connect(function() keys.Value += 1 end)
	addsuperkey.MouseButton1Click:Connect(function()
		local Skey = localPlayer:FindFirstChild("SuperKey")
		if Skey then Skey.Value = false task.wait(0.005) Skey.Value = true end
	end)
	addbricks.MouseButton1Click:Connect(function()
		local leaderstats = localPlayer:FindFirstChild("leaderstats")
		local brick = leaderstats and leaderstats:FindFirstChild("Bricks")
		if brick then brick.Value += 5000 end
	end)
	addvision.MouseButton1Click:Connect(function()
		local vis = localPlayer:FindFirstChild("SuperKey")
		if vis then vis.Value += 1 end
	end)
end

destroy_barriers.MouseButton1Click:Connect(function()
	local barriers = workspace:FindFirstChild("barriers")
	if barriers then barriers:Destroy() end
end)

-- Movement Toggles
local speedToggle = false
toggle_speed.MouseButton1Click:Connect(function()
	speedToggle = not speedToggle
	if speedToggle then
		toggle_speed.Text = "Speed 100: ON"
		toggle_speed.TextColor3 = Color3.fromRGB(50, 255, 50)
	else
		toggle_speed.Text = "Speed 100: OFF"
		toggle_speed.TextColor3 = Color3.fromRGB(230, 140, 10)
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then humanoid.WalkSpeed = 16 end
	end
end)

local jumpToggle = false
toggle_jump.MouseButton1Click:Connect(function()
	jumpToggle = not jumpToggle
	if jumpToggle then
		toggle_jump.Text = "JumpPower 120: ON"
		toggle_jump.TextColor3 = Color3.fromRGB(50, 255, 50)
	else
		toggle_jump.Text = "JumpPower 120: OFF"
		toggle_jump.TextColor3 = Color3.fromRGB(230, 140, 10)
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			if humanoid.UseJumpPower then humanoid.JumpPower = 50 else humanoid.JumpHeight = 7.2 end
		end
	end
end)

-- Fly System
local flyToggle = false
local camera = workspace.CurrentCamera
local bodyVelocity, bodyGyro, flyConnection

local function stopFlying()
	flyToggle = false
	toggle_fly.Text = "Fly: OFF"
	toggle_fly.TextColor3 = Color3.fromRGB(230, 140, 10)
	if flyConnection then flyConnection:Disconnect() end
	if bodyVelocity then bodyVelocity:Destroy() end
	if bodyGyro then bodyGyro:Destroy() end
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.PlatformStand = false end
end

local function startFlying()
	local character = localPlayer.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not rootPart or not humanoid then flyToggle = false return end

	flyToggle = true
	toggle_fly.Text = "Fly: ON"
	toggle_fly.TextColor3 = Color3.fromRGB(50, 255, 50)
	humanoid.PlatformStand = true

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = rootPart

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bodyGyro.CFrame = rootPart.CFrame
	bodyGyro.Parent = rootPart

	flyConnection = RunService.RenderStepped:Connect(function()
		local currentCharacter = localPlayer.Character
		local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
		local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
		if not currentRoot or not currentHumanoid or not flyToggle then stopFlying() return end

		currentHumanoid.PlatformStand = true
		bodyGyro.CFrame = camera.CFrame
		local lookVector = camera.CFrame.LookVector
		local moveDirection = currentHumanoid.MoveDirection

		if moveDirection.Magnitude == 0 then
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		else
			local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
			local rightVector = camera.CFrame.RightVector
			local sideMovement = rightVector * (moveDirection:Dot(rightVector))
			local trueForward = lookVector * (moveDirection:Dot(flatLook))
			bodyVelocity.Velocity = (trueForward + sideMovement).Unit * flySpeed
		end
	end)
end

toggle_fly.MouseButton1Click:Connect(function()
	if flyToggle then stopFlying() else startFlying() end
end)

-- Click Teleport
local tpToggle = false
local mouse = localPlayer:GetMouse()
local tpInputConnection

toggle_clicktp.MouseButton1Click:Connect(function()
	tpToggle = not tpToggle
	if tpToggle then
		toggle_clicktp.Text = "Ctrl+Click TP: ON"
		toggle_clicktp.TextColor3 = Color3.fromRGB(50, 255, 50)
		tpInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
				local character = localPlayer.Character
				local rootPart = character and character:FindFirstChild("HumanoidRootPart")
				if rootPart and mouse.Target then rootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) end
			end
		end)
	else
		toggle_clicktp.Text = "Ctrl+Click TP: OFF"
		toggle_clicktp.TextColor3 = Color3.fromRGB(230, 140, 10)
		if tpInputConnection then tpInputConnection:Disconnect() tpInputConnection = nil end
	end
end)

-- Noclip
local noclipToggle = false
local noclipConnection
toggle_noclip.MouseButton1Click:Connect(function()
	noclipToggle = not noclipToggle
	if noclipToggle then
		toggle_noclip.Text = "Noclip: ON"
		toggle_noclip.TextColor3 = Color3.fromRGB(50, 255, 50)
		noclipConnection = RunService.Stepped:Connect(function()
			local character = localPlayer.Character
			if character and noclipToggle then
				for _, part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
				end
			end
		end)
	else
		toggle_noclip.Text = "Noclip: OFF"
		toggle_noclip.TextColor3 = Color3.fromRGB(230, 140, 10)
		if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
	end
end)

-- Infinite Jump
local infJumpToggle = false
local infJumpConnection
toggle_infjump.MouseButton1Click:Connect(function()
	infJumpToggle = not infJumpToggle
	if infJumpToggle then
		toggle_infjump.Text = "Infinite Jump: ON"
		toggle_infjump.TextColor3 = Color3.fromRGB(50, 255, 50)
		infJumpConnection = UserInputService.JumpRequest:Connect(function()
			local character = localPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
		end)
	else
		toggle_infjump.Text = "Infinite Jump: OFF"
		toggle_infjump.TextColor3 = Color3.fromRGB(230, 140, 10)
		if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
	end
end)

-- Float Pad
local floatToggle = false
local floatPart = nil
task.spawn(function()
	while true do
		task.wait(0.05)
		if floatToggle then
			local character = localPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if root then
				if not floatPart or not floatPart.Parent then
					floatPart = Instance.new("Part")
					floatPart.Size = Vector3.new(6, 0.5, 6)
					floatPart.Transparency = 0.6
					floatPart.BrickColor = BrickColor.new("Deep orange")
					floatPart.Anchored = true
					floatPart.Parent = workspace
				end
				floatPart.CFrame = CFrame.new(root.Position.X, root.Position.Y - 3.25, root.Position.Z)
			end
		else
			if floatPart then floatPart:Destroy() floatPart = nil end
		end
	end
end)

toggle_float.MouseButton1Click:Connect(function()
	floatToggle = not floatToggle
	if floatToggle then
		toggle_float.Text = "Float Pad: ON"
		toggle_float.TextColor3 = Color3.fromRGB(50, 255, 50)
	else
		toggle_float.Text = "Float Pad: OFF"
		toggle_float.TextColor3 = Color3.fromRGB(230, 140, 10)
	end
end)

-- Low Gravity
local lowGravToggle = false
toggle_lowgrav.MouseButton1Click:Connect(function()
	lowGravToggle = not lowGravToggle
	if lowGravToggle then
		toggle_lowgrav.Text = "Low Gravity: ON"
		toggle_lowgrav.TextColor3 = Color3.fromRGB(50, 255, 50)
		workspace.Gravity = 35
	else
		toggle_lowgrav.Text = "Low Gravity: OFF"
		toggle_lowgrav.TextColor3 = Color3.fromRGB(230, 140, 10)
		workspace.Gravity = 196.2
	end
end)

-- Bunnyhop
local bhopToggle = false
local bhopConnection
toggle_bhop.MouseButton1Click:Connect(function()
	bhopToggle = not bhopToggle
	if bhopToggle then
		toggle_bhop.Text = "Bunnyhop Auto: ON"
		toggle_bhop.TextColor3 = Color3.fromRGB(50, 255, 50)
		bhopConnection = RunService.RenderStepped:Connect(function()
			local character = localPlayer.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		toggle_bhop.Text = "Bunnyhop Auto: OFF"
		toggle_bhop.TextColor3 = Color3.fromRGB(230, 140, 10)
		if bhopConnection then bhopConnection:Disconnect() bhopConnection = nil end
	end
end)

-- Spin Bot
local spinToggle = false
local spinConnection
toggle_spin.MouseButton1Click:Connect(function()
	spinToggle = not spinToggle
	if spinToggle then
		toggle_spin.Text = "Spin Bot: ON"
		toggle_spin.TextColor3 = Color3.fromRGB(50, 255, 50)
		spinConnection = RunService.RenderStepped:Connect(function()
			local character = localPlayer.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(25), 0) end
		end)
	else
		toggle_spin.Text = "Spin Bot: OFF"
		toggle_spin.TextColor3 = Color3.fromRGB(230, 140, 10)
		if spinConnection then spinConnection:Disconnect() spinConnection = nil end
	end
end)

-- TP Walk System
local tpWalkToggle = false
local tpWalkConnection
toggle_tpwalk.MouseButton1Click:Connect(function()
	tpWalkToggle = not tpWalkToggle
	if tpWalkToggle then
		toggle_tpwalk.Text = "TP Walk (Click & Go): ON"
		toggle_tpwalk.TextColor3 = Color3.fromRGB(50, 255, 50)
		tpWalkConnection = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 and not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
				local char = localPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root and mouse.Target then
					root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
				end
			end
		end)
	else
		toggle_tpwalk.Text = "TP Walk (Click & Go): OFF"
		toggle_tpwalk.TextColor3 = Color3.fromRGB(230, 140, 10)
		if tpWalkConnection then tpWalkConnection:Disconnect() tpWalkConnection = nil end
	end
end)

-- High Jump Boost
local highJumpToggle = false
local highJumpConnection
toggle_highjump.MouseButton1Click:Connect(function()
	highJumpToggle = not highJumpToggle
	if highJumpToggle then
		toggle_highjump.Text = "Super High-Jump Boost: ON"
		toggle_highjump.TextColor3 = Color3.fromRGB(50, 255, 50)
		highJumpConnection = UserInputService.JumpRequest:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				root.Velocity = Vector3.new(root.Velocity.X, 150, root.Velocity.Z)
			end
		end)
	else
		toggle_highjump.Text = "Super High-Jump Boost: OFF"
		toggle_highjump.TextColor3 = Color3.fromRGB(230, 140, 10)
		if highJumpConnection then highJumpConnection:Disconnect() highJumpConnection = nil end
	end
end)

-- Q Key Horizontal Dash
local speedDashToggle = false
local speedDashConnection
toggle_speeddash.MouseButton1Click:Connect(function()
	speedDashToggle = not speedDashToggle
	if speedDashToggle then
		toggle_speeddash.Text = "Q Key Dash Active: ON"
		toggle_speeddash.TextColor3 = Color3.fromRGB(50, 255, 50)
		speedDashConnection = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.KeyCode == Enum.KeyCode.Q then
				local char = localPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if root and hum then
					local moveDir = hum.MoveDirection
					if moveDir.Magnitude == 0 then moveDir = root.CFrame.LookVector end
					root.Velocity = Vector3.new(moveDir.X * 220, root.Velocity.Y, moveDir.Z * 220)
				end
			end
		end)
	else
		toggle_speeddash.Text = "Q Key Dash Active: OFF"
		toggle_speeddash.TextColor3 = Color3.fromRGB(230, 140, 10)
		if speedDashConnection then speedDashConnection:Disconnect() speedDashConnection = nil end
	end
end)

-- Scanner Function for Closest Target Player
local function getClosestPlayer()
	local closestPlayer = nil
	local shortestDistance = math.huge
	local myCharacter = localPlayer.Character
	local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
	if not myRoot then return nil end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if root and hum and hum.Health > 0 then
				local distance = (myRoot.Position - root.Position).Magnitude
				if distance < shortestDistance then
					shortestDistance = distance
					closestPlayer = player
				end
			end
		end
	end
	return closestPlayer
end

-- Shared Tool Setup Management
local function handleToolToggle(toolButton, toolName, setupFunction)
	local targetBackpack = localPlayer:WaitForChild("Backpack")
	local existingTool = targetBackpack:FindFirstChild(toolName) or (localPlayer.Character and localPlayer.Character:FindFirstChild(toolName))

	if existingTool then
		existingTool:Destroy()
		toolButton.Text = "Tool: " .. toolName .. " [OFF]"
		toolButton.TextColor3 = Color3.fromRGB(230, 140, 10)
	else
		local newTool = Instance.new("Tool")
		newTool.Name = toolName
		newTool.RequiresHandle = false
		setupFunction(newTool)
		newTool.Parent = targetBackpack
		toolButton.Text = "Tool: " .. toolName .. " [ON]"
		toolButton.TextColor3 = Color3.fromRGB(50, 255, 50)
	end
end

-- Original Tools Toggles
toggle_scythe.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_scythe, "Admin Scythe", function(tool)
		tool.Activated:Connect(function()
			local character = localPlayer.Character
			local rootPart = character and character:FindFirstChild("HumanoidRootPart")
			if not rootPart then return end
			local targetPlayer = getClosestPlayer()
			local targetChar = targetPlayer and targetPlayer.Character
			local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local direction = (targetRoot.Position - rootPart.Position).Unit
				rootPart.Velocity = (direction * scytheDashForce) + Vector3.new(0, scytheUpwardForce, 0)
			end
		end)
	end)
end)

toggle_grapple.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_grapple, "Web Grapple", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root and mouse.Target then
				local targetPos = mouse.Hit.Position
				local dashForce = Instance.new("BodyVelocity")
				dashForce.MaxForce = Vector3.new(1e6, 1e6, 1e6)
				dashForce.Velocity = (targetPos - root.Position).Unit * 160
				dashForce.Parent = root
				task.wait(0.25)
				dashForce:Destroy()
			end
		end)
	end)
end)

toggle_push.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_push, "Repulsion Blaster", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				local lookDirection = camera.CFrame.LookVector
				root.Velocity = Vector3.new(-lookDirection.X * 170, 45, -lookDirection.Z * 170)
			end
		end)
	end)
end)

toggle_glider.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_glider, "Jet Glider", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				local lookDir = camera.CFrame.LookVector
				root.Velocity = Vector3.new(lookDir.X * 140, 12, lookDir.Z * 140)
			end
		end)
	end)
end)

toggle_anchor.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_anchor, "Gravity Anchor", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then root.Velocity = Vector3.new(0, 0, 0) end
		end)
	end)
end)

-- 10 Advantage Movement Tools Toggles
toggle_blink.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_blink, "Phase Blink", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if root and hum then
				local moveDir = hum.MoveDirection
				if moveDir.Magnitude == 0 then moveDir = root.CFrame.LookVector end
				root.CFrame = root.CFrame + (moveDir * 25)
			end
		end)
	end)
end)

local positionHistory = {}
task.spawn(function()
	while true do
		task.wait(0.1)
		local char = localPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			table.insert(positionHistory, root.CFrame)
			if #positionHistory > 30 then table.remove(positionHistory, 1) end
		end
	end
end)

toggle_rewind.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_rewind, "Time Rewinder", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root and #positionHistory > 0 then
				root.CFrame = positionHistory[1]
				table.clear(positionHistory)
			end
		end)
	end)
end)

toggle_vault.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_vault, "Pole Vault", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then root.Velocity = Vector3.new(root.Velocity.X, 180, root.Velocity.Z) end
		end)
	end)
end)

toggle_magnet.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_magnet, "Player Magnet", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local target = getClosestPlayer()
			local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
			if root and targetRoot then
				root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
			end
		end)
	end)
end)

local hoverActive = false
local hoverConnection
toggle_hover.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_hover, "Hover Board", function(tool)
		tool.Activated:Connect(function()
			hoverActive = not hoverActive
			if hoverActive then
				hoverConnection = RunService.Heartbeat:Connect(function()
					local char = localPlayer.Character
					local root = char and char:FindFirstChild("HumanoidRootPart")
					if root then
						root.Velocity = Vector3.new(root.CFrame.LookVector.X * 110, root.Velocity.Y, root.CFrame.LookVector.Z * 110)
					end
				end)
			else
				if hoverConnection then hoverConnection:Disconnect() end
			end
		end)
	end)
end)

toggle_slingshot.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_slingshot, "Slingshot", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root and mouse.Hit then
				local dir = (mouse.Hit.Position - root.Position).Unit
				root.Velocity = dir * 210
			end
		end)
	end)
end)

toggle_boostpad.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_boostpad, "Instant Pad", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				local pad = Instance.new("Part")
				pad.Size = Vector3.new(5, 0.5, 5)
				pad.CFrame = root.CFrame - Vector3.new(0, 3, 0)
				pad.Anchored = true
				pad.BrickColor = BrickColor.new("Lime green")
				pad.Parent = workspace

				local connection
				connection = pad.Touched:Connect(function(hit)
					if hit:IsDescendantOf(char) then
						root.Velocity = Vector3.new(root.Velocity.X, 140, root.Velocity.Z)
						connection:Disconnect()
						pad:Destroy()
					end
				end)
				task.delay(4, function() if pad.Parent then pad:Destroy() end end)
			end
		end)
	end)
end)

local chargeStart = 0
toggle_charge_btn.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_charge_btn, "Kinetic Charge", function(tool)
		tool.Equipped:Connect(function() chargeStart = os.clock() end)
		tool.Activated:Connect(function()
			local elapsed = math.clamp(os.clock() - chargeStart, 1, 5)
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then root.Velocity = root.CFrame.LookVector * (elapsed * 65) end
			chargeStart = os.clock()
		end)
	end)
end)

toggle_swap.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_swap, "Position Swapper", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local target = getClosestPlayer()
			local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
			if root and targetRoot then
				local temp = root.CFrame
				root.CFrame = targetRoot.CFrame
				targetRoot.CFrame = temp
			end
		end)
	end)
end)

toggle_vortex.MouseButton1Click:Connect(function()
	handleToolToggle(toggle_vortex, "Tailwind Vortex", function(tool)
		tool.Activated:Connect(function()
			local char = localPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				local force = Instance.new("BodyThrust")
				force.Force = Vector3.new(0, 0, -35000)
				force.Parent = root
				task.wait(0.4)
				force:Destroy()
			end
		end)
	end)
end)

localPlayer.CharacterAdded:Connect(function() if flyToggle then stopFlying() end end)

-- Constant Validation Loop
task.spawn(function()
	while GooseClient and GooseClient.Parent do
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			if speedToggle and humanoid.WalkSpeed ~= 100 and not flyToggle then humanoid.WalkSpeed = 100 end
			if jumpToggle then
				humanoid.UseJumpPower = true
				if humanoid.JumpPower ~= 120 then humanoid.JumpPower = 120 end
			end
		end
		task.wait(0.1)
	end
end)

-- Cleanup Handler
local function cleanTool(toolName)
	local t1 = localPlayer.Backpack:FindFirstChild(toolName)
	if t1 then t1:Destroy() end
	if localPlayer.Character then
		local t2 = localPlayer.Character:FindFirstChild(toolName)
		if t2 then t2:Destroy() end
	end
end

-- UI Destruction Clean-up Actions
dest_button.MouseButton1Click:Connect(function()
	speedToggle = false
	jumpToggle = false
	noclipToggle = false
	tpToggle = false
	infJumpToggle = false
	floatToggle = false
	lowGravToggle = false
	bhopToggle = false
	spinToggle = false
	tpWalkToggle = false
	highJumpToggle = false
	speedDashToggle = false
	hoverActive = false

	workspace.Gravity = 196.2
	if tpInputConnection then tpInputConnection:Disconnect() end
	if noclipConnection then noclipConnection:Disconnect() end
	if infJumpConnection then infJumpConnection:Disconnect() end
	if bhopConnection then bhopConnection:Disconnect() end
	if spinConnection then spinConnection:Disconnect() end
	if tpWalkConnection then tpWalkConnection:Disconnect() end
	if highJumpConnection then highJumpConnection:Disconnect() end
	if speedDashConnection then speedDashConnection:Disconnect() end
	if hoverConnection then hoverConnection:Disconnect() end
	if floatPart then floatPart:Destroy() end

	cleanTool("Admin Scythe")
	cleanTool("Web Grapple")
	cleanTool("Repulsion Blaster")
	cleanTool("Jet Glider")
	cleanTool("Gravity Anchor")
	cleanTool("Phase Blink")
	cleanTool("Time Rewinder")
	cleanTool("Pole Vault")
	cleanTool("Player Magnet")
	cleanTool("Hover Board")
	cleanTool("Slingshot")
	cleanTool("Instant Pad")
	cleanTool("Kinetic Charge")
	cleanTool("Position Swapper")
	cleanTool("Tailwind Vortex")

	stopFlying()

	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = 16
		if humanoid.UseJumpPower then humanoid.JumpPower = 50 else humanoid.JumpHeight = 7.2 end
	end
	GooseClient:Destroy()
end)
