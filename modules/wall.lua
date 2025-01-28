local wall = {}

function wall.new(x, y, width, height)
	local body = love.physics.newBody(world, x, y, "static")
	local shape = love.physics.newRectangleShape(width, height)
	local fixture = love.physics.newFixture(body, shape)
	fixture:setCategory(collision_masks.wall)
end

return wall