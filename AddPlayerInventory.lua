game.Players.PlayerAdded:connect(function(player)
	local playerValues = Instance.new("Model")
    playerValues.Name = "PlayerInventory"
    playerValues.Parent = player

	local total = Instance.new("IntValue") 
    total.Name = "Total"
	total.Parent = playerValues  
    total.Value = 38 

	local v1 = Instance.new("IntValue") 
    v1.Name = "Potatoes"
	v1.Parent = playerValues  
    v1.Value = 26 
    
	local v2 = Instance.new("IntValue") 
    v2.Name = "Carrots"
	v2.Parent = playerValues   
    v2.Value = 4
	
	local v3 = Instance.new("IntValue") 
    v3.Name = "Onions"
	v3.Parent = playerValues  
    v3.Value = 4
		
	local v4 = Instance.new("IntValue") 
    v4.Name = "Pumpkins"
	v4.Parent = playerValues  
    v4.Value = 4

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
	
	
end)
