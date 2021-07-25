local players = game:GetService("Players")	
local serverStorage = game:GetService("ServerStorage")
local helperModule = require(workspace.ModuleScript)
local farmSpaceCost = workspace:WaitForChild("GameValues"):WaitForChild("GameMisc").FarmSpaceCost.Value:split(",")


-----------------
-- Market
-----------------
function OpenMarket(player)
	game:GetService("ReplicatedStorage"):WaitForChild("OpenMarket"):FireClient(player) -- Sends to OpenGuis LocalScript
end
workspace:FindFirstChild("Market").ClickDetector.mouseClick:connect(OpenMarket);


-----------------
-- OrderBoard
-----------------
function OpenOrders(player)	
	game:GetService("ReplicatedStorage"):WaitForChild("OpenOrders"):FireClient(player) -- Sends to OrderBoard LocalScript
end
workspace:FindFirstChild("Orderboard").ClickDetector.mouseClick:connect(OpenOrders);


-----------------
-- Quests
-----------------
function OpenQuests(player, who)
	game:GetService("ReplicatedStorage"):WaitForChild("OpenQuests"):FireClient(player, who) -- Sends to Quests LocalScript
end
workspace:WaitForChild("Quest Zone").Devon.ClickDetector.mouseClick:connect(function(player) OpenQuests(player, "Devon") end);
workspace:WaitForChild("Stable").Stan.ClickDetector.mouseClick:connect(function(player) OpenQuests(player, "Stan") end);
workspace:WaitForChild("Delivery").Marie.ClickDetector.mouseClick:connect(function(player) OpenQuests(player, "Marie") end);
workspace:WaitForChild("Corral").Emma.ClickDetector.mouseClick:connect(function(player) OpenQuests(player, "Emma") end);
workspace:WaitForChild("BlueHouse").Wyatt.ClickDetector.mouseClick:connect(function(player) OpenQuests(player, "Wyatt") end);


-----------------------
-- Upgrade Farm Space
-----------------------
-- Most upgrade functions are in OpenGuis
function BuyUpgrade(player)
	local farm = workspace:FindFirstChild(player.Name .. "_Farm")
	local numPlots = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues.NumPlots
	local moneyNeeded = tonumber(farmSpaceCost[numPlots.Value/2-1])
	local playerMoney = players:FindFirstChild(player.Name):WaitForChild("PlayerValues").Money
	local numPlots = players:FindFirstChild(player.Name):WaitForChild("PlayerValues").NumPlots 
	
	if playerMoney.Value > moneyNeeded and numPlots.Value < 12 then  -- if they have the money and don't have all tiles yet
		playerMoney.Value = playerMoney.Value - moneyNeeded
		numPlots.Value = numPlots.Value + 2
		-- show new farm tile model
		helperModule.PlaceFarmTiles(player)  	
		-- open UpgradeGui to tell them what they get
		game:GetService("ReplicatedStorage"):WaitForChild("OpenUpgrades"):FireClient(player, numPlots)  -- Goes to OpenGuis localscript
	elseif numPlots.Value >= 12 then
		game:GetService("ReplicatedStorage"):WaitForChild("Warning"):FireClient(player, "Sorry this upgrade isn't active yet") -- Goes to OpenGuis Warning()
	end	
end
game:GetService("ReplicatedStorage"):WaitForChild("BuyFarmSpace").OnServerEvent:Connect(BuyUpgrade)  -- comes from OpenGuis UpgradeFarmSpace()


-------------------------
-- Change Storage Model
-------------------------
function NewStorage(player)
	helperModule.PlaceStorageModel(player)
end
game:GetService("ReplicatedStorage"):WaitForChild("BiggerStorage").OnServerEvent:Connect(NewStorage)  -- comes from OpenGuis UpgradeStorage()


---------------------------------------------------
-- Add or Subtract from PlayerValues and Inventory
---------------------------------------------------
function ChangePlayerValue(player, item, quantity, addBool)
	local values = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues")		
	if quantity == 0 then   -- set which plot is clicked -- Comes from PickVeggies ChooseSeeds()
		game:GetService("Players"):WaitForChild(player.Name).ActivePlot.Value = item
	else
		local itemAmount = values:WaitForChild(item)
		if addBool == true then			
			itemAmount.Value = itemAmount.Value + quantity
		else
			itemAmount.Value = itemAmount.Value - quantity
		end
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue").OnServerEvent:Connect(ChangePlayerValue) -- this comes from localscripts  PickVeggies ChooseSeeds(), Market SellVeggies(), and Levels LevelUp(), Tutorial NextAction()


function ChangePlayerInventory(player, item, quantity, addBool)	
	local inventory = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerInventory")	
	local itemAmount = inventory:WaitForChild(item)
	if addBool == true then			
		itemAmount.Value = itemAmount.Value + quantity
	else
		itemAmount.Value = itemAmount.Value - quantity
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("ChangeInventory").OnServerEvent:Connect(ChangePlayerInventory) -- this comes from localscripts PickVeggies HarvestPlants() and Market SellVeggies()


function UpdatePlayerInventoryTotals(player, correctValue)
	local inventory = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerInventory")
	inventory.Total.Value = correctValue
end
game:GetService("ReplicatedStorage"):WaitForChild("UpdateInventoryTotal").OnServerEvent:Connect(UpdatePlayerInventoryTotals) -- this comes from localscripts PickVeggies HarvestPlants() and Market SellVeggies()


function ChangeLeaderstats(player)	
	local stat = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("leaderstats")	
	stat.Level.Value = stat.Level.Value + 1
end
game:GetService("ReplicatedStorage"):WaitForChild("ChangeLeaderstats").OnServerEvent:Connect(ChangeLeaderstats) -- this comes from localscripts PickVeggies HarvestPlants() and Market SellVeggies() and Levels LevelUp()


function ResetTutorial(player)
	local values = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues")	
	values.Tutorial.Value = 1
end
game:GetService("ReplicatedStorage").Tutorial:WaitForChild("ResetTut").OnServerEvent:Connect(ResetTutorial) -- this comes from Tutorial


--------------------
-- Teleport Buttons
--------------------
function FarmTeleport(player)
	local playerModel = workspace:WaitForChild(player.Name)
	local farm = workspace:WaitForChild(player.Name .. "_Farm")
	farm.Truck.Seat1.Disabled = true
	wait(.5)	
	playerModel:WaitForChild("HumanoidRootPart").CFrame = farm.SpawnLocation.CFrame  + Vector3.new(0, 3, 0)	
	wait(.5)
	farm.Truck.Seat1.Disabled = false
end
game:GetService("ReplicatedStorage"):WaitForChild("TeleportToFarm").OnServerEvent:Connect(FarmTeleport)  -- comes from OpenGuis FarmTeleport()

function MarketTeleport(player)
	local playerModel = workspace:WaitForChild(player.Name)
	local farm = workspace:WaitForChild(player.Name .. "_Farm")
	farm.Truck.Seat1.Disabled = true	
	wait(.5)
	playerModel:WaitForChild("HumanoidRootPart").CFrame = workspace.Market.Spawn.CFrame  + Vector3.new(0, 3, 0)	
	wait(.5)
	farm.Truck.Seat1.Disabled = false	
end
game:GetService("ReplicatedStorage"):WaitForChild("TeleportToMarket").OnServerEvent:Connect(MarketTeleport)  -- comes from OpenGuis MarketTeleport()



--[[ 
------------------------------------------
-- Test placement of all farms
------------------------------------------
local farms = workspace.Farms:GetChildren()
for i=1,#farms do
	local location = farms[i].CFrame	
	farms[i]:Destroy()	
	local newPlot = game.ServerStorage:FindFirstChild("FarmModel"):Clone()
	newPlot.Parent = workspace.Farms
	newPlot.Name = "FarmModel"		
	newPlot:SetPrimaryPartCFrame(location) 
	newPlot:FindFirstChild("Owner").Value = "X"
end
--]]