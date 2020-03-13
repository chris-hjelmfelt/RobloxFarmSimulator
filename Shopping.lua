local player = game.Players.LocalPlayer
local shopGui = player.PlayerGui:WaitForChild("ShopGui")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local truckGamePassID = 8496920  
local telportGamePassID = 8496944  

-- Main shop Gui
function OpenShop()
	player.PlayerGui:WaitForChild("ShopGui").GamePass.Visible = true
end
player.PlayerGui:WaitForChild("HUDGui").HUD.Misc.Shop.MouseButton1Click:Connect(OpenShop)


-- Function to prompt purchase of the game pass
local function PromptPurchase(gamePassID) 
	local hasPass = false

	local success, message = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassID)
	end) 
	if not success then
		warn("Error while checking if player has pass: " .. tostring(message))
		return
	end

	if hasPass then  -- Player already owns the game pass		
		shopGui.AlreadyOwned.Visible = true
	else  -- Player does NOT own the game pass - prompt them to purchase		
		MarketplaceService:PromptGamePassPurchase(player, gamePassID)
	end
end
shopGui.GamePass.Items.Truck.MouseButton1Click:Connect(function() PromptPurchase(truckGamePassID) end)
shopGui.GamePass.Items.Teleport.MouseButton1Click:Connect(function() PromptPurchase(telportGamePassID) end)

