
local players = game:GetService("Players")	
local helperModule = require(workspace.ModuleScript)
--local MarketplaceService = game:GetService("MarketplaceService")
local truckGamePassID = 0000000  

players.PlayerAdded:Connect(function(player)
	local hasTruckPass = false 	
	local farm = workspace:WaitForChild(player.Name .. "_Farm")	
--[[
	local success, message = pcall(function()
		hasTruckPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, truckGamePassID)
	end) 
	if not success then
		warn("Error while checking if player has pass: " .. tostring(message))
		helperModule.PlaceTruck(player, farm, false)
		return
	end 
--]]
	if hasTruckPass == true then
		--print(player.Name .. " owns the game pass with ID " .. truckGamePassID)
		helperModule.PlaceTruck(player, farm, true)
	else
		--print(player.Name .. " does not own the Farm Truck Game Pass")
		helperModule.PlaceTruck(player, farm, false)
	end

end)
--]]