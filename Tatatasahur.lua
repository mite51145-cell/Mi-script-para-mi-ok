-- Hub Mota con TP2 sobre plataforma física
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MotaGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0,100,0,40)
toggleButton.Position = UDim2.new(0,10,0,10)
toggleButton.Text = "Mota"
toggleButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleButton.TextColor3 = Color3.fromRGB(255,255,255)
toggleButton.TextScaled = true
toggleButton.Parent = screenGui

-- Hub frame
local hubFrame = Instance.new("Frame")
hubFrame.Name = "MotaHub"
hubFrame.Size = UDim2.new(0,300,0,220)
hubFrame.Position = UDim2.new(0,150,0,100)
hubFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
hubFrame.Visible = false
hubFrame.Parent = screenGui
hubFrame.Active = true

-- TitleBar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,30)
titleBar.BackgroundColor3 = Color3.fromRGB(20,20,20)
titleBar.Parent = hubFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Mota"
titleLabel.Size = UDim2.new(1,0,1,0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
titleLabel.TextScaled = true
titleLabel.Parent = titleBar

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,30,0,30)
closeButton.Position = UDim2.new(1,-35,0,0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeButton.TextColor3 = Color3.fromRGB(255,255,255)
closeButton.Parent = hubFrame

-- TP button
local tpButton = Instance.new("TextButton")
tpButton.Size = UDim2.new(0, 100,0,40)
tpButton.Position = UDim2.new(0,20,0,50)
tpButton.Text = "TP"
tpButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
tpButton.TextColor3 = Color3.fromRGB(255,255,255)
tpButton.TextScaled = true
tpButton.Parent = hubFrame

-- TP2 button (plataforma física)
local tp2Button = Instance.new("TextButton")
tp2Button.Size = UDim2.new(0, 100,0,40)
tp2Button.Position = UDim2.new(0,140,0,50)
tp2Button.Text = "TP2"
tp2Button.BackgroundColor3 = Color3.fromRGB(60,60,60)
tp2Button.TextColor3 = Color3.fromRGB(255,255,255)
tp2Button.TextScaled = true
tp2Button.Parent = hubFrame

-- TP3 button (barrera protectora)
local tp3Button = Instance.new("TextButton")
tp3Button.Size = UDim2.new(0, 120, 0, 40)
tp3Button.Position = UDim2.new(0, 20, 0, 110)
tp3Button.Text = "TP3 Barrera"
tp3Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
tp3Button.TextColor3 = Color3.fromRGB(255,255,255)
tp3Button.TextScaled = true
tp3Button.Parent = hubFrame

-- Toggle y Close
toggleButton.MouseButton1Click:Connect(function()
	hubFrame.Visible = not hubFrame.Visible
end)

closeButton.MouseButton1Click:Connect(function()
	hubFrame.Visible = false
end)

-- Hub movible
local dragging = false
local dragOffset = Vector2.new()
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		local mousePos = input.Position
		dragOffset = Vector2.new(hubFrame.Position.X.Offset - mousePos.X, hubFrame.Position.Y.Offset - mousePos.Y)
	end
end)
titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local mousePos = input.Position
		hubFrame.Position = UDim2.new(0, mousePos.X + dragOffset.X, 0, mousePos.Y + dragOffset.Y)
	end
end)

-- TP logic
local savedPosition = nil
tpButton.MouseButton1Click:Connect(function()
	if savedPosition then
		hrp.CFrame = savedPosition
	else
		savedPosition = hrp.CFrame
		warn("Posición guardada para TP")
	end
end)

-- TP2 con plataforma física
tp2Button.MouseButton1Click:Connect(function()
	if savedPosition then
		local character = player.Character
		if not character then return end
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		-- Crear plataforma física debajo del personaje
		local platform = Instance.new("Part")
		platform.Size = Vector3.new(8,1,8)
		platform.Anchored = true
		platform.CanCollide = true
		platform.Material = Enum.Material.Neon
		platform.Transparency = 0.5
		platform.Color = Color3.fromRGB(50,50,255)
		platform.CFrame = hrp.CFrame * CFrame.new(0,-3,0)
		platform.Parent = workspace

		-- Teletransportación sobre la plataforma en pasos finos
		local steps = 40
		local startPos = hrp.Position
		local endPos = savedPosition.Position
		for i = 1, steps do
			local lerpPos = startPos:Lerp(endPos, i/steps)
			platform.CFrame = CFrame.new(lerpPos.X, lerpPos.Y - 3, lerpPos.Z)
			hrp.CFrame = CFrame.new(lerpPos)
			RunService.RenderStepped:Wait()
		end

		-- Ajustar posición final
		hrp.CFrame = savedPosition
		platform.CFrame = savedPosition * CFrame.new(0,-3,0)

		-- Mantener la plataforma por 1 segundo extra y luego eliminarla
		wait(1)
		platform:Destroy()

		warn("TP2 con plataforma completado: seguro y visible en servidor")
	else
		warn("Primero guarda una posición usando TP")
	end
end)

-- TP3 logic (barrera protectora)
local barrierActive = false
local barrier = nil
tp3Button.MouseButton1Click:Connect(function()
	if not character or not hrp then return end

	if barrierActive then
		if barrier then barrier:Destroy() end
		barrierActive = false
	else
		barrierActive = true
		barrier = Instance.new("Part")
		barrier.Size = Vector3.new(10, 6, 10)
		barrier.Anchored = true
		barrier.CanCollide = true
		barrier.Material = Enum.Material.Neon
		barrier.Transparency = 0.6
		barrier.Color = Color3.fromRGB(50,50,255)
		barrier.Parent = workspace

		local connection
		connection = RunService.RenderStepped:Connect(function()
			if not barrierActive or not barrier or not hrp.Parent then
				if connection then connection:Disconnect() end
				if barrier then barrier:Destroy() end
				return
			end
			barrier.CFrame = hrp.CFrame * CFrame.new(0, 3, 0)
		end)
	end
end)
