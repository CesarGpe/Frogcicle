local anim8 = require("libs.anim8")
local ice = love.graphics.newImage("assets/sprites/frozen.png")
local sprite = love.graphics.newImage("assets/sprites/suwako-sheet.png")
local shadow = love.graphics.newImage("assets/sprites/suwako-shadow.png")
local particle_spr = love.graphics.newImage("assets/sprites/particle.png")

local enemy = {}
enemy.__index = enemy

local function setanims(spr)
	local grid = anim8.newGrid(24, 32, spr:getWidth(), spr:getHeight())
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

function enemy.new(x, y)
	local self = setmetatable({}, enemy)

	--------------------------------------------------------------------
	self.x = x
	self.y = y
	self.offsetx = 12
	self.offsety = 20
	self.radius = 8
	self.scale = 1
	self.friction = 6
	self.life_span = 8
	self.jump_time = 1.5
	self.jump_delay = 1
	self.jump_length = 0.38
	self.jump_randomness = 0.5
	self.jump_strength = 60
	self.animations = {}
	self.anim = {}
	self.shanimations = {}
	self.shanim = {}
	self.body = nil
	self.shape = nil
	self.fixture = nil
	self.timings = {}
	self.ice_time = 5
	self.ice_alpha = 0.5
	self.frozen = false
	self.freeze_timer = {}
	self.dying = false
	self.die_timer = {}
	self.die_anim_timer = {}
	self.blinking = false
	self.blink_timer = {}
	self.tint = { r = 1, g = 1, b = 1, a = 0 }
	self.shader = love.graphics.newShader("shader/tint.fs")
	self.particles = love.graphics.newParticleSystem(particle_spr, 1000)
	self.prt_color = { 1, 1, 1, 1 }
	self.hit_angle = 0
	--------------------------------------------------------------------

	self.animations, self.anim = setanims(sprite)
	self.shanimations, self.shanim = setanims(shadow)

	self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	self.body:setLinearDamping(self.friction)
	self.body:setFixedRotation(true)
	self.shape = love.physics.newCircleShape(self.radius)
	self.fixture = love.physics.newFixture(self.body, self.shape)
	self.fixture:setRestitution(0.15)
	self.fixture:setCategory(collision_masks.enemy)

	self.jump_time = self.jump_time + (love.math.random() * 2 - 1)
	self.life_span = self.life_span + (love.math.random() * 2 - 1)
	table.insert(self.timings, ticker.new(self.jump_time, function() self:jump() end))
	table.insert(self.timings, ticker.new(self.life_span, function() self:destroy() end))

	self.particles:setLinearAcceleration(-20, -20, 20, 20)
	self.particles:setParticleLifetime(0.5, 1)
	self.particles:setSizeVariation(1)
	self.particles:setSpread(0.8)
	self.particles:setSpeed(40)
	self.particles:setSpin(10, 40)

	self.fixture:setUserData(self)
	return self
end

function enemy:draw_shadow()
	love.graphics.setShader(self.shader)
	if not self.blinking or (self.blink_timer and math.floor(self.blink_timer.getTime() * 10) % 2 == 0) then
		self.shanim = self.anim
		self.shanim:draw(shadow, self.x, self.y, 0, self.scale, self.scale)
	end
	love.graphics.setShader()
end

function enemy:draw()
	love.graphics.setShader(self.shader)
	if self.hit_angle <= 0 then
		love.graphics.draw(self.particles)
	end
	if self.frozen then
		love.graphics.setColor(0.7, 0.7, 1, 1)
		self.anim:draw(sprite, self.x, self.y, 0, self.scale, self.scale)
		love.graphics.setColor(1, 1, 1, self.ice_alpha)
		love.graphics.draw(ice, self.x - 4, self.y - 4, 0, self.scale - 0.2, self.scale - 0.2)
		love.graphics.setColor(1, 1, 1, 1)
	elseif not self.blinking or (self.blink_timer and math.floor(self.blink_timer.getTime() * 10) % 2 == 0) then
		love.graphics.setColor(1, 1, 1, 1)
		self.anim:draw(sprite, self.x, self.y, 0, self.scale, self.scale)
	end
	if self.hit_angle > 0 then
		love.graphics.draw(self.particles)
	end
	love.graphics.setShader()
end

function enemy:update(dt)
	self.shader:send("new", { self.tint.r, self.tint.g, self.tint.b, self.tint.a })

	if self.frozen then
		if not self.freeze_timer.isExpired() then self.freeze_timer.update(dt) end
		self.ice_alpha = math.min(0.65, (self.freeze_timer.getTime() / self.ice_time) + 0.2)
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
	self.particles:setColors(self.prt_color, { self.prt_color[1], self.prt_color[2], self.prt_color[3], 0 })
	self.particles:setPosition(self.body:getX(), self.body:getY())

	self.anim:update(dt)
end

function enemy:jump()
	table.insert(self.timings,
		ticker.new(self.jump_time + self.jump_delay + (love.math.random() - self.jump_randomness),
			function() self:jump() end))

	local mx = love.math.random(0, 1) * 2 - 1 * (1 + love.math.random())
	local my = love.math.random(0, 1) * 2 - 1 * (1 + love.math.random())
	mx, my = math.norm(mx, my)

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
end

function enemy:freeze(angle)
	self.hit_angle = angle
	self.prt_color = { 0.7, 0.8, 1, 0.8 }
	--self.particles:setLinearAcceleration(dx * m, dy * m, dx * m, dy * m)
	self.particles:setEmissionArea("uniform", 5, 5, angle, false)
	self.particles:setDirection(angle)
	self.particles:setSpread(0.8)
	self.particles:emit(30)

	self.frozen = true
	self.tint.a = 1
	flux.to(self.tint, 0.35, { a = 0 })
	game.cam.trauma = game.cam.trauma + 0.16
	sounds.freeze()

	self.freeze_timer = ticker.new(self.ice_time, function()
		self.frozen = false
		self.prt_color = { 1, 1, 1, 0.5 }
		self.particles:setSpread(10)
		self.particles:emit(10)
		self.hit_angle = 0
		sounds.defreeze()
		sounds.df_chime()
	end)
end

function enemy:destroy()
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
end

function enemy:delete()
	self.fixture:destroy()
	self.shape = nil
	self.body:destroy()
end

return enemy
