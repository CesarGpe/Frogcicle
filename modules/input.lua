local input = {
	up = { "up", "w" },
	down = { "down", "s" },
	left = { "left", "a" },
	right = { "right", "d" },
	left_joy = { dx = 0, dy = 0 },
	right_joy = { dx = 0, dy = 0 },
	pew = false,
	pew_angle = math.pi / 2,
}

function input.pressed(key)
	return love.keyboard.isDown(input[key])
end

function input.shoot()
	if game.controller_mode then
		return game.gamepad:isGamepadDown("rightshoulder", "leftshoulder")
	elseif game.mobile then
		return input.pew
	else
		return love.mouse.isDown(1)
	end
end

function input.joysticks(dx1, dy1, dx2, dy2)
	input.left_joy = {dx = dx1, dy = dy1}
	input.right_joy = {dx = dx2, dy = dy2}
end

return input
