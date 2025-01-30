local screen = {}

function screen.setup()
	local screenWidth, screenHeight = love.window.getDesktopDimensions()
	push:setupScreen(WIDTH, HEIGHT, screenWidth, screenHeight,
		{ fullscreen = true, resizable = false, pixelperfect = true })
	game.cam.scale = 2

	--[[push:setupScreen(WIDTH, HEIGHT, WIDTH, HEIGHT,
		{ fullscreen = false, resizable = false, pixelperfect = true })
	game.cam.scale = 2]]
end

function screen.update(dt)
	game.cam.trauma = math.clamp(game.cam.trauma, 0, game.cam.trauma - dt * 2)

	game.cam.angle = game.cam.trauma ^ 2 * 0.5 * love.math.random(-1, 1)
	game.cam.ofsx = game.cam.trauma ^ 2 * love.math.random(-1, 1)
	game.cam.ofsy = game.cam.trauma ^ 2 * love.math.random(-1, 1)

	--[[local seed = love.timer.getTime()
	game.cam.angle = game.cam.trauma ^ 2 * (love.math.noise(seed, seed+3) * 2 - 1)
	game.cam.ofsx = game.cam.trauma ^ 2 * (love.math.noise(seed+1, seed+4) * 2 - 1)
	game.cam.ofsy = game.cam.trauma ^ 2 * (love.math.noise(seed+2, seed+5) * 2 - 1)]]
end

return screen
