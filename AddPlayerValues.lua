game.Players.PlayerAdded:connect(function(player)
	local playerValues = Instance.new("Model")
    playerValues.Name = "PlayerValues"
    playerValues.Parent = player

	local level = Instance.new("IntValue")
 	level.Name = "Level"
    level.Parent = playerValues 
    level.Value = 1   -- starts at 1
	
	local xp = Instance.new("IntValue")
 	xp.Name = "Experience"
    xp.Parent = playerValues 
	xp.Value = 0	-- starts at 0

	local money = Instance.new("IntValue") 
    money.Name = "Money"
    money.Parent = playerValues 
	money.Value = 0		-- starts at 0

	local tut = Instance.new("IntValue")
	tut.Name = "Tutorial"
	tut.Parent = playerValues 
    tut.Value = 1	 -- starts at 1	

	local numPlots = Instance.new("IntValue") 
    numPlots.Name = "NumPlots" 
    numPlots.Parent = playerValues
    numPlots.Value = 4   -- starts at 4
	
	local store = Instance.new("IntValue") 
    store.Name = "StorageLevel" 
    store.Parent = playerValues
    store.Value = 1   -- starts at 1

	local trees = Instance.new("IntValue") 
	trees.Name = "TreesAvailable" 
	trees.Parent = playerValues
	trees.Value = 0		-- starts at 0

	local animals = Instance.new("IntValue") 
	animals.Name = "AnimalsAvailable" 
	animals.Parent = playerValues
	animals.Value = 0	-- starts at 0

	local harvests = Instance.new("IntValue") 
	harvests.Name = "PlantsHarvested" 
	harvests.Parent = playerValues
	harvests.Value = 0    -- starts at 0

	local quest01 = Instance.new("IntValue") 
	quest01.Name = "Quest01_Progress" 
	quest01.Parent = playerValues
	quest01.Value = 1    -- starts at 1



	-- The following will be trash if I reset all player saves

	local broken = Instance.new("BoolValue")
	broken.Name = "BrokenData"
	broken.Parent = playerValues
	broken.Value = false  -- if true test data overwrote their progress :(

	local broken2 = Instance.new("IntValue")
	broken2.Name = "BrokenData2"
	broken2.Parent = playerValues
	broken2.Value = 0  -- 0 is default, it means they haven't gone through the change screen 

	local quest = Instance.new("IntValue") 
	quest.Name = "QuestProgress" 
	quest.Parent = playerValues
	quest.Value = 1    -- starts at 1
end)