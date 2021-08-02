-- This contains functions for setting PlayerValues
-- These come from Miscellanious - State Events   (except where noted)
local StateModule = {}   
	function StateModule.LevelSet(player, value)
		local level = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues"):WaitForChild("Level")
		level.Value = value
	end

	function StateModule.ExperienceSet(player, addValue)
		local xp = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues"):WaitForChild("Experience")
		xp.Value = xp.value + addValue
	end

	function StateModule.MoneySet(player, value, add)  -- also comes from Misc - BuyUpgrade
		local money = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues"):WaitForChild("Money")
		if  (add == true) then
			money.Value = money.Value + value
		else
			money.Value = money.Value - value
		end
	end

	function StateModule.TutorialChanges(player, value)  -- also comes from PlayerAddRemove - Main
		local tutorial = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues"):WaitForChild("Tutorial")
		tutorial.Value = value
	end

	function StateModule.Quest01_Set(player, value)
		local quest = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues"):WaitForChild('Quest01_Progress')
		quest.Value = value
	end

	function StateModule.NumPlotsSet(player, addValue)  -- comes from Misc - BuyUpgrades
		local plots = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues"):WaitForChild('NumPlots')
		plots.Value = plots.Value + addValue
	end

	function StateModule.StorageLevelSet(player, addValue)
		local storage = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues"):WaitForChild('StorageLevel')
		storage.Value = storage.Value + addValue
	end

	function StateModule.PlantsHarvestedSet(player, addValue)
		local plants = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues"):WaitForChild('PlantsHarvested')
		plants.Value = plants.Value + addValue
	end

	function StateModule.InventorySet(player, itemName, quantity, addBool)
		local inventory = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerInventory")	
		local item = inventory:WaitForChild(itemName)
		local total = inventory:WaitForChild('total')
		-- update item and also total
		if addBool == true then			
			item.Value = item.Value + quantity
			total.Value = total.Value + quantity
		else
			item.Value = item.Value - quantity
			total.Value = total.Value - quantity
		end		
	end

	function StateModule.TestingValues(player)
		local values = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues")
		values:WaitForChild("Money").Value = 10000
		values:WaitForChild("Experience").Value = 0
		values:WaitForChild("Level").Value = 1
		values:WaitForChild("NumPlots").Value = 4
		values:WaitForChild("StorageLevel").Value = 1
		values:WaitForChild("Quest01_Progress").Value = 1
		values:WaitForChild("Tutorial").Value = 1
		values:WaitForChild("PlantsHarvested").Value = 0
		print("testing")
	end
return StateModule
