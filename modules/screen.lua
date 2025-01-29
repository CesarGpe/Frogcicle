local screen = {}

function screen.setup()
	if save_data.config.bigger or game.mobile then
		local screenWidth, screenHeight = love.window.getDesktopDimensions()
		push:setupScreen(WIDTH, HEIGHT, screenWidth, screenHeight,
			{ fullscreen = true, resizable = false, pixelperfect = true })
		game.cam.scale = 2
		game.get_mouse = function()
			return love.mouse.getPosition()
		end
	else
		push:setupScreen(WIDTH, HEIGHT, WIDTH * 2, HEIGHT * 2,
			{ fullscreen = false, resizable = false, pixelperfect = true })
		game.cam.scale = 1
		game.get_mouse = function()
			return push:toGame(love.mouse.getPosition())
		end
	end
end

function screen.update(dt)
	if game.cam.trauma > 0 then
		game.cam.trauma = math.clamp(game.cam.trauma, 0, game.cam.trauma - dt * 2)
	end

	--local seed = love.timer.getTime()
	--game.cam.angle = game.cam.trauma ^ 2 * 0.5 * love.math.noise(seed+1, seed+4, seed+7, seed+10)
	--game.cam.ofsx = game.cam.trauma ^ 2 * love.math.noise(seed+2, seed+5, seed+8, seed+11)
	--game.cam.ofsy = game.cam.trauma ^ 2 * love.math.noise(seed+3, seed+6, seed+9, seed+12)

	game.cam.angle = game.cam.trauma ^ 2 * 0.5 * love.math.random(-1, 1)
	game.cam.ofsx = game.cam.trauma ^ 2 * love.math.random(-1, 1)
	game.cam.ofsy = game.cam.trauma ^ 2 * love.math.random(-1, 1)
end

return screen
