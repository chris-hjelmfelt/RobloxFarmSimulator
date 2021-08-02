local player = game.Players.LocalPlayer
local orderGui = player.PlayerGui:WaitForChild("OrderGui"):WaitForChild("OrderBoard").Items
local values = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues")
local inventory = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerInventory")
local plants = workspace:WaitForChild("GameValues"):WaitForChild("PlantCosts")
local orderTimer1 = 0  -- timer for a new order to appear
local orderTimer2 = 0
local orderTimer3 = 0
local orderTimer4 = 0
local orderTimer5 = 0
local timerLength = 30
local customOrderBonus = 1.5
local helperModule = require(workspace.ModuleScript)


-- open Orderboard Gui
function OpenOrders()	
	if values.Level.Value >= 3 then
		player.PlayerGui:WaitForChild("OrderGui"):WaitForChild("OrderBoard").Visible = true
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenOrders").OnClientEvent:Connect(OpenOrders) -- comes from Misc OpenOrders()


-- Finish order and send it for profit
function SendOrder(num)
	local orderNum = "Order" .. num
	-- Sell the items in the order
	local item1 = orderGui:FindFirstChild(orderNum).Item1
	local amount1 = orderGui:FindFirstChild(orderNum).Amount1	
	local item2 = orderGui:FindFirstChild(orderNum).Item2
	local amount2 = orderGui:FindFirstChild(orderNum).Amount2
	local value1 = inventory:WaitForChild(item1.Text)  -- number of items in storage
	local value2 = inventory:WaitForChild(item2.Text)
	local p1 = workspace.GameValues:WaitForChild("PlantCosts"):FindFirstChild(item1.Text).Value  -- find sale price of item1
	local p2 = workspace.GameValues.PlantCosts:FindFirstChild(item2.Text).Value

	-- Make sure they have their truck to deliver
	local check = helperModule.checkTruckHere(player, workspace.Orderboard.SellZone)
	if check == true then	
		-- Check that they have the items available (fast clicks on Gui buttons can allow double orders)
		if value1.Value >= tonumber(amount1.Text) and item2.Visible == false then   -- Single item order
			local profit = math.ceil(p1 * amount1.Text) * customOrderBonus  -- calculate value of items with a bonus for custom order
			orderGui:FindFirstChild(orderNum).Visible = false
			game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("MoneySet"):FireServer(profit, true)  -- Goes to Miscellanious - State Events
			game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("InventorySet"):FireServer(item1.Text, amount1.Text, false)  -- Goes to Miscellanious - State Events
			if num == "1" then orderTimer1 = timerLength elseif num == "2" then orderTimer2 = timerLength elseif num == "3" then orderTimer3 = timerLength elseif num == "4" then orderTimer4 = timerLength elseif num == "5" then orderTimer5 = timerLength end   -- set the timer for a new order
		elseif value1.Value >= tonumber(amount1.Text) and value2.Value >= tonumber(amount2.Text) then   -- Double item order
			local profit = math.ceil((p1 * amount1.Text) + (p2 * amount2.Text)) * customOrderBonus
			orderGui:FindFirstChild(orderNum).Visible = false
			game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("MoneySet"):FireServer(profit, true)  -- Goes to Miscellanious - State Events
			game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("InventorySet"):FireServer(item1.Text, amount1.Text, false)  -- Goes to Miscellanious - State Events
			game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("InventorySet"):FireServer(item2.Text, amount2.Text, false)  -- Goes to Miscellanious - State Events
			if num == "1" then orderTimer1 = timerLength elseif num == "2" then orderTimer2 = timerLength elseif num == "3" then orderTimer3 = timerLength elseif num == "4" then orderTimer4 = timerLength elseif num == "5" then orderTimer5 = timerLength end  -- set the timer for a new order
		end
	else
		player.PlayerGui:WaitForChild("OrderGui"):WaitForChild("OrderBoard").Visible = false
		player.PlayerGui:WaitForChild("OrderGui").WarnTruck.Visible = true
	end
end
-- Order Buttons
orderGui.Order1.Done.MouseButton1Click:Connect(function() SendOrder("1")end)
orderGui.Order2.Done.MouseButton1Click:Connect(function() SendOrder("2")end)
orderGui.Order3.Done.MouseButton1Click:Connect(function() SendOrder("3")end)
orderGui.Order4.Done.MouseButton1Click:Connect(function() SendOrder("4")end)
orderGui.Order5.Done.MouseButton1Click:Connect(function() SendOrder("5")end)


-- See what items are in storage and show checkmarks and Done button
function CheckOrderStatus(num)
	local orderNum = "Order" .. num
	local item1 = orderGui:FindFirstChild(orderNum).Amount1  -- number of items required
	local item2 = orderGui:FindFirstChild(orderNum).Amount2
	local value1 = inventory:WaitForChild(orderGui:FindFirstChild(orderNum).Item1.Text)  -- number of items in storage
	local value2 = inventory:WaitForChild(orderGui:FindFirstChild(orderNum).Item2.Text)
	local check1 = orderGui:FindFirstChild(orderNum).Check1  -- checkmark on Gui
	local check2 = orderGui:FindFirstChild(orderNum).Check2
	if value1.Value >= tonumber(item1.Text) then  -- enough of first item
		check1.Visible = true
	else
		check1.Visible = false
	end
	if value2.Value >= tonumber(item2.Text) and item2.Visible == true then  -- enough of second item
		check2.Visible = true
	else
		check2.Visible = false
	end
	if value1.Value >= tonumber(item1.Text) and item2.Visible == false then  -- show button to complete order
		orderGui:FindFirstChild(orderNum).Done.Visible = true
	elseif value1.Value >= tonumber(item1.Text) and value2.Value >= tonumber(item2.Text) then
		orderGui:FindFirstChild(orderNum).Done.Visible = true
	else
		orderGui:FindFirstChild(orderNum).Done.Visible = false
	end
end


-- Once timer is finished show a new order
function CreateNewOrder(num)
	local orderNum = "Order" .. num
	local values = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues")
	local numItemsAvailable = values.Level.Value + 1  -- how many total items do they have available to create
	local level = values.Level.Value
	local safety = 0  -- no infinite loops	
	local randTotal = math.random(1,2)   -- How many different items in the order
	local randItem1 = math.random(1,numItemsAvailable)  -- Which item 
	local randItem2 = math.random(1,numItemsAvailable)
	while randItem2 == randItem1 and safety < 1000 do  -- don't do the same item twice
		randItem2 = math.random(1,numItemsAvailable)
		safety = safety +1
	end
	local randAmount1 = math.random(2,10) + ((level - 2) * 2)  -- quantity needed   (at level 3 min is 4 max is 12 - goes up 2 each level from there)
	local randAmount2 = math.random(2,10) + ((level - 2) * 2)
	local item1 = orderGui:FindFirstChild(orderNum).Item1
	local amount1 = orderGui:FindFirstChild(orderNum).Amount1	
	local item2 = orderGui:FindFirstChild(orderNum).Item2
	local amount2 = orderGui:FindFirstChild(orderNum).Amount2
	
	local each = plants:GetChildren()  -- list of items 
	
	if randTotal == 2 then  -- fill the textLabels on the Gui with the random items and amounts
		item1.Text = each[randItem1].Name
		item2.Text = each[randItem2].Name
		amount1.Text = randAmount1 
		amount2.Text = randAmount2 		
	else		            -- skip item2 if randTotal = 1
		item1.Text = each[randItem1].Name
		amount1.Text = randAmount1 
		item2.Visible = false
		amount2.Visible = false
	end
	orderGui:FindFirstChild(orderNum).Check2.Visible = false
	orderGui:FindFirstChild(orderNum).Check2.Visible = false
	orderGui:FindFirstChild(orderNum).Done.Visible = false
	orderGui:FindFirstChild(orderNum).Visible = true
end


-- Setup a whole group of orders to start with
function InitialOrders()	
	workspace.Orderboard.Order3.SGui.Warn.Visible = false
	workspace.Orderboard.Order1.SGui.Info.Visible = true
	workspace.Orderboard.Order2.SGui.Info.Visible = true
	workspace.Orderboard.Order3.SGui.Info.Visible = true
	workspace.Orderboard.Order4.SGui.Info.Visible = true
	workspace.Orderboard.Order5.SGui.Info.Visible = true
	CreateNewOrder("1")
	CreateNewOrder("2")
	CreateNewOrder("3")
	CreateNewOrder("4")
	CreateNewOrder("5")
end
game:GetService("ReplicatedStorage"):WaitForChild("ReachedLevel").Event:connect(function(level)  InitialOrders() end)  -- comes from Levels ShowLevelGui()


-- If they are high enough show messages on Orderboard and setup intial orders
if values.Level.Value >= 3 then
	workspace:WaitForChild("Orderboard").Order3.SGui.Warn.Visible = false
	workspace.Orderboard.Order1.SGui.Info.Visible = true
	workspace.Orderboard.Order2.SGui.Info.Visible = true
	workspace.Orderboard.Order3.SGui.Info.Visible = true
	workspace.Orderboard.Order4.SGui.Info.Visible = true
	workspace.Orderboard.Order5.SGui.Info.Visible = true
	InitialOrders()
end

-- Keep Orderboard Gui updated
while true do
	-- Keep current orders up to date
	CheckOrderStatus("1")
	CheckOrderStatus("2")
	CheckOrderStatus("3")
	CheckOrderStatus("4")
	CheckOrderStatus("5")
	-- Add a new order in a blank space after a wait time
	if orderGui.Order1.Visible == false then
		if orderTimer1 <= 0 then
			CreateNewOrder("1")
		else
			orderTimer1 = orderTimer1 - 1
		end
	end
	if orderGui.Order2.Visible == false then
		if orderTimer2 <= 0 then
			CreateNewOrder("2")
		else
			orderTimer2 = orderTimer2 - 1
		end
	end
	if orderGui.Order3.Visible == false then
		if orderTimer3 <= 0 then
			CreateNewOrder("3")
		else
			orderTimer3 = orderTimer3 - 1
		end
	end
	if orderGui.Order4.Visible == false then
		if orderTimer4 <= 0 then
			CreateNewOrder("4")
		else
			orderTimer4 = orderTimer4 - 1
		end
	end
	if orderGui.Order5.Visible == false then
		if orderTimer5 <= 0 then
			CreateNewOrder("5")
		else
			orderTimer5 = orderTimer5 - 1
		end
	end
	wait(1)
end