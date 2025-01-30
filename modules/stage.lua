local sprite = love.graphics.newImage("sprites/house.png")
local stage = {
    x = WIDTH / 2 - sprite:getWidth() / 2,
    y = HEIGHT / 2 - sprite:getHeight() / 2,
    dark = 0
}

function stage:draw()
    --push:setBorderColor(0.173, 0.18, 0.227)

    love.graphics.setColor(0.173, 0.18, 0.227, 1)
    love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(sprite, self.x, self.y)

    love.graphics.setColor(0, 0, 0, self.dark)
    love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
end

return stage
