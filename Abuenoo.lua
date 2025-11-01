local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Creamos la carpeta y eventos si no existen
local folder = ReplicatedStorage:FindFirstChild("MotaHub") or Instance.new("Folder", ReplicatedStorage)
folder.Name = "MotaHub"

local function ensureEvent(name)
	local ev = folder:FindFirstChild(name)
	if not ev then
		ev = Instance.new("RemoteEvent")
		ev.Name = name
		ev.Parent = folder
	end
	return ev
end

local SaveTP = ensureEvent("SaveTP")
local GoTP = ensureEvent("GoTP")
local Noclip = ensureEvent("Noclip")

-- Guardado de ubicaciones
local savedLocations = {}

Players.PlayerRemoving:Connect(function(plr)
	savedLocations[plr.UserId] = nil
end)

local function getHRP(char)
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
end

SaveTP.OnServerEvent:Connect(function(plr)
	local hrp = getHRP(plr.Character)
	if hrp then
		savedLocations[plr.UserId] = hrp.CFrame
		print(plr.Name .. " guardó una ubicación.")
	end
end)

GoTP.OnServerEvent:Connect(function(plr)
	local cf = savedLocations[plr.UserId]
	local hrp = getHRP(plr.Character)
	if cf and hrp then
		plr.Character:SetPrimaryPartCFrame(cf + Vector3.new(0,3,0))
	end
end)

Noclip.OnServerEvent:Connect(function(plr, dur)
	local char = plr.Character
	if not char then return end
	dur = tonumber(dur) or 5
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
	task.delay(dur, function()
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end)
end)
