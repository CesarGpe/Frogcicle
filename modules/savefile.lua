-- saves and loads user data when needed
local savefile = {
	data = {
		highscore = 0,
		fullscreen = true,
		debug = false,
	}
}

local lume = require("libs.lume")
local file = "savedata.frg"

function savefile:save()
	local d = self.data
	local serialize = lume.serialize(d)
	love.filesystem.write(file, serialize)
end

function savefile:load()
	if love.filesystem.getInfo(file) then
		local d = lume.deserialize(love.filesystem.read(file))
		self.data = d
	else
		print("No previous savefile found? I shall create it!!")
		self:save()
	end
end

return savefile
