
local players = game:GetService("Players")	
local helperModule = require(workspace.ModuleScript)
local MarketplaceService = game:GetService("MarketplaceService")
local truckGamePassID = 8496920  
local telportGamePassID = 8496944  


players.PlayerAdded:Connect(function(player)
	CheckTruckPass(player)
	CheckTeleportPass(player)
end)


function CheckTruckPass(player)
	local hasTruckPass = false
	
	local success, message = pcall(function()
		hasTruckPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, truckGamePassID)
	end) 
	if not success then
		warn("Error while checking if player has pass: " .. tostring(message))
		helperModule.PlaceTruck(player, false)
		return
	end 

	if hasTruckPass == true then
		helperModule.PlaceTruck(player, true)
	else
		helperModule.PlaceTruck(player, false)
	end
end


function CheckTeleportPass(player)
	local hasTelePass = false
	local success, message = pcall(function()
		hasTelePass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, telportGamePassID)
	end) 
	if not success then
		warn("Error while checking if player has pass: " .. tostring(message))
		return
	end 
	if hasTelePass == true then
		game:GetService("ReplicatedStorage"):WaitForChild("ShowTeleportButtons"):FireClient(player) -- Sends to OpenGuis ShowTeleportButtons()
	end
end


-- Function to handle a completed prompt and purchase
local function onPromptGamePassPurchaseFinished(player, purchasedPassID, purchaseSuccess)
 	-- Farm Truck
	if purchaseSuccess == true and purchasedPassID == truckGamePassID then
		print(player.Name .. " purchased the game pass with ID " .. truckGamePassID)
		--Switch to special farm truck
		helperModule.PlaceTruck(player, true)
	end
	-- Teleport
	if purchaseSuccess == true and purchasedPassID == telportGamePassID then
		print(player.Name .. " purchased the game pass with ID " .. telportGamePassID)
		-- show teleport buttons
		game:GetService("ReplicatedStorage"):WaitForChild("ShowTeleportButtons"):FireClient(player) -- Sends to OpenGuis ShowTeleportButtons()
	end
end 
MarketplaceService.PromptGamePassPurchaseFinished:Connect(onPromptGamePassPurchaseFinished)