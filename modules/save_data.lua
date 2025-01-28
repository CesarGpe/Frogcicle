local lume = require("libs.lume")
local file = "savedata.txt"

local save_data = {
	highscore = 0,
	config = {
		debug = false,
		bigger = false,
	},
}

function save_data:save()
	local data = self.config
	local serialize = lume.serialize(data)
	love.filesystem.write(file, serialize)
end

function save_data:load()
	if love.filesystem.getInfo(file) then
		local data = lume.deserialize(love.filesystem.read(file))
		self.config = data
	else
		self:save()
		print("No previous data found. Creating file.")
	end
end

return save_data
