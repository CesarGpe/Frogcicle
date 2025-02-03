require("entities.player")
require("modules.sounds")
require("modules.ticker")
require("globals")

local drawer = require("modules.entity_drawer")
local screen = require("modules.screen")
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
		screen.setup()
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

function love.update(dt)
	if game.active then
		game.difficulty = game.difficulty + dt * 0.008
		game.score = game.score + dt * math.pow(game.frozen_enemies, 1.01)
		if game.time_left > 1 then
			game.time_left = game.time_left - dt * (1 - game.frozen_enemies * 0.2) * (1 + game.difficulty)
			game.elapsed = game.elapsed + dt
		else
			ui_gameover:load()
			flux.to(stage, 1, { dark = 1 })
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

	player.update(dt)
	proj_manager:update(dt)
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

function love.resize(w, h)
	push:resize(w, h)
end

function love.draw()
	push:start()
	game.camera:draw(draw_game)
	push:finish()
	--love.graphics.print(love.timer.getFPS(), 10, 10)
end

function draw_game()
	stage:draw()
	drawer.draw(enemy_manager.enemies, proj_manager.splashes, proj_manager.projectiles)

	if savefile.data.debug then debug.draw() end
	if game.menu then ui_menu:draw() end
	if game.over then ui_gameover:draw() else ui_score:draw() end
end

function love.run()
	---@diagnostic disable-next-line: redundant-parameter
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0
	local dt_smooth = 1 / 100
	local run_time = 0

	-- Main loop time.
	return function()
		run_time = love.timer.getTime()
		-- Process events.
		if love.event and game then
			love.event.pump()
			local _n, _a, _b, _c, _d, _e, _f, touched
			for name, a, b, c, d, e, f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				if name == 'touchpressed' then
					touched = true
				elseif name == 'mousepressed' then
					_n, _a, _b, _c, _d, _e, _f = name, a, b, c, d, e, f
				else
					love.handlers[name](a, b, c, d, e, f)
				end
			end
			if _n then
				love.handlers['mousepressed'](_a, _b, _c, touched)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then dt = love.timer.step() end
		dt_smooth = math.min(0.8 * dt_smooth + 0.2 * dt, 0.1)
		-- Call update and draw
		if love.update then love.update(dt_smooth) end -- will pass 0 if love.timer is disabled

		if love.graphics and love.graphics.isActive() then
			if love.draw then love.draw() end
			love.graphics.present()
		end

		run_time = math.min(love.timer.getTime() - run_time, 0.1)
	end
end