function AddGameValues2()
	local gameValues = Instance.new("Model")
    gameValues.Name = "GameMisc"
    gameValues.Parent = workspace.GameValues
 
	local storeL = Instance.new("StringValue") 
    storeL.Name = "StorageLevels"
	storeL.Parent = gameValues  
    storeL.Value = "40,100,200,300,500,750,1000,2000" 

	local storeC = Instance.new("StringValue") 
    storeC.Name = "StorageCost"
	storeC.Parent = gameValues  
    storeC.Value = "200,600,1500,3000,5000,10000,20000,50000,100000" 

	local storeC = Instance.new("StringValue") 
    storeC.Name = "FarmSpaceCost"
	storeC.Parent = gameValues  
    storeC.Value = "30,100,300,600,2000,6000,15000,30000,100000"   

	local xpNeeded = Instance.new("StringValue") 
    xpNeeded.Name = "NextLevelXP"
	xpNeeded.Parent = gameValues  
    xpNeeded.Value = "100,300,600,1000,2000,3500,5000,7000,9000,11000,14000,17000"
end
AddGameValues2()
