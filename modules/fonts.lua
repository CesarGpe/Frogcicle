-- loads all fonts for ease of use
local fonts = {}

function fonts.load()
	local files = love.filesystem.getDirectoryItems("assets/font")
	for _, file in pairs(files) do
        local ext = string.sub(file, -4)
        if ext == ".png" then
            local font = string.sub(file, 1, -5)
            fonts.new(font)
        end
    end
end

function fonts.new(name)
	local font = love.graphics.newFont("assets/font/" .. name .. ".txt", "assets/font/" .. name .. ".png")
	font:setFilter("nearest", "nearest", 1)
	fonts[name] = font
end

return fonts
