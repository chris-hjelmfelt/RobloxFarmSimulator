local light1 = script.Parent:FindFirstChild("Light1")
local light2 = script.Parent:FindFirstChild("Light2")
local seat1 = script.Parent:FindFirstChild("Seat1")
local seat2 = script.Parent:FindFirstChild("Seat2")
local check = false


function TruckActive(seat)
	if seat.Occupant.Parent.Name == script.Parent.Parent:FindFirstChild("Owner").Value then	
		seat.Disabled = false
		light1.SpotLight.Brightness = 2
		light1.BrickColor = BrickColor.new("Wheat") 
		light2.SpotLight.Brightness = 2
		light2.BrickColor = BrickColor.new("Wheat") 
	else
		seat.Disabled = true
		light1.SpotLight.Brightness = 0
		light1.Color = Color3.new(75, 75, 75)
		light2.SpotLight.Brightness = 0
		light2.Color = Color3.new(75, 75, 75)
	end
end


while wait(1) do	
	if seat1.Occupant or seat1.Occupant then
		if seat1.Occupant then
			TruckActive(seat1)	
		end
		if seat2.Occupant then
			TruckActive(seat2)	
		end	
	else
		light1.SpotLight.Brightness = 0
		light1.Color = Color3.new(75, 75, 75)
		light2.SpotLight.Brightness = 0
		light2.Color = Color3.new(75, 75, 75)
	end
end
		
