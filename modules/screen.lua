local border_shader = love.graphics.newShader("shader/screen_fx.fs")
local screen = {
	scale = 1,
	border_size = 1,
	border_color = {1, 1, 1, 1},
}

function screen.setup()
	if not window_init then
		love.window.setMode(WIDTH, HEIGHT, { resizable = not game.mobile, fullscreen = (savefile.data.fullscreen or game.mobile) })
		window_init = true
	end

	screen.border_size = 0
	screen.border_color = {0.4, 0.9, 1, 0.5}
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

	border_shader:send("border_size", screen.border_size)
	border_shader:send("border_color", screen.border_color)
	love.graphics.setShader(border_shader)

	love.graphics.draw(game.canvas, love.graphics.getWidth() / 2 + game.cam.x + game.cam.ofsx,
		love.graphics.getHeight() / 2 + game.cam.y + game.cam.ofsy, game.cam.angle, screen.scale, screen.scale,
		game.canvas:getWidth() / 2, game.canvas:getHeight() / 2)

	love.graphics.setShader()
end

return screen
