--// Variables

local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local debris = game:GetService("Debris")

local player = players.LocalPlayer
local character = player.Character
local humanoidRootPart = character.HumanoidRootPart

local modules = replicatedStorage.Modules

local configuration = modules.Configuration
local shared_configuration = require(configuration.Shared_Configuration)

local client = shared_configuration.Client

local decay = workspace.DECAY
local hitable = workspace.HITABLE

local utility, main = {}, {}
main.__index = main

--// Functions

function utility.New(Data: {any})
	local self = setmetatable({
		Count = 0,
		Loaded = Data.Loaded,
		Lock = false
	}, main)
	return self
end

function main:Get(): {Instance}
	local size = client.HitboxSize
	local cframe = humanoidRootPart.CFrame * CFrame.new(0, 0, -size.Z / 2)

	local bounds = workspace:GetPartBoundsInBox(cframe, size)
	local instances = {}

	for _, instance in ipairs(bounds) do
		local parent = instance.Parent
		local valid = players:GetPlayerFromCharacter(parent)

		if (not valid and not parent:IsDescendantOf(hitable))
			or valid == player or parent.Humanoid.Health <= 0
			or table.find(instances, parent) then
			continue
		end

		table.insert(instances, parent)
	end

	return instances
end

function main:Run(Callback: (Combo: number) -> ())
	if self.Lock then
		return
	end

	self.Lock = true
	self.Count = (self.Count % #self.Loaded) + 1

	Callback(self.Count)

	local track = self.Loaded[self.Count]

	track:Play(client.FadeIn)
	track.Stopped:Wait()

	self.Lock = false
end

return utility