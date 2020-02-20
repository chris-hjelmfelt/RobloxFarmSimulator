-- This is a ModuleScript make sure to copy it into the right type of script

local Module = {}	
	function Module.PlantSeeds(player, plot, seeds)
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
			end
		end		
		plot.BrickColor = BrickColor.new("Brown")
	end


	function Module.WaterPlant(player, plot)
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


	function Module.RakePlant(player, plot, pickedItem)
		local respawntime = 3
		local weeds = plot.Weed:GetChildren()
		local count = plot.Racking	
		local gui = player.PlayerGui:WaitForChild("FarmGuis").StopClicks.Sheet		
		local timerBar = player.PlayerGui:WaitForChild("FarmGuis").StopClicks.Timer
		local timer = 40
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
			count.Value = 5
		else	
			for i=1,#weeds do
				weeds[i].Transparency = 0
			end
		end	
		plot.ClickDetector.MaxActivationDistance = 16		
	end

	
	function Module.PickPlant(player, plot)		
		game:GetService("ReplicatedStorage"):WaitForChild("HarvestPlants"):FireClient(player, plot) -- Sends to PickVeggies LocalScript
		
		-- Make veggie disappear 
		for index, child in pairs(plot:GetChildren()) do
			if child.Name == "Plant" then 
				for k, p in pairs(child:GetChildren()) do
    				p.Transparency = 1.0
				end
			end
		end		
	end

	-- Used to see if the players truck is close enough to their storage   -- comes from OpenGuis OpenMarket() and also OpenStorage()
	function Module.checkTruckHere(player, zone)			
		local connection = zone.Touched:Connect(function() end)
		local results = zone:GetTouchingParts()	
		connection:Disconnect()		
		local check = false
		for i = 1,#results do
			if results[i].Name == "Wheel" and results[i].Parent.Name == "Truck" then
				if zone == workspace.Market.SellZone then    
					if results[i].Parent.Parent:FindFirstChild("Owner").Value == player.Name then  -- make sure it's the right player's truck 
						check = true
					end
				else	
					if results[i].Parent.Parent == zone.Parent then
						check = true	
					end
				end
			end	
		end			
		return check
	end
	

	-- Used to weld an object to a player
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

	function Module.LightSwitch(player)	
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
return Module
