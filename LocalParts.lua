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


while wait() do
	if arrow then
		arrow:SetPrimaryPartCFrame(arrow.Main.CFrame * CFrame.fromEulerAnglesXYZ(0,.05,0))
	end
end
