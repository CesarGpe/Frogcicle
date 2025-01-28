local screen = {}

function screen.setup()
	if game.mobile then
		local screenWidth, screenHeight = love.window.getDesktopDimensions()
		push:setupScreen(WIDTH, HEIGHT, screenWidth, screenHeight, { fullscreen = true, resizable = false })
		game.cam.x, game.cam.y = push:toGame(WIDTH / 2, HEIGHT / 2)
		game.cam.x = -game.cam.x
		game.cam.y = -game.cam.y
	elseif save_data.config.bigger then
		push:setupScreen(WIDTH, HEIGHT, WIDTH * 2, HEIGHT * 2, {
			fullscreen = false,
			resizable = false,
			pixelperfect = true
		})
		game.cam.x, game.cam.y = push:toGame(WIDTH, HEIGHT)
		game.cam.x = -game.cam.x
		game.cam.y = -game.cam.y
	else
		push:setupScreen(WIDTH, HEIGHT, WIDTH, HEIGHT, {
			fullscreen = false,
			resizable = false,
			pixelperfect = true
		})
		game.cam.x, game.cam.y = push:toGame(WIDTH * 2, HEIGHT * 2)
	end
end

return screen