local anim8 = require("libs.anim8")

function new_player(x, y, width, height, scale)
    return {
        x = x,
        y = y,
        width = width,
        height = height,
        scale = scale,
        yvel = 0,
        xvel = 0,
        friction = 5,
        speed = 1000,
        sprite = love.graphics.newImage("sprites/cirno-sheet.png"),
        animations = {},
        anim = {},

        load = function(self)
            local grid = anim8.newGrid(24, 32, self.sprite:getWidth(), self.sprite:getHeight())

            self.animations = {}
            self.animations.up = anim8.newAnimation(grid("1-4", 1), 0.2)
            self.animations.up_attack = anim8.newAnimation(grid("5-5", 1), 0.2)
            self.animations.up_right = anim8.newAnimation(grid("1-4", 2), 0.2)
            self.animations.up_right_attack = anim8.newAnimation(grid("5-5", 2), 0.2)
            self.animations.right = anim8.newAnimation(grid("1-4", 3), 0.2)
            self.animations.right_attack = anim8.newAnimation(grid("5-5", 3), 0.2)
            self.animations.down_right = anim8.newAnimation(grid("1-4", 4), 0.2)
            self.animations.down_right_attack = anim8.newAnimation(grid("5-5", 4), 0.2)
            self.animations.down = anim8.newAnimation(grid("1-4", 5), 0.2)
            self.animations.down_attack = anim8.newAnimation(grid("5-5", 5), 0.2)
            self.animations.down_left = anim8.newAnimation(grid("1-4", 6), 0.2)
            self.animations.down_left_attack = anim8.newAnimation(grid("5-5", 6), 0.2)
            self.animations.left = anim8.newAnimation(grid("1-4", 7), 0.2)
            self.animations.left_attack = anim8.newAnimation(grid("5-5", 7), 0.2)
            self.animations.up_left = anim8.newAnimation(grid("1-4", 8), 0.2)
            self.animations.up_left_attack = anim8.newAnimation(grid("5-5", 8), 0.2)
            self.anim = self.animations.down
        end,

        draw = function(self)
            self.anim:draw(self.sprite, self.x, self.y, 0, self.scale, self.scale)
        end,

        physics = function(self, dt)
            self.x = self.x + self.xvel * dt
            self.y = self.y + self.yvel * dt
            self.xvel = self.xvel * (1 - math.min(dt * self.friction, 1))
            self.yvel = self.yvel * (1 - math.min(dt * self.friction, 1))
        end,

        move = function(self, dt)
            local dx, dy = 0, 0

            if love.keyboard.isDown("d", "right") then dx = dx + 1 end
            if love.keyboard.isDown("a", "left") then dx = dx - 1 end
            if love.keyboard.isDown("s", "down") then dy = dy + 1 end
            if love.keyboard.isDown("w", "up") then dy = dy - 1 end

            local mouseX, mouseY = love.mouse.getPosition()
            local deltaX = mouseX - x
            local deltaY = mouseY - y
            local angle = math.atan2(deltaY, deltaX)
            local angleDeg = math.deg(angle)

            if angleDeg < 0 then
                angleDeg = angleDeg + 360
            end

            if angleDeg < 22.5 or angleDeg >= 337.5 then
                if love.mouse.isDown(1) then
                    self.anim = self.animations.right_attack
                else
                    self.anim = self.animations.right
                end
            elseif angleDeg < 67.5 then
                if love.mouse.isDown(1) then
                    self.anim = self.animations.down_right_attack
                else
                    self.anim = self.animations.down_right
                end
            elseif angleDeg < 112.5 then
                if love.mouse.isDown(1) then
                    self.anim = self.animations.down_attack
                else
                    anim = self.animations.down
                end
            elseif angleDeg < 157.5 then
                if love.mouse.isDown(1) then
                    self.anim = self.animations.down_left_attack
                else
                    anim = self.animations.down_left
                end
            elseif angleDeg < 202.5 then
                if love.mouse.isDown(1) then
                    self.anim = self.animations.left_attack
                else
                    anim = self.animations.left
                end
            elseif angleDeg < 247.5 then
                if love.mouse.isDown(1) then
                    self.anim = self.animations.up_left_attack
                else
                    self.anim = self.animations.up_left
                end
            elseif angleDeg < 292.5 then
                if love.mouse.isDown(1) then
                    self.anim = self.animations.up_attack
                else
                    self.anim = self.animations.up
                end
            elseif angleDeg < 337.5 then
                if love.mouse.isDown(1) then
                    self.anim = self.animations.up_right_attack
                else
                    self.anim = self.animations.up_right
                end
            end

            local magnitude = math.sqrt(dx * dx + dy * dy)
            if magnitude > 0 then
                dx = dx / magnitude
                dy = dy / magnitude
            end

            self.xvel = self.xvel + dx * self.speed * dt
            self.yvel = self.yvel + dy * self.speed * dt

            self.anim:update(dt)
        end,

        update = function(self, dt)
            self.physics(self, dt)
            self.move(self, dt)
        end
    }
end

--[[
function load()
    x = love.graphics.getWidth() / 2
    y = love.graphics.getHeight() / 2
    width = 10
    height = 10
    scale = 2
    xvel = 0
    yvel = 0
    friction = 5
    speed = 1000
    sprite = love.graphics.newImage("sprites/cirno-sheet.png")
    grid = anim8.newGrid(24, 32, sprite:getWidth(), sprite:getHeight())

    animations = {}
    animations.up = anim8.newAnimation(grid("1-4", 1), 0.2)
    animations.up_attack = anim8.newAnimation(grid("5-5", 1), 0.2)
    animations.up_right = anim8.newAnimation(grid("1-4", 2), 0.2)
    animations.up_right_attack = anim8.newAnimation(grid("5-5", 2), 0.2)
    animations.right = anim8.newAnimation(grid("1-4", 3), 0.2)
    animations.right_attack = anim8.newAnimation(grid("5-5", 3), 0.2)
    animations.down_right = anim8.newAnimation(grid("1-4", 4), 0.2)
    animations.down_right_attack = anim8.newAnimation(grid("5-5", 4), 0.2)
    animations.down = anim8.newAnimation(grid("1-4", 5), 0.2)
    animations.down_attack = anim8.newAnimation(grid("5-5", 5), 0.2)
    animations.down_left = anim8.newAnimation(grid("1-4", 6), 0.2)
    animations.down_left_attack = anim8.newAnimation(grid("5-5", 6), 0.2)
    animations.left = anim8.newAnimation(grid("1-4", 7), 0.2)
    animations.left_attack = anim8.newAnimation(grid("5-5", 7), 0.2)
    animations.up_left = anim8.newAnimation(grid("1-4", 8), 0.2)
    animations.up_left_attack = anim8.newAnimation(grid("5-5", 8), 0.2)

    anim = animations.down
end

function physics(dt)
    x = x + xvel * dt
    y = y + yvel * dt
    xvel = xvel * (1 - math.min(dt * friction, 1))
    yvel = yvel * (1 - math.min(dt * friction, 1))
end

function move(dt)
    local dx, dy = 0, 0

    if love.keyboard.isDown("d", "right") then dx = dx + 1 end
    if love.keyboard.isDown("a", "left") then dx = dx - 1 end
    if love.keyboard.isDown("s", "down") then dy = dy + 1 end
    if love.keyboard.isDown("w", "up") then dy = dy - 1 end

    local mouseX, mouseY = love.mouse.getPosition()
    local deltaX = mouseX - x
    local deltaY = mouseY - y
    local angle = math.atan2(deltaY, deltaX)
    local angleDeg = math.deg(angle)

    if angleDeg < 0 then
        angleDeg = angleDeg + 360
    end

    if angleDeg < 22.5 or angleDeg >= 337.5 then
        if love.mouse.isDown(1) then
            anim = animations.right_attack
        else
            anim = animations.right
        end
    elseif angleDeg < 67.5 then
        if love.mouse.isDown(1) then
            anim = animations.down_right_attack
        else
            anim = animations.down_right
        end
    elseif angleDeg < 112.5 then
        if love.mouse.isDown(1) then
            anim = animations.down_attack
        else
            anim = animations.down
        end
    elseif angleDeg < 157.5 then
        if love.mouse.isDown(1) then
            anim = animations.down_left_attack
        else
            anim = animations.down_left
        end
    elseif angleDeg < 202.5 then
        if love.mouse.isDown(1) then
            anim = animations.left_attack
        else
            anim = animations.left
        end
    elseif angleDeg < 247.5 then
        if love.mouse.isDown(1) then
            anim = animations.up_left_attack
        else
            anim = animations.up_left
        end
    elseif angleDeg < 292.5 then
        if love.mouse.isDown(1) then
            anim = animations.up_attack
        else
            anim = animations.up
        end
    elseif angleDeg < 337.5 then
        if love.mouse.isDown(1) then
            anim = animations.up_right_attack
        else
            anim = animations.up_right
        end
    end

    local magnitude = math.sqrt(dx * dx + dy * dy)
    if magnitude > 0 then
        dx = dx / magnitude
        dy = dy / magnitude
    end

    xvel = xvel + dx * speed * dt
    yvel = yvel + dy * speed * dt

    anim:update(dt)
end

function draw()
    anim:draw(sprite, x, y, 0, scale, scale)
end

function update(dt)
    physics(dt)
    move(dt)
end
]]