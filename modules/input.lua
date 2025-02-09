local keys = {
	up = { "up", "w" },
	down = { "down", "s" },
	left = { "left", "a" },
	right = { "right", "d" },
}

local input = {
	move = { dx = 0, dy = 0 }, -- x and y vector
	look = math.pi / 2,     -- angle in radians
	shoot = false,
}

-- returns the value of the axis when its outside the deadzone
local query = { 0, 0, 0, 0 }
local deadzone = 0.1
local function deadzone_axis(axis)
	local val = game.gamepad:getAxis(axis)
	if not (val > -deadzone and val < deadzone) then
		query[axis] = val
	end
	return query[axis]
end

local function in_deadzone(axis)
	local val = game.gamepad:getAxis(axis)
	return (val > -deadzone and val < deadzone)
end

function input.update(dt)
	if game.gamepad and not game.gamepad:isConnected() then
		game.gamepad = nil
	end

	if game.gamepad then -- gamepad controls
		input.shoot = game.gamepad:isGamepadDown("rightshoulder", "leftshoulder")
		input.move = { dx = game.gamepad:getAxis(1), dy = game.gamepad:getAxis(2) }

		local dx, dy = deadzone_axis(3), deadzone_axis(4)
		input.look = math.atan2(dy, dx)
		game.crosshair.x = player.body:getX() + dx * 60
		game.crosshair.y = player.body:getY() + dy * 60

		local minDistance = 0
		local maxDistance = 85
		local distance = math.sqrt((game.crosshair.x - player.body:getX()) ^ 2 +
			(game.crosshair.y - player.body:getY()) ^ 2)

		if not in_deadzone(3) or not in_deadzone(4) then
			game.crosshair.alpha = math.min(0.75, math.max(0, (distance - minDistance) / (maxDistance - minDistance)))
		else
			game.crosshair.alpha = 0
		end
	elseif game.mobile then -- mobile controls
		touch_controls:update(dt)
	else                 -- mouse and keyboard controls
		local dx, dy = 0, 0
		if input.pressed("right") then dx = dx + 1 end
		if input.pressed("left") then dx = dx - 1 end
		if input.pressed("down") then dy = dy + 1 end
		if input.pressed("up") then dy = dy - 1 end

		dx, dy = math.norm(dx, dy)
		input.move = { dx = dx, dy = dy }

		local mx, my = game.coords(love.mouse.getPosition())
		input.look = math.atan2(my - player.body:getY(), mx - player.body:getX())
		input.shoot = love.mouse.isDown(1)
		game.crosshair.x, game.crosshair.y = mx, my
		game.crosshair.alpha = 0.75
	end
end

function input.pressed(k)
	return love.keyboard.isDown(keys[k])
end

return input
