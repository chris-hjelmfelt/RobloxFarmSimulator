local player = game.Players.LocalPlayer
local levelGui = player.PlayerGui:WaitForChild("LevelGui").LevelUp
local values = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues
local xpArray = workspace:WaitForChild("GameValues"):WaitForChild("GameMisc").NextLevelXP.Value:split(",")  -- xp needed for each level
local plantList = workspace:WaitForChild("GameValues"):WaitForChild("PlantCosts"):GetChildren()  -- list of items 


function LevelUp()
	local level = values.Level
	if level <= 10 then
		game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("Level", 1, true) -- Goes to Misc ChangePlayerValue()
		game:GetService("ReplicatedStorage"):WaitForChild("ChangeLeaderstats"):FireServer() -- update leaderstats
		game:GetService("ReplicatedStorage"):WaitForChild("LevelEffects"):FireServer()  -- Show particle explosion
		wait(3)
		player.PlayerGui:WaitForChild("HUDGui").HUD.NextLevel.Text2.Text = xpArray[level.Value]
		ShowLevelGui(level.Value)
		AddNewItems(level.Value)
	end
end



function ShowLevelGui(level)	
	-- Reset to blank first
	levelGui.Items.List1.Text = "You can grow a new plant!"
	levelGui.Items.List2.Text = string.upper(plantList[level+1].Name)
	levelGui.Items.List3.Text = ""
	levelGui.Items.List4.Text = ""
	levelGui.Items.List5.Text = ""
	
	if level == 3 then
		levelGui.Items.List3.Text = "You can now fill custom orders!"
		levelGui.Items.List4.Text = "Look for the order board in the town center"
		levelGui.Items.List5.Text = "near the market"
	end
	levelGui.Visible = true
end


function AddNewItems(level)	
	game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("SeedsAvailable", 1, true) -- Goes to Misc ChangePlayerValue()
	-- later levels need trees, animals, etc.
end


while wait(1) do
	local xp = values.Experience.Value
	local level = values.Level
	local nextXP = tonumber(xpArray[level.Value])
	if xp >= nextXP then
		LevelUp()
	end
end