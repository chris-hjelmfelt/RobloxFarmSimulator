local player = game.Players.LocalPlayer
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local marketGui = player.PlayerGui:WaitForChild("MarketGui")
local truck = invGui.Truck
local truckHere = false
local helperModule = require(workspace.ModuleScript)

-- Sell the items in the basket
function SellVeggies()
	local itemsSold = marketGui.Market.Items:GetChildren()
	local totalItems = 0
	local totalCoins = 0
	for i = 1,#itemsSold do
		if tonumber(itemsSold[i].TextBox.Text) then
			if tonumber(itemsSold[i].TextBox.Text) > 0 then -- make sure user only entered numbers
				if (tonumber(itemsSold[i]:FindFirstChild("Amount").Text) >= tonumber(itemsSold[i].TextBox.Text)) then  -- if they have the items
					local price = workspace.GameValues:WaitForChild("PlantCosts"):FindFirstChild(itemsSold[i].Text).Value  -- find sale price of the item
					local addMoney = itemsSold[i].TextBox.Text * price
					GainCoins(addMoney)
					totalItems = totalItems + itemsSold[i].TextBox.Text
					totalCoins = totalCoins + addMoney
					game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("Money", addMoney, true)  -- Goes to Misc ChangePlayerValue()
					game:GetService("ReplicatedStorage"):WaitForChild("ChangeInventory"):FireServer(itemsSold[i].Name, itemsSold[i].TextBox.Text, false)  -- Goes to Misc ChangePlayerInventory()
					game:GetService("ReplicatedStorage"):WaitForChild("ChangeInventory"):FireServer("Total", itemsSold[i].TextBox.Text, false)  -- Goes to Misc ChangePlayerInventory()
					marketGui.Market.Items:FindFirstChild(itemsSold[i].Name).Amount.Text = marketGui.Market.Items:FindFirstChild(itemsSold[i].Name).Amount.Text - itemsSold[i].TextBox.Text
					itemsSold[i].TextBox.Text = 0
				end
			end
		else
			marketGui.WarnNumbers.Visible = true
		end
	end
	if totalCoins > 0 then
		player.PlayerGui:WaitForChild("HUDGui").HUD.Money.Text = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues.Money.Value
		marketGui.Sold.Message1.Text = "You sold " .. totalItems .. " items"
		marketGui.Sold.Message2.Text = "For " .. totalCoins .. " Coins"
		marketGui.Sold.Visible = true
		marketGui.Market.Visible = false
	end
end
marketGui:WaitForChild("Market").Sell.MouseButton1Click:Connect(SellVeggies)


--[[

-- Put items from storage into the basket to go to market
function TransferToTruck()
	
		local textBoxes = marketGui.Market.Items:GetChildren()
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
--]]

function GainCoins(amount)
	local hudText = player.PlayerGui:WaitForChild("HUDGui").GainCoins
	hudText.Text1.Text = "+" .. amount
	hudText.Visible = true
	wait(.2)
	for i = 1,8 do
		hudText.Text1.Position = hudText.Text1.Position + UDim2.new(0,0,0,-5)
		wait(.2)
	end
	hudText.Visible = false
	hudText.Text1.Position = hudText.Text1.Position + UDim2.new(0,0,0,40)
end