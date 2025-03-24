--// Variables

local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")

local player = players.LocalPlayer
local character = script.Parent.Parent
local humanoid = character:WaitForChild("Humanoid")

local client_modules = script.Modules
local client_core = client_modules.Core

local shared_modules = replicatedStorage:WaitForChild("Modules")
local shared_core = shared_modules:WaitForChild("Core")

local animator = require(shared_core:WaitForChild("Animator"))
local utility = require(client_core:WaitForChild("Utility"))

local remotes = replicatedStorage:WaitForChild("Remotes")
local attack = remotes:WaitForChild("Attack")

local animations = replicatedStorage:WaitForChild("Animations")
local hit = animations:WaitForChild("Hit")

local main = utility.New({Loaded = animator.Store(character, hit)})

--// Functions

humanoid.Died:Connect(function()
	animator.Clear(character)
end)

userInputService.InputBegan:Connect(function(Input: InputObject, Processed: boolean)
	if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end
	
	local instances = main:Get()
	
	main:Run(function(Combo: number)
		attack:FireServer(instances, Combo)
	end)
end)
