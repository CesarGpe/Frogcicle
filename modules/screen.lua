local moonshine = require("libs.moonshine")
local screen_shader = love.graphics.newShader("shader/screen_fx.fs")
local screen = {
	scale = 1,
	border_size = 1,
	border_color = { 1, 1, 1, 1 },
	fx = {}
}

function screen.setup()
	if not window_init then
		love.window.setMode(WIDTH, HEIGHT,
			{ resizable = true, fullscreen = (savefile.data.fullscreen or game.mobile) })
			--{ resizable = not game.mobile, fullscreen = (savefile.data.fullscreen or game.mobile) })

		screen.fx = moonshine(moonshine.effects.crt).chain(moonshine.effects.scanlines).chain(moonshine.effects.glow)
			.chain(moonshine.effects.chromasep)
		screen.fx.crt.distortionFactor = { 1.04, 1.04 }
		screen.fx.scanlines.opacity = 0.3
		screen.fx.chromasep.radius = 1
		screen.fx.chromasep.angle = 1
		screen.fx.glow.min_luma = 0.8
		screen.fx.glow.strength = 6

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

	love.graphics.setShader(screen_shader)

	if game.mobile then
		love.graphics.draw(game.canvas, love.graphics.getWidth() / 2 + game.cam.x + game.cam.ofsx,
			love.graphics.getHeight() / 2 + game.cam.y + game.cam.ofsy, game.cam.angle, screen.scale, screen.scale,
			game.canvas:getWidth() / 2, game.canvas:getHeight() / 2)
	else
		screen.fx(function()
			love.graphics.draw(game.canvas, love.graphics.getWidth() / 2 + game.cam.x + game.cam.ofsx,
				love.graphics.getHeight() / 2 + game.cam.y + game.cam.ofsy, game.cam.angle, screen.scale, screen.scale,
				game.canvas:getWidth() / 2, game.canvas:getHeight() / 2)
		end)
	end

	love.graphics.setShader()
end

return screen
