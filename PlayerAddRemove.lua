    local Players = game:GetService("Players")	
	local serverStorage = game:GetService("ServerStorage")
	local xpArray = workspace:WaitForChild("GameValues"):WaitForChild("GameMisc").NextLevelXP.Value:split(",")  -- xp needed for each level
	local playerLevel = nil	
	local helperModule = require(workspace.ModuleScript)
	local valueDataLoaded = false
	local farmTilesLoaded = false

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
	if farm:FindFirstChild("Owner").Value == player.Name then    -- only owner can open storage 
		game:GetService("ReplicatedStorage"):WaitForChild("OpenStorage"):FireClient(player) -- Sends to OpenGuis OpenStorage()
	end
end


----------------------
-- Upgrade Farm Space
----------------------
function OpenUpgradeFarm(player, farm)
	if farm:FindFirstChild("Owner").Value == player.Name then    -- only owner can open
		game:GetService("ReplicatedStorage"):WaitForChild("OpenUpgradeFarm"):FireClient(player)  -- Goes to OpenGuis OpenUpgradeFarmGui()
	end
end


------------------------
-- Main
------------------------
Players.PlayerAdded:Connect(function(player)
	-- Show Welcome Gui
	player.PlayerGui:WaitForChild("TutorialGui"):WaitForChild("Welcome").Visible = true  -- if you stop showing this make sure you enable HUD because closing this enables it
	
	-- Setup farm
	local playerModel = workspace:WaitForChild(player.Name)
	local values = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues")	
	local farm = PlaceFarm(player)
	
	-- truck is added in MS called by gamepass
	helperModule.PlaceStorageModel(player)
	if values.StorageLevel.Value >= 7 then
		player.PlayerGui:WaitForChild("InventoryGui").Storage.Upgrade.Visible = false
		player.PlayerGui:WaitForChild("HUDGui").Warning.Upgrade.Visible = false
	end


	-- values for testing
	if player.Name == "Erin_OShea" or player.Name == "Jaylah_Everstar" then
		values.Money.Value = 1000
		values.Experience.Value = 0
		values.Level.Value = 1
		values.NumPlots.Value = 4
		values.StorageLevel.Value = 1
		values.QuestProgress.Value = 1
		--values.Tutorial.Value = 1
		values.PlantsHarvested = 0
	end

	-- Fix tutorial error
	if values:WaitForChild("Tutorial").Value == 0 then
		values:WaitForChild("Tutorial").Value = 1
		values.WaitForChild("BrokenData").Value = true
	end
	
	-- Check for exit game in mid tutorial
	if values:WaitForChild("Tutorial").Value > 1 and values:WaitForChild("Tutorial").Value < 16 then
		values:WaitForChild("Tutorial").Value = 16		
	end

	-- Show special items
	if values.QuestProgress.Value >= 10 then
		helperModule.ShowBench(player)
	end

	-- truck clickdetectors
	farm:WaitForChild("Truck").ClickDetector.mouseClick:connect(function(player) OpenStorage(player, farm) end);		
	-- Upgrade clickdetector
	farm:FindFirstChild("Upgrades").ClickDetector.mouseClick:connect(function(player) OpenUpgradeFarm(player, farm) end);
	-- Lightswitch and bookcase clickdetector
	farm:FindFirstChild("House").LightSwitch.ClickDetector.mouseClick:connect(helperModule.LightSwitch);
	farm:FindFirstChild("House").Bookcase.ClickDetector.mouseClick:connect(helperModule.OpenBookcase);
	
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
	

	helperModule.PlaceFarmTiles(player)
	-- Add this value to keep track of plots
    local objectValue = Instance.new("ObjectValue")
    objectValue.Name = "ActivePlot"
    objectValue.Value = nil
    objectValue.Parent = player

	-- Show starting values in HUD
	player.PlayerGui:WaitForChild("HUDGui").HUD.Money.Text = "Money: " .. values.Money.Value
	player.PlayerGui:WaitForChild("HUDGui").HUD.Experience.Text = "Experience: " .. values.Experience.Value
	player.PlayerGui:WaitForChild("HUDGui").HUD.NextLevel.Text2.Text = xpArray[values.Level.Value]  
	

	-- Player dies or resets
	player.CharacterAdded:Connect(function(character)		
		local thisPlayer = Players:GetPlayerFromCharacter(character)
		playerModel = workspace:WaitForChild(thisPlayer.Name)
		playerModel:WaitForChild("HumanoidRootPart").CFrame = farm.SpawnLocation.CFrame  + Vector3.new(0, 3, 0)		
	end)
		
end)


Players.PlayerRemoving:Connect(function(player)
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


function DataLoaded()
	valueDataLoaded = true
end
game:GetService("ReplicatedStorage"):WaitForChild("LoadedValues").Event:connect(function(player)  DataLoaded() end)  -- comes from SavePVD LoadData()


Players.PlayerAdded:Connect(function(player)
	-- create leaderboard
	local stats = Instance.new("Model")
    stats.Name = "leaderstats"
    stats.Parent = player
	
	local level = Instance.new("IntValue")
 	level.Name = "Level"
    level.Parent = stats 
    level.Value = player:WaitForChild("PlayerValues"):WaitForChild("Level").Value	

--[[
	-- place farm tiles
	while wait() and farmTilesLoaded == false do
		if workspace:FindFirstChild(player.Name .. "_Farm") and valueDataLoaded == true then
			helperModule.PlaceFarmTiles(player)
			farmTilesLoaded = true
		end
	end
--]]
end)