-- This contains functions for setting PlayerValues

local StateModule = {}
	function StateModule.TutorialChanges(player, value)
		local tutorial = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues"):WaitForChild("Tutorial")
		tutorial.Value = value
	end

	function StateModule.Quest01_Set(player, value)
		local quest = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues"):WaitForChild('Quest01_Progress')
		quest.Value = value
	end

	function StateModule.TestingValues(player)
		local values = game:GetService("Players"):WaitForChild(player.Name):WaitForChild("PlayerValues")
		values:WaitForChild("Money").Value = 1000
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
