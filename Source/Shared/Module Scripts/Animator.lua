--// Variables

local animator, loaded = {}, {}

--// Functions

function animator.Store(Character: Model, Container: Instance): { [number]: AnimationTrack }
	local humanoid = Character.Humanoid
	local animator = humanoid.Animator

	loaded[Character] = {}

	for I, Animation in ipairs(Container:GetChildren()) do
		local prefix = string.gsub(Animation.Name, "%d", "")
		loaded[Character][I] = animator:LoadAnimation(Container[`{prefix}{I}`])
	end

	return loaded[Character]
end

function animator.Clear(Character: Model)
	if loaded[Character] then
		local humanoid = Character.Humanoid
		local playing = humanoid:GetPlayingAnimationTracks()

		for _, track in ipairs(playing) do
			track:Stop()
		end

		loaded[Character] = nil
	end
end

return animator