local player = game.Players.LocalPlayer

function MovePet()
	local hum = workspace:WaitForChild(player.Name):FindFirstChild("Humanoid")
	local torso = workspace:WaitForChild(player.Name):FindFirstChild("UpperTorso")
	local pet = workspace:WaitForChild(player.Name .. "_Farm"):WaitForChild("Pet")
	local maxFloat = 1
	local floatInc = 0.025
	local sw = false
	local fl = 0
		
	while true do
		wait()
		if not sw then
			fl = fl + floatInc
			if fl >= maxFloat then
				sw = true
			end
		else
			fl = fl - floatInc
			if fl <=-maxFloat then
				sw = false
			end
		end
		if pet ~= nil and hum ~= nil and torso ~= nil then
			local cf = torso.CFrame * CFrame.new(3,2+fl,3)
			pet.BodyPosition.Position = Vector3.new(cf.x,cf.y,cf.z)
			pet.BodyGyro.CFrame = torso.CFrame * CFrame.new(3,0,-3)
		end
	end
end
--MovePet()
