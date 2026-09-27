--============================================================
-- SPX HUB - STEAL A EGG
-- SERVER SYSTEM
-- Steal / Collect / Speed / Teleport
--============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--============================================================
-- CONFIG
--============================================================

local CONFIG = {
	MAX_SPEED = 60,
	DEFAULT_SPEED = 16,

	STEAL_DISTANCE = 15,
	COLLECT_DISTANCE = 15,

	TELEPORT_HEIGHT = 5,

	STEAL_COOLDOWN = 0.5,
	COLLECT_COOLDOWN = 0.25,
	TELEPORT_COOLDOWN = 1,
	SPEED_COOLDOWN = 0.5,
}

--============================================================
-- REMOTE FOLDER
--============================================================

local remoteFolder = ReplicatedStorage:FindFirstChild("SPX_Remotes")

if not remoteFolder then
	remoteFolder = Instance.new("Folder")
	remoteFolder.Name = "SPX_Remotes"
	remoteFolder.Parent = ReplicatedStorage
end

local function getRemote(name)
	local remote = remoteFolder:FindFirstChild(name)

	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = remoteFolder
	end

	return remote
end

local StealRemote = getRemote("StealEgg")
local CollectRemote = getRemote("CollectEgg")
local SpeedRemote = getRemote("SetSpeed")
local TeleportRemote = getRemote("TeleportBase")

--============================================================
-- PLAYER DATA
--============================================================

local PlayerData = {}

local function setupPlayer(player)
	PlayerData[player] = {
		SpeedEnabled = false,
		CarryingEgg = nil,

		LastSteal = 0,
		LastCollect = 0,
		LastTeleport = 0,
		LastSpeed = 0,
	}
end

Players.PlayerAdded:Connect(setupPlayer)

Players.PlayerRemoving:Connect(function(player)
	PlayerData[player] = nil
end)

for _, player in ipairs(Players:GetPlayers()) do
	setupPlayer(player)
end

--============================================================
-- CHARACTER / ROOT
--============================================================

local function getCharacter(player)
	local character = player.Character

	if not character then
		return nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not root then
		return nil
	end

	if humanoid.Health <= 0 then
		return nil
	end

	return character, humanoid, root
end

--============================================================
-- COOLDOWN
--============================================================

local function canUse(player, key, cooldown)
	local data = PlayerData[player]

	if not data then
		return false
	end

	local now = os.clock()

	if now - data[key] < cooldown then
		return false
	end

	data[key] = now

	return true
end

--============================================================
-- FIND MY BASE
--============================================================

local function getPlayerBase(player)
	local plots = workspace:FindFirstChild("Plots")

	if not plots then
		return nil
	end

	for _, plot in ipairs(plots:GetChildren()) do

		-- Method 1:
		-- plot.Data.Owner
		local data = plot:FindFirstChild("Data")

		if data then
			local owner = data:FindFirstChild("Owner")

			if owner then

				-- ObjectValue
				if owner:IsA("ObjectValue") then
					if owner.Value == player then
						return plot
					end
				end

				-- StringValue
				if owner:IsA("StringValue") then
					if owner.Value == player.Name then
						return plot
					end
				end

				-- IntValue / NumberValue
				if owner:IsA("IntValue") or owner:IsA("NumberValue") then
					if tonumber(owner.Value) == player.UserId then
						return plot
					end
				end
			end
		end

		-- Method 2:
		-- Attribute Owner
		local attributeOwner = plot:GetAttribute("Owner")

		if attributeOwner == player.Name
			or attributeOwner == player.UserId then

			return plot
		end
	end

	return nil
end

--============================================================
-- BASE POSITION
--============================================================

local function getBasePosition(player)
	local plot = getPlayerBase(player)

	if not plot then
		return nil
	end

	local success, pivot = pcall(function()
		return plot:GetPivot()
	end)

	if success and pivot then
		return pivot.Position + Vector3.new(
			0,
			CONFIG.TELEPORT_HEIGHT,
			0
		)
	end

	return nil
end

--============================================================
-- FIND NEAREST EGG
--============================================================

local function findNearestEgg(player)
	local character, humanoid, root = getCharacter(player)

	if not root then
		return nil
	end

	local eggsFolder =
		workspace:FindFirstChild("Eggs")
		or workspace:FindFirstChild("FieldEggs")

	if not eggsFolder then
		return nil
	end

	local nearestEgg = nil
	local nearestDistance = CONFIG.STEAL_DISTANCE

	for _, egg in ipairs(eggsFolder:GetChildren()) do

		local part

		if egg:IsA("BasePart") then
			part = egg

		elseif egg:IsA("Model") then
			part = egg.PrimaryPart
				or egg:FindFirstChildWhichIsA(
					"BasePart",
					true
				)
		end

		if part then
			local distance =
				(root.Position - part.Position).Magnitude

			if distance <= nearestDistance then
				nearestDistance = distance
				nearestEgg = egg
			end
		end
	end

	return nearestEgg
end

--============================================================
-- STEAL EGG
--============================================================

StealRemote.OnServerEvent:Connect(function(player)

	if not canUse(
		player,
		"LastSteal",
		CONFIG.STEAL_COOLDOWN
	) then
		return
	end

	local data = PlayerData[player]

	if not data then
		return
	end

	-- Already carrying
	if data.CarryingEgg then
		return
	end

	local egg = findNearestEgg(player)

	if not egg then
		return
	end

	-- Mark owner/carrier
	data.CarryingEgg = egg

	egg:SetAttribute("CarriedBy", player.UserId)
	egg:SetAttribute("IsStolen", true)

	-- Move egg to player
	local character, humanoid, root =
		getCharacter(player)

	if not root then
		data.CarryingEgg = nil
		return
	end

	local eggPart

	if egg:IsA("BasePart") then
		eggPart = egg

	elseif egg:IsA("Model") then
		eggPart =
			egg.PrimaryPart
			or egg:FindFirstChildWhichIsA(
				"BasePart",
				true
			)
	end

	if eggPart then

		eggPart.Anchored = false

		eggPart.CFrame =
			root.CFrame
			* CFrame.new(0, 2, -2)

		local weld = Instance.new("WeldConstraint")
		weld.Name = "SPX_EggCarryWeld"
		weld.Part0 = root
		weld.Part1 = eggPart
		weld.Parent = eggPart
	end

	print(
		"[SPX] "
			.. player.Name
			.. " stole an egg"
	)
end)

--============================================================
-- COLLECT EGG
--============================================================

CollectRemote.OnServerEvent:Connect(function(player)

	if not canUse(
		player,
		"LastCollect",
		CONFIG.COLLECT_COOLDOWN
	) then
		return
	end

	local data = PlayerData[player]

	if not data then
		return
	end

	local egg = data.CarryingEgg

	if not egg then
		return
	end

	local character, humanoid, root =
		getCharacter(player)

	if not root then
		return
	end

	-- Verify player is at base
	local basePosition =
		getBasePosition(player)

	if not basePosition then
		return
	end

	local distance =
		(root.Position - basePosition).Magnitude

	if distance > CONFIG.COLLECT_DISTANCE then
		return
	end

	-- Remove weld
	if egg then
		local weld =
			egg:FindFirstChild(
				"SPX_EggCarryWeld",
				true
			)

		if weld then
			weld:Destroy()
		end
	end

	-- Give reward
	-- Replace this section with your own currency system.
	local leaderstats =
		player:FindFirstChild("leaderstats")

	if leaderstats then
		local eggs =
			leaderstats:FindFirstChild("Eggs")

		if eggs and eggs:IsA("IntValue") then
			eggs.Value += 1
		end
	end

	-- Remove egg from world
	if egg and egg.Parent then
		egg:Destroy()
	end

	data.CarryingEgg = nil

	print(
		"[SPX] "
			.. player.Name
			.. " collected an egg"
	)
end)

--============================================================
-- SPEED
--============================================================

SpeedRemote.OnServerEvent:Connect(function(
	player,
	enabled
)

	if not canUse(
		player,
		"LastSpeed",
		CONFIG.SPEED_COOLDOWN
	) then
		return
	end

	local data = PlayerData[player]

	if not data then
		return
	end

	data.SpeedEnabled =
		enabled == true

	local character, humanoid =
		getCharacter(player)

	if not humanoid then
		return
	end

	if data.SpeedEnabled then
		humanoid.WalkSpeed =
			CONFIG.MAX_SPEED
	else
		humanoid.WalkSpeed =
			CONFIG.DEFAULT_SPEED
	end
end)

--============================================================
-- TELEPORT TO BASE
--============================================================

TeleportRemote.OnServerEvent:Connect(function(player)

	if not canUse(
		player,
		"LastTeleport",
		CONFIG.TELEPORT_COOLDOWN
	) then
		return
	end

	local character, humanoid, root =
		getCharacter(player)

	if not root then
		return
	end

	local basePosition =
		getBasePosition(player)

	if not basePosition then
		warn(
			"[SPX] Base not found for "
				.. player.Name
		)

		return
	end

	root.CFrame =
		CFrame.new(basePosition)

	print(
		"[SPX] "
			.. player.Name
			.. " teleported to base"
	)
end)

--============================================================
-- RESPAWN HANDLER
--============================================================

local function setupCharacter(player, character)

	local humanoid =
		character:WaitForChild(
			"Humanoid",
			10
		)

	if not humanoid then
		return
	end

	local data =
		PlayerData[player]

	if data then

		data.CarryingEgg = nil

		task.wait(0.2)

		humanoid.WalkSpeed =
			data.SpeedEnabled
			and CONFIG.MAX_SPEED
			or CONFIG.DEFAULT_SPEED
	end
end

Players.PlayerAdded:Connect(function(player)

	player.CharacterAdded:Connect(
		function(character)
			setupCharacter(
				player,
				character
			)
		end
	)

end)

for _, player in ipairs(
	Players:GetPlayers()
) do

	if player.Character then
		task.spawn(
			setupCharacter,
			player,
			player.Character
		)
	end

	player.CharacterAdded:Connect(
		function(character)
			setupCharacter(
				player,
				character
			)
		end
	)
end

print(
	"================================================"
)

print(
	"SPX HUB Server System Loaded"
)

print(
	"Steal / Collect / Speed / Teleport: READY"
)

print(
	"================================================"
)
