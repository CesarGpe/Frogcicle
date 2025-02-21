local sprite = love.graphics.newImage("assets/sprites/house.png")
local wall = require("modules.wall")

-- the background of the game
local stage = {
	x = WIDTH / 2 - sprite:getWidth() / 2,
	y = HEIGHT / 2 - sprite:getHeight() / 2,
	alpha = 1
}

function stage:load()
	self.alpha = 1
	wall.new(self.x * 0.995, self.y * 2, 10, sprite:getHeight()) -- left wall
	wall.new(self.x * 1.93, self.y * 2, 10, sprite:getHeight()) -- right wall
	wall.new(self.x * 1.46, self.y * 1.17, sprite:getWidth(), 10) -- up wall
	wall.new(self.x * 1.46, self.y * 2.87, sprite:getWidth(), 10) -- down wall
end

function stage:draw()
	love.graphics.setColor(game.bg.r, game.bg.g, game.bg.b)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)

	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.draw(sprite, self.x, self.y)

	love.graphics.setColor(1, 1, 1, 1)
end

return stage
