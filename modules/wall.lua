local wall = {}

function wall.new(x, y, w, h)
	local body = love.physics.newBody(world, x, y, "static")
	local shape = love.physics.newRectangleShape(w, h)
	local fixture = love.physics.newFixture(body, shape)
	fixture:setCategory(collision_masks.wall)
	--return { x = x, y = y, w = w, h = h }
end

return wall
