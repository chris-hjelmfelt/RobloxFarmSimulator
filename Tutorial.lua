local player = game.Players.LocalPlayer
local farm = workspace:WaitForChild(player.Name .. "_Farm")
local tutGui = player.PlayerGui:WaitForChild("TutorialGui")
local values = game:GetService("Players"):FindFirstChild(player.Name):WaitForChild("PlayerValues")
local helpGui = player.PlayerGui:WaitForChild("HelpGui")
local arrow = nil
local arrow2 = nil
local showArrow = false
local step = values.Tutorial.Value


function ShowTutGui()
	tutGui.Skip.SkipButton.Visible = true
	if step == 1 then  -- just after Welcome, tells them to click on a farm tile
		wait(1)
		helpGui.Restart.Visible = false
		ShowIndicator()
	elseif step == 2 then  -- tell them to choose seeds 
		-- nothing extra
	elseif step == 3 then  -- tells them to water the tile
		wait(1)
	elseif step == 4 then  -- show the farm a moment before telling them to rake the tile
		wait(1.5)
	elseif step == 5 then  -- tells them to harvest
		wait(1.5)
	elseif step == 6 then  -- tells them to grow 4 more
		showArrow = false
		arrow.Transparency = 1
	elseif step == 7 then  -- tells them to look in storage
		arrow.Transparency = 0
		arrow.CFrame = farm.Storage.PrimaryPart.CFrame + Vector3.new(0,7,0)
		game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("Blink"):Fire() -- starts Blink() later on this page
	elseif step == 8 then  -- tells where to see their total
		-- nothing extra
	elseif step == 9 then  -- tells them how to close the storage menu
		-- nothing extra
	elseif step == 10 then  -- tells them to get into their truck
		arrow.CFrame = farm:WaitForChild("Truck").PrimaryPart.CFrame + Vector3.new(0,8,0)
	elseif step == 11 then  -- tells them to drive to market
		showArrow = false
		arrow.Transparency = 1	
		arrow2 = game.ReplicatedStorage.Arrow3:Clone()
		arrow2.Parent = farm
		arrow2.Anchored = true
		
		arrow2.CFrame = farm:WaitForChild("Truck").PrimaryPart.CFrame + Vector3.new(0,6,-13)
		arrow2.Orientation = Vector3.new(90, 0, 0)
		game:GetService("ReplicatedStorage"):WaitForChild("Tutorial").ShowTruckArrow:Fire()  -- goes to ArrowPosition
	elseif step == 12 then  -- tells them to click on the market building
		-- nothing extra
	elseif step == 13 then  -- tells them about Market menu
		-- nothing extra
	elseif step == 14 then  -- tells them about Market sell button
		-- nothing extra
	elseif step == 15 then  -- End tutorial message
		tutGui.Skip.SkipButton.Visible = false
	end
	if step < 16 then	-- possible to get here with step = 16
		tutGui:FindFirstChild("Step" .. step).Visible = true		
		player.PlayerGui:WaitForChild("FarmGuis").PlantSeeds.Visible = false
		step = step + 1
		game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("Tutorial", 1, true)  -- Goes to Misc ChangePlayerValue()
	end
end 
-- TutBindable comes from ModuleScript CollectVeggie(), WaterPlant(), RakePlant(), PickPlant(), TruckActive (inside of Trucks)
-- OpenGuis OpenStorage(), and OpenMarket()
game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("TutBindable").Event:connect(ShowTutGui) 
-- TutRemote comes from TutorialGui>Welcome>Title>Close and >TextButton CloseWelcome, PickVeggies SendSeeds(),
-- TutorialGui>Step8>Next CloseStep8, TutorialGui>Step9>Next CloseStep9 or InventoryGui>Storage>Title1>Close Close
-- ArrowPosition, TutorialGui>Step13>Next CloseStep13, and TutorialGui>Step14>Next CloseStep14
game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("TutRemote").OnClientEvent:Connect(ShowTutGui)  


-- player clicks tutorial restart button in help gui
function RestartTutorial()	
	if arrow then	arrow:destroy()  end
	if arrow2 then	arrow2:destroy()  end
	showArrow = false
	game:GetService("ReplicatedStorage").Tutorial:WaitForChild("ResetTut"):FireServer()  -- Goes to Misc ResetTutorial()
	step = 1	
	helpGui.Help1.Visible = false
	helpGui.Restart.Visible = true
	ShowTutGui()	
end
helpGui.Help1.RestartTut.MouseButton1Click:Connect(RestartTutorial)


-- player clicks skip tutorial button on screen
function OpenSkip()
	tutGui.Skip.SkipButton.Visible = false
	tutGui.Skip.Message.Visible = true
end
tutGui.Skip.SkipButton.SkipTut.MouseButton1Click:Connect(OpenSkip)


-- player clicks yes to skip tutorial
function SkipTutorial()
	step = 16
	if arrow then	arrow:destroy()  end
	if arrow2 then	arrow2:destroy()  end
	showArrow = false
	local needAdd = 16 - values.Tutorial.Value 
	game:GetService("ReplicatedStorage"):WaitForChild("ChangeValue"):FireServer("Tutorial", needAdd, true)  -- Goes to Misc ChangePlayerValue()
	for i=1,15 do
		tutGui:FindFirstChild("Step" .. i).Visible = false
	end
	wait(.5)
	tutGui.Skip.SkipButton.Visible = false
	tutGui.Skip.Message.Visible = false
end
tutGui.Skip.Message.Yes.MouseButton1Click:Connect(SkipTutorial)


-- player clicks no don't skip tutorial
function DontSkip()
	tutGui.Skip.SkipButton.Visible = true
	tutGui.Skip.Message.Visible = false
end
tutGui.Skip.Message.No.MouseButton1Click:Connect(DontSkip)


-- Blinking arrow above farm tiles, storage or truck
function ShowIndicator()
	wait(1)	
	arrow = game.ReplicatedStorage.Arrow2:Clone()
	arrow.Parent = farm
	arrow.CFrame = farm:WaitForChild("FarmTiles").PrimaryPart.CFrame + Vector3.new(4,6,4)
	game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("Blink"):Fire() -- starts Blink() later on this page
end


-- blinks the arrow parts
function Blink()
	showArrow = true
	while showArrow do
		if arrow.Transparency ==  0 then
			arrow.Transparency = 1
		else
			arrow.Transparency =  0 
		end
		wait(.4)
	end
end
game:GetService("ReplicatedStorage"):WaitForChild("Tutorial"):WaitForChild("Blink").Event:connect(Blink) -- comes from ShowIndicator() above


-- blinks the gui arrow during the storage and market menu sections
while wait(.4) and step < 15 do
	if tutGui:FindFirstChild("Step8").ImageLabel.Visible == false then
		tutGui:FindFirstChild("Step8").ImageLabel.Visible = true
		tutGui:FindFirstChild("Step9").ImageLabel.Visible = true
		tutGui:FindFirstChild("Step13").ImageLabel.Visible = true
		tutGui:FindFirstChild("Step14").ImageLabel.Visible = true
	else
		tutGui:FindFirstChild("Step8").ImageLabel.Visible = false
		tutGui:FindFirstChild("Step9").ImageLabel.Visible = false
		tutGui:FindFirstChild("Step13").ImageLabel.Visible = false
		tutGui:FindFirstChild("Step14").ImageLabel.Visible = false
	end
end