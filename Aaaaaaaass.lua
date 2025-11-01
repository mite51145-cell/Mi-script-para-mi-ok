local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remotes = ReplicatedStorage:WaitForChild("MotaRemotes")

local saveRemote = remotes:WaitForChild("SavePosition")
local tpRemote = remotes:WaitForChild("TeleportToSaved")
local noclipRemote = remotes:WaitForChild("ToggleNoclip")

local savedPositions = {}

saveRemote.OnServerEvent:Connect(function(player, pos)
	if typeof(pos) == "Vector3" then
		savedPositions[player] = pos
	end
end)

tpRemote.OnServerEvent:Connect(function(player)
	local pos = savedPositions[player]
	if not pos then return end
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
	end
end)

noclipRemote.OnServerEvent:Connect(function(player)
	local char = player.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
	task.wait(5)
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = true
		end
	end
end)
