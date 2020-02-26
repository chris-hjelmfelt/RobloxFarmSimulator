function AddGameValues2()
	local gameValues = Instance.new("Model")
    gameValues.Name = "GameValues2"
    gameValues.Parent = workspace
 
	local storeL = Instance.new("StringValue") 
    storeL.Name = "StorageLevels"
	storeL.Parent = gameValues  
    storeL.Value = "40,100,200,300,500,750,1000,2000" 

	local storeC = Instance.new("StringValue") 
    storeC.Name = "StorageCost"
	storeC.Parent = gameValues  
    storeC.Value = "400,1000,2000,3000,5000,7500,10000,20000" 

	local storeC = Instance.new("StringValue") 
    storeC.Name = "FarmSpaceCost"
	storeC.Parent = gameValues  
    storeC.Value = "100,200,300,400,600,800,1000,1200,1400"    
end
AddGameValues2()
