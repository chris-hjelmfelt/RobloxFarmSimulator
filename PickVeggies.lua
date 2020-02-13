-- Make sure this is a local script, and add the Remote events it is listening for
local player = game.Players.LocalPlayer
local players = game:GetService("Players")	
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local truck = invGui.Truck
local gameValues = workspace:WaitForChild("GameValues")
local each = gameValues:GetChildren()  -- list of items 

-- get veggie
local function HarvestPlants(plot)
	local item = plot.CropType.Value
	local storage = invGui.Storage.Items:FindFirstChild(item)	
	storage.Amount.Text = storage.Amount.Text + 1
	game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer(item, 1, true)  -- goes to Miscellanious script ChangePlayerValue()
end
game:GetService("ReplicatedStorage"):WaitForChild("HarvestPlants").OnClientEvent:Connect(HarvestPlants) -- Comes from ModuleScript PickPlant()


function ChooseSeeds(plot)
	local farmGui = player.PlayerGui:WaitForChild("FarmGuis")
	local playerLevel = players:FindFirstChild(player.Name):WaitForChild("PlayerValues").Level 
	local plants = farmGui.PlantSeeds.Items:GetChildren()
	local seedPosition = 1000
	for i=1,#plants do  -- Show the seed buttons for the seeds they have available
		if plants[i].ClassName == "TextButton" then 
			plants[i].Visible = false   -- start with it all hidden
			-- local seedPosition = table.find(seedArray, plants[i].Text)  -- search the seedArray to find the level (2 items per level)
			for j=1,#each do  -- each is at top
				if each[j].Name == plants[i].Text then
					if (playerLevel.Value *2 +2) >= j then  
						plants[i].Visible = true
					end
				end
			end			
		end		
	end
	farmGui.PlantSeeds.Visible = true	
	game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer(plot, 0, true) -- goes to Miscellanious script ChangePlayerValue()
end
game:GetService("ReplicatedStorage"):WaitForChild("ChooseSeeds").OnClientEvent:Connect(ChooseSeeds) 


function SendSeeds(seedType)
	local plot = players:FindFirstChild(player.Name).PlayerValues.ActivePlot.Value	
	plot.CropType.Value = seedType
	game:GetService("ReplicatedStorage"):WaitForChild("PlantSeeds"):FireServer(plot, seedType) -- goes to PlayerAddRemove script PlantSeeds()
	player.PlayerGui:WaitForChild("FarmGuis").PlantSeeds.Visible = false
end
-- Plant Seed buttons clickdetectors
local seedsAvailable = player.PlayerGui:WaitForChild("FarmGuis").PlantSeeds.Items:GetChildren()
for seed = 1,#seedsAvailable do
	if seedsAvailable[seed].ClassName == "TextButton" then
		seedsAvailable[seed].MouseButton1Click:Connect(function() SendSeeds(seedsAvailable[seed].Text) end)
	end
end
