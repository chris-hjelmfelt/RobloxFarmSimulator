local arrow = nil

--------------------
-- Arrow Over Farm
--------------------
function ShowArrow(farm)
	local location = farm.Decorations.Grass.CFrame
	arrow = game:GetService("ReplicatedStorage"):WaitForChild("Arrow"):Clone()
	arrow.Parent = workspace		
	arrow:SetPrimaryPartCFrame(location + Vector3.new(0,50,0))
	arrow.Main.Transparency = 0
	arrow.Wedge1.Transparency = 0
	arrow.Wedge2.Transparency = 0
end
game:GetService("ReplicatedStorage"):WaitForChild("ShowArrow").OnClientEvent:Connect(ShowArrow)  -- Comes from PlayerAddRemove


function ShowTruckIndicator(truck)
	local location = truck.PrimaryPart.CFrame
	local part = Instance.new("Part", truck)
	part.Shape = "Cylinder"	
	part.Name = "Indicator"	
	part.CFrame = location + Vector3.new(0,15,0)
	part.Orientation = Vector3.new(0,0,90)
	part.Size = Vector3.new(4,.8,.8)
	part.BrickColor = BrickColor.new("Pink")
	part.Material = "Neon"	
	part.CanCollide = false	
	local weld = Instance.new("WeldConstraint")	
	weld.Parent = truck
	weld.Part0 = part
	weld.Part1 = truck.Support
end
game:GetService("ReplicatedStorage"):WaitForChild("ShowTruckIndicator").OnClientEvent:Connect(ShowTruckIndicator)  -- comes from ModuleScript PlaceTruck()

while wait() do
	if arrow then
		arrow:SetPrimaryPartCFrame(arrow.Main.CFrame * CFrame.fromEulerAnglesXYZ(0,.05,0))
	end
end
