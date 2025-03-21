--// Variables

local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local animations = replicatedStorage.Animations
local remotes = replicatedStorage.Remotes

local attack = remotes.Attack

local modules = replicatedStorage.Modules
local configuration = modules.Configuration

local shared_configuration = require(configuration.Shared_Configuration)

local server = shared_configuration.Server

--// Functions

attack.OnServerEvent:Connect(function(Player: Player, Characters: {Model}, Combo: number)
	--// No server-side validation cause im lazy—enjoy the visuals.
	
	for _, Character in ipairs(Characters) do
		local humanoid = Character.Humanoid
		local humanoidRootPart = Character.HumanoidRootPart

		local otherRootPart = Player.Character.HumanoidRootPart

		local direction = (humanoidRootPart.Position - otherRootPart.Position).Unit
		local impulse, died = server.ImpulseIntensity * 30, false

		humanoid.Health -= server.Damage

		if humanoid.Health <= 0 then
			died = true
			impulse = server.ImpulseIntensity * 50
		else
			died = false
		end

		local folder = if died then humanoidRootPart.Death_Hit else humanoidRootPart.Normal_Hit

		for _, Particle in ipairs(folder:GetChildren()) do
			local emitDelay = Particle:GetAttribute("EmitDelay")
			local emitCount = Particle:GetAttribute("EmitCount")
			
			Particle.Enabled = true

			task.delay(emitDelay, function()
				Particle:Emit(emitCount)
				Particle.Enabled = false
			end)
		end

		humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, otherRootPart.Position)
		humanoidRootPart:ApplyImpulse(direction * impulse)
	end
end)
