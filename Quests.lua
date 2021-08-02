local player = game.Players.LocalPlayer
local values = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues")
local inventory = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerInventory")
local questGui = player.PlayerGui:WaitForChild("QuestGui")
local helperModule = require(workspace.ModuleScript)

-------------
-- Quests
-------------
function OpenQuests(who)	
	if values.Quest01_Progress.Value == 1 then
		if who == "Devon" then
			questGui.Devon1_1.Visible = true
			game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Quest01_Set"):FireServer(2)  -- Goes to Miscellanious - State Events
		end
	elseif values.Quest01_Progress.Value == 2 and inventory.Potatoes.Value >= 6 then
		if who == "Devon" then
			questGui.Devon1_2.Visible = true
		elseif who == "Stan" then
			questGui.Stan1_2.Visible = true	
			game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("InventorySet"):FireServer("Potatoes", 6, false)  -- Goes to Miscellanious - State Events
			game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("MoneySet"):FireServer(20, true)  -- Goes to Miscellanious - State Events
			game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Quest01_Set"):FireServer(3)  -- Goes to Miscellanious - State Events
			helperModule.GainCoins(player, 20)
		end
	elseif values.Quest01_Progress.Value == 2 and inventory.Potatoes.Value < 6 then
		if who == "Devon" then
			questGui.Devon1_2.Visible = true
		elseif who == "Stan" then
			questGui.Stan1_1.Visible = true	
		end
	elseif values.Quest01_Progress.Value == 3 then 
		if who == "Devon" then
			questGui.Devon2_1.Visible = true
			game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Quest01_Set"):FireServer(4)  -- Goes to Miscellanious - State Events
		end
	elseif values.Quest01_Progress.Value == 4 then 
		if who == "Devon" then
			questGui.Devon2_2.Visible = true
		elseif who == "Marie" then
			questGui.Marie1_1.Visible = true	
			game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Quest01_Set"):FireServer(5)  -- Goes to Miscellanious - State Events
		end
	elseif values.Quest01_Progress.Value == 5 then 
		if who == "Devon" then
			questGui.Devon3_1.Visible = true
			game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Quest01_Set"):FireServer(6)  -- Goes to Miscellanious - State Events
			game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("MoneySet"):FireServer(20, true)  -- Goes to Miscellanious - State Events
			helperModule.GainCoins(player, 20)
		end
	elseif values.Quest01_Progress.Value == 6 then 
		if who == "Devon" then
			questGui.Devon3_1.Visible = true
		elseif who == "Emma" then
			questGui.Emma1_1.Visible = true	
			game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Quest01_Set"):FireServer(7)  -- Goes to Miscellanious - State Events
		end
	elseif values.Quest01_Progress.Value == 7 then 
		if who == "Devon" then
			questGui.Devon4_1.Visible = true
			game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("MoneySet"):FireServer(20, true)  -- Goes to Miscellanious - State Events
			helperModule.GainCoins(player, 20)
			game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Quest01_Set"):FireServer(8)  -- Goes to Miscellanious - State Events
		end
	elseif values.Quest01_Progress.Value == 8 then 
		if who == "Devon" then
			questGui.Devon4_1.Visible = true
		elseif who == "Wyatt" then
			questGui.Wyatt1_1.Visible = true	
			game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Quest01_Set"):FireServer(9)  -- Goes to Miscellanious - State Events
		end
	elseif values.Quest01_Progress.Value == 9 then 
		if who == "Devon" then
			questGui.Devon4_1.Visible = true
		elseif who == "Wyatt" and inventory.Corn.Value >= 20 then
			questGui.Wyatt2_1.Visible = true	
			game:GetService("ReplicatedStorage"):WaitForChild("StateEvents"):WaitForChild("InventorySet"):FireServer("Corn", 20, false)  -- Goes to Miscellanious - State Events
			helperModule.ShowBench(player)
			game:GetService("ReplicatedStorage"):WaitForChild("Quests"):WaitForChild("Quest01_Set"):FireServer(10)  -- Goes to Miscellanious - State Events		
		elseif who == "Wyatt" then
			questGui.Wyatt4_5.Visible = true
		end
	elseif values.Quest01_Progress.Value == 10 then 
		if who == "Devon" then
			questGui.Devon5_1.Visible = true
		end
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenQuests").OnClientEvent:Connect(OpenQuests)  -- Comes from Miscellanious
