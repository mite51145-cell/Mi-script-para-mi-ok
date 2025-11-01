local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Crear carpeta y RemoteEvents si no existen
local remotesFolder = ReplicatedStorage:FindFirstChild("MotaRemotes")
if not remotesFolder then
	remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "MotaRemotes"
	remotesFolder.Parent = ReplicatedStorage
end

local function getOrCreateRemote(name)
	local r = remotesFolder:FindFirstChild(name)
	if not r then
		r = Instance.new("RemoteEvent")
		r.Name = name
		r.Parent = remotesFolder
	end
	return r
end

local SaveLocationRE = getOrCreateRemote("SaveLocation")
local TeleportToSavedRE = getOrCreateRemote("TeleportToSaved")
local PassThroughWallRE = getOrCreateRemote("PassThroughWall")

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MotaHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Mota"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = frame

-- Función para crear botones
local function makeButton(text, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9, 0, 0, 40)
	btn.Position = UDim2.new(0.05, 0, 0, 35 + (order - 1) * 45)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Parent = frame
	return btn
end

local btnSave = makeButton("TP (Guardar)", 1)
local btnGoto = makeButton("TP2 (Ir)", 2)
local btnPass = makeButton("TRAS (Traspasar)", 3)

-- Cambia texto temporalmente
local function flashText(button, msg)
	local old = button.Text
	button.Text = msg
	task.wait(0.8)
	if button then
		button.Text = old
	end
end

-- Conexión de eventos
btnSave.MouseButton1Click:Connect(function()
	SaveLocationRE:FireServer()
	flashText(btnSave, "Guardado")
end)

btnGoto.MouseButton1Click:Connect(function()
	TeleportToSavedRE:FireServer()
	flashText(btnGoto, "Teletransportando")
end)

btnPass.MouseButton1Click:Connect(function()
	PassThroughWallRE:FireServer()
	flashText(btnPass, "Traspasando")
end)
