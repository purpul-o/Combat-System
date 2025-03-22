--// Variables

local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local visuals = replicatedStorage.Visuals
local animations = replicatedStorage.Animations
local remotes = replicatedStorage.Remotes

local attack = remotes.Attack

local particles = visuals.Particles

local modules = replicatedStorage.Modules

local configuration = modules.Configuration
local core = modules.Core

local particles_module = require(core.Particles)
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
		local impulse, container = server.ImpulseIntensity * 30, particles.Normal_Hit

		humanoid.Health -= server.Damage

		if humanoid.Health <= 0 then
			impulse = server.ImpulseIntensity * 50
			container = particles.Death_Hit
		end
		
		particles_module.Emit(Character, container)
		
		humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, otherRootPart.Position)
		humanoidRootPart:ApplyImpulse(direction * impulse)
	end
end)
