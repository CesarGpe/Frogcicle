local debug = {}

function debug.draw()
    love.graphics.setColor(1, 1, 1, 0.25)
    love.graphics.rectangle("fill", 568, 290, 400, 302)
    for _, body in pairs(world:getBodies()) do
        for _, fixture in pairs(body:getFixtures()) do
            local shape = fixture:getShape()

            if body:getType() == "static" then
                love.graphics.setColor(0.5, 1, 0.5, 0.5)
            else
                love.graphics.setColor(1, 0.5, 0.5, 0.8)
            end

            if shape:typeOf("CircleShape") then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                love.graphics.circle("fill", cx, cy, shape:getRadius())
            elseif shape:typeOf("PolygonShape") then
                love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
            else
                love.graphics.line(body:getWorldPoints(shape:getPoints()))
            end
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return debug
