local player = game.Players.LocalPlayer
local values = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues")
local inventory = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerInventory")
local questGui = player.PlayerGui:WaitForChild("QuestGui")
local helperModule = require(workspace.ModuleScript)

-------------
-- Quests
-------------
function OpenQuests(who)	
	if values.QuestProgress.Value == 1 then
		if who == "Devon" then
			questGui.Devon1_1.Visible = true
			values.QuestProgress.Value = 2
		end
	elseif values.QuestProgress.Value == 2 and inventory.Potatoes.Value >= 6 then
		if who == "Devon" then
			questGui.Devon1_2.Visible = true
		elseif who == "Stan" then
			questGui.Stan1_2.Visible = true	
			game:GetService("ReplicatedStorage"):WaitForChild("ChangeInventory"):FireServer("Potatoes", 6, false)
			game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("Money", 20, true)
			values.QuestProgress.Value = 3
			helperModule.GainCoins(player, 20)
		end
	elseif values.QuestProgress.Value == 2 and inventory.Potatoes.Value < 6 then
		if who == "Devon" then
			questGui.Devon1_2.Visible = true
		elseif who == "Stan" then
			questGui.Stan1_1.Visible = true	
		end
	elseif values.QuestProgress.Value == 3 then 
		if who == "Devon" then
			questGui.Devon2_1.Visible = true
			values.QuestProgress.Value = 4
		end
	elseif values.QuestProgress.Value == 4 then 
		if who == "Devon" then
			questGui.Devon2_2.Visible = true
		elseif who == "Marie" then
			questGui.Marie1_1.Visible = true	
			values.QuestProgress.Value = 5
		end
	elseif values.QuestProgress.Value == 5 then 
		if who == "Devon" then
			questGui.Devon3_1.Visible = true
			values.QuestProgress.Value = 6
			game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("Money", 20, true)
			helperModule.GainCoins(player, 20)
		end
	elseif values.QuestProgress.Value == 6 then 
		if who == "Devon" then
			questGui.Devon3_1.Visible = true
		elseif who == "Emma" then
			questGui.Emma1_1.Visible = true	
			values.QuestProgress.Value = 7
		end
	elseif values.QuestProgress.Value == 7 then 
		if who == "Devon" then
			questGui.Devon4_1.Visible = true
			game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("Money", 20, true)
			helperModule.GainCoins(player, 20)
			values.QuestProgress.Value = 8
		end
	elseif values.QuestProgress.Value == 8 then 
		if who == "Devon" then
			questGui.Devon4_1.Visible = true
		elseif who == "Wyatt" then
			questGui.Wyatt1_1.Visible = true	
			values.QuestProgress.Value = 9
		end
	elseif values.QuestProgress.Value == 9 then 
		if who == "Devon" then
			questGui.Devon4_1.Visible = true
		elseif who == "Wyatt" and inventory.Corn.Value >= 20 then
			questGui.Wyatt2_1.Visible = true	
			game:GetService("ReplicatedStorage"):WaitForChild("ChangeInventory"):FireServer("Corn", 20, false)
			helperModule.ShowBench(player)
			values.QuestProgress.Value = 10			
		elseif who == "Wyatt" then
			questGui.Wyatt4_5.Visible = true
		end
	elseif values.QuestProgress.Value == 10 then 
		if who == "Devon" then
			questGui.Devon5_1.Visible = true
		end
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("OpenQuests").OnClientEvent:Connect(OpenQuests)  -- Comes from Miscellanious
