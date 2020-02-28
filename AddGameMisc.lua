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
    storeC.Value = "200,400,1000,2000,3000,5000,7500,10000,20000" 

	local storeC = Instance.new("StringValue") 
    storeC.Name = "FarmSpaceCost"
	storeC.Parent = gameValues  
    storeC.Value = "20,50,100,200,300,400,600,800,1000,1200,1400"   

	local xpNeeded = Instance.new("StringValue") 
    xpNeeded.Name = "NextLevelXP"
	xpNeeded.Parent = gameValues  
    xpNeeded.Value = "200,500,900,1300,1800,2400,3100,3900,4900,6000,7200"
end
AddGameValues2()
