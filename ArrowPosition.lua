local player = game.Players.LocalPlayer


function PointArrow()
	local truck = workspace:WaitForChild(player.Name .. "_Farm"):FindFirstChild("Truck"):FindFirstChild("Seat1")
	local arrow = workspace:WaitForChild(player.Name .. "_Farm"):WaitForChild("Arrow3")
	local market = workspace:WaitForChild("Market").SellZone.Zone	
	local distant = true
	while distant do
		wait()
		if arrow ~= nil and truck ~= nil and market ~= nil then	
			local cf = truck.CFrame * CFrame.new(0,2.5,-13)
			arrow.Anchored = false
			arrow.BodyPosition.Position = Vector3.new(cf.x,cf.y,cf.z) 
			arrow.BodyGyro.CFrame = CFrame.new(arrow.Position, market.Position)		
			if 40 > (market.Position.x - truck.Position.x) and (market.Position.x - truck.Position.x) > -40 then
				if 40 > (market.Position.z - truck.Position.z) and (market.Position.z - truck.Position.z) > -40 then
					distant = false
					arrow.Parent = nil
					game:GetService("ReplicatedStorage"):WaitForChild("Tutorial").TutBindable:Fire()  -- goes to Tutorial
				end
			end
		end		
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("Tutorial").ShowTruckArrow.Event:connect(PointArrow)  -- comes from Tutorial
