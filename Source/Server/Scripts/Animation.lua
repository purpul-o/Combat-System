--// Variables

local replicatedStorage = game:GetService("ReplicatedStorage")

local animations = replicatedStorage.Animations
local modules = replicatedStorage.Modules

local configuration = modules.Configuration
local shared_configuration = require(configuration.Shared_Configuration)

local server = shared_configuration.Server

local hurt = animations.Hurt
local core = modules.Core

local animator = require(core.Animator)
local hitable = workspace.HITABLE

local previous = {}

--// Functions

local function Animate(Target: Model)	
	local humanoid = Target.Humanoid
	local stored = animator.Store(Target, hurt)

	previous[Target] = humanoid.Health

	local connection
	connection = humanoid.HealthChanged:Connect(function(Health: number)
		if Health == 0 then
			connection:Disconnect()
			previous[Target] = nil
		elseif Health < previous[Target] then
			stored[math.random(1, #stored)]:Play(server.FadeIn)
			previous[Target] = Health
		end
	end)
end

hitable.ChildAdded:Connect(Animate)

for _, Target in ipairs(hitable:GetChildren()) do
	Animate(Target)
end