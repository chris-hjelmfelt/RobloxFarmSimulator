
-- Saving and Loading settings --
local AUTO_SAVE = true		-- Make true to enable auto saving
local TIME_BETWEEN_SAVES = 60	-- In seconds (WARNING): Do not put this lower than 60 seconds
local PRINT_OUTPUT = false		-- Will print saves and loads in the output
local SAFE_SAVE = true			-- Upon server shutdown, holds server open to save all data
---------------------------------

local players = game:GetService("Players")
local dataStoreService = game:GetService("DataStoreService")
local playerInventoryData = dataStoreService:GetDataStore("PlayerInventory")
-- BE VERY CAREFUL WHEN COPYING - DON'T USE THIS SCRIPT - USE HOUSE STATS OR SOMETHING FROM SCIENCE CENTER 
-- IF YOU DON"T GET ALL VARIABLES CHANGED YOU COULD OVERWRITE THE STATS YOU COPIED THIS FROM!

local function Print(message)
	if PRINT_OUTPUT then print(message) end
end


local function SaveData(player)
	if player.userId < 0 then return end
	player:WaitForChild("PlayerInventory")
	wait(1)
	local playerInventoryStats = {}
	for i, stat in pairs(player.PlayerInventory:GetChildren()) do
		table.insert(playerInventoryStats, {stat.Name, stat.Value})
	end
	Passed, Error = pcall(function() playerInventoryData:SetAsync(player.userId, playerInventoryStats) end)
	assert(Passed, Error)
end


local function LoadData(player)
	if player.userId < 0 then return end
	player:WaitForChild("PlayerInventory")
	local playerInventoryStats = playerInventoryData:GetAsync(player.userId)
	for i, stat in pairs(playerInventoryStats) do
		local currentStat = player.PlayerInventory:FindFirstChild(stat[1])
		if not currentStat then return end
		currentStat.Value = stat[2]
	end
end

players.PlayerAdded:connect(LoadData)
players.PlayerRemoving:connect(SaveData)


if SAFE_SAVE and not game:GetService("RunService"):IsStudio() then
	game:BindToClose(function()
		for i, player in pairs(players:GetChildren()) do
			SaveData(player)
		end
		wait(1)
	end)
end


while AUTO_SAVE do
	wait(TIME_BETWEEN_SAVES)
	for i, player in pairs(players:GetChildren()) do
		SaveData(player)
	end
end


