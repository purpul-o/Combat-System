--// Variables

local particles = {}

--// Functions

function particles.Emit(Character: Model, Container: Instance)
	local humanoidRootPart = Character.HumanoidRootPart
	
	local attachment = Instance.new("Attachment")
	attachment.Parent = humanoidRootPart
	
	local activeParticles = 0
	
	for _, Particle in ipairs(Container:GetChildren()) do
		local emitDelay = Particle:GetAttribute("EmitDelay")
		local emitCount = Particle:GetAttribute("EmitCount")
		local lifetime = Particle.Lifetime.Max
		
		local new = Particle:Clone()
		new.Enabled = true
		new.Parent = attachment
		
		activeParticles += 1
		
		task.delay(emitDelay, function()
			new:Emit(emitCount)
			new.Enabled = false
			
			task.delay(lifetime, function()
				activeParticles -= 1
				if activeParticles == 0 then
					attachment:Destroy()
				end
			end)
		end)
	end
end

return particles
