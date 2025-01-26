local anim8 = require("libs.anim8")
enemies = {}

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
		jump_time = 1.5, -- time between each jump without delay
		jump_delay = 1,  -- the delay between the turn and the jump
		jump_length = 0.38, -- time in the air when it jumps
		jump_randomness = 0.5, -- variance of time between jumps
		jump_strength = 5000,
		ice = love.graphics.newImage("sprites/frozen.png"),
		sprite = love.graphics.newImage("sprites/suwako-sheet.png"),
		shadow = love.graphics.newImage("sprites/suwako-shadow.png"),
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

		load = function(self)
			self.animations, self.anim = suwakoAnims(self.sprite)
			self.shanimations, self.shanim = suwakoAnims(self.shadow)

			self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
			self.body:setFixedRotation(true)
			self.shape = love.physics.newCircleShape(self.radius)
			self.fixture = love.physics.newFixture(self.body, self.shape)
			self.fixture:setRestitution(0.15)
			self.fixture:setCategory(collision_masks.enemy)

			self.jump_time = self.jump_time + (love.math.random() * 2 - 1)
			table.insert(self.timings, timers.new(self.jump_time, function() self:jump() end))
			table.insert(self.timings, timers.new(self.life_span * difficulty, function() self:destroy() end))

			table.insert(enemies, self)
			self.fixture:setUserData(self)
		end,

		draw_shadow = function(self)
			self.shanim = self.anim
			self.shanim:draw(self.shadow, self.x, self.y, 0, self.scale, self.scale)
		end,

		draw = function(self)
			self.anim:draw(self.sprite, self.x, self.y, 0, self.scale, self.scale)
			if self.frozen then
				love.graphics.setColor(1, 1, 1, 0.5)
				love.graphics.draw(self.ice, self.x - 4, self.y - 4, 0, self.scale - 0.2, self.scale - 0.2)
				love.graphics.setColor(1, 1, 1, 1)
			end
		end,

		update = function(self, dt)
			if self.frozen then
				if not self.freeze_timer.isExpired() then
					self.freeze_timer.update(dt)
				end
			elseif self.dying then
				if not self.die_timer.isExpired() then self.die_timer.update(dt) end
				--if not self.die_anim_timer.isExpired() then self.die_anim_timer.update(dt) end
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

			local velx, vely = self.body:getLinearVelocity()
			self.body:setLinearVelocity(velx * (1 - math.min(dt * self.friction, 1)),
				vely * (1 - math.min(dt * self.friction, 1)))

			self.anim:update(dt)
		end,

		jump = function(self)
			-- jump again!!
			table.insert(self.timings,
				timers.new(self.jump_time + self.jump_delay + (love.math.random() - self.jump_randomness),
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

			table.insert(self.timings, timers.new(self.jump_delay, function()
				self.body:applyForce(self.jump_strength * mx, self.jump_strength * my)
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

			table.insert(self.timings, timers.new(self.jump_delay + self.jump_length, function()
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
			if not self.frozen then
				sounds.freeze()
			end
			self.frozen = true
			self.freeze_timer = timers.new(self.ice_time - (difficulty - 1), function()
				self.frozen = false
				sounds.defreeze()
				sounds.df_chime()
			end)
		end,

		destroy = function(self)
			self.dying = true
			self.anim = self.animations.shocked
			self.die_timer = timers.new(1.9, function()
				self.fixture:destroy()
				self.shape = nil
				self.body:destroy()
			end)
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
	--animations.shocked = anim8.newAnimation(grid("1-1", 9), 0.2)
	animations.shocked = anim8.newAnimation(grid("1-2", 9), 1, false)
	anim = animations.down

	return animations, anim
end

return newEnemy
