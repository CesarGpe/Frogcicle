require("modules.sounds")
require("modules.ticker")
require("globals")
require("player")

local drawer = require("modules.entity_drawer")
local screen = require("modules.screen")
local stage = require("modules.stage")
local debug = require("modules.debug")
local wall = require("modules.wall")

local ui_gameover = require("modules.ui_gameover")
local ui_score = require("modules.ui_score")
local ui_menu = require("modules.ui_menu")

function love.load()
	set_globals()
	save_data:load()
	screen.setup()
	fonts.load()

	wall.new(0, 0, 1135, 1600) -- left wall
	wall.new(1535, 0, 1135, 1600) -- right wall
	wall.new(0, 0, 2310, 580) -- up wall
	wall.new(0, 880, 2310, 580) -- down wall

	sounds.menu_music()
	player.load()
	ui_menu:load()
end

function love.mousepressed(x, y, button, istouch, presses)
	if game.can_click then
		game.can_click = false
		if game.over then
			love.load()
		elseif not game.active then
			ui_menu:start()
		end
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "f11" then
		save_data.config.bigger = not save_data.config.bigger
		screen:setup()
		save_data:save()
	end
	if key == "r" then
		game.cam.trauma = game.cam.trauma + 0.2
		--screen.shake(0.5, 0.5, 1)
	end
	if key == "-" then
		save_data.config.debug = not save_data.config.debug
		save_data:save()
	end
end

function love.update(dt)
	if game.active then
		game.difficulty = game.difficulty + dt * 0.001
		game.score = game.score + dt * math.pow(game.frozen_enemies, 1.01)
		if game.time_left > 1 then
			local time_change = dt * (1 - game.frozen_enemies * 0.1) * (1 + game.difficulty)
			if game.frozen_enemies > 4 then time_change = -time_change end
			game.time_left = game.time_left - time_change
		else
			ui_gameover:load()
		end
	end

	player.update(dt)
	game.proj_manager:update()
	game.enemy_manager:update(dt + game.difficulty * 0.001)

	if game.music_timer.update then
		game.music_timer.update(dt)
	end

	screen.update(dt)
	world:update(dt)
	timer.update(dt)
	flux.update(dt)
	sounds.update()
end

function love.draw()
	push:start()

	game.camera:setPosition(game.cam.x + game.cam.ofsx, game.cam.y + game.cam.ofsy)
	game.camera:setScale(game.cam.scale + game.cam.zoom)
	game.camera:setAngle(game.cam.angle)
	game.camera:draw(draw_game)

	push:finish()
end

function draw_game()
	stage:draw()
	drawer.draw(game.enemy_manager.enemies, game.proj_manager.projectiles)

	if save_data.config.debug then debug.draw() end
	if game.menu then ui_menu:draw() end
	if game.over then ui_gameover:draw() else ui_score:draw() end
end
