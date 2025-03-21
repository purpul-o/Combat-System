--// Variables

local motors, ragdoll, ragdolling = {}, {}, {}

--// Functions

function ragdoll.Store(Character: Model)
	motors[Character] = {}
	
	for _, descendant in ipairs(Character:GetDescendants()) do
		if not descendant:IsA("Motor6D") then
			continue
		end
		
		motors[Character][descendant] = {
			C0 = descendant.C0,
			C1 = descendant.C1,
			Part0 = descendant.Part0,
			Part1 = descendant.Part1
		}
	end
end

function ragdoll.Clear(Character: Model)
	if motors[Character] then
		motors[Character] = nil
	end
	if ragdolling[Character] then
		ragdolling[Character] = nil
	end
end

function ragdoll.Enable(Character: Model)
	if ragdolling[Character] then return end
	
	local humanoid = Character.Humanoid
	local humanoidRootPart = Character.HumanoidRootPart
	
	ragdolling[Character] = true
	
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	
	for _, descendant in ipairs(Character:GetDescendants()) do
		if not descendant:IsA("Motor6D") then
			continue
		end
		
		local socket = Instance.new("BallSocketConstraint")
		local a1 = Instance.new("Attachment")
		local a2 = Instance.new("Attachment")

		a1.Parent, a2.Parent = descendant.Part0, descendant.Part1
		socket.Parent = descendant.Parent
		socket.Attachment0, socket.Attachment1 = a1, a2
		a1.CFrame, a2.CFrame = descendant.C0, descendant.C1

		socket.LimitsEnabled = true
		socket.TwistLimitsEnabled = true

		descendant:Destroy()
	end
end

function ragdoll.Disable(Character: Model)
	if not ragdolling[Character] then return end
	
	local humanoid = Character.Humanoid
	local humanoidRootPart = Character.HumanoidRootPart
	
	ragdolling[Character] = nil
	
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

	for joint, data in pairs(motors[Character]) do
		local newJoint = Instance.new("Motor6D")
		newJoint.Part0, newJoint.Part1 = data.Part0, data.Part1
		newJoint.C0, newJoint.C1 = data.C0, data.C1
		newJoint.Parent = data.Part0
	end

	for _, descendant in ipairs(Character:GetDescendants()) do
		if descendant:IsA("BallSocketConstraint") or descendant:IsA("Attachment") then
			descendant:Destroy()
		end
	end
end

return ragdoll