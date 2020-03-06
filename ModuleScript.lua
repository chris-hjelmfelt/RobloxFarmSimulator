-- This is a ModuleScript make sure to copy it into the right type of script

local Module = {}	
	function Module.CollectVeggie(player, plot)
		if player.Name == plot.Parent.Parent:FindFirstChild("Owner").Value then
			if plot.Plant.Leaf.Transparency == 0 then
				Module.PickPlant(player, plot)	-- pick them
			elseif plot.BrickColor.Name == "Brown" then			
				Module.WaterPlant(player, plot)			
			elseif plot.Weed.Weed.Transparency == 0 then	
				Module.RakePlant(player, plot)	-- rake them
			else
				game:GetService("ReplicatedStorage"):WaitForChild("ChooseSeeds"):FireClient(player, plot)  -- Goes to PickVeggies localScript ChooseSeeds()
			end	
		end
	end


	function Module.PlantSeeds(player, plot, seeds)  -- called from function collectVeggie() above
		for index, child in pairs(plot:GetChildren()) do
			if child.Name == "Plant" then 
				local newPlant = game.ServerStorage:FindFirstChild(seeds):Clone()
				newPlant.Parent = plot	
				newPlant.Name = "Plant"
				newPlant:SetPrimaryPartCFrame(child.PrimaryPart.CFrame) 	
				child:Destroy()						
				for k, p in pairs(newPlant:GetChildren()) do
    				p.Transparency = 1
					p.CanCollide = false
				end	
				-- Make buds appear 
				for b, c in pairs(plot.Buds:GetChildren()) do
					c.Transparency = 0
				end	
			end
		end		
		plot.BrickColor = BrickColor.new("Brown")
	end


	function Module.WaterPlant(player, plot)  -- called from function collectVeggie() above
		local gui = player.PlayerGui:WaitForChild("FarmGuis").StopClicks.Sheet		
		local timerBar = player.PlayerGui:WaitForChild("FarmGuis").StopClicks.Timer
		local timer = 10
		local tickSize = 200/timer  -- width of Gui/timer
		Module.HoldWater(player, false)
		gui.Visible = true  -- put up an invisible Gui to prevent them clicking other stuff during the weeding period

		-- raking timer 
		timerBar.Visible = true
		while timer > 0 do
			timerBar.Size = UDim2.new(0, timerBar.Size.X.Offset - tickSize, 0, 15)
			timer = timer - 1
			wait(0.1)
		end
		timerBar.Visible = false
		timerBar.Size = UDim2.new(0, 200, 0, 15)
		plot.BrickColor = BrickColor.new("Dirt brown")
		wait()
		gui.Visible = false
		Module.HoldWater(player, true)
		
		-- hold water can and do timer		
		plot:WaitForChild("ClickDetector").MaxActivationDistance = 0		
		wait(3)
		local weeds = plot.Weed:GetChildren()
		for i=1,#weeds do
			weeds[i].Transparency = 0
		end
		plot.ClickDetector.MaxActivationDistance = 16
	end


	function Module.RakePlant(player, plot)  -- called from function collectVeggie() above
		local pickedItem = plot.CropType.Value
		local respawntime = workspace:WaitForChild("GameValues"):WaitForChild("PlantGrowTimes"):FindFirstChild(pickedItem).Value
		local weeds = plot.Weed:GetChildren()
		local count = plot.Racking	-- also resets below
		local gui = player.PlayerGui:WaitForChild("FarmGuis").StopClicks.Sheet		
		local timerBar = player.PlayerGui:WaitForChild("FarmGuis").StopClicks.Timer
		local timer = 20
		local tickSize = 200/timer  -- width of Gui/timer

		-- Do racking action
		Module.HoldRake(player, false)
		gui.Visible = true  -- put up an invisible Gui to prevent them clicking other stuff during the weeding period

		-- raking timer 
		timerBar.Visible = true
		while timer > 0 do
			timerBar.Size = UDim2.new(0, timerBar.Size.X.Offset - tickSize, 0, 15)
			timer = timer - 1
			wait(0.1)
		end
		timerBar.Visible = false
		timerBar.Size = UDim2.new(0, 200, 0, 15)
		timer = 20

		-- Hide weeds
		for i=1,#weeds do
			weeds[i].Transparency = 1
		end		
		count.Value = count.Value -1
		wait()
		gui.Visible = false
		Module.HoldRake(player, true)
		
		plot.ClickDetector.MaxActivationDistance = 0
		wait(respawntime)

		if count.Value <= 0 then
			for index, child in pairs(plot:GetChildren()) do
				if child.Name == "Plant" then 
					for k, p in pairs(child:GetChildren()) do
	    				p.Transparency = 0
					end
				end
			end	
			count.Value = 1
		else	
			for i=1,#weeds do
				weeds[i].Transparency = 0
			end
		end	
		plot.ClickDetector.MaxActivationDistance = 16		
	end

	
	function Module.PickPlant(player, plot)	 -- called from function collectVeggie() above
		local inventory = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerInventory")
		local storeLevels = workspace:WaitForChild("GameValues"):WaitForChild("GameMisc").StorageLevels.Value:split(",")
		local values = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues
		if inventory.Total.Value < tonumber(storeLevels[values.StorageLevel.Value]) then  -- Do they have room in storage?	
			game:GetService("ReplicatedStorage"):WaitForChild("HarvestPlants"):FireClient(player, plot) -- Sends to PickVeggies LocalScript
			
			-- Make veggie disappear 
			for index, child in pairs(plot:GetChildren()) do
				if child.Name == "Plant" then 
					for k, p in pairs(child:GetChildren()) do
	    				p.Transparency = 1.0
					end
				end
			end
			-- Make buds disappear 
			for b, c in pairs(plot.Buds:GetChildren()) do
				c.Transparency = 1.0
			end
		else  -- Tell them their storage is full
			game:GetService("ReplicatedStorage"):WaitForChild("Warning"):FireClient(player, "Storage Full")
		end		
	end

	-- Used to see if the players truck is close enough to their storage   
	function Module.checkTruckHere(player, zone)	  -- comes from OpenGuis OpenMarket() and also OpenStorage()
		local connection = zone.Touched:Connect(function() end)
		local results = zone:GetTouchingParts()	
		connection:Disconnect()		
		local check = false
		for i = 1,#results do
			if results[i].Name == "Wheel" and results[i].Parent.Name == "Truck" then
				if zone == workspace.Market.SellZone.Zone then   
					if results[i].Parent.Parent:FindFirstChild("Owner").Value == player.Name then  -- make sure it's the right player's truck 
						check = true
					end
				else 
					-- not using this for storage anymore but soon for orderboard						
				end
			end	
		end			
		return check
	end
	

	-- Used to weld an object to a player   -- Used for HoldRake() and HoldWater()
	function Module.weldToHuman(a,b) -- put bodypart as a and put object as b
	   b.CFrame = a.CFrame -- * CFrame.Angles(math.rad(90), 0, 0) -- * CFrame.new(0,0,0)--  to change location or angles
	   local weld = Instance.new("Weld")
	   weld.Part0 = a;
	   weld.C0 = a.CFrame:inverse()
	   weld.Part1 = b;
	   weld.C1 = b.CFrame:inverse()
	   weld.Parent = a;
	end
	

	-- Equip the Rake tool
	function Module.HoldRake(player, hold)
		local playerModel = workspace:WaitForChild(player.Name)
		local humanoid = playerModel:FindFirstChildOfClass("Humanoid")
		if humanoid then
			if hold == false then
				local tool = player.Backpack:FindFirstChild("Rake")
				if tool then			
					humanoid:EquipTool(tool)
				end	
			else
				local tool = playerModel:FindFirstChild("Rake")
				if tool then	
					humanoid:UnequipTools()
				end			
			end
		end
	end


	-- Equip the Rake tool
	function Module.HoldWater(player, hold)
		local playerModel = workspace:WaitForChild(player.Name)
		local humanoid = playerModel:FindFirstChildOfClass("Humanoid")
		if humanoid then
			if hold == false then
				local tool = player.Backpack:FindFirstChild("Watering Can")
				if tool then			
					humanoid:EquipTool(tool)
				end	
			else
				local tool = playerModel:FindFirstChild("Watering Can")
				if tool then	
					humanoid:UnequipTools()
				end			
			end
		end
	end

	
	-- hide plants on start
	function Module.HidePlants(farmPlot)  -- Comes from PlayerAddRemove PlayerAdded() and Miscellanious newPlotTiles()
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
				-- Make buds disappear 
				for b, c in pairs(plot[c].Buds:GetChildren()) do
					c.Transparency = 1.0
				end
				plot[c].Racking.Value = 1
			end				
		end
	end

	
	function Module.LightSwitch(player)	 -- Comes from PlayerAddRemove PlayerAdded()
		local farm = workspace:FindFirstChild(player.Name .. "_Farm")
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

	
	-- find a vector for shifting a model using some base part to get orientation of which way farm is facing  
	function Module.ShiftModel(base, x,y,z)
		local spin = base.Orientation
		if spin.Y == 0 then  -- Place new farm tiles, farms can face any direction so check to see which way to shift the new tiles
			return Vector3.new(x,y,z)
		elseif spin.Y == 180 then
			return Vector3.new(-x,y,-z)
		elseif spin.Y == 90 then
			return Vector3.new(z,y,-x)
		elseif spin.Y == -90 then
			return Vector3.new(-z,y,x)
		else
			print("Misc newPlots fell through")
			return Vector3.new(-x,y,z)			
		end
	end

	function Module.PlaceStorageModel(player)
		local farm = workspace:FindFirstChild(player.Name .. "_Farm")
		local storeLevel = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues").StorageLevel
		local oldModel = farm.Storage
		local location = oldModel.PrimaryPart.CFrame
		local newModel = nil	
		
		if storeLevel.Value < 6 then
			newModel = game.ServerStorage:FindFirstChild("Storage" .. storeLevel.Value):Clone()
			newModel:SetPrimaryPartCFrame(location)
			oldModel:Destroy()
		elseif storeLevel.Value == 6 then
			newModel = game.ServerStorage:FindFirstChild("Shed"):Clone()
			local shiftVector = Module.ShiftModel(oldModel.PrimaryPart, 0, -2, 0)
			newModel:SetPrimaryPartCFrame(location + shiftVector)
			oldModel:Destroy()
		elseif storeLevel.Value == 7 then
			newModel = game.ServerStorage:FindFirstChild("Silo"):Clone()
			local shiftVector = Module.ShiftModel(oldModel.PrimaryPart, -10.2, 4.45, -3)
			newModel:SetPrimaryPartCFrame((location * CFrame.Angles(0,0, math.rad(90)))+ shiftVector)
		elseif storeLevel.Value >= 8 then
			newModel = game.ServerStorage:FindFirstChild("Silo"):Clone()
			local shiftVector = Module.ShiftModel(oldModel.PrimaryPart, -10.2, 4.45, 3)
			newModel:SetPrimaryPartCFrame((location * CFrame.Angles(0,0, math.rad(90)))+ shiftVector)
		end
		newModel.Parent = farm
		newModel.Name = "Storage"	
	end


	function Module.PlaceFarmTiles(player, numPlots)
		local farm = workspace:FindFirstChild(player.Name .. "_Farm")
		local numPlots = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues.NumPlots
		local oldPlot = farm.FarmTiles
		local location = oldPlot.PrimaryPart.CFrame
		local shiftVector = Module.ShiftModel(farm.Decorations.Grass, -4, 0, 0)
		oldPlot:Destroy()	
		local newPlot = game.ServerStorage:FindFirstChild("FarmTiles" .. numPlots.Value):Clone()
		newPlot.Parent = farm
		newPlot.Name = "FarmTiles"	
		newPlot:SetPrimaryPartCFrame(location + shiftVector)
		Module.HidePlants(newPlot)
		Module.SetClickDetectors(newPlot)
	end


	-- clickdetectors for Farm DirtTiles
	function Module.SetClickDetectors(farmPlot)  -- Comes from PlayerAddRemove PlayerAdded() and Miscellanious newPlotTiles()
		local plot = farmPlot:GetChildren()
		for c = 1,#plot do
			if plot[c].Name == "Dirt Tile" then 		
				plot[c].ClickDetector.mouseClick:connect(function(player) Module.CollectVeggie(player, plot[c]) end);	
			end
		end
	end


	function Module.PlaceTruck(player, farm, owned)  -- called by GamePass script
		local location = farm.Decorations.Driveway.CFrame
		local truck = nil
		if owned == true then
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
		
		-- Make truck drive slow in water
		local child = truck:GetChildren()
		for i = 1,#child do
			if child[i].Name == "Wheel" then				
				child[i].Touched:Connect(function(part) Module.WaterSlowDown(truck,part)  end) 
			end
		end

		-- Show an indicator over their truck
		game:GetService("ReplicatedStorage"):WaitForChild("ShowTruckIndicator"):FireClient(player, truck)  -- Goes to localscript LocalParts  ShowArrow()
		
		return truck
	end
	

	-- This handles vehicles driving in the river
	function Module.WaterSlowDown(truck, part)		
		if part == workspace.River then  
			truck:FindFirstChild("Seat1").MaxSpeed = truck.MaxSpeed.Value /3
		elseif part == workspace.Baseplate then   
			truck:FindFirstChild("Seat1").MaxSpeed = truck.MaxSpeed.Value
		end
	end

	function Module.GainCoins(player, amount)
		local hudText = player.PlayerGui:WaitForChild("HUDGui").GainCoins
		local hudMoney = player.PlayerGui:WaitForChild("HUDGui").HUD.Money
		hudText.Text1.Text = "+" .. amount
		hudText.Visible = true
		wait(.2)
		for i = 1,8 do
			hudText.Text1.Position = hudText.Text1.Position + UDim2.new(0,0,0,-5)
			wait(.2)
		end
		hudText.Visible = false
		hudText.Text1.Position = hudText.Text1.Position + UDim2.new(0,0,0,40)
		hudMoney.Text = "Money: " .. player:WaitForChild("PlayerValues").Money.Value
	end

return Module
