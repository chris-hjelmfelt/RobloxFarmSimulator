local player = game.Players.LocalPlayer
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local hudGui = player.PlayerGui:WaitForChild("HUDGui")
local inventory = game:GetService("Players"):FindFirstChild(player.Name).PlayerInventory
local values = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues
local storeLevels = workspace:WaitForChild("GameValues"):WaitForChild("GameMisc").StorageLevels.Value:split(",")
local helperModule = require(workspace.ModuleScript)


-- Show Inventory
local list = invGui.Storage.Items:GetChildren()
local list3 = player.PlayerGui:WaitForChild("MarketGui").Market.Items:GetChildren()
while wait(1) do
	local total = inventory.Total.Value 
	for i=1,#list do
		if list[i].ClassName == "TextLabel" then
			local quantity = inventory:FindFirstChild(list[i].Name).Value
			list[i].Amount.Text = quantity
			list3[i].Amount.Text = quantity
			if list[i].Amount.Text == "0" then
				list[i].TextColor3 = Color3.new(0.6, 0.6, 0.6)
				list[i].Amount.TextColor3 = Color3.new(0.6, 0.6, 0.6)				
			else
				list[i].TextColor3 = Color3.new(0, 0, 0)
				list[i].Amount.TextColor3 = Color3.new(0, 0, 1)				
			end
		end
	end	
	hudGui.HUD.Money.Text = "Money: " .. values.Money.Value
	invGui.Storage.NumItems.Text = total .. "/"	.. storeLevels[values.StorageLevel.Value]
end


