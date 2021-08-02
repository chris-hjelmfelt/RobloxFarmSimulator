-- Make sure this is a local script, and add the Remote events it is listening for
local player = game.Players.LocalPlayer
local players = game:GetService("Players")	
local invGui = player.PlayerGui:WaitForChild("InventoryGui")
local truck = invGui.Storage
local values = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues")
local plantCosts = workspace:WaitForChild("GameValues"):WaitForChild("PlantCosts")
local helperModule = require(workspace.ModuleScript)
local each = plantCosts:GetChildren()  -- list of items 
local debounce1 = false
local debounce2 = false
local debounce3 = false
local debounce4 = false

-- get veggie
function HarvestPlants(plot)		
	local item = plot.CropType.Value
	local storage = invGui.Storage.Items:FindFirstChild(item)
	local xpAmount = 10	
	storage.Amount.Text = storage.Amount.Text + 1
	player.PlayerGui:WaitForChild("HUDGui").HUD.Experience.Text = "Experience: " .. values.Experience.Value + xpAmount
	GainXP()	
	game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("XPSet"):FireServer(xpAmount)  -- Goes to Miscellanious - State Events
	game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("InventorySet"):FireServer(item, 1, true)  -- Goes to Miscellanious - State Events
	game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("PlantsHarvestedSet"):FireServer(1)  -- Goes to Miscellanious - State Events
	-- Tutorial
	if values.Tutorial.Value == 7 and values.PlantsHarvested.Value > 4 then  -- tutorial running and enough veggies harvested
		game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("TutBindable"):Fire()  -- goes to Tutorial
	end
	-- Make sure inventory totals are still correct
	helperModule.CheckInvTotal(player)
end
game:GetService("ReplicatedStorage"):WaitForChild("HarvestPlants").OnClientEvent:Connect(HarvestPlants) -- Comes from ModuleScript PickPlant()


function ChooseSeeds(plot)
	local farmGui = player.PlayerGui:WaitForChild("FarmGuis")
	local available = values.Level.Value + 1
	local plants = farmGui.PlantSeeds.Items:GetChildren()
	for i=1,#plants do  -- Show the seed buttons for the seeds they have available
		if plants[i].ClassName == "TextButton" then 
			plants[i].Visible = false   -- start with it all hidden
			for j=1,#each do  -- each is at top
				if each[j].Name == plants[i].Text then
					if (available) >= j then  
						plants[i].Visible = true
					end
				end
			end			
		end		
	end
	if values.Tutorial.Value >= 3 then  -- don't show this yet during tutorial
		farmGui.PlantSeeds.Visible = true
	end	
	game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer(plot, 0, true) -- goes to Miscellanious script ChangePlayerValue()
end
game:GetService("ReplicatedStorage"):WaitForChild("ChooseSeeds").OnClientEvent:Connect(ChooseSeeds) -- comes from MS CollectVeggie()


function SendSeeds(seedType)  -- from click detectors below
	local plot = players:FindFirstChild(player.Name).ActivePlot.Value	
	game:GetService("ReplicatedStorage"):WaitForChild("PlantSeeds"):FireServer(plot, seedType) -- goes to PlayerAddRemove PlantSeeds() 
	if game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues").Tutorial.Value == 3 then 
		game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("TutBindable"):Fire()  -- goes to Tutorial	
	end
	player.PlayerGui:WaitForChild("FarmGuis").PlantSeeds.Visible = false
end
-- Plant Seed buttons clickdetectors
local seedsAvailable = player.PlayerGui:WaitForChild("FarmGuis").PlantSeeds.Items:GetChildren()
for seed = 1,#seedsAvailable do
	if seedsAvailable[seed].ClassName == "TextButton" then
		seedsAvailable[seed].MouseButton1Click:Connect(function() SendSeeds(seedsAvailable[seed].Text) end)
	end
end


function GainXP()
	local hudText = nil
	local deLevel = 0
	if debounce1 == false then
		debounce1 = true
		deLevel = 1
		hudText = player.PlayerGui:WaitForChild("HUDGui").GainXP:FindFirstChild("Text1")
	elseif debounce2 == false then
		debounce2 = true
		deLevel = 2
		hudText = player.PlayerGui:WaitForChild("HUDGui").GainXP:FindFirstChild("Text2")
	elseif debounce3 == false then
		debounce3 = true
		deLevel = 3
		hudText = player.PlayerGui:WaitForChild("HUDGui").GainXP:FindFirstChild("Text3")
	elseif debounce4 == false then
		debounce4 = true
		deLevel = 4
		hudText = player.PlayerGui:WaitForChild("HUDGui").GainXP:FindFirstChild("Text4")
	end
	if deLevel ~= 0 then
		hudText.Visible = true
		wait(.2)
		for i = 1,8 do
			hudText.Position = hudText.Position + UDim2.new(0,0,0,-5)
			wait(.2)
		end
		hudText.Visible = false
		hudText.Position = hudText.Position + UDim2.new(0,0,0,40)
		if deLevel == 1 then
			debounce1 = false
		elseif deLevel == 2 then
			debounce2 = false
		elseif deLevel == 3 then
			debounce3 = false
		else
			debounce4 = false
		end
	end
end


-- GainCoins is in Market
