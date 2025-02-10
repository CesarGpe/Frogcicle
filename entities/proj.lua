local sprite = love.graphics.newImage("assets/sprites/ice-shot.png")

local proj = {}
proj.__index = proj

function proj.new(x, y, dx, dy, angle)
    local self = setmetatable({}, proj)

    self.x = x
    self.y = y
    self.dx = dx
    self.dy = dy
    self.angle = angle
    self.radius = 5
    self.scale = 0.75
    self.body = nil
    self.shape = nil
    self.fixture = nil

	self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.body:setFixedRotation(true)
    self.body:setBullet(true)
    self.shape = love.physics.newCircleShape(self.radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setCategory(collision_masks.proj)
    self.fixture:setMask(collision_masks.player, collision_masks.proj)

    self.body:applyLinearImpulse(self.dx, self.dy)
    self.fixture:setUserData(self)
    sounds.shoot()

    return self
end

function proj:draw()
    love.graphics.draw(sprite, self.x, self.y, self.angle, self.scale, self.scale, sprite:getWidth() / 2, sprite:getHeight() / 2)
end

function proj:update(dt)
    self.x = self.body:getX()
    self.y = self.body:getY()
end

function proj:destroy()
    if self.fixture then
        self.fixture:destroy()
        self.shape = nil
        self.body:destroy()
    end
end

-- Return the Projectile class for use elsewhere
return proj