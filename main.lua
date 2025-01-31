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
	savefile:load()
	screen.setup()
	fonts.load()

	wall.new(0, 0, 880, 1100) -- left wall
	wall.new(1280, 0, 880, 1100) -- right wall
	wall.new(0, 0, 1950, 435) -- up wall
	wall.new(0, 735, 1950, 435) -- down wall

	sounds.menu_music()
	player.load()
	ui_menu:load()

	stage.dark = 0
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
		savefile.data.fullscreen = not savefile.data.fullscreen
		push:switchFullscreen(WIDTH, HEIGHT)
		savefile:save()
	end
	if key == "f12" then
		savefile.data.pixelperfect = not savefile.data.pixelperfect
		screen.setup()
		savefile:save()
	end
	if key == "r" then
		love.load()
	end
	if key == "-" then
		savefile.data.debug = not savefile.data.debug
		savefile:save()
	end
end

function love.resize(w, h)
	push:resize(w, h)
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
			flux.to(stage, 1, { dark = 1 })
			local score = math.floor(game.score)
			if score > savefile.data.highscore then
				savefile.data.highscore = score
				savefile:save()
			end
		end
	end

	if game.music_timer.update then
		game.music_timer.update(dt)
	end

	player.update(dt)
	proj_manager:update()
	enemy_manager:update(dt + game.difficulty * 0.001)

	game.camera:setPosition(game.cam.x + game.cam.ofsx, game.cam.y + game.cam.ofsy)
	game.camera:setScale(game.cam.scale + game.cam.zoom)
	game.camera:setAngle(game.cam.angle)

	ui_menu:update(dt)
	screen.update(dt)
	world:update(dt)
	timer.update(dt)
	flux.update(dt)
	sounds.update()
end

function love.draw()
	push:start()
	game.camera:draw(draw_game)
	push:finish()
	--love.graphics.print(love.timer.getFPS(), 10, 10)
end

function draw_game()
	stage:draw()
	drawer.draw(enemy_manager.enemies, proj_manager.projectiles)

	if savefile.data.debug then debug.draw() end
	if game.menu then ui_menu:draw() end
	if game.over then ui_gameover:draw() else ui_score:draw() end
end
