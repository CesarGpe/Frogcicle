--local shader = love.graphics.newShader("shader/skew.fs")
local joyImg = love.graphics.newImage("assets/sprites/control-ray.png")
local stickImg = love.graphics.newImage("assets/sprites/control-stick.png")
local buttons = {
	joy = require("libs.Vjoy").new("fixed", 80, 80, 50, 0.035, 1, joyImg, stickImg),
	joy_enabled = false,
	alpha = 0,
}

function buttons:draw()
	self.joy.draw(1, 1, 1, self.alpha, "line", 1, 1, 1, self.alpha)
end

function buttons:update(dt)
	self.joy.update(dt)

	self.joy.setJoyRay((love.graphics.getWidth() + love.graphics.getHeight()) * 0.05)
	self.joy.setJoyPosition(1.3 * self.joy.getRay(), 2.25 * self.joy.getRay())

	local touching_screen = false
	local touches = love.touch.getTouches()
	for _, id in ipairs(touches) do
		if self.joy.heldId ~= id then
			touching_screen = true
			local mx, my = game.coords(love.touch.getPosition(id))
			local deltaX = mx - player.body:getX()
			local deltaY = my - player.body:getY()
			input.look = math.atan2(deltaY, deltaX)
			input.shoot = true
		end
	end
	if not touching_screen then
		input.shoot = false
	end

	if game.over and not self.joy.heldId then
		self.joy_enabled = false
	end
end

return buttons
