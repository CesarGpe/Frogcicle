love.graphics.setDefaultFilter("nearest", "nearest", 1)

require("entities.player")
require("globals")

local drawer = require("modules.entity_drawer")
local stage = require("modules.stage")
local debug = require("modules.debug")

function love.load()
	set_globals()
	savefile:load()
	screen.setup()
	fonts.load()

	stage:load()
	player.load()

	ui_menu:load()
	ui_score:load()
end

function love.update(dt)
	screen.update(dt)
	input.update(dt)
	timer.update(dt)
	flux.update(dt)
	sounds.update()

	ui_menu:update(dt)
	ui_score:update(dt)
	ui_gameover:update(dt)

	-- pausing is pretty easy actually :smiling_imp:
	if game.paused then return end

	if game.active then
		if game.time_left > 1 and not game.tutorial_active then
			game.difficulty = game.difficulty + dt * 0.008
			game.score = game.score + dt * math.pow(game.frozen_enemies, 1.01)

			game.elapsed = game.elapsed + dt
			game.time_left = game.time_left - dt * (1 - game.frozen_enemies * 0.2) * (1 + game.difficulty)

			flux.to(screen, 1, { border_size = game.frozen_enemies * 0.06 })
		elseif not game.tutorial_active then
			ui_gameover:start(1.5)
			flux.to(stage, 1, { alpha = 0 })
			flux.to(game.bg, 1, { r = 0, g = 0, b = 0 })
			local score = math.floor(game.score)
			if score > savefile.data.highscore then
				savefile.data.highscore = score
				ui_gameover.hs.new = true
				savefile:save()
			end
		end
		debug1 = game.difficulty
		debug2 = game.elapsed
	end

	talkies.update(dt)
	player.update(dt)
	proj_manager:update(dt)
	enemy_manager:update(dt + game.difficulty * 0.001)
	world:update(dt)
end

local fish = love.graphics.newImage("assets/sprites/lol.png")
local function draw_game()
	stage:draw()
	drawer.draw(enemy_manager.enemies, proj_manager.splashes, proj_manager.projectiles)

	if savefile.data.debug then debug.draw() end

	if game.menu then ui_menu:draw() end
	if game.over then ui_gameover:draw() end
	ui_score:draw()
	ui_pause:draw()

	-- lol
	if game.menu and not game.transitioning then
		love.graphics.draw(fish, 420, 450)
	end
	-- lmao

	love.mouse.setVisible((not game.active or game.paused) and not game.mobile and not game.gamepad)
	if game.active and not game.paused and (game.gamepad or not game.mobile) then
		game.crosshair.angle = game.crosshair.angle + 0.006
		love.graphics.setColor(1, 1, 1, game.crosshair.alpha)
		love.graphics.draw(game.crosshair.sprite, math.floor(game.crosshair.x), math.floor(game.crosshair.y),
			game.crosshair.angle, game.crosshair.scale, game.crosshair.scale, game.crosshair.sprite:getWidth() / 2,
			game.crosshair.sprite:getHeight() / 2)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function love.draw()
	screen.draw(draw_game)
	if game.mobile and not game.gamepad then
		touch_controls:draw()
	end
	if savefile.data.debug then
		love.graphics.print(love.timer.getFPS(), 10, 10)
		love.graphics.print("D1: " .. debug1, 10, 30)
		love.graphics.print("D2: " .. debug2, 10, 50)
	end
end

local function press()
	talkies.onAction()
	if game.waiting and not touch_controls.joy.heldId then
		game.waiting = false
		if game.over then
			ui_gameover.player_twn:stop()
			love.load()
		elseif not game.active then
			ui_menu:start()
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	game.gamepad = nil
	if key == "escape" and game.active then
		ui_pause:switch()
	end
	if key == "space" then
		press()
	end
	if key == "f11" then
		savefile.data.fullscreen = not savefile.data.fullscreen
		love.window.setFullscreen(savefile.data.fullscreen)
		savefile:save()
	end
	if key == "-" then
		savefile.data.debug = not savefile.data.debug
		savefile:save()
	end
	if key == "r" and savefile.data.debug then
		love.load()
	end
end

function love.mousereleased(x, y, button, istouch, presses)
	if not game.mouse_in_button then
		press()
	end
	game.gamepad = nil
end

function love.mousemoved(x, y, dx, dy, istouch)
	game.gamepad = nil
end

function love.gamepadreleased(joystick, button)
	press()
	if not game.gamepad and joystick:isGamepad() then
		game.gamepad = joystick
	end
end

function love.gamepadaxis(joystick, axis, value)
	if not game.gamepad and joystick:isGamepad() then
		game.gamepad = joystick
	end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	if touch_controls.joy_enabled then
		touch_controls.joy.pressed(id, x, y, dx, dy)
		touch_controls:pause_button_check(id, x, y)
	end
end

function love.touchmoved(id, x, y, dx, dy, pressure)
	if touch_controls.joy_enabled then
		touch_controls.joy.moved(id, x, y, dx, dy)
	end
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	touch_controls.joy.released(id, x, y, dx, dy)
end
