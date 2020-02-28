    local PhysicsService = game:GetService("PhysicsService")
     --[[
    local blueDoors = "BlueDoors"
    local redDoors = "RedDoors"
     
    -- Create door collision groups
    PhysicsService:CreateCollisionGroup(blueDoors)
    PhysicsService:CreateCollisionGroup(redDoors)
     
    -- Add doors to their proper collision group
    PhysicsService:SetPartCollisionGroup(workspace.BlueDoor, blueDoors)
    PhysicsService:SetPartCollisionGroup(workspace.RedDoor, redDoors)


	local bluePlayers = "BluePlayers"
	local redPlayers = "RedPlayers"

	-- Create player collision groups
	PhysicsService:CreateCollisionGroup(bluePlayers)
	PhysicsService:CreateCollisionGroup(redPlayers)

	local function setCollisionGroup(character, groupName)
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("BasePart") then
				PhysicsService:SetPartCollisionGroup(child, groupName)
			end
		end
		character.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("BasePart") then
				PhysicsService:SetPartCollisionGroup(descendant, groupName)
			end
		end)
	end
--]]