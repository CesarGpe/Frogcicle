local screen_shader = love.graphics.newShader("shader/screen_fx.fs")
local screen = {
	scale = 1,
	border_size = 1,
	border_color = { 1, 1, 1, 1 },
	noiselvl = 0.012,
	glitchlvl = 0,
}

function screen.setup()
	if not window_init then
		love.window.setMode(WIDTH, HEIGHT,
			{ resizable = not game.mobile, fullscreen = (savefile.data.fullscreen or game.mobile) })

		window_init = true
	end

	screen.border_size = 0
	screen.border_color = { 0.4, 0.9, 1, 0.5 }
end

function screen.update(dt)
	game.cam.trauma = math.clamp(game.cam.trauma, 0, game.cam.trauma - dt * 2)

	game.cam.angle = game.cam.trauma ^ 2 * 0.5 * love.math.random(-1, 1)
	game.cam.ofsx = game.cam.trauma ^ 2 * love.math.random(-1, 1)
	game.cam.ofsy = game.cam.trauma ^ 2 * love.math.random(-1, 1)
end

function screen.draw(func)
	love.graphics.setCanvas(game.canvas)
	love.graphics.clear()

	func()

	love.graphics.setCanvas()
	local maxScaleX = love.graphics.getWidth() / game.canvas:getWidth()
	local maxScaleY = love.graphics.getHeight() / game.canvas:getHeight()
	screen.scale = math.min(maxScaleX, maxScaleY) * game.cam.zoom

	screen_shader:send("border_size", screen.border_size)
	screen_shader:send("border_color", screen.border_color)
	screen_shader:send("time", love.timer.getTime())
	screen_shader:send("distortion_fac", { 1.2, 1.2 })
	screen_shader:send("scale_fac", { 1, 1 })
	screen_shader:send("feather_fac", 0.01)
	screen_shader:send("noise_fac", screen.noiselvl)
	screen_shader:send("crt_intensity", 0.016)
	screen_shader:send("glitch_intensity", screen.glitchlvl)
	screen_shader:send("scanlines", game.canvas:getPixelHeight()*1.2)
	if game.mobile then
		screen_shader:send("bloom_fac", 0)
	else
		screen_shader:send("bloom_fac", 2)
	end

	love.graphics.setShader(screen_shader)

	love.graphics.draw(game.canvas, love.graphics.getWidth() / 2 + game.cam.ofsx,
		love.graphics.getHeight() / 2 + game.cam.ofsy, game.cam.angle, screen.scale, screen.scale,
		game.canvas:getWidth() / 2, game.canvas:getHeight() / 2)

	love.graphics.setShader()
end

return screen
