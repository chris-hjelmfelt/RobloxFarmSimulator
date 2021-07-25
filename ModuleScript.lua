-- This is a ModuleScript make sure to copy it into the right type of script
debounce = false

local Module = {}	
	function Module.CollectVeggie(player, plot)  -- called from SetClickDetectors() below
		if player.Name == plot.Parent.Parent:FindFirstChild("Owner").Value and debounce == false then
			debounce = true						
			if plot.Plant.Leaf.Transparency == 0 then
				debounce = false
				Module.PickPlant(player, plot)	-- pick them
			elseif plot.BrickColor.Name == "Brown" then			
				Module.WaterPlant(player, plot)	 -- water them
			elseif plot.Weed.Weed.Transparency == 0 then	
				Module.RakePlant(player, plot)	-- rake them
			else	-- plant them (choose seeds)
				debounce = false	
				if game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues").Tutorial.Value == 2 then 
					game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("TutRemote"):FireClient(player)  -- goes to Tutorial						
				end
				game:GetService("ReplicatedStorage"):WaitForChild("ChooseSeeds"):FireClient(player, plot)  -- Goes to PickVeggies localScript ChooseSeeds()
			end	
			
		end
	end


	function Module.PlantSeeds(player, plot, seeds)  
		plot.BrickColor = BrickColor.new("Brown")
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
	end


	function Module.WaterPlant(player, plot)  -- called from function collectVeggie() above
		local timerBar = player.PlayerGui:WaitForChild("FarmGuis").StopClicks.Timer
		local timer = 10
		local tickSize = 200/timer  -- width of Gui/timer
		Module.HoldWater(player, false)
		

		-- watering timer 
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
		Module.HoldWater(player, true)
		debounce = false	
		plot:WaitForChild("ClickDetector").MaxActivationDistance = 0
		if game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues").Tutorial.Value == 4 then 	
			game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("TutRemote"):FireClient(player)  -- goes to Tutorial		
		end
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
		local timerBar = player.PlayerGui:WaitForChild("FarmGuis").StopClicks.Timer
		local timer = 20
		local tickSize = 200/timer  -- width of Gui/timer

		-- Do racking action
		Module.HoldRake(player, false)
		
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
		--gui.Visible = false
		Module.HoldRake(player, true)
		debounce = false
		plot.ClickDetector.MaxActivationDistance = 0
		if game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues").Tutorial.Value == 5 then 
			game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("TutRemote"):FireClient(player)  -- goes to Tutorial	
		end
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
		if game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues").Tutorial.Value == 6 then 
			game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("TutRemote"):FireClient(player)  -- goes to Tutorial	
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
				elseif zone == workspace.Orderboard.SellZone then
					if results[i].Parent.Parent:FindFirstChild("Owner").Value == player.Name then  -- make sure it's the right player's truck 
						check = true
					end					
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

	function Module.OpenBookcase(player)
		game:GetService("ReplicatedStorage"):WaitForChild("OpenBookcase"):FireClient(player) -- Sends to OpenGui OpenBookcase()
	end


	-- find a vector for shifting a model using some base part to get orientation of which way farm is facing  
	function Module.ShiftModel(base, x,y,z)
		local spin = base.Orientation
		if spin.Y == 0 then  -- Place new farm tiles, farms can face any direction so check to see which way to shift the new tiles
			return Vector3.new(x,y,z)
		elseif spin.Y == 180 or spin.Y == -180 then
			return Vector3.new(-x,y,-z)
		elseif spin.Y == 90 then
			return Vector3.new(z,y,-x)
		elseif spin.Y == -90 then
			return Vector3.new(-z,y,x)
		else
			print("MS Shift Model fell through - spin.Y isn't found")
			return Vector3.new(-x,y,z)			
		end
	end

	function Module.PlaceStorageModel(player)
		local farm = workspace:WaitForChild(player.Name .. "_Farm")
		local storeLevel = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues").StorageLevel
		local oldModel = farm:WaitForChild("Storage")
		local location = farm:WaitForChild("StoragePlacement")
		local ModelOne = nil	
		local ModelTwo = nil
		local ModelThree = nil
		if storeLevel.Value < 6 then
			ModelOne = game.ServerStorage:FindFirstChild("Storage" .. storeLevel.Value):Clone()
			ModelOne.Parent = farm
			ModelOne.Name = "Storage"	
			ModelOne:SetPrimaryPartCFrame(location.CFrame)
		elseif storeLevel.Value >= 6 then
			ModelOne = game.ServerStorage:FindFirstChild("Shed"):Clone()
			ModelOne.Parent = farm
			ModelOne.Name = "Storage"	
			local shiftVector = Module.ShiftModel(location, 0, -2, 0)
			ModelOne:SetPrimaryPartCFrame(location.CFrame + shiftVector)
		end
		if storeLevel.Value >= 7 then
			ModelTwo = game.ServerStorage:FindFirstChild("Silo"):Clone()			
			ModelTwo.Parent = farm
			ModelTwo.Name = "Silo1"	
			local shiftVector = Module.ShiftModel(location, -10.2, 2.45, -3)
			ModelTwo:SetPrimaryPartCFrame((location.CFrame * CFrame.Angles(0,0, math.rad(90)))+ shiftVector)
		end
		if storeLevel.Value >= 8 then
			ModelThree = game.ServerStorage:FindFirstChild("Silo"):Clone()
			ModelThree.Parent = farm
			ModelThree.Name = "Silo2"	
			local shiftVector = Module.ShiftModel(location, -10.2, 2.45, 3)
			ModelThree:SetPrimaryPartCFrame((location.CFrame * CFrame.Angles(0,0, math.rad(90)))+ shiftVector)
		end			
		oldModel:Destroy()
		ModelOne.ClickDetector.mouseClick:connect(function(player)  
			if farm:FindFirstChild("Owner").Value == player.Name then    -- only owner can open storage 
				game:GetService("ReplicatedStorage"):WaitForChild("OpenStorage"):FireClient(player) -- Sends to OpenGuis OpenStorage()
			end
		end);
		if ModelTwo then
			ModelTwo.ClickDetector.mouseClick:connect(function(player)  
				if farm:FindFirstChild("Owner").Value == player.Name then    -- only owner can open storage 
					game:GetService("ReplicatedStorage"):WaitForChild("OpenStorage"):FireClient(player) -- Sends to OpenGuis OpenStorage()
				end
			end);
		end
		if ModelThree then
			ModelThree.ClickDetector.mouseClick:connect(function(player)  
				if farm:FindFirstChild("Owner").Value == player.Name then    -- only owner can open storage 
					game:GetService("ReplicatedStorage"):WaitForChild("OpenStorage"):FireClient(player) -- Sends to OpenGuis OpenStorage()
				end
			end);
		end
	end


	function Module.PlaceFarmTiles(player)
		local farm = workspace:FindFirstChild(player.Name .. "_Farm")
		local numPlots = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues.NumPlots.Value
		local oldPlot = farm.FarmTiles
		local location = oldPlot.PrimaryPart.CFrame
		local shiftVector = Module.ShiftModel(farm.Decorations.Grass, -4, 0, 0)
		oldPlot:Destroy()		
		local newPlot = game.ServerStorage:FindFirstChild("FarmTiles" .. numPlots):Clone()
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


	function Module.PlaceTruck(player, owned)  -- called by GamePass script
		local farm = workspace:WaitForChild(player.Name .. "_Farm")	
		local location = farm.Decorations.Driveway.CFrame
		local truck = nil
		if farm:FindFirstChild("Truck") then
			print("MS PlaceTruck destroy")
			farm:FindFirstChild("Truck"):Destroy()
		end
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


	function Module.ShowBench(player)
		local bench = workspace:WaitForChild(player.Name .. "_Farm").Decorations.Bench
		bench.Main.Transparency = 0
		bench.Main.CanCollide = true
		bench:WaitForChild("Seat1").CanCollide = true
		bench:WaitForChild("Seat2").CanCollide = true		
	end

	
	function Module.CheckInvTotal(player)
		wait(2)
		local inventory = game:GetService("Players"):FindFirstChild(player.Name).PlayerInventory
		local total = 0
		local invList = inventory:GetChildren()
		for t=2,#invList do
			total = total + invList[t].Value
		end
		game:GetService("ReplicatedStorage"):WaitForChild("UpdateInventoryTotal"):FireServer(total)  -- Goes to Misc UpdatePlayerInventoryTotals()
	end
return Module
