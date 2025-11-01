local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remotesFolder = ReplicatedStorage:FindFirstChild("MotaRemotes") or Instance.new("Folder", ReplicatedStorage)
remotesFolder.Name = "MotaRemotes"

local function remote(name)
	return remotesFolder:FindFirstChild(name) or Instance.new("RemoteEvent", remotesFolder)
end

local SaveLocation = remote("SaveLocation")
local TeleportToSaved = remote("TeleportToSaved")
local PassThroughWall = remote("PassThroughWall")

local saved = {}

SaveLocation.OnServerEvent:Connect(function(p)
	local c = p.Character
	if c and c:FindFirstChild("HumanoidRootPart") then
		saved[p.UserId] = c.HumanoidRootPart.CFrame
	end
end)

TeleportToSaved.OnServerEvent:Connect(function(p)
	local c = p.Character
	if c and c:FindFirstChild("HumanoidRootPart") and saved[p.UserId] then
		c.HumanoidRootPart.CFrame = saved[p.UserId] + Vector3.new(0,3,0)
	end
end)

PassThroughWall.OnServerEvent:Connect(function(p)
	local c = p.Character
	if not c then return end
	for _,v in pairs(c:GetDescendants()) do
		if v:IsA("BasePart") then v.CanCollide=false end
	end
	task.wait(3)
	for _,v in pairs(c:GetDescendants()) do
		if v:IsA("BasePart") then v.CanCollide=true end
	end
end)
