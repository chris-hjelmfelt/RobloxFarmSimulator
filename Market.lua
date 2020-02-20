local player = game.Players.LocalPlayer
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local marketGui = player.PlayerGui:WaitForChild("MarketGui")
local truck = invGui.Truck
local truckHere = false
local helperModule = require(workspace.ModuleScript)

-- Sell the items in the basket
function SellVeggies()
	marketGui.Market.Visible = false
	local sold = truck.Items:GetChildren()	
	for i=1,#sold do
		if sold[i].ClassName == "TextLabel" and (tonumber(sold[i].Amount.Text) > 0) then
			local price = workspace.GameValues:FindFirstChild(sold[i].Text).Value  -- find sale price of the item
			local addMoney = sold[i].Amount.Text * price
			game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("Money", addMoney, true)
			game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer(sold[i].Name, sold[i].Amount.Text, false)
			truck.Items:FindFirstChild(sold[i].Name).Amount.Text = 0
		end
	end
end
marketGui.Market.Sell.MouseButton1Click:Connect(SellVeggies)


-- Put items from storage into the basket to go to market
function TransferToTruck()
	local zone = workspace:FindFirstChild(player.Name .. "_Farm").LoadingZone
	truckHere = helperModule.checkTruckHere(player, zone)
	if truckHere == true then
		local textBoxes = invGui.Storage.Items:GetChildren()
		for i = 1,#textBoxes do
			if tonumber(textBoxes[i].TextBox.Text) and tonumber(textBoxes[i].TextBox.Text) > 0 then -- make sure user only entered numbers
				if (tonumber(textBoxes[i]:FindFirstChild("Amount").Text) >= tonumber(textBoxes[i].TextBox.Text)) then  -- if they have the items
					textBoxes[i]:FindFirstChild("Amount").Text = textBoxes[i]:FindFirstChild("Amount").Text - textBoxes[i].TextBox.Text
					truck.Items:FindFirstChild(textBoxes[i].Name).Amount.Text = truck.Items:FindFirstChild(textBoxes[i].Name).Amount.Text + textBoxes[i].TextBox.Text
					textBoxes[i].TextBox.Text = 0
				end
			end
		end
	end		
end
invGui.Storage.Ready.MouseButton1Click:Connect(TransferToTruck)



-- Move items from truck into storage
function TransferToTruck()
	local zone = workspace:FindFirstChild(player.Name .. "_Farm").LoadingZone
	truckHere = helperModule.checkTruckHere(player, zone)
	if truckHere == true then
		local cargo = invGui.Truck.Items:GetChildren()
		for j = 1,#cargo do
			cargo[j].Amount.Text = 0
		end
	end		
end
invGui.Truck.Return.MouseButton1Click:Connect(TransferToTruck)
