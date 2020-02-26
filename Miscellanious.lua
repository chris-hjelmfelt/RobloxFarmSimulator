local players = game:GetService("Players")	
local serverStorage = game:GetService("ServerStorage")
local helperModule = require(workspace.ModuleScript)
local farmSpaceCost = workspace:WaitForChild("GameValues2").FarmSpaceCost.Value:split(",")


-----------------
-- Market
-----------------
function OpenMarket(player)
	game:GetService("ReplicatedStorage"):WaitForChild("OpenMarket"):FireClient(player) -- Sends to OpenGuis LocalScript
end
workspace:FindFirstChild("Market").ClickDetector.mouseClick:connect(OpenMarket);


-----------------
-- OrderBoard
-----------------
function OpenOrders(player)
	
	game:GetService("ReplicatedStorage"):WaitForChild("OpenOrders"):FireClient(player) -- Sends to OrderBoard LocalScript
end
workspace:FindFirstChild("Orderboard").ClickDetector.mouseClick:connect(OpenOrders);


-----------------------
-- Upgrade Farm Space
-----------------------
-- Most upgrade functions are in OpenGuis
function BuyUpgrade(player)
	local farm = workspace:FindFirstChild(player.Name .. "_Farm")
	local numPlots = game:GetService("Players"):FindFirstChild(player.Name).PlayerValues.NumPlots
	local moneyNeeded = tonumber(farmSpaceCost[numPlots.Value/2-1])
	local playerMoney = players:FindFirstChild(player.Name):WaitForChild("PlayerValues").Money
	local numPlots = players:FindFirstChild(player.Name):WaitForChild("PlayerValues").NumPlots 
	
	if playerMoney.Value > moneyNeeded and numPlots.Value < 12 then  -- if they have the money and don't have all tiles yet
		playerMoney.Value = playerMoney.Value - moneyNeeded
		numPlots.Value = numPlots.Value + 2
		-- show new farm tile model
		helperModule.PlaceFarmTiles(player)  	
		-- open UpgradeGui to tell them what they get
		game:GetService("ReplicatedStorage"):WaitForChild("OpenUpgrades"):FireClient(player, numPlots)  -- Goes to OpenGuis localscript
	elseif numPlots.Value >= 12 then
		game:GetService("ReplicatedStorage"):WaitForChild("Warning"):FireClient(player, "Sorry this upgrade isn't active yet")
	end	
end
game:GetService("ReplicatedStorage"):WaitForChild("BuyFarmSpace").OnServerEvent:Connect(BuyUpgrade)


-------------------------
-- Change Storage Model
-------------------------
function NewStorage(player)
	helperModule.PlaceStorageModel(player)
end
game:GetService("ReplicatedStorage"):WaitForChild("BiggerStorage").OnServerEvent:Connect(NewStorage)


---------------------------------------------------
-- Add or Subtract from PlayerValues and Inventory
---------------------------------------------------
function ChangePlayerValue(player, item, quantity, addBool)	
	local values = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues")		
	if quantity == 0 then
		values.ActivePlot.Value = item
	else
		local itemAmount = values:WaitForChild(item)
		if addBool == true then			
			itemAmount.Value = itemAmount.Value + quantity
		else
			itemAmount.Value = itemAmount.Value - quantity
		end
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue").OnServerEvent:Connect(ChangePlayerValue) -- this comes from localscripts  PickVeggies ChooseSeeds(), Market SellVeggies(), and Levels LevelUp()


function ChangePlayerInventory(player, item, quantity, addBool)	
	local inventory = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerInventory")	
	local itemAmount = inventory:WaitForChild(item)
	if addBool == true then			
		itemAmount.Value = itemAmount.Value + quantity
	else
		itemAmount.Value = itemAmount.Value - quantity
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("ChangeInventory").OnServerEvent:Connect(ChangePlayerInventory) -- this comes from localscripts PickVeggies HarvestPlants() and Market SellVeggies()

----------------------------
-- Particle Effects
----------------------------
function LevelUpEffects(player)
	local playerModel = workspace:WaitForChild(player.Name)
	local effect = game.ServerStorage:FindFirstChild("LevelUpEffect"):Clone()
	effect.Parent = workspace	
	effect.Position = playerModel.Head.Position + Vector3.new(0,-4,0)
	wait(2)
	effect.ParticleEmitter.Rate = 0
	wait(2)
	effect:Destroy()
end
game:GetService("ReplicatedStorage"):WaitForChild("LevelEffects").OnServerEvent:Connect(LevelUpEffects)
workspace:FindFirstChild("Baseplate").ClickDetector.mouseClick:connect(LevelUpEffects);


--[[ 
------------------------------------------
-- Test placement of all farms
------------------------------------------
local farms = workspace.Farms:GetChildren()
for i=1,#farms do
	local location = farms[i].CFrame	
	farms[i]:Destroy()	
	local newPlot = game.ServerStorage:FindFirstChild("FarmModel"):Clone()
	newPlot.Parent = workspace.Farms
	newPlot.Name = "FarmModel"		
	newPlot:SetPrimaryPartCFrame(location) 
	newPlot:FindFirstChild("Owner").Value = "X"
end
--]]