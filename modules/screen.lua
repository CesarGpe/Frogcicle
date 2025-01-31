--local shader = love.graphics.newShader("shader/red_top.fs")
local screen = {}

function screen.setup()
	if savefile.data.fullscreen then
		local screenWidth, screenHeight = love.window.getDesktopDimensions()
		push:setupScreen(WIDTH, HEIGHT, screenWidth, screenHeight,
			{ fullscreen = true, resizable = false, pixelperfect = savefile.data.pixelperfect })
		push:resize(screenWidth, screenHeight)
		game.mouse_position = function()
			return push:toGame(love.mouse.getPosition())
		end
	else
		push:setupScreen(WIDTH, HEIGHT, WIDTH, HEIGHT,
			{ fullscreen = false, resizable = false, pixelperfect = savefile.data.pixelperfect })
		push:resize(WIDTH, HEIGHT)
		game.mouse_position = function()
			return game.camera:toWorld(push:toGame(love.mouse.getPosition()))
		end
	end

	--shader:send("border_color", { 0, 1, 1, 1 })
	--shader:send("screen_size", { screen.width, screen.height })
	--push:setShader(shader)
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
