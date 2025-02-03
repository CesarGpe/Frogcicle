local sprite = love.graphics.newImage("assets/sprites/house.png")
local wall = require("modules.wall")
local stage = {
	x = WIDTH / 2 - sprite:getWidth() / 2,
	y = HEIGHT / 2 - sprite:getHeight() / 2,
	dark = 0
}

function stage:load()
	self.dark = 0
	wall.new(self.x, self.y * 2, 10, sprite:getHeight()) -- left wall
	wall.new(self.x * 1.93, self.y * 2, 10, sprite:getHeight()) -- right wall
	wall.new(self.x * 1.46, self.y * 1.17, sprite:getWidth(), 10) -- up wall
	wall.new(self.x * 1.46, self.y * 2.87, sprite:getWidth(), 10) -- down wall
end

function stage:draw()
	--push:setBorderColor(0.173, 0.18, 0.227)

	love.graphics.setColor(0.173, 0.18, 0.227, 1)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(sprite, self.x, self.y)

	love.graphics.setColor(0, 0, 0, self.dark)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)

	love.graphics.setColor(1, 1, 1, 1)
end

return stage
