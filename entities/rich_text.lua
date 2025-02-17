local lg = love.graphics
local text = {}
text.__index = text

function text.new(string, font, ogx, ogy)
	local self = setmetatable({}, text)

	self.x = ogx
	self.y = ogy
	self.ogx = ogx
	self.ogy = ogy
	self.text = string
	self.font = font
	self.color = { r = 1, g = 1, b = 1, a = 1 }
	self.scale = 1
	self.angle = 0
	self.width = 50
	self.height = 18

	return self
end

function text:draw()
	self.width = self.font:getWidth(self.text)
	self.height = self.font:getHeight()

	lg.setFont(self.font)
	lg.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
	lg.print(self.text, self.x, self.y, self.angle, self.scale, self.scale, self.width / 2, self.height / 2)
	lg.setColor(1, 1, 1, 1)
end

return text