game.Players.PlayerAdded:connect(function(player)
	local playerValues = Instance.new("Model")
    playerValues.Name = "PlayerCustomize"
    playerValues.Parent = player

	-- Colors
	local tcolor = Instance.new("Color3Value") 
    tcolor.Name = "TruckColor"
    tcolor.Parent = playerValues 
    tcolor.Value = Color3.new(151, 0, 0)

	local hcolor = Instance.new("Color3Value") 
    hcolor.Name = "HouseColor"
    hcolor.Parent = playerValues 
    hcolor.Value = Color3.new(188, 155, 93)
end)
