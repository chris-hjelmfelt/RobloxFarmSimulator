local player = game.Players.LocalPlayer
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local truck = invGui.Truck.Items
local values = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues

-- Show Inventory
local list = invGui.Storage.Items:GetChildren()
while true do
	for i=1,#list do
		if list[i].ClassName == "TextLabel" then
			list[i].Amount.Text = values:FindFirstChild(list[i].Name).Value - truck:FindFirstChild(list[i].Name).Amount.Text
			if list[i].Amount.Text == "0" then
				list[i].TextColor3 = Color3.new(0.6, 0.6, 0.6)
				list[i].Amount.TextColor3 = Color3.new(0.6, 0.6, 0.6)				
			else
				list[i].TextColor3 = Color3.new(0, 0, 0)
				list[i].Amount.TextColor3 = Color3.new(0, 0, 1)				
			end
		end
	end
	invGui.HUD.Money.Text = "Money: " .. values.Money.Value
	wait(.5)
end
