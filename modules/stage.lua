local tint = love.graphics.newShader("shader/tint.fs")
local sprite = love.graphics.newImage("sprites/house.png")
local stage = {
    x = WIDTH / 2 - sprite:getWidth() / 2,
    y = HEIGHT / 2 - sprite:getHeight() / 2
}

function stage:draw()
    if game.over then
        tint:send("new", { 1, 1, 1, 1 })
        love.graphics.setShader(tint)
        push:setBorderColor(0, 0, 0)
        --push:setBorderColor(1, 1, 1)
        --love.graphics.setColor(0, 0, 0, 1)
    else
        push:setBorderColor(0.173, 0.18, 0.227)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(sprite, self.x, self.y)
    end
end

return stage
