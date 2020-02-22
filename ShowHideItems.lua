local player = game.Players.LocalPlayer
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local hudGui = player.PlayerGui:WaitForChild("HUDGui")
local truck = invGui.Truck.Items
local inventory = game:GetService("Players"):FindFirstChild(player.Name).PlayerInventory
local values = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues
local storeLevels = workspace.GameValues2.StorageLevels.Value:split(",")

-- Show Inventory
local list = invGui.Storage.Items:GetChildren()
local total = inventory.Total.Value
while true do
	for i=1,#list do
		if list[i].ClassName == "TextLabel" then
			local quantity = inventory:FindFirstChild(list[i].Name).Value - truck:FindFirstChild(list[i].Name).Amount.Text
			list[i].Amount.Text = quantity
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
	wait(.5)
end
