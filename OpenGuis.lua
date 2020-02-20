local player = game.Players.LocalPlayer
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local marketGui = player.PlayerGui:WaitForChild("MarketGui")
local helpGui = player.PlayerGui:WaitForChild("HelpGui")
local truck = invGui.Truck
local truckHere = false
local gameValues = workspace:WaitForChild("GameValues")
local each = gameValues:GetChildren()  -- list of items 
local helperModule = require(workspace.ModuleScript)

-- Hide Backpack items
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)


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


function OpenMarket()	
	truckHere = helperModule.checkTruckHere(player, workspace.Market.SellZone.Zone)
	if truckHere == true then
		marketGui.Market.Visible = true
	end	
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenMarket").OnClientEvent:Connect(OpenMarket)  -- Comes from Miscellanious


function OpenHelp()
	helpGui.Help1.Visible = true
end
invGui.HUD.Help.MouseButton1Click:Connect(OpenHelp)


function OpenUpgrades(playerLevel)
	local upgradeGui = player.PlayerGui:WaitForChild("UpgradeGui").Upgrade
	if playerLevel.Value <= 5 then
		upgradeGui.Items.List1.Text = "2 more farm tiles"
		upgradeGui.Items.List2.Text = each[playerLevel.Value*2-1].Name -- find the new seeds in the array
		upgradeGui.Items.List3.Text = each[playerLevel.Value*2].Name
		upgradeGui.Items.List4.Visible = false
		upgradeGui.Items.List5.Visible = false
	end
	upgradeGui.Visible = true
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenUpgrades").OnClientEvent:Connect(OpenUpgrades)  -- Comes from PlayerAddRemove


-- Show or Hide button to open truck inventory and sell buttons in Storage Gui
function ShowHideSell(show)
	invGui.Warning.Visible = not show
	invGui.Storage.Ready.Visible = show
	local child = invGui.Storage.Items:GetChildren()
	for i=1,#child do
		child[i].TextBox.Visible = show
	end
	truck.Visible = show
end