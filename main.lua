love.graphics.setDefaultFilter("nearest", "nearest", 1)

require("entities.player")
require("modules.sounds")
require("modules.ticker")
require("globals")

local drawer = require("modules.entity_drawer")
local stage = require("modules.stage")
local debug = require("modules.debug")

local ui_gameover = require("modules.ui_gameover")
local ui_score = require("modules.ui_score")
local ui_menu = require("modules.ui_menu")

function love.load()
	set_globals()

	savefile:load()
	screen.setup()
	fonts.load()

	stage:load()
	player.load()
	ui_menu:load()
	sounds.menu_music()
end

local function pressed()
	if game.waiting then
		game.waiting = false
		if game.over then
			love.load()
		elseif not game.active then
			ui_menu:start()
		end
	end
end

function love.gamepadaxis(joystick, axis, value)
	if not game.gamepad and joystick:isGamepad() then
		game.gamepad = joystick
	end
end

function love.gamepadreleased(joystick, button)
	pressed()
	if not game.gamepad and joystick:isGamepad() then
		game.gamepad = joystick
	end
end

function love.mousereleased(x, y, button, istouch, presses)
	pressed()
	game.gamepad = nil
end

function love.mousemoved(x, y, dx, dy, istouch)
	game.gamepad = nil
end

function love.keypressed(key, scancode, isrepeat)
	game.gamepad = nil
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

function love.update(dt)
	if game.active then
		game.difficulty = game.difficulty + dt * 0.008
		game.score = game.score + dt * math.pow(game.frozen_enemies, 1.01)
		if game.time_left > 1 then
			game.elapsed = game.elapsed + dt
			game.time_left = game.time_left - dt * (1 - game.frozen_enemies * 0.2) * (1 + game.difficulty)
			if game.frozen_enemies > 0 then
				screen.border_size = math.clamp(screen.border_size, screen.border_size + 0.1 * dt,
					game.frozen_enemies * 0.06)
			else
				screen.border_size = math.clamp(screen.border_size, screen.border_size - 0.1 * dt,
					game.frozen_enemies * 0.06)
			end
		else
			ui_gameover:load(1)
			flux.to(stage, 1, { alpha = 0 })
			flux.to(game.bg, 1, { r = 0, g = 0, b = 0 })
			local score = math.floor(game.score)
			if score > savefile.data.highscore then
				ui_gameover.new_hs = true
				savefile.data.highscore = score
				savefile:save()
			end
		end
	end
	if game.music_timer.update then
		game.music_timer.update(dt)
	end

	input.update(dt)
	player.update(dt)
	proj_manager:update(dt)
	enemy_manager:update(dt + game.difficulty * 0.001)

	ui_menu:update(dt)
	screen.update(dt)
	world:update(dt)
	timer.update(dt)
	flux.update(dt)
	sounds.update()
end

local function draw_game()
	stage:draw()
	drawer.draw(enemy_manager.enemies, proj_manager.splashes, proj_manager.projectiles)

	if savefile.data.debug then debug.draw() end
	if game.menu then ui_menu:draw() end

	if game.over then
		ui_gameover:draw()
	else
		ui_score:draw()
		if game.mobile and not game.gamepad then
			touch_controls:draw()
		end
	end

	love.mouse.setVisible(not game.active and not game.mobile and not game.gamepad)
	if game.active and (game.gamepad or not game.mobile) then
		game.crosshair.angle = game.crosshair.angle + 0.005
		love.graphics.setColor(1, 1, 1, game.crosshair.alpha)
		love.graphics.draw(game.crosshair.sprite, game.crosshair.x, game.crosshair.y, game.crosshair.angle,
			game.crosshair.scale,
			game.crosshair.scale, game.crosshair.sprite:getWidth() / 2, game.crosshair.sprite:getHeight() / 2)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

function love.draw()
	screen.draw(draw_game)
end
