function newProj(x, y, dx, dy, angle)
	return {
		x = x,
		y = y,
		dx = dx,
		dy = dy,
		angle = angle,
		radius = 5,
		scale = 0.75,
		sprite = love.graphics.newImage("assets/sprites/ice-shot-big.png"),
		body = {},
		shape = {},
		fixture = {},

		load = function(self)
			self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
			self.body:setFixedRotation(true)
			self.body:setBullet(true)
			self.shape = love.physics.newCircleShape(self.radius)
			self.fixture = love.physics.newFixture(self.body, self.shape)
			self.fixture:setCategory(collision_masks.proj)
			self.fixture:setMask(collision_masks.player, collision_masks.proj)

			self.fixture:setUserData(self)
			self.body:applyLinearImpulse(dx, dy)
			sounds.shoot()
		end,

		draw = function(self)
			love.graphics.draw(self.sprite, self.x, self.y, self.angle, self.scale, self.scale, self.sprite:getWidth() /
			2, self.sprite:getHeight() / 2)
		end,

		update = function(self, dt)
			self.x = self.body:getX()
			self.y = self.body:getY()
		end,

		destroy = function(self)
			self.fixture:destroy()
			self.shape = nil
			self.body:destroy()
		end
	}
end

return newProj
