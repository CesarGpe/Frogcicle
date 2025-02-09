local shader = love.graphics.newShader("shader/skew.fs")
local buttons = {
	cross = {
		sprite = love.graphics.newImage("assets/sprites/control.png"),
		x = 330,
		y = 200,
		scale = 6,
		alpha = 0,
		hovering = 0,
	},
}

function buttons:draw()
	love.graphics.setShader(shader)
	love.graphics.setColor(1, 1, 1, self.cross.alpha)

	love.graphics.draw(self.cross.sprite, self.cross.x, self.cross.y, 0, self.cross.scale,
		self.cross.scale)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setShader()
end

function buttons:update(dt)
	self.cross.x, self.cross.y = game.coords(0, love.graphics.getHeight() - 360)

	local lerp = 0.15
	local max = 0.0045

	local touching_cross = false
	local touching_screen = false

	local touches = love.touch.getTouches()
	for _, id in pairs(touches) do
		local mx, my = game.coords(love.touch.getPosition(id))

		local cross_center_x = self.cross.x + (self.cross.sprite:getWidth() * self.cross.scale) / 2
		local cross_center_y = self.cross.y + (self.cross.sprite:getHeight() * self.cross.scale) / 2

		local dx = (mx - cross_center_x) / (self.cross.scale * 8)
		local dy = (my - cross_center_y) / (self.cross.scale * 8)

		if math.mag(dx, dy) > 0.8 then
			dx, dy = math.norm(dx, dy, 0.8)
		end

		if mx > self.cross.x and mx < self.cross.x + self.cross.sprite:getWidth() * self.cross.scale and my > self.cross.y and my < self.cross.y + self.cross.sprite:getHeight() * self.cross.scale then
			touching_cross = true
			self.cross.hovering = math.clamp(self.cross.hovering, max, self.cross.hovering + dt * lerp)
			input.move = { dx = dx, dy = dy }
			shader:send("mouse_screen_pos", { mx, my })
		else
			touching_screen = true
			local deltaX = mx - player.body:getX()
			local deltaY = my - player.body:getY()
			input.look = math.atan2(deltaY, deltaX)
			input.shoot = true
		end
	end

	if not touching_cross then
		self.cross.hovering = math.clamp(self.cross.hovering, 0, self.cross.hovering - dt * lerp)
		input.move = { dx = 0, dy = 0 }
	end
	if not touching_screen then
		input.shoot = false
	end

	shader:send("screen_scale", love.graphics.getWidth() / love.graphics.getHeight())
	shader:send("hovering", self.cross.hovering)
end

return buttons
