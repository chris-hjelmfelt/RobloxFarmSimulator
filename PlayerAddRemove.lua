    local players = game:GetService("Players")	
	local serverStorage = game:GetService("ServerStorage")
	local upgradeArray = {5,10,15,20,25,30,35,40,45,50} -- money needed for the next level
	local playerLevel = nil
	local helperModule = require(workspace.ModuleScript)

-----------------
-- Farm Tiles
-----------------
function collectVeggie(player, plot)
	if player.Name == plot.Parent.Parent:FindFirstChild("Owner").Value then
		if plot.Plant.Leaf.Transparency == 0 then
			helperModule.PickPlant(player, plot)	-- pick them
		elseif plot.BrickColor.Name == "Brown" then			
			helperModule.WaterPlant(player, plot)			
		elseif plot.Weed.Weed.Transparency == 0 then	
			helperModule.RakePlant(player, plot)	-- rake them
		else
			game:GetService("ReplicatedStorage"):WaitForChild("ChooseSeeds"):FireClient(player, plot)  -- Goes to PickVeggies localScript ChooseSeeds()
		end	
	end
end

function PlantSeeds(player, plot, seeds)
	helperModule.PlantSeeds(player, plot, seeds)  -- Plant Seeds	
end
game:GetService("ReplicatedStorage"):WaitForChild("PlantSeeds").OnServerEvent:Connect(PlantSeeds) -- Comes from PickVeggies LocalScript SendSeeds()


-----------------
-- Storage
-----------------  moved into a script inside the storage model (so I can check ownership)

function OpenStorage(player, farm)
	if farm:FindFirstChild("Owner").Value == player.Name then    -- only owner can open truck
		game:GetService("ReplicatedStorage"):WaitForChild("OpenStorage"):FireClient(player) -- Sends to OpenGuis LocalScript
	end
end


-----------------
-- Truck
-----------------   moved into a script inside the truck model (so I can check ownership)
function OpenTruck(player, farm)
	if farm:FindFirstChild("Owner").Value == player.Name then
		game:GetService("ReplicatedStorage"):WaitForChild("OpenTruck"):FireClient(player) -- Sends to OpenGuis LocalScript
	end
end


-----------------
-- Upgrade Farm 
-----------------
function BuyUpgrade(player)
	local farm = workspace:FindFirstChild(player.Name .. "_Farm")
	local numPlots = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues.NumPlots
	local moneyNeeded = upgradeArray[numPlots.Value/2-1]
	local playerMoney = players:FindFirstChild(player.Name):WaitForChild("PlayerValues").Money
	local numPlots = players:FindFirstChild(player.Name):WaitForChild("PlayerValues").NumPlots 
	
	if playerMoney.Value > moneyNeeded and numPlots.Value < 12 then  -- if they have the money and don't have all tiles yet
		playerMoney.Value = playerMoney.Value - moneyNeeded
		numPlots.Value = numPlots.Value + 2
		-- show new items	
		newPlotTiles(numPlots.Value, farm)  	
		-- open UpgradeGui to tell them what they get
		game:GetService("ReplicatedStorage"):WaitForChild("OpenUpgrades"):FireClient(player, numPlots)  -- Goes to OpenGuis localscript
	end	
end


function newPlotTiles(numPlots, farm)
	local oldPlot = farm.FarmTiles
	local location = oldPlot.PrimaryPart.CFrame
	local spin = farm.Decorations.Grass.Orientation
	oldPlot:Destroy()	
	local newPlot = game.ServerStorage:FindFirstChild("FarmTiles" .. numPlots):Clone()
	newPlot.Parent = farm
	newPlot.Name = "FarmTiles"	
	if spin.Y == 0 then  -- Place new farm tiles, farms can face any direction so check to see which way to shift the new tiles
		newPlot:SetPrimaryPartCFrame(location + Vector3.new(-4,0,0))
	elseif spin.Y == 180 then
		newPlot:SetPrimaryPartCFrame(location + Vector3.new(4,0,0))
	elseif spin.Y == 90 then
		newPlot:SetPrimaryPartCFrame(location + Vector3.new(0,0,4))
	elseif spin.Y == -90 then
		newPlot:SetPrimaryPartCFrame(location + Vector3.new(0,0,-4))
	end		
	HidePlants(newPlot)
	SetClickDetectors(newPlot)
end



------------------------
-- Main
------------------------
players.PlayerAdded:Connect(function(player)
	local farm = PlaceFarm(player)	

	-- farm tile clickdetectors 
	local plot1 = farm:WaitForChild('FarmTiles')
	SetClickDetectors(plot1)
	HidePlants(plot1)
	-- storage clickdetector
	farm:FindFirstChild("Storage").ClickDetector.mouseClick:connect(function(player) OpenStorage(player, farm) end);
	-- truck clickdetector
	farm:FindFirstChild("Truck").ClickDetector.mouseClick:connect(function(player) OpenTruck(player, farm) end);	
	-- Upgrade clickdetector
	farm:FindFirstChild("Upgrades").ClickDetector.mouseClick:connect(BuyUpgrade);
	-- Lightswitch clickdetector
	farm:FindFirstChild("House").LightSwitch.ClickDetector.mouseClick:connect(helperModule.LightSwitch);

	local playerModel = workspace:WaitForChild(player.Name)
	playerModel.HumanoidRootPart.CFrame = farm.SpawnLocation.CFrame  + Vector3.new(0, 3, 0)
	game.Players:WaitForChild(player.Name).CameraMaxZoomDistance = 25

	-- Show starting values in inventory
	local invGui = player.PlayerGui:WaitForChild("InventoryGui")
	local inventory = game:GetService("Players"):FindFirstChild(player.Name).PlayerInventory
	local values = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues
	local list = invGui.Storage.Items:GetChildren()
	for i = 1,#list do	
		if list[i].Name ~= 'Title' and list[i].Name ~= 'Ready' then
			local invItem = invGui.Storage.Items:FindFirstChild(list[i].Name).Amount
			invItem.Text = inventory:WaitForChild(list[i].Name).Value
		end
	end

	-- Put player's name on their truck and farm sign
	farm:FindFirstChild("Truck").Wood.Sign1.SurfaceGui.NameText.Text = player.Name
	farm:FindFirstChild("Truck").Wood.Sign2.SurfaceGui.NameText.Text = player.Name
	farm:FindFirstChild("Sign").Main.SurfaceGui.NameText.Text = player.Name

	-- Show the arrow over their farm
	farm:FindFirstChild("Arrow").Main.Transparency = 0
	farm:FindFirstChild("Arrow").Wedge1.Transparency = 0
	farm:FindFirstChild("Arrow").Wedge2.Transparency = 0

	
	

--[[
	-- Show Welcome Gui
	if values.Tutorial.Value == 1 then
		player.PlayerGui.TutorialGui.Welcome.Visible = true
		values.Tutorial.Value = 2
	end
--]]
	
	
end)
 

players.PlayerRemoving:Connect(function(player)
	local findFarms = workspace:GetChildren()
	for i = 1,#findFarms do
		if findFarms[i].Name == player.Name .. "_Farm" and findFarms[i].Owner.Value == player.Name then
			RemoveFarm(findFarms[i])
		end
	end		
end)


-- clickdetectors for Farm DirtTiles
function SetClickDetectors(farmPlot)
	local plot = farmPlot:GetChildren()
	for c = 1,#plot do
		if plot[c].Name == "Dirt Tile" then 		
			plot[c].ClickDetector.mouseClick:connect(function(player) collectVeggie(player, plot[c]) end);	
		end
	end
end

function PlaceFarm(player)	
	--local spaces = workspace.Farms:GetChildren()
	--local rand = math.random(1,#spaces)
	--local location = spaces[rand].CFrame	
	--spaces[rand]:Destroy()

	local old = workspace.Farms:FindFirstChild("Farm1")
	local location = old.CFrame
	old:Destroy()

	local newPlot = game.ServerStorage:FindFirstChild("FarmModel"):Clone()
	newPlot.Parent = workspace
	newPlot.Name = player.Name .. "_Farm"		
	newPlot:SetPrimaryPartCFrame(location + Vector3.new(0,.1,0)) 
	newPlot:FindFirstChild("Owner").Value = player.Name
	return newPlot
end


function RemoveFarm(plot)
	local location = plot.PrimaryPart.CFrame	
	plot:Destroy()	
	local newPlot = game.ServerStorage:FindFirstChild("Grass"):Clone()
	newPlot.Parent = workspace.Farms
	newPlot.Name = "Farm"		
	newPlot.CFrame = location
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
			--plot[c].BrickColor = BrickColor.new("Brown")
			plot[c].Racking.Value = 1
		end	
	end
end



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

