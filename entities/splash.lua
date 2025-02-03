local sprite = love.graphics.newImage("assets/sprites/ice-break.png")
local ice_particle = love.graphics.newImage("assets/sprites/ice-particle.png")

local splash = {}
splash.__index = splash

function splash.new(x, y)
	local instance = setmetatable({}, splash)
	instance.x = x
	instance.y = y
	instance.alpha = 1
	instance.elapsed = 0
	flux.to(instance, 0.25, { alpha = 0 })

	instance.prt = love.graphics.newParticleSystem(ice_particle, 1000)
	instance.prt:setLinearAcceleration(-20, -20, 20, 20)
	instance.prt:setColors(1, 1, 1, 1, 1, 1, 1, 0)
	instance.prt:setParticleLifetime(0.4, 0.8)
	instance.prt:setSizeVariation(1)
	instance.prt:setSpread(10)
	instance.prt:setSpeed(20)
	instance.prt:setSpin(10, 40)
	instance.prt:emit(20)

	return instance
end

function splash:update(dt)
	self.prt:update(dt)
	self.elapsed = self.elapsed + dt
end

function splash:draw()
	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.draw(sprite, self.x, self.y, 0, 1.25, 1.25, sprite:getWidth() / 2,
		sprite:getHeight() / 2)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(self.prt, self.x, self.y)
end

function splash:destroy()
	self = nil
end

return splash
