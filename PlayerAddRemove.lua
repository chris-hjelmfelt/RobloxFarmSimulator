    local players = game:GetService("Players")	
	local serverStorage = game:GetService("ServerStorage")
	local upgradeArray = {5,10,15,20,25,30,35,40,45,50} -- money needed for the next level
	local playerLevel = nil	
	local helperModule = require(workspace.ModuleScript)
	
----------------
-- Farming
----------------
function PlantSeeds(player, plot, seeds)
	plot.CropType.Value = seeds  -- keep track of what is planted here
	helperModule.PlantSeeds(player, plot, seeds)  -- Plant Seeds			
end
game:GetService("ReplicatedStorage"):WaitForChild("PlantSeeds").OnServerEvent:Connect(PlantSeeds) -- Comes from PickVeggies LocalScript SendSeeds()


-----------------
-- Storage
-----------------
function OpenStorage(player, farm)
	if farm:FindFirstChild("Owner").Value == player.Name then    -- only owner can open stoage or truck
		game:GetService("ReplicatedStorage"):WaitForChild("OpenStorage"):FireClient(player) -- Sends to OpenGuis LocalScript
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
	local playerModel = workspace:WaitForChild(player.Name)
	local values = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues")	
	local farm = PlaceFarm(player)
	-- truck is added in MS called by gamepass
	helperModule.PlaceStorageModel(player)
	helperModule.PlaceFarmTiles(player)	
	-- storage and truck clickdetectors
	farm:WaitForChild("Storage").ClickDetector.mouseClick:connect(function(player) OpenStorage(player, farm) end);
	farm:WaitForChild("Truck").ClickDetector.mouseClick:connect(function(player) OpenStorage(player, farm) end);		
	-- Upgrade clickdetector
	farm:FindFirstChild("Upgrades").ClickDetector.mouseClick:connect(function(player) OpenUpgradeFarm(player, farm) end);
	-- Lightswitch clickdetector
	farm:FindFirstChild("House").LightSwitch.ClickDetector.mouseClick:connect(helperModule.LightSwitch);

	
	playerModel:WaitForChild("HumanoidRootPart").CFrame = farm.SpawnLocation.CFrame  + Vector3.new(0, 3, 0)
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
	
	-- Show starting values in HUD
	player.PlayerGui:WaitForChild("HUDGui").HUD.Money.Text = "Money: " .. values.Money.Value
	player.PlayerGui:WaitForChild("HUDGui").HUD.Experience.Text = "Experience: " .. values.Experience.Value
	
	-- Show Welcome Gui
	if values.Tutorial.Value == 1 then
		player.PlayerGui.TutorialGui.Welcome.Visible = true
		values.Tutorial.Value = 2
	end

	-- Player dies or resets
	player.CharacterAdded:Connect(function()
		playerModel:WaitForChild("HumanoidRootPart").CFrame = farm.SpawnLocation.CFrame  + Vector3.new(0, 3, 0)
	end)
		
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

	-- Put player's name on their farm signs
	newPlot:WaitForChild("Decorations"):FindFirstChild("Sign1").Main.SurfaceGui.NameText.Text = player.Name
	newPlot:WaitForChild("Decorations"):FindFirstChild("Sign2").Main.SurfaceGui.NameText.Text = player.Name
	
	-- Show the arrow over their farm
	game:GetService("ReplicatedStorage"):WaitForChild("ShowArrow"):FireClient(player, newPlot)  -- Goes to localscript LocalParts  ShowArrow()

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


-- Put level in a model called leaderstats so it shows up in player list
game.Players.PlayerAdded:connect(function(player)
	local stats = Instance.new("Model")
    stats.Name = "leaderstats"
    stats.Parent = player

	local findLevel = player:WaitForChild("PlayerValues"):WaitForChild("Level")

	local level = Instance.new("IntValue")
 	level.Name = "Level"
    level.Parent = stats 
    level.Value = findLevel.Value	
end)



