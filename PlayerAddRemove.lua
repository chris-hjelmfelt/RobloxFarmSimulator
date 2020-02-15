    local players = game:GetService("Players")	
	local serverStorage = game:GetService("ServerStorage")
    local farm = workspace:WaitForChild('Jaylah_EverstarFarm')
	local farmPlot1 = farm:WaitForChild('FarmTiles')
	local upgradeArray = {5,10,15,20,25,30,35,40,45,50} -- money needed for the next level
	local playerLevel = nil

-----------------
-- Farm Tiles
-----------------
function collectVeggie(player, plot)	
	local helperModule = require(workspace.ModuleScript)
	if plot.Plant.Leaf.Transparency == 0 then
		helperModule.PickPlant(player, plot)	-- pick them
	elseif plot.Weed.Weed.Transparency == 0 then	
		helperModule.RakePlant(player, plot)	-- rake them
	else
		game:GetService("ReplicatedStorage"):WaitForChild("ChooseSeeds"):FireClient(player, plot)  -- Goes to PickVeggies localScript ChooseSeeds()
	end	
end

function PlantSeeds(player, plot, seeds)
	local helperModule = require(workspace.ModuleScript)
	helperModule.PlantSeeds(player, plot, seeds)  -- Plant Seeds
end
game:GetService("ReplicatedStorage"):WaitForChild("PlantSeeds").OnServerEvent:Connect(PlantSeeds) -- Comes from PickVeggies LocalScript SendSeeds()


-----------------
-- Storage
-----------------
function OpenStorage(player)
	game:GetService("ReplicatedStorage"):WaitForChild("OpenStorage"):FireClient(player) -- Sends to OpenGuis LocalScript
end


-----------------
-- Jeep
-----------------
function OpenTruck(player)
	game:GetService("ReplicatedStorage"):WaitForChild("OpenTruck"):FireClient(player) -- Sends to OpenGuis LocalScript
end


-----------------
-- OrderBoard
-----------------
function OpenOrders(player)
	game:GetService("ReplicatedStorage"):WaitForChild("OpenOrders"):FireClient(player) -- Sends to OrderBoard LocalScript
end


-----------------
-- Upgrades
-----------------
function CheckForUpgrades()
	 local child = players:GetChildren()
	for i=1,#child do
		--local buttons = workspace:WaitForChild("child[i].Name .. "Farm").UpgradeButtons		
		playerLevel = players:FindFirstChild(child[i].Name):WaitForChild("PlayerValues").Level
		local playerMoney = players:FindFirstChild(child[i].Name):WaitForChild("PlayerValues").Money
		local moneyNeeded = upgradeArray[playerLevel.Value]
		if playerMoney.Value >= moneyNeeded and playerLevel.Value < 5 then
			--farm.buttons["Button" .. playerLevel].Transparency = 0
			--farm.buttons["Button" .. playerLevel].CanCollide = true
			farm:WaitForChild("Button").Transparency = 0
			farm.Button.ClickDetector.MaxActivationDistance = 16
			farm.Button.CanCollide = true
			farm.Button.Billboard.Cost.Visible = true
		end
	end	
end

function BuyUpgrade(player)
	playerLevel = players:FindFirstChild(player.Name):WaitForChild("PlayerValues").Level 
	--local farm = workspace:FindFirstChild(player.Name .. "Farm")

	-- Hide the button
	--farm.UpgradeButtons["Button" .. playerLevel].Transparency = 1
	--farm.UpgradeButtons["Button" .. playerLevel].CanCollide = false
	farm.Button.Transparency = 1  
	farm.Button.CanCollide = false
	farm.Button.Billboard.Cost.Visible = false
	farm.Button.ClickDetector.MaxActivationDistance = 0
	farm.Button.CFrame = farm.Button.CFrame - Vector3.new(8,0,0) -- move 8 studs 

	-- Take money and increase their level
	local moneyNeeded = upgradeArray[playerLevel.Value]
	local playerMoney = players:FindFirstChild(player.Name):WaitForChild("PlayerValues").Money
	playerMoney.Value = playerMoney.Value - moneyNeeded
	playerLevel.Value = playerLevel.Value + 1

	-- Show new models	
	if playerLevel.Value >= 2 and playerLevel.Value <= 5 then
		newPlotTiles(playerLevel.Value, farm)
	end
	-- new items are checked for in PickVeggies localscript when they pick seeds

	-- open UpgradeGui to tell them what they get
	game:GetService("ReplicatedStorage"):WaitForChild("OpenUpgrades"):FireClient(player, playerLevel)  -- Goes to OpenGuis localscript
end


function newPlotTiles(level, farm)
	local oldPlot = farm.FarmTiles
	local location = oldPlot.PrimaryPart.CFrame	
	oldPlot:Destroy()	
	local tilesNum = level * 2 + 2
	local newPlot = game.ServerStorage:FindFirstChild("FarmTiles" .. tilesNum):Clone()
	newPlot.Parent = farm
	newPlot.Name = "FarmTiles"		
	newPlot:SetPrimaryPartCFrame(location + Vector3.new(-4,0,0))  -- level1 is at 6.2, level2 is at 2.2, etc		
	HidePlants(newPlot)
	SetClickDetectors(newPlot)
end




players.PlayerAdded:Connect(function(player)
	farm = workspace:WaitForChild('Jaylah_EverstarFarm')
--[[
	local farm = serverStorage.Farm:Clone()
	farm.Parent = workspace
	farm.Name = playerName .. "_Farm"
	farm.Owner.Value = player.Name
--]]

	-- AddPlayerValues is its own script

	-- farm tile clickdetectors 
	local plot1 = farm:WaitForChild('FarmTiles')
	SetClickDetectors(plot1)
	-- storage clickdetector
	farm:FindFirstChild("Storage").ClickDetector.mouseClick:connect(OpenStorage);
	-- truck clickdetector
	farm:FindFirstChild("Truck").ClickDetector.mouseClick:connect(OpenTruck);
	-- orderboard clickdetector
	farm:FindFirstChild("Orderboard").ClickDetector.mouseClick:connect(OpenOrders);
	-- Upgrade clickdetector
	farm:FindFirstChild("Button").ClickDetector.mouseClick:connect(BuyUpgrade);
	-- Upgrade clickdetector
	farm:FindFirstChild("House").LightSwitch.ClickDetector.mouseClick:connect(LightSwitch);

	

	-- Show starting values in inventory
	local inventory = player.PlayerGui:WaitForChild("InventoryGui")
	local values = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues
	local list = inventory.Storage.Items:GetChildren()
	for i = 1,#list do	
		if list[i].Name ~= 'Title' and list[i].Name ~= 'Ready' then
			local invItem = inventory.Storage.Items:FindFirstChild(list[i].Name).Amount
			invItem.Text = values:WaitForChild(list[i].Name).Value
		end
	end

	-- Put player's name on their truck
	farm:FindFirstChild("Truck").Wood.Sign1.SurfaceGui.NameText.Text = player.Name
	farm:FindFirstChild("Truck").Wood.Sign2.SurfaceGui.NameText.Text = player.Name
	
end)
 

players.PlayerRemoving:Connect(function(player)
	local findFarms = workspace:GetChildren()
	for i = 1,#findFarms do
		if findFarms[i].Name == "Farm" and findFarms[i].Owner.Value == player.Name then
			findFarms[i]:Destroy()
		end
	end		
end)



function LightSwitch(player)
	local light1 = farm.House.OverheadLight.Light.PointLight
	local light2 = farm.House.Ceiling.SurfaceLight
	if player.Name == farm.Owner.Value then  -- only works for farm owner
		if light2.Enabled == true then
			light1.Brightness = 0
			light2.Enabled = false
		else
			light1.Brightness = .5
			light2.Enabled = true
		end
	end
end


function SetClickDetectors(farmPlot)
	local plot = farmPlot:GetChildren()
	for c = 1,#plot do
		if plot[c].Name == "Dirt Tile" then 		
			plot[c].ClickDetector.mouseClick:connect(function(player) collectVeggie(player, plot[c]) end);	-- from clickdetectors on Farm Drt Tiles
		end
	end
end



-- hide plants on start
function HidePlants(farmPlot)
	local plot = farmPlot:GetChildren()
	for c = 1,#plot do
		if plot[c].Name == "Dirt Tile" then
			for index, child in pairs(plot[c]:GetChildren()) do
				if child.Name == "Plant" then 
					for k, p in pairs(child:GetChildren()) do
						p.Transparency = 1
						p.CanCollide = false
					end
				end
			end	
			plot[c].Racking.Value = 5
		end	
	end
end
HidePlants(farmPlot1)


-- Put level in a model called leaderstats so it shows up in player list
game.Players.PlayerAdded:connect(function(player)
	local stats = Instance.new("Model")
    stats.Name = "Leaderstats"
    stats.Parent = player

	local findLevel = player:WaitForChild("PlayerValues"):WaitForChild("Level")

	local level = Instance.new("IntValue")
 	level.Name = "Level"
    level.Parent = stats 
    level.Value = findLevel.Value	
end)

while true do
	CheckForUpgrades()
	wait(5)
end
