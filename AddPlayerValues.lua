game.Players.PlayerAdded:connect(function(player)
	local playerValues = Instance.new("Model")
    playerValues.Name = "PlayerValues"
    playerValues.Parent = player

	local level = Instance.new("IntValue")
 	level.Name = "Level"
    level.Parent = playerValues 
    level.Value = 1  -- starts at 1
	
	local xp = Instance.new("IntValue")
 	xp.Name = "Experience"
    xp.Parent = playerValues 
    xp.Value = 0

	local money = Instance.new("IntValue") 
    money.Name = "Money"
    money.Parent = playerValues 
    money.Value = 0

	local tut = Instance.new("IntValue")
	tut.Name = "Tutorial"
	tut.Parent = playerValues 
    tut.Value = 1	-- starts at 1
	
	local trees = Instance.new("IntValue") 
    trees.Name = "TreesAvailable" 
    trees.Parent = playerValues
    trees.Value = 0

	local animals = Instance.new("IntValue") 
    animals.Name = "AnimalsAvailable" 
    animals.Parent = playerValues
    animals.Value = 0

	local numPlots = Instance.new("IntValue") 
    numPlots.Name = "NumPlots" 
    numPlots.Parent = playerValues
    numPlots.Value = 4  -- starts at 4
	
	local store = Instance.new("IntValue") 
    store.Name = "StorageLevel" 
    store.Parent = playerValues
    store.Value = 1  -- starts at 1

	local quest = Instance.new("IntValue") 
    quest.Name = "QuestProgress" 
    quest.Parent = playerValues
    quest.Value = 1   -- starts at 1
end)