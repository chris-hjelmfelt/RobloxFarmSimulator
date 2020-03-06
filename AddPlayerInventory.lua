game.Players.PlayerAdded:connect(function(player)
	local playerValues = Instance.new("Model")
    playerValues.Name = "PlayerInventory"
    playerValues.Parent = player

	-- Plot 1

	local total = Instance.new("IntValue") 
    total.Name = "Total"
	total.Parent = playerValues  
    total.Value = 0 

	local v1 = Instance.new("IntValue") 
    v1.Name = "Potatoes"
	v1.Parent = playerValues  
    v1.Value = 10 
    
	local v2 = Instance.new("IntValue") 
    v2.Name = "Carrots"
	v2.Parent = playerValues   
    v2.Value = 0
	
	local v3 = Instance.new("IntValue") 
    v3.Name = "Onions"
	v3.Parent = playerValues  
    v3.Value = 0
		
	local v4 = Instance.new("IntValue") 
    v4.Name = "Pumpkins"
	v4.Parent = playerValues  
    v4.Value = 0

	local v5 = Instance.new("IntValue") 
    v5.Name = "Corn"
	v5.Parent = playerValues   
    v5.Value = 0	
	
	local v6 = Instance.new("IntValue") 
    v6.Name = "Tomatoes"
	v6.Parent = playerValues  
    v6.Value = 0

	local v7 = Instance.new("IntValue") 
    v7.Name = "Wheat"
	v7.Parent = playerValues  
    v7.Value = 0

	local v8 = Instance.new("IntValue") 
    v8.Name = "Beans"
	v8.Parent = playerValues   
    v8.Value = 0

	local v9 = Instance.new("IntValue") 
    v9.Name = "Squash"
	v9.Parent = playerValues   
    v9.Value = 0

	local v10 = Instance.new("IntValue") 
    v10.Name = "Melons"
	v10.Parent = playerValues   
    v10.Value = 0

	local v11 = Instance.new("IntValue") 
    v11.Name = "Peas"
	v11.Parent = playerValues   
    v11.Value = 0

	local v12 = Instance.new("IntValue") 
    v12.Name = "Peppers"
	v12.Parent = playerValues   
    v12.Value = 0

	-- Plot 2

	local v13 = Instance.new("IntValue") 
    v13.Name = "Lettuce"
	v13.Parent = playerValues   
    v13.Value = 0

	local v14 = Instance.new("IntValue") 
    v14.Name = "Strawberries"
	v14.Parent = playerValues   
    v14.Value = 0

	local v15 = Instance.new("IntValue") 
    v15.Name = "Cotton"
	v15.Parent = playerValues   
    v15.Value = 0

	local v16 = Instance.new("IntValue") 
    v16.Name = "Tea"
	v16.Parent = playerValues   
    v16.Value = 0

	local v17 = Instance.new("IntValue") 
    v17.Name = "Soybeans"
	v17.Parent = playerValues   
    v17.Value = 0

	local v18 = Instance.new("IntValue") 
    v18.Name = "Yams"
	v18.Parent = playerValues   
    v18.Value = 0

	local v19 = Instance.new("IntValue") 
    v19.Name = "Grapes"
	v19.Parent = playerValues   
    v19.Value = 0

	local v20 = Instance.new("IntValue") 
    v20.Name = "Coffee"
	v20.Parent = playerValues   
    v20.Value = 0

	local v21 = Instance.new("IntValue") 
    v21.Name = "Rice"
	v21.Parent = playerValues   
    v21.Value = 0

	local v22 = Instance.new("IntValue") 
    v22.Name = "Spinach"
	v22.Parent = playerValues   
    v22.Value = 0

	local v23 = Instance.new("IntValue") 
    v23.Name = "Garlic"
	v23.Parent = playerValues   
    v23.Value = 0

	local v24 = Instance.new("IntValue") 
    v24.Name = "SugarCane"
	v24.Parent = playerValues   
    v24.Value = 0

		
	
end)
