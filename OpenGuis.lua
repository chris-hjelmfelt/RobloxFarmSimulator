local player = game.Players.LocalPlayer
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local marketGui = player.PlayerGui:WaitForChild("MarketGui")
local helpGui = player.PlayerGui:WaitForChild("HelpGui")
local hudGui = player.PlayerGui:WaitForChild("HUDGui")
local spawnGui = player.PlayerGui:WaitForChild("RespawnGui")
local upgradeGui = player.PlayerGui:WaitForChild("UpgradeGui")
local values = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues")
local tutGui = player.PlayerGui:WaitForChild("TutorialGui")
local gameValues = workspace:WaitForChild("GameValues"):WaitForChild("PlantCosts")
local each = gameValues:GetChildren()  -- list of items 
local truckHere = false
local helperModule = require(workspace.ModuleScript)
local storeLevels = workspace:WaitForChild("GameValues"):WaitForChild("GameMisc").StorageLevels.Value:split(",")
local storeCost = workspace.GameValues.GameMisc.StorageCost.Value:split(",")
local farmSpaceCost = workspace.GameValues.GameMisc.FarmSpaceCost.Value:split(",")
local farm = workspace:WaitForChild(player.Name .. "_Farm")


---------------------
-- Respawn Truck
---------------------
spawnGui.Adornee = farm.Decorations.Driveway
function Respawn()
	if player.Name == farm.Owner.Value then
		local location= farm.Decorations.Driveway.CFrame
		farm.Truck:SetPrimaryPartCFrame(location + Vector3.new(0,2,0))
	end
end
spawnGui.Respawn.MouseButton1Click:Connect(Respawn);


-----------------------------
-- Set guis at start of game
------------------------------
-- Hide Backpack items and Teleport buttons
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
hudGui.HUD.Teleports.Visible = false

-- Make sure Inventory total is correct
helperModule.CheckInvTotal(player)

-- Storage upgrade buttons visible or not
if values.StorageLevel.Value < 8 then
	invGui.Storage.Upgrade.Visible = true
	hudGui.Warning.Upgrade.Visible = true
else
	invGui.Storage.Upgrade.Visible = false
	hudGui.Warning.Upgrade.Visible = false
end


-----------------------------------------------
-- Quests and Shopping have their own scripts
-----------------------------------------------


---------------------
-- Inventory 
---------------------
function OpenStorage()	
	invGui.Storage.Visible = true
	if game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues").Tutorial.Value == 8 then 
		game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("TutBindable"):Fire()  -- goes to Tutorial
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenStorage").OnClientEvent:Connect(OpenStorage)  -- Comes from PlayerAddRemove  OpenStorage()


-------------
-- Market
-------------
function OpenMarket()	
	truckHere = helperModule.checkTruckHere(player, workspace.Market:WaitForChild("SellZone").Zone)
	if truckHere == true then
		marketGui.Market.Visible = true
		invGui.Storage.Visible = false
		if values.Tutorial.Value == 13 then 
			game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("TutBindable"):Fire()  -- goes to Tutorial
		end
	else
		marketGui.WarnTruck.Visible = true
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
game:GetService("ReplicatedStorage"):WaitForChild("OpenUpgradeFarm").OnClientEvent:Connect(OpenUpgradeFarmGui)  -- comes from PlayerAddRemove  OpenUpgradeFarm()


-- Purchase Farm Space Upgrade
function UpgradeFarmSpace()
	upgradeGui.UpgradeFarmSpace.Visible = false
	game:GetService("ReplicatedStorage"):WaitForChild("BuyFarmSpace"):FireServer() -- Goes to Miscellanious BuyUpgrade()
end
upgradeGui.UpgradeFarmSpace.Items.Button.MouseButton1Click:Connect(UpgradeFarmSpace)


-- Set items in Gui for buying more storage space and open the Gui
function OpenUpgradeStorageGui()	
	local upGui = upgradeGui.UpgradeStorage.Items
	hudGui.Warning.Visible = false
	if values.StorageLevel.Value == 1 then
		upGui.List1.Text = "Store " .. storeLevels[2] .. " Items - " .. storeCost[1] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[3] .. " Items"
		upGui.List3.Text = "Store " .. storeLevels[4] .. " Items"
		upGui.List4.Text = "Store " .. storeLevels[5] .. " Items"
		upGui.List5.Text = "Store " .. storeLevels[6] .. " Items"
	elseif values.StorageLevel.Value == 2 then
		upGui.List1.Text = "Store " .. storeLevels[3] .. " Items - " .. storeCost[2] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[4] .. " Items"
		upGui.List3.Text = "Store " .. storeLevels[5] .. " Items"
		upGui.List4.Text = "Store " .. storeLevels[6] .. " Items"
		upGui.List5.Text = "Store " .. storeLevels[7] .. " Items"
	elseif values.StorageLevel.Value == 3 then
		upGui.List1.Text = "Store " .. storeLevels[4] .. " Items - " .. storeCost[3] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[5] .. " Items"
		upGui.List3.Text = "Store " .. storeLevels[6] .. " Items"
		upGui.List4.Text = "Store " .. storeLevels[7] .. " Items"
		upGui.List5.Text = "Store " .. storeLevels[8] .. " Items"
	elseif values.StorageLevel.Value == 4 then
		upGui.List1.Text = "Store " .. storeLevels[5] .. " Items - " .. storeCost[4] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[6] .. " Items"
		upGui.List3.Text = "Store " .. storeLevels[7] .. " Items"
		upGui.List4.Text = "Store " .. storeLevels[8] .. " Items"
		upGui.List5.Visible = false
	elseif values.StorageLevel.Value == 5 then
		upGui.List1.Text = "Store " .. storeLevels[6] .. " Items - " .. storeCost[5] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[7] .. " Items"
		upGui.List3.Text = "Store " .. storeLevels[8] .. " Items"
		upGui.List4.Visible = false
		upGui.List5.Visible = false
	elseif values.StorageLevel.Value == 6 then
		upGui.List1.Text = "Store " .. storeLevels[7] .. " Items - " .. storeCost[6] .. " Coins"
		upGui.List2.Text = "Store " .. storeLevels[8] .. " Items"
		upGui.List3.Visible = false
		upGui.List4.Visible = false
		upGui.List5.Visible = false
	elseif values.StorageLevel.Value == 7 then
		upGui.List1.Text = "Store " .. storeLevels[8] .. " Items - " .. storeCost[7] .. " Coins"
		upGui.List2.Visible = false
		upGui.List3.Visible = false
		upGui.List4.Visible = false
		upGui.List5.Visible = false
	end
	invGui.Storage.Visible = false
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
		game:GetService("ReplicatedStorage"):WaitForChild("BiggerStorage"):FireServer()  -- goes to Miscellanious NewStorage()
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
game:GetService("ReplicatedStorage"):WaitForChild("Warning").OnClientEvent:Connect(OpenWarning)  -- Comes from ModuleScript PickPlant() and Misc BuyUpgrade()


-----------------
-- Bookcase
-----------------
function OpenBookcase()
	player.PlayerGui:WaitForChild("Bookcase"):WaitForChild("ComingSoon").Visible = true
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenBookcase").OnClientEvent:Connect(OpenBookcase)  -- Comes from ModuleScript OpenBookcase()


--------------------
-- Teleport Buttons
--------------------
function ShowTeleportButtons()
	hudGui.HUD.Teleports.Visible = true
end
game:GetService("ReplicatedStorage"):WaitForChild("ShowTeleportButtons").OnClientEvent:Connect(ShowTeleportButtons)  -- comes from GamePass CheckTeleportPass() and onPromptGamePassPurchaseFinished()

function FarmTeleport()
	game:GetService("ReplicatedStorage"):WaitForChild("TeleportToFarm"):FireServer()  -- Goes to Misc FarmTeleport()
end
hudGui.HUD.Teleports.Farm.MouseButton1Click:Connect(FarmTeleport)

function MarketTeleport()
	game:GetService("ReplicatedStorage"):WaitForChild("TeleportToMarket"):FireServer()  -- Goes to Misc MarketTeleport()
end
hudGui.HUD.Teleports.Market.MouseButton1Click:Connect(MarketTeleport)