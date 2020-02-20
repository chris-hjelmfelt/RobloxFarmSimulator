

--[[
local farms = workspace.Farms:GetChildren()
for i=1,#farms do
	local location = farms[i].CFrame	
	farms[i]:Destroy()	
	local newPlot = game.ServerStorage:FindFirstChild("FarmModel"):Clone()
	newPlot.Parent = workspace.Farms
	newPlot.Name = "FarmModel"		
	newPlot:SetPrimaryPartCFrame(location) 
	newPlot:FindFirstChild("Owner").Value = "X"
end
--]]

-----------------
-- Market
-----------------
function OpenMarket(player)
	local values = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues")
	--if values.Level >= 3 then	
		game:GetService("ReplicatedStorage"):WaitForChild("OpenMarket"):FireClient(player) -- Sends to OpenGuis LocalScript
	--end
end
workspace:FindFirstChild("Market").ClickDetector.mouseClick:connect(OpenMarket);


-----------------
-- OrderBoard
-----------------
function OpenOrders(player)
	
	game:GetService("ReplicatedStorage"):WaitForChild("OpenOrders"):FireClient(player) -- Sends to OrderBoard LocalScript
end
workspace:FindFirstChild("Orderboard").ClickDetector.mouseClick:connect(OpenOrders);



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


