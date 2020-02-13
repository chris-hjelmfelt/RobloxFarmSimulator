-- Creates a Ray to show the path to a part you want the player to find (player house, market, etc.)
-- This is a regular script that goes inside the part 
-------------------------------------------------------------------------------------------------------
local players = game:GetService("Players")	
local player = workspace:WaitForChild('Jaylah_Everstar'):WaitForChild("LowerTorso")

-- Make a part to use to show the path
local beam = Instance.new("Part", workspace)
beam.BrickColor = BrickColor.new("HotPink")
beam.FormFactor = "Custom"
beam.Material = "Foil"
beam.Transparency = 0.8
beam.Anchored = true
beam.Locked = true
beam.CanCollide = false
local emitter = Instance.new("ParticleEmitter", beam)
emitter.Enabled = true
emitter.Lifetime = NumberRange.new(0.3,0.5)
local colorKeypoints = {
	-- API: ColorSequenceKeypoint.new(time, color)
	ColorSequenceKeypoint.new( 0, Color3.new(1, .8, 1)),  -- At t=0, 
	ColorSequenceKeypoint.new(.5, Color3.new(1, .7, .8)), -- At t=.5,
	ColorSequenceKeypoint.new( 1, Color3.new(1, .6, .6))   -- At t=1, 
}
emitter.Color = ColorSequence.new(colorKeypoints)
emitter.Size = NumberSequence.new(.3,.3)
emitter.Rate = 300 -- Particles per second
emitter.Speed = NumberRange.new(0.5, 0.5) 

-- Find path to player
local direction = player.Position - script.Parent.Position 
local sendOut = Vector3.new(direction.X *2,direction.Y *2,direction.Z *2)
local distance = (player.Position - script.Parent.Position).magnitude
beam.Size = Vector3.new(0.2, 0.2, distance)

-- Create the ray
local ray = Ray.new(script.Parent.Position, sendOut)

-- If showRay is enabled run the loop  
local showRay = false  -- this should change to a playervalue at some point
if player then
	while showRay and wait() do
		direction = player.Position - script.Parent.Position 
		sendOut = Vector3.new(direction.X *2,direction.Y *2,direction.Z *2)
		distance = (player.Position - script.Parent.Position).magnitude
		beam.Size = Vector3.new(0.2, 0.2, distance)
		ray = Ray.new(script.Parent.Position, sendOut)
		local hit, position  = workspace:FindPartOnRayWithIgnoreList(ray, {script.Parent})
	
		if hit then	
			beam.CFrame = CFrame.new(script.Parent.Position, position) * CFrame.new(0, 0, -distance / 2)
		end
	end
end
