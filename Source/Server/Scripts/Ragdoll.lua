--// Variables

local replicatedStorage = game:GetService("ReplicatedStorage")

local modules = replicatedStorage.Modules
local core = modules.Core

local ragdoll = require(core.Ragdoll)

local hitable = workspace.HITABLE

--// Functions

local function Recursive(Target: Model)
	local clone = Target:Clone()
	ragdoll.Store(Target)
	
	Target.Humanoid.Died:Once(function()
		ragdoll.Enable(Target)
		
		task.delay(1.2, function()
			clone.Parent = Target.Parent
			
			ragdoll.Clear(Target)
			Target:Destroy()
			
			Recursive(clone)
		end)
	end)
end

for _, Target in ipairs(hitable:GetChildren()) do
	Recursive(Target)
end