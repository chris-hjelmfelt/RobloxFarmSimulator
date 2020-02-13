
-----------------
-- Market
-----------------
function OpenMarket(player)
	game:GetService("ReplicatedStorage"):WaitForChild("OpenMarket"):FireClient(player) -- Sends to OpenGuis LocalScript
end
workspace:FindFirstChild("Market").ClickDetector.mouseClick:connect(OpenMarket);

---------------------------------------
-- Add or Subtract from PlayerValues
---------------------------------------
function ChangePlayerValue(player, item, quantity, addBool)	
	local values = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues")	
	if quantity == 0 then
		values.ActivePlot.Value = item
	else
		local itemAmount = values:WaitForChild(item)
		if addBool == true then			
			itemAmount.Value = itemAmount.Value + quantity
		else
			itemAmount.Value = itemAmount.Value - quantity
		end
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue").OnServerEvent:Connect(ChangePlayerValue) -- this comes from PickVeggies localscript both HarvestPlants() and ChooseSeeds()



