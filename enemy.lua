local anim8 = require("libs.anim8")
local ice = love.graphics.newImage("sprites/frozen.png")
local sprite = love.graphics.newImage("sprites/suwako-sheet.png")
local shadow = love.graphics.newImage("sprites/suwako-shadow.png")
local ice_particle = love.graphics.newImage("sprites/ice-particle.png")

function newEnemy(x, y)
	return {
		x = x,
		y = y,
		offsetx = 12,
		offsety = 20,
		radius = 8,
		scale = 1,
		friction = 6,
		life_span = 8,
		jump_time = 1.5,
		jump_delay = 1,
		jump_length = 0.38,
		jump_randomness = 0.5,
		jump_strength = 60,
		animations = {},
		anim = {},
		shanimations = {},
		shanim = {},
		body = {},
		shape = {},
		fixture = {},
		timings = {},
		ice_time = 5,
		frozen = false,
		freeze_timer = {},
		dying = false,
		die_timer = {},
		die_anim_timer = {},
		blinking = false,
		blink_timer = {},
		tint = { r = 1, g = 1, b = 1, a = 0 },
		shader = love.graphics.newShader("shader/tint.fs"),
		particles = love.graphics.newParticleSystem(ice_particle, 1000),

		load = function(self)
			self.animations, self.anim = suwakoAnims(sprite)
			self.shanimations, self.shanim = suwakoAnims(shadow)

			self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
			self.body:setLinearDamping(self.friction)
			self.body:setFixedRotation(true)
			self.shape = love.physics.newCircleShape(self.radius)
			self.fixture = love.physics.newFixture(self.body, self.shape)
			self.fixture:setRestitution(0.15)
			self.fixture:setCategory(collision_masks.enemy)
			self.fixture:setUserData(self)

			self.jump_time = self.jump_time + (love.math.random() * 2 - 1)
			table.insert(self.timings, ticker.new(self.jump_time, function() self:jump() end))
			table.insert(self.timings, ticker.new(self.life_span, function() self:destroy() end))

			self.particles:setLinearAcceleration(-20, -20, 20, 20)
			self.particles:setColors(1, 1, 1, 1, 1, 1, 1, 0)
			self.particles:setParticleLifetime(0.5, 1)
			self.particles:setSizeVariation(1)
			self.particles:setSpread(10)
			self.particles:setSpeed(40)
			self.particles:setSpin(10, 40)
		end,

		draw_shadow = function(self)
			love.graphics.setShader(self.shader)
			if not self.blinking or (self.blink_timer and math.floor(self.blink_timer.getTime() * 10) % 2 == 0) then
				self.shanim = self.anim
				self.shanim:draw(shadow, self.x, self.y, 0, self.scale, self.scale)
			end
			love.graphics.setShader()
		end,

		draw = function(self)
			love.graphics.setShader(self.shader)
			love.graphics.draw(self.particles)
			if self.frozen then
				love.graphics.setColor(0.7, 0.7, 1, 1)
				self.anim:draw(sprite, self.x, self.y, 0, self.scale, self.scale)
				love.graphics.setColor(1, 1, 1, 0.5)
				love.graphics.draw(ice, self.x - 4, self.y - 4, 0, self.scale - 0.2, self.scale - 0.2)
				love.graphics.setColor(1, 1, 1, 1)
			elseif not self.blinking or (self.blink_timer and math.floor(self.blink_timer.getTime() * 10) % 2 == 0) then
				love.graphics.setColor(1, 1, 1, 1)
				self.anim:draw(sprite, self.x, self.y, 0, self.scale, self.scale)
			end
			love.graphics.setShader()
		end,

		update = function(self, dt)
			self.shader:send("new", { self.tint.r, self.tint.g, self.tint.b, self.tint.a })

			if self.frozen then
				if not self.freeze_timer.isExpired() then self.freeze_timer.update(dt) end
			elseif self.dying then
				if not self.die_timer.isExpired() then self.die_timer.update(dt) end
				if not self.die_anim_timer.isExpired() then self.die_anim_timer.update(dt) end
				if self.blinking and not self.blink_timer.isExpired() then
					self.blink_timer.update(dt)
				end
			else
				for _, t in pairs(self.timings) do
					if not t.isExpired() then t.update(dt) end
				end
			end

			if self.body:isDestroyed() then
				return
			end

			self.x = self.body:getX() - self.offsetx
			self.y = self.body:getY() - self.offsety

			self.particles:update(dt)
			self.particles:setPosition(self.body:getX(), self.body:getY())

			self.anim:update(dt)
		end,

		jump = function(self)
			table.insert(self.timings,
				ticker.new(self.jump_time + self.jump_delay + (love.math.random() - self.jump_randomness),
					function() self:jump() end))

			local mx = love.math.random(0, 1) * 2 - 1 * (1 + love.math.random())
			local my = love.math.random(0, 1) * 2 - 1 * (1 + love.math.random())

			local magnitude = math.sqrt(mx * mx + my * my)
			if magnitude > 0 then
				mx = mx / magnitude
				my = my / magnitude
			end

			local margin = 0.35
			if mx > -margin and mx < margin and my < 0 then
				self.anim = self.animations.up
			elseif mx > -margin and mx < margin and my > 0 then
				self.anim = self.animations.down
			elseif mx > 0 and my > -margin and my < margin then
				self.anim = self.animations.right
			elseif mx < 0 and my > -margin and my < margin then
				self.anim = self.animations.left
			elseif mx > 0 and my < 0 then
				self.anim = self.animations.up_right
			elseif mx < 0 and my < 0 then
				self.anim = self.animations.up_left
			elseif mx > 0 and my > 0 then
				self.anim = self.animations.down_right
			elseif mx < 0 and my > 0 then
				self.anim = self.animations.down_left
			end

			table.insert(self.timings, ticker.new(self.jump_delay, function()
				self.body:applyLinearImpulse(self.jump_strength * mx, self.jump_strength * my)
				sounds.leap()

				if mx > -margin and mx < margin and my < 0 then
					self.anim = self.animations.up_jump
				elseif mx > -margin and mx < margin and my > 0 then
					self.anim = self.animations.down_jump
				elseif mx > 0 and my > -margin and my < margin then
					self.anim = self.animations.right_jump
				elseif mx < 0 and my > -margin and my < margin then
					self.anim = self.animations.left_jump
				elseif mx > 0 and my < 0 then
					self.anim = self.animations.up_right_jump
				elseif mx < 0 and my < 0 then
					self.anim = self.animations.up_left_jump
				elseif mx > 0 and my > 0 then
					self.anim = self.animations.down_right_jump
				elseif mx < 0 and my > 0 then
					self.anim = self.animations.down_left_jump
				end
			end))

			table.insert(self.timings, ticker.new(self.jump_delay + self.jump_length, function()
				if self.anim == self.animations.up_jump then
					self.anim = self.animations.up
				elseif self.anim == self.animations.down_jump then
					self.anim = self.animations.down
				elseif self.anim == self.animations.right_jump then
					self.anim = self.animations.right
				elseif self.anim == self.animations.left_jump then
					self.anim = self.animations.left
				elseif self.anim == self.animations.up_right_jump then
					self.anim = self.animations.up_right
				elseif self.anim == self.animations.up_left_jump then
					self.anim = self.animations.up_left
				elseif self.anim == self.animations.down_right_jump then
					self.anim = self.animations.down_right
				elseif self.anim == self.animations.down_left_jump then
					self.anim = self.animations.down_left
				end
			end))
		end,

		freeze = function(self)
			sounds.freeze()
			self.particles:emit(30)
			self.frozen = true
			self.tint.a = 1
			flux.to(self.tint, 0.35, { a = 0 })
			game.cam.trauma = game.cam.trauma + 0.16

			self.freeze_timer = ticker.new(self.ice_time, function()
				self.frozen = false
				sounds.defreeze()
				sounds.df_chime()
			end)
		end,

		destroy = function(self)
			self.dying = true
			self.anim = self.animations.shocked
			self.die_anim_timer = ticker.new(0.6, function()
				self.anim = self.animations.dead
				self.blinking = true
				self.blink_timer = ticker.new(1.4)
			end)
			self.die_timer = ticker.new(2, function()
				self.fixture:destroy()
				self.shape = nil
				self.body:destroy()
			end)
		end,

		delete = function(self)
			self.fixture:destroy()
			self.shape = nil
			self.body:destroy()
		end
	}
end

function suwakoAnims(sprite)
	local grid = anim8.newGrid(24, 32, sprite:getWidth(), sprite:getHeight())
	local animations = {}

	animations.up = anim8.newAnimation(grid("1-1", 1), 0.2)
	animations.up_jump = anim8.newAnimation(grid("2-2", 1), 0.2)
	animations.up_right = anim8.newAnimation(grid("1-1", 2), 0.2)
	animations.up_right_jump = anim8.newAnimation(grid("2-2", 2), 0.2)
	animations.right = anim8.newAnimation(grid("1-1", 3), 0.2)
	animations.right_jump = anim8.newAnimation(grid("2-2", 3), 0.2)
	animations.down_right = anim8.newAnimation(grid("1-1", 4), 0.2)
	animations.down_right_jump = anim8.newAnimation(grid("2-2", 4), 0.2)
	animations.down = anim8.newAnimation(grid("1-1", 5), 0.2)
	animations.down_jump = anim8.newAnimation(grid("2-2", 5), 0.2)
	animations.down_left = anim8.newAnimation(grid("1-1", 6), 0.2)
	animations.down_left_jump = anim8.newAnimation(grid("2-2", 6), 0.2)
	animations.left = anim8.newAnimation(grid("1-1", 7), 0.2)
	animations.left_jump = anim8.newAnimation(grid("2-2", 7), 0.2)
	animations.up_left = anim8.newAnimation(grid("1-1", 8), 0.2)
	animations.up_left_jump = anim8.newAnimation(grid("2-2", 8), 0.2)
	animations.shocked = anim8.newAnimation(grid("1-1", 9), 1)
	animations.dead = anim8.newAnimation(grid("2-2", 9), 1)
	local anim = animations.down

	return animations, anim
end

return newEnemy
