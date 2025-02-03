local wall = {}

function wall.new(x, y, w, h)
	local body = love.physics.newBody(world, x, y, "static")
	local shape = love.physics.newRectangleShape(w, h)
	local fixture = love.physics.newFixture(body, shape)
	fixture:setCategory(collision_masks.wall)
	return { body = body, shape = shape, fixture = fixture }
end

return wall
