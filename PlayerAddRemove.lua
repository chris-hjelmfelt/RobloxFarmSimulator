    local players = game:GetService("Players")	
	local serverStorage = game:GetService("ServerStorage")
	local upgradeArray = {5,10,15,20,25,30,35,40,45,50} -- money needed for the next level
	local playerLevel = nil	
	local helperModule = require(workspace.ModuleScript)

-----------------
-- Farm Tiles
-----------------
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


----------------------
-- Upgrade Farm Space
----------------------
function OpenUpgradeFarm(player, farm)
	if farm:FindFirstChild("Owner").Value == player.Name then    -- only owner can open
		game:GetService("ReplicatedStorage"):WaitForChild("OpenUpgradeFarm"):FireClient(player)  -- Goes to OpenGuis localscript -- Sends to OpenGuis LocalScript
	end
end


------------------------
-- Main
------------------------
players.PlayerAdded:Connect(function(player)
	local farm = PlaceFarm(player)	
	PlaceTruck(player, farm)
	helperModule.PlaceStorageModel(player)
	helperModule.PlaceFarmTiles(player)
	-- farm tile clickdetectors 
	local plot1 = farm:WaitForChild('FarmTiles')
	helperModule.SetClickDetectors(plot1)
	helperModule.HidePlants(plot1)
	-- storage clickdetector
	farm:FindFirstChild("Storage").ClickDetector.mouseClick:connect(function(player) OpenStorage(player, farm) end);
	-- truck clickdetector
	farm:FindFirstChild("Truck").ClickDetector.mouseClick:connect(function(player) OpenTruck(player, farm) end);	
	-- Upgrade clickdetector
	farm:FindFirstChild("Upgrades").ClickDetector.mouseClick:connect(function(player) OpenUpgradeFarm(player, farm) end);
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


function PlaceFarm(player)	
	local spaces = workspace.Farms:GetChildren()
	local rand = math.random(1,#spaces)
	local location = spaces[rand].CFrame	
	spaces[rand]:Destroy()
	-- Use this code to test a specific farm location - name the grass tile "Farm1" and comment out code above
	--local old = workspace.Farms:FindFirstChild("Farm1")
	--local location = old.CFrame
	--old:Destroy()

	local newPlot = game.ServerStorage:FindFirstChild("FarmModel"):Clone()
	newPlot.Parent = workspace
	newPlot.Name = player.Name .. "_Farm"		
	newPlot:SetPrimaryPartCFrame(location) 
	newPlot:FindFirstChild("Owner").Value = player.Name

	-- Put player's name on their truck and farm sign
	newPlot:FindFirstChild("Sign").Main.SurfaceGui.NameText.Text = player.Name
	-- Show the arrow over their farm
	newPlot:FindFirstChild("Arrow").Main.Transparency = 0
	newPlot:FindFirstChild("Arrow").Wedge1.Transparency = 0
	newPlot:FindFirstChild("Arrow").Wedge2.Transparency = 0

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


function PlaceTruck(player, farm)
	local values = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues")
	local location = farm.Decorations.Driveway.CFrame
	local truck = nil
	if values:FindFirstChild('FarmTruck') and values.FarmTruck.Value == true then
		truck = game.ServerStorage:FindFirstChild("FarmTruck"):Clone()
		-- Put player's name on their truck
		truck.Wood.Sign1.SurfaceGui.NameText.Text = player.Name
		truck.Wood.Sign2.SurfaceGui.NameText.Text = player.Name
	else
		truck = game.ServerStorage:FindFirstChild("MiniTruck"):Clone()
		-- Put player's name on their truck
		truck.Cargo.SurfaceGui.NameText.Text = player.Name
	end
	truck.Parent = farm
	truck:SetPrimaryPartCFrame(location + Vector3.new(0,2,0))
	truck.Name = "Truck"	
	return truck
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

