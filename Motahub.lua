--// 🌈 Mota Hub (Funcional)
--// Creador: ChatGPT (GPT-5)

repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MotaHub"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🌈 Mota Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = mainFrame

-- Botón de colapsar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 30, 0, 30)
toggleButton.Position = UDim2.new(1, -35, 0, 0)
toggleButton.BackgroundTransparency = 1
toggleButton.Text = "-"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 22
toggleButton.Parent = mainFrame

-- Contenedor
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
content.BorderSizePixel = 0
content.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = content

-- Función para crear botones
local function createButton(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, 10 + (order - 1) * 50)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 18
	btn.Parent = content

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(80, 80, 80)
	stroke.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
	end)

	return btn
end

-- Crear botones
local btnTP = createButton("Guardar TP", 1)
local btnTP2 = createButton("Ir a TP", 2)
local btnTRAS = createButton("TRAS (NoClip)", 3)

-- Colapsar/desplegar
local collapsed = false
toggleButton.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	local goal = {}
	if collapsed then
		goal.Size = UDim2.new(0, 320, 0, 30)
		toggleButton.Text = "+"
	else
		goal.Size = UDim2.new(0, 320, 0, 220)
		toggleButton.Text = "-"
	end
	TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), goal):Play()
end)

-- FUNCIONES
local savedPosition = nil
local noclipEnabled = false

local function getCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
	return char, char:WaitForChild("HumanoidRootPart")
end

btnTP.MouseButton1Click:Connect(function()
	local char, root = getCharacter()
	savedPosition = root.Position
	print("✅ Posición guardada:", savedPosition)
end)

btnTP2.MouseButton1Click:Connect(function()
	if savedPosition then
		local char, root = getCharacter()
		root.CFrame = CFrame.new(savedPosition)
		print("⚡ Teletransportado.")
	else
		warn("⚠️ No hay posición guardada.")
	end
end)

btnTRAS.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	btnTRAS.Text = noclipEnabled and "TRAS: Activado ✅" or "TRAS (NoClip)"
end)

-- Noclip loop
RunService.Stepped:Connect(function()
	if noclipEnabled then
		local char = player.Character
		if char then
			for _, part in ipairs(char:GetChildren()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end
	end
end)

print("🌈 Mota Hub cargado correctamente ✅")
