local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear RemoteEvents si no existen (para pruebas locales)
local function getOrCreateEvent(name)
	local ev = ReplicatedStorage:FindFirstChild(name)
	if not ev then
		ev = Instance.new("RemoteEvent")
		ev.Name = name
		ev.Parent = ReplicatedStorage
	end
	return ev
end

local saveEvent = getOrCreateEvent("Imran_SaveTP")
local tpEvent = getOrCreateEvent("Imran_DoTP")
local toggleTras = getOrCreateEvent("Imran_ToggleTras")

-- 🖥️ Crear interfaz
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ImranHubGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fram
