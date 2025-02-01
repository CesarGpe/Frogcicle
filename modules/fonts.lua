local fonts = {}

function fonts.load()
	fonts.new("boldblocks")
	fonts.new("cakeicing")
	fonts.new("cleanvictory")
	fonts.new("indigopaint")
	fonts.new("paintbasic")
	fonts.new("poolparty")
end

function fonts.new(name)
	local font = love.graphics.newFont("font/" .. name .. ".txt", "font/" .. name .. ".png")
	font:setFilter("nearest")
	fonts[name] = font
end

return fonts
