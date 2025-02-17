local joyImg = love.graphics.newImage("assets/sprites/control-ray.png")
local stickImg = love.graphics.newImage("assets/sprites/control-stick.png")
local pauseImg = love.graphics.newImage("assets/sprites/pause.png")

-- manages the virtual joystick and touches for mobile devices
local buttons = {
	alpha = 0,
	joy_enabled = false,
	joy = require("libs.Vjoy").new("fixed", 80, 80, 50, 0.035, 1.5, joyImg, stickImg),
	pause = {
		x = 0,
		y = 0,
		scale = 6,
		sprite = pauseImg,
	},
}

local function in_button(button, tx, ty)
	local sizex = button.sprite:getWidth() * button.scale
	local sizey = button.sprite:getHeight() * button.scale
	return tx >= button.x and tx <= button.x * sizex and
		ty >= button.y and ty <= button.y * sizey
end

function buttons:pause_button_check(id, x, y)
	if self.joy.heldId ~= id and in_button(self.pause, x, y) then
		ui_pause:switch()
	end
end

function buttons:draw()
	self.joy.draw(1, 1, 1, self.alpha, "line", 1, 1, 1, self.alpha)
	love.graphics.setColor(1, 1, 1, self.alpha * 0.35)
	love.graphics.draw(self.pause.sprite, self.pause.x, self.pause.y, 0, self.pause.scale, self.pause.scale)
	love.graphics.setColor(1, 1, 1, 1)
end

function buttons:update(dt)
	self.joy.update(dt)
	self.joy.setJoyRay((love.graphics.getWidth() + love.graphics.getHeight()) * 0.05)
	self.joy.setJoyPosition(1.3 * self.joy.getRay(), 2.25 * self.joy.getRay())

	self.pause.scale = (love.graphics.getWidth() + love.graphics.getHeight()) * 0.0035
	self.pause.x = love.graphics.getWidth() - self.pause.sprite:getWidth() * self.pause.scale * 1.2
	self.pause.y = self.pause.sprite:getWidth() * self.pause.scale * 0.2

	local touching_screen = false
	local touches = love.touch.getTouches()
	for _, id in pairs(touches) do
		local tx, ty = love.touch.getPosition(id)
		if self.joy.heldId ~= id and not in_button(self.pause, tx, ty) then
			touching_screen = true
			local sx, sy = game.coords(tx, ty)
			local deltaX = sx - player.body:getX()
			local deltaY = sy - player.body:getY()
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
