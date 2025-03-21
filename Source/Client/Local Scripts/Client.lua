if game.Loaded == false then
	game.Loaded:Wait()
end

--// Variables

local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")
local players = game:GetService("Players")

local player = players.LocalPlayer
local character = script.Parent.Parent
local humanoid = character.Humanoid

local client_modules = script.Modules
local shared_modules = replicatedStorage.Modules

local client_core = client_modules.Core
local shared_core = shared_modules.Core

local animator = require(shared_core.Animator)
local utility = require(client_core.Utility)

local remotes = replicatedStorage.Remotes
local attack = remotes.Attack

local animations = replicatedStorage.Animations
local hit = animations.Hit

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