local player = game.Players.LocalPlayer
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local marketGui = player.PlayerGui:WaitForChild("MarketGui")
local values = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues")
local truck = invGui.Storage
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
					helperModule.GainCoins(player, addMoney)
					totalItems = totalItems + itemsSold[i].TextBox.Text
					totalCoins = totalCoins + addMoney
					game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("MoneySet"):FireServer(addMoney, true)  -- Goes to Miscellanious - State Events
					game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("InventorySet"):FireServer(itemsSold[i].Name, itemsSold[i].TextBox.Text, false)  -- Goes to Miscellanious - State Events
					marketGui.Market.Items:FindFirstChild(itemsSold[i].Name).Amount.Text = marketGui.Market.Items:FindFirstChild(itemsSold[i].Name).Amount.Text - itemsSold[i].TextBox.Text
					itemsSold[i].TextBox.Text = 0
				end
			end
		else
			marketGui.WarnNumbers.Visible = true
		end
	end
	if totalCoins > 0 then
		player.PlayerGui:WaitForChild("HUDGui").HUD.Money.Text = values.Money.Value
		marketGui.Sold.Message1.Text = "You sold " .. totalItems .. " items"
		marketGui.Sold.Message2.Text = "For " .. totalCoins .. " Coins"
		marketGui.Sold.Visible = true
		if values.Tutorial.Value < 14 or values.Tutorial.Value > 15 then
			marketGui.Market.Visible = false
		end
	end
	-- Make sure inventory totals are still correct
	helperModule.CheckInvTotal(player)
end
marketGui:WaitForChild("Market").Sell.MouseButton1Click:Connect(SellVeggies)

