local screen = {}

function screen.setup()
	if save_data.config.bigger or game.mobile then
		local screenWidth, screenHeight = love.window.getDesktopDimensions()
		push:setupScreen(WIDTH, HEIGHT, screenWidth, screenHeight,
			{ fullscreen = true, resizable = false, pixelperfect = true })
		game.cam.scale = 2
	else
		push:setupScreen(WIDTH, HEIGHT, WIDTH * 2, HEIGHT * 2,
			{ fullscreen = false, resizable = false, pixelperfect = true })
		game.cam.scale = 1
	end
end

function screen.shake(time, intensity, variation)
	timer.during(time, function()
		game.cam.ofsx = intensity * love.math.random(-variation, variation)
		game.cam.ofsy = intensity * love.math.random(-variation, variation)
	end)
end

return screen
