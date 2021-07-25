local player = game.Players.LocalPlayer
local levelGui = player.PlayerGui:WaitForChild("LevelGui").LevelUp
local values = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues")
local xpArray = workspace:WaitForChild("GameValues"):WaitForChild("GameMisc").NextLevelXP.Value:split(",")  -- xp needed for each level
local plantList = workspace:WaitForChild("GameValues"):WaitForChild("PlantCosts"):GetChildren()  -- list of items 

function LevelUp()
	local level = values.Level.Value	
	if level <= 10 then
		game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("Level", 1, true) -- goes to Misc ChangePlayerValue()
		game:GetService("ReplicatedStorage"):WaitForChild("ChangeLeaderstats"):FireServer() -- goes to Misc ChangeLeaderstats()
		LevelUpEffects()		
		if level < 10 then
			player.PlayerGui:WaitForChild("HUDGui").HUD.NextLevel.Text2.Text = xpArray[level+1]
		else
			player.PlayerGui:WaitForChild("HUDGui").HUD.NextLevel.Text2.Text = "coming soon"
		end
		ShowLevelGui(level + 1)
		AddNewItems(level)
	else
		player.PlayerGui:WaitForChild("LevelGui").Warning.Visible = true
		print("Levelup error - shouldn't ever hit this")
	end
end



function ShowLevelGui(level)
	levelGui.Level.Text = "You have reached level " .. tostring(level)
	levelGui.Items.List1.Text = "You can grow a new plant!"
	levelGui.Items.List2.Text = string.upper(plantList[level+1].Name)	
	
	if level == 3 then
		levelGui.Additional.Visible = true
		levelGui.Additional.List1.Text = "You can now fill custom orders!"
		levelGui.Additional.List2.Text = "Look for the order board in the town center near the market"
		-- change Orderboard message and setup intial orders
		game:GetService("ReplicatedStorage"):WaitForChild("ReachedLevel"):Fire("3")		-- goes to Orderboard IntialOrders()
	else 
		levelGui.Additional.Visible = false
	end
	levelGui.Visible = true
end


function AddNewItems(level)	
	game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("SeedsAvailable", 1, true) -- Goes to Misc ChangePlayerValue()
	-- later levels need trees, animals, etc.
end


-- particle effects
function LevelUpEffects()
	local playerModel = workspace:WaitForChild(player.Name)
	local effect = game:GetService("ReplicatedStorage"):WaitForChild("LevelUpEffect"):Clone()
	effect.Parent = playerModel
	effect.Position = playerModel.Head.Position + Vector3.new(0,-4,0)
	player.PlayerGui:WaitForChild("Win"):Play()
	wait(2)	
	effect.ParticleEmitter.Rate = 0
	wait(1)
	effect:Destroy()
end


while wait(1) do
	local xp = values.Experience.Value
	local nextXP = tonumber(xpArray[values.Level.Value])
	if xp >= nextXP then
		LevelUp()
	end
end
