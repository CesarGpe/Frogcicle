require("entities.proj")

local anim8 = require("libs.anim8")
player = {}

function player.load()
    player.x = WIDTH / 2
    player.y = HEIGHT / 2
    player.angle = 0
    player.offsetx = 12
    player.offsety = 20
    player.radius = 8
    player.scale = 1
    player.friction = 2.5
    player.speed = 150
    player.shooting = false
    player.can_shoot = true
    player.anim_time = 0.1
    player.shoot_time = 0.5
    player.proj_speed = 15
    player.timings = {}
    player.sprite = love.graphics.newImage("assets/sprites/cirno-sheet.png")
    player.shadow = love.graphics.newImage("assets/sprites/cirno-shadow.png")
    player.animations, player.anim = cirnoAnims(player.sprite)
    player.shanimations, player.shanim = cirnoAnims(player.shadow)

    player.body = love.physics.newBody(world, player.x, player.y, "dynamic")
    player.body:setLinearDamping(player.friction)
    player.body:setFixedRotation(true)
    player.shape = love.physics.newCircleShape(player.radius)
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setRestitution(0.15)
    player.fixture:setCategory(collision_masks.player)
    player.fixture:setMask(collision_masks.proj)

    player.prt_shoot = love.graphics.newParticleSystem(love.graphics.newImage("assets/sprites/ice-particle.png"), 1000)
    player.prt_shoot:setParticleLifetime(0.3, 0.6)
    player.prt_shoot:setSizeVariation(1)
    player.prt_shoot:setSpread(0.5)
    player.prt_shoot:setSpeed(50)
    player.prt_shoot:setSpin(10, 40)
    player.prt_shoot:setColors(1, 1, 1, 1, 1, 1, 1, 0)

    player.prt_trail = love.graphics.newParticleSystem(love.graphics.newImage("assets/sprites/ice-particle.png"), 1000)
    player.prt_trail:setEmissionArea("uniform", 5, 5, 0, true)
    player.prt_trail:setLinearAcceleration(-20, -20, 20, 20)
    player.prt_trail:setColors(1, 1, 1, 1, 1, 1, 1, 0)
    player.prt_trail:setParticleLifetime(0.4, 0.8)
    player.prt_trail:setSizeVariation(1)
    player.prt_trail:setSpread(5)
    player.prt_trail:setSpeed(1)
    player.prt_trail:setSpin(10, 40)
    player.prt_trail:setEmissionRate(50)
end

function player.draw_shadow()
    player.shanim = player.anim
    player.shanim:draw(player.shadow, player.x, player.y, 0, player.scale, player.scale)
end

function player.draw()
    love.graphics.draw(player.prt_trail)
    love.graphics.draw(player.prt_shoot)
    player.anim:draw(player.sprite, player.x, player.y, 0, player.scale, player.scale)
end

function player.controls()
    local dx, dy = 0, 0
    if game.active and not game.transitioning then
        if love.keyboard.isDown("d", "right") then dx = dx + 1 end
        if love.keyboard.isDown("a", "left") then dx = dx - 1 end
        if love.keyboard.isDown("s", "down") then dy = dy + 1 end
        if love.keyboard.isDown("w", "up") then dy = dy - 1 end
    end

    local magnitude = math.sqrt(dx * dx + dy * dy)
    if magnitude > 0 then
        dx = dx / magnitude
        dy = dy / magnitude
    end

    player.body:applyForce(player.speed * dx, player.speed * dy)
end

local mousex, mousey = 0, 0
function player.face_cursor()
    local tempx, tempy = game.camera:toWorld(push:toGame(love.mouse.getPosition()))
    if tempx and tempy then
        mousex, mousey = tempx, tempy
    end

    local deltaX = mousex - player.body:getX()
    local deltaY = mousey - player.body:getY()
    player.angle = math.atan2(deltaY, deltaX)

    local angleDeg = math.deg(player.angle)
    if angleDeg < 0 then
        angleDeg = angleDeg + 360
    end

    if game.over then
        player.anim = player.animations.dead
    elseif not game.transitioning then
        if angleDeg < 22.5 or angleDeg >= 337.5 then
            if player.shooting then
                player.anim = player.animations.right_attack
            else
                player.anim = player.animations.right
            end
        elseif angleDeg < 67.5 then
            if player.shooting then
                player.anim = player.animations.down_right_attack
            else
                player.anim = player.animations.down_right
            end
        elseif angleDeg < 112.5 then
            if player.shooting then
                player.anim = player.animations.down_attack
            else
                player.anim = player.animations.down
            end
        elseif angleDeg < 157.5 then
            if player.shooting then
                player.anim = player.animations.down_left_attack
            else
                player.anim = player.animations.down_left
            end
        elseif angleDeg < 202.5 then
            if player.shooting then
                player.anim = player.animations.left_attack
            else
                player.anim = player.animations.left
            end
        elseif angleDeg < 247.5 then
            if player.shooting then
                player.anim = player.animations.up_left_attack
            else
                player.anim = player.animations.up_left
            end
        elseif angleDeg < 292.5 then
            if player.shooting then
                player.anim = player.animations.up_attack
            else
                player.anim = player.animations.up
            end
        elseif angleDeg < 337.5 then
            if player.shooting then
                player.anim = player.animations.up_right_attack
            else
                player.anim = player.animations.up_right
            end
        end
    else
        player.anim = player.animations.yeah
    end
end

function player.shoot()
    player.shooting = true
    player.can_shoot = false
    table.insert(player.timings, ticker.new(player.anim_time, function() player.shooting = false end))
    table.insert(player.timings, ticker.new(player.shoot_time, function() player.can_shoot = true end))

    local dx = player.proj_speed * math.cos(player.angle)
    local dy = player.proj_speed * math.sin(player.angle)
    proj_manager:new_proj(player.body:getX() + dx, player.body:getY() + dy, dx, dy, player.angle)

    local m = 5
    player.prt_shoot:setLinearAcceleration(dx*m, dy*m, dx*m, dy*m)
    player.prt_shoot:setEmissionArea("uniform", 5, 5, player.angle, false)
    player.prt_shoot:setDirection(player.angle)
    player.prt_shoot:emit(15)
end

function player.update(dt)
    for _, t in pairs(player.timings) do
        if not t.isExpired() then t.update(dt) end
    end

    player.x = player.body:getX() - player.offsetx
    player.y = player.body:getY() - player.offsety

    player.controls()
    player.face_cursor()
    player.anim:update(dt)

    player.prt_shoot:update(dt)
    player.prt_trail:update(dt)
    player.prt_shoot:setPosition(player.body:getX(), player.body:getY())
    player.prt_trail:setPosition(player.body:getX(), player.body:getY() - 4)

    local vx, vy = player.body:getLinearVelocity()
    local mag = math.sqrt(vx * vx + vy * vy)
    player.prt_trail:setEmissionRate(0.23 * mag)
    player.prt_trail:setSpread(0.08 * mag)

    if love.mouse.isDown(1) and game.active and player.can_shoot and not player.shooting then
        player.shoot()
    end
end

function cirnoAnims(sprite)
    local grid = anim8.newGrid(24, 32, sprite:getWidth(), sprite:getHeight())
    local animations = {}

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
    animations.yeah = anim8.newAnimation(grid("1-4", 9), 0.2)
    animations.dead = anim8.newAnimation(grid("5-5", 9), 1)
    local anim = animations.down

    return animations, anim
end