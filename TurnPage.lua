local player = game.Players.LocalPlayer
local helpGui =  player.PlayerGui:WaitForChild("HelpGui")


-- Arrow buttons turn pages in the Help Manual
function TurnPage(currPage, nextPage)
	helpGui:FindFirstChild(currPage).Visible = false
	helpGui:FindFirstChild(nextPage).Visible = true
end
helpGui.Help1.Right.MouseButton1Click:Connect(function() TurnPage("Help1", "Help2")end)
helpGui.Help2.Left.MouseButton1Click:Connect(function() TurnPage("Help2", "Help1")end)