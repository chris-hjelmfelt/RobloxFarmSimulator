local player = game.Players.LocalPlayer
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local marketGui = player.PlayerGui:WaitForChild("MarketGui")
local helpGui = player.PlayerGui:WaitForChild("HelpGui")
local hudGui = player.PlayerGui:WaitForChild("HUDGui")
local truck = invGui.Truck
local truckHere = false
local gameValues = workspace:WaitForChild("GameValues")
local each = gameValues:GetChildren()  -- list of items 
local values = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues")
local helperModule = require(workspace.ModuleScript)
local values = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues
local upgradeGui = player.PlayerGui:WaitForChild("UpgradeGui")
local storeLevels = workspace.GameValues2.StorageLevels.Value:split(",")
local storeCost = workspace.GameValues2.StorageCost.Value:split(",")
local farmSpaceCost = workspace.GameValues2.FarmSpaceCost.Value:split(",")


-----------------------------
-- Set guis at start of game
------------------------------
-- Hide Backpack items
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

-- Storage upgrade buttons visible or not
if values.StorageLevel.Value < 8 then
	invGui.Storage.Upgrade.Visible = true
	hudGui.Warning.Upgrade.Visible = true
else
	invGui.Storage.Upgrade.Visible = false
	hudGui.Warning.Upgrade.Visible = false
end


---------------------
-- Inventory 
---------------------
function OpenStorage()	
	local zone = workspace:FindFirstChild(player.Name .. "_Farm").LoadingZone
	invGui.Storage.Visible = true
	truck.Visible = false	
	truckHere = helperModule.checkTruckHere(player, zone)
	if truckHere == true then
		ShowHideSell(true)
	else
		ShowHideSell(false)
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenStorage").OnClientEvent:Connect(OpenStorage)  -- Comes from PlayerAddRemove


function OpenTruck()	
	truck.Visible = true
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenTruck").OnClientEvent:Connect(OpenTruck)  -- Comes from PlayerAddRemove


-- Show or Hide truck inventory and transfer buttons in Storage Gui
function ShowHideSell(show)
	invGui.Warning.Visible = not show
	invGui.Storage.Ready.Visible = show
	local child = invGui.Storage.Items:GetChildren()
	for i=1,#child do
		child[i].TextBox.Visible = show
	end
	truck.Visible = show
end

-------------
-- Market
-------------
function OpenMarket()	
	print("OpenGuis Market")
	truckHere = helperModule.checkTruckHere(player, workspace.Market:WaitForChild("SellZone").Zone)
	if truckHere == true then
		marketGui.Market.Visible = true
	end	
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenMarket").OnClientEvent:Connect(OpenMarket)  -- Comes from Miscellanious



-------------
-- Upgrades
-------------
-- Set items in Farm Space Upgrade Gui and Open the Gui
function OpenUpgradeFarmGui()
	local upGui = upgradeGui.UpgradeFarmSpace.Items
	if values.NumPlots.Value == 4 then
		upGui.List1.Text = "2 more farm tiles - " .. farmSpaceCost[1] .. " Coins"
		upGui.List2.Text = "2 more farm tiles"
		upGui.List3.Text = "2 more farm tiles"
		upGui.List4.Text = "2 more farm tiles"
		upGui.List5.Text = "2 fruit trees"
	elseif values.NumPlots.Value == 6 then
		upGui.List1.Text = "2 more farm tiles - " .. farmSpaceCost[2] .. " Coins"
		upGui.List2.Text = "2 more farm tiles"
		upGui.List3.Text = "2 more farm tiles"
		upGui.List4.Text = "2 fruit trees"
		upGui.List5.Text = "2 fruit trees"
	elseif values.NumPlots.Value == 8 then
		upGui.List1.Text = "2 more farm tiles - " .. farmSpaceCost[3] .. " Coins"
		upGui.List2.Text = "2 more farm tiles"
		upGui.List3.Text = "2 fruit trees"
		upGui.List4.Text = "2 fruit trees"
		upGui.List5.Text = "2 fruit trees"
	elseif values.NumPlots.Value == 10 then
		upGui.List1.Text = "2 more farm tiles - " .. farmSpaceCost[4] .. " Coins"
		upGui.List2.Text = "2 fruit trees"
		upGui.List3.Text = "2 fruit trees"
		upGui.List4.Text = "2 fruit trees"
		upGui.List5.Visible = false
	elseif values.NumPlots.Value == 12 then
		upGui.List1.Text = "2 fruit trees - " .. farmSpaceCost[5] .. " Coins"
		upGui.List2.Text = "2 fruit trees"
		upGui.List3.Text = "2 fruit trees"
		upGui.List4.Visible = false
		upGui.List5.Visible = false
	end
	upgradeGui.UpgradeFarmSpace.Visible = true
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenUpgradeFarm").OnClientEvent:Connect(OpenUpgradeFarmGui)


-- Purchase Farm Space Upgrade
function UpgradeFarmSpace()
	upgradeGui.UpgradeFarmSpace.Visible = false
	game:GetService("ReplicatedStorage"):WaitForChild("BuyFarmSpace"):FireServer() -- Goes to PlayerAddRemove 
end
upgradeGui.UpgradeFarmSpace.Items.Button.MouseButton1Click:Connect(UpgradeFarmSpace)


-- Set items in Gui for buying more storage space and open the Gui
function OpenUpgradeStorageGui()
	local upGui = upgradeGui.UpgradeStorage.Items
	if values.StorageLevel.Value == 1 then
		upGui.List1.Text = "Store " .. storeLevels[2] .. " Items - " .. storeCost[2] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[3] .. " Items"
		upGui.List3.Text = "Store " .. storeLevels[4] .. " Items"
		upGui.List4.Text = "Store " .. storeLevels[5] .. " Items"
		upGui.List5.Text = "Store " .. storeLevels[6] .. " Items"
	elseif values.StorageLevel.Value == 2 then
		upGui.List1.Text = "Store " .. storeLevels[3] .. " Items - " .. storeCost[3] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[4] .. " Items"
		upGui.List3.Text = "Store " .. storeLevels[5] .. " Items"
		upGui.List4.Text = "Store " .. storeLevels[6] .. " Items"
		upGui.List5.Text = "Store " .. storeLevels[7] .. " Items"
	elseif values.StorageLevel.Value == 3 then
		upGui.List1.Text = "Store " .. storeLevels[4] .. " Items - " .. storeCost[4] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[5] .. " Items"
		upGui.List3.Text = "Store " .. storeLevels[6] .. " Items"
		upGui.List4.Text = "Store " .. storeLevels[7] .. " Items"
		upGui.List5.Text = "Store " .. storeLevels[8] .. " Items"
	elseif values.StorageLevel.Value == 4 then
		upGui.List1.Text = "Store " .. storeLevels[5] .. " Items - " .. storeCost[5] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[6] .. " Items"
		upGui.List3.Text = "Store " .. storeLevels[7] .. " Items"
		upGui.List4.Text = "Store " .. storeLevels[8] .. " Items"
		upGui.List5.Visible = false
	elseif values.StorageLevel.Value == 5 then
		upGui.List1.Text = "Store " .. storeLevels[6] .. " Items - " .. storeCost[6] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[7] .. " Items"
		upGui.List3.Text = "Store " .. storeLevels[8] .. " Items"
		upGui.List4.Visible = false
		upGui.List5.Visible = false
	elseif values.StorageLevel.Value == 6 then
		upGui.List1.Text = "Store " .. storeLevels[7] .. " Items - " .. storeCost[7] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[8] .. " Items"
		upGui.List3.Visible = false
		upGui.List4.Visible = false
		upGui.List5.Visible = false
	elseif values.StorageLevel.Value == 7 then
		upGui.List1.Text = "Store " .. storeLevels[8] .. " Items - " .. storeCost[8] .. " Coins"
		upGui.List2.Visible = false
		upGui.List3.Visible = false
		upGui.List4.Visible = false
		upGui.List5.Visible = false
	end
	invGui.Storage.Visible = false
	invGui.Truck.Visible = false
	upgradeGui.UpgradeStorage.Visible = true
end
hudGui.Warning.Upgrade.MouseButton1Click:Connect(OpenUpgradeStorageGui)
invGui.Storage.Upgrade.MouseButton1Click:Connect(OpenUpgradeStorageGui)


-- Purchase more storage space
function UpgradeStorage()
	local cost = tonumber(storeCost[values.StorageLevel.Value+1])
	if values.Money.Value > cost then
		upgradeGui.UpgradeStorage.Visible = false
		game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("StorageLevel", 1, true)  -- Goes to Misc ChangePlayerValue()
		game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("Money", cost, false)  -- Goes to Misc ChangePlayerValue()	
		upgradeGui.UpgradeConfirm.Items.List1.Text = "You have increased your available storage space!"
		upgradeGui.UpgradeConfirm.Visible = true		
		if values.StorageLevel.Value >= 7 then
			invGui.Storage.Upgrade.Visible = false
			hudGui.Warning.Upgrade.Visible = false
		end
		game:GetService("ReplicatedStorage"):WaitForChild("BiggerStorage"):FireServer()
	end
end
upgradeGui.UpgradeStorage.Items.Button.MouseButton1Click:Connect(UpgradeStorage)


-- open Gui to confirm Upgrade
function OpenUpgrades()	
	upgradeGui.UpgradeConfirm.Items.List1.Text = "You've upgraded your farm"
	upgradeGui.UpgradeConfirm.Visible = true
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenUpgrades").OnClientEvent:Connect(OpenUpgrades)  -- Comes from PlayerAddRemove BuyUpgrades


---------------
-- Help Gui
---------------
function OpenHelp()
	helpGui.Help1.Visible = true
end
hudGui.HUD.Help.MouseButton1Click:Connect(OpenHelp)


----------------
-- Warning Gui
----------------
function OpenWarning(sent)	
	hudGui.Warning.TextLabel.Text = sent
	hudGui.Warning.Visible = true
end
game:GetService("ReplicatedStorage"):WaitForChild("Warning").OnClientEvent:Connect(OpenWarning)  -- Comes from ModuleScript



