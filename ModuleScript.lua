-- This is a ModuleScript make sure to copy it into the right type of script

local Module = {}	
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

		local respawntime = 5
		local weeds = plot.Weed:GetChildren()
		wait(respawntime)
		for i=1,#weeds do
			weeds[i].Transparency = 0
		end
		plot:WaitForChild("ClickDetector").MaxActivationDistance = 16
	end



	function Module.RakePlant(player, plot, pickedItem)
		local respawntime = 3
		local weeds = plot.Weed:GetChildren()
		local count = plot.Racking	
		plot.ClickDetector.MaxActivationDistance = 0
		for i=1,#weeds do
			weeds[i].Transparency = 1
		end		
		count.Value = count.Value -1
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


	-- Used to see if the players truck is close enough to their storage
	function Module.checkTruckHere(zone)			
		local connection = zone.Touched:Connect(function() end)
		local results = zone:GetTouchingParts()	
		connection:Disconnect()		
		local check = false
		for i = 1,#results do	
			local rightTruck = results[i].Parent.Parent == zone.Parent 	 -- make sure it's the right player's truck 	
			if results[i].Name == "Wheel" and results[i].Parent.Name == "Truck" and rightTruck == true then						
				check = true					
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
return Module
