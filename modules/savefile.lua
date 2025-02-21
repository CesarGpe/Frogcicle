-- saves and loads user data when needed
local savefile = {
	data = {
		highscore = 99,
		fullscreen = true,
		debug = false,
		lang = "en_US",
		completed_tutorial = false,
	}
}

local lume = require("libs.lume")
local file = "savedata.frg"

function savefile:save()
	local serialize = lume.serialize(self.data)
	love.filesystem.write(file, serialize)
end

function savefile:load()
	if love.filesystem.getInfo(file) then
		local saved = lume.deserialize(love.filesystem.read(file))
		-- check for missing values in the save file and fill them with default ones
		for key, value in pairs(self.data) do
			if saved[key] == nil then
				saved[key] = value
			end
		end
		self.data = saved
	else
		self:save() -- make a save file because there is none
	end
end

return savefile
