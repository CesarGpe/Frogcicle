require("globals")
require("sounds")
require("player")
require("timer")

--local shader = love.graphics.newShader("shader/test.fs")

local enemy_manager = require("enemy_manager")

----==== USER CONFIG ====----
local lume = require("libs.lume")
local savefile = "savedata.txt"
local config = {
	debug = false,
	bigger = false
}

----==== SPRITES ====----
local paintbasic = love.graphics.newFont("font/paintbasic.txt", "font/paintbasic.png")

local house = love.graphics.newImage("sprites/house.png")
local housex = WIDTH / 2 - house:getWidth() / 2
local housey = HEIGHT / 2 - house:getHeight() / 2

local title = love.graphics.newImage("sprites/title.png")
local titlex = WIDTH / 2 - title:getWidth() / 2
local titley = HEIGHT / 3.3 - title:getHeight() / 2


function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	paintbasic:setFilter("nearest")

	loadData()
	setupScreen()

	sounds.menu_music()

	makeRect(0, 0, 560, 1200)
	makeRect(960, 0, 560, 1200)
	makeRect(0, 0, 2000, 254)
	makeRect(0, 554, 2000, 250)

	player.load()
end

local clicked = false
function love.mousepressed(x, y, button, istouch, presses)
	if not game.active and not clicked then
		clicked = true
		sounds.intro()
		sounds.stop_menu_music()
		game.transitioning = true
		timers.oneshot(1.38, function()
			enemy_manager:init()
			sounds.game_music()
			game.score = 0
			game.active = true
			game.transitioning = false
		end)
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "f11" then
		config.bigger = not config.bigger
		saveData()
		setupScreen()
	end

	if key == "-" then
		config.debug = not config.debug
		saveData()
	end
	if key == "e" and config.debug then
		enemy_manager:debug_spawn()
	end
	if key == "r" and config.debug then
		enemy_manager:kill_everyone()
	end
end

function love.update(dt)
	mouseX, mouseY = push:toGame(love.mouse.getPosition())
	--shader:send("screen_size", {WIDTH, HEIGHT})

	if game.active then
		game.difficulty = game.difficulty + dt * 0.001
		if game.time_left > 1  then
			local time_change = dt * (1 - game.frozen_enemies * 0.1) * (1 + game.difficulty)
			if game.frozen_enemies > 4 then time_change = -time_change end
			game.time_left = game.time_left - time_change
		else
			-- matar
		end
	end

	player.update(dt)
	enemy_manager:update(dt + game.difficulty * 0.001)

	game.score = game.score + dt * math.pow(game.frozen_enemies, 1.01)

	for i = #projectiles, 1, -1 do
		local p = projectiles[i]
		if not p.body:isDestroyed() then
			local cons = p.body:getContacts()
			if #cons ~= 0 then
				for _, c in pairs(cons) do
					local a, b = c:getFixtures()
					for _, f in pairs({ a, b }) do
						if f:getCategory() == collision_masks.enemy then
							f:getUserData():freeze()
							break
						end
					end
				end
				p:destroy()
				sounds.hit()
			else
				p:update()
			end
		else
			table.remove(projectiles, i)
		end
	end

	timers.miscUpdate(dt)
	sounds.update()
	world:update(dt)
end

local dproj_sprite = love.graphics.newImage("sprites/ice-break.png")
function love.draw()
	push:start()

	love.graphics.setColor(0.173, 0.18, 0.227, 1)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(house, housex, housey)

	for _, e in pairs(enemy_manager.enemies) do
		e:draw_shadow()
	end
	player.draw_shadow()

	local entities = {}
	table.insert(entities, player)
	for _, e in pairs(enemy_manager.enemies) do
		if not e.body:isDestroyed() then
			table.insert(entities, e)
		end
	end
	for _, p in pairs(projectiles) do
		if not p.body:isDestroyed() then
			table.insert(entities, p)
		else
			love.graphics.draw(dproj_sprite, p.x, p.y, 0, 1.35, 1.35, dproj_sprite:getWidth() / 2,
				dproj_sprite:getHeight() / 2)
		end
	end
	table.sort(entities, function(a, b)
		local aY = a.body and a.body:getY() or a.y
		local bY = b.body and b.body:getY() or b.y
		return aY < bY
	end)
	for _, e in pairs(entities) do
		e:draw()
	end

	if config.debug then
		love.graphics.setColor(1, 1, 1, 0.25)
		love.graphics.rectangle("fill", 280, 127, 400, 302)
		for _, body in pairs(world:getBodies()) do
			for _, fixture in pairs(body:getFixtures()) do
				local shape = fixture:getShape()

				if body:getType() == "static" then
					love.graphics.setColor(0.5, 1, 0.5, 0.5)
				else
					love.graphics.setColor(1, 0.5, 0.5, 0.8)
				end

				if shape:typeOf("CircleShape") then
					local cx, cy = body:getWorldPoints(shape:getPoint())
					love.graphics.circle("fill", cx, cy, shape:getRadius())
				elseif shape:typeOf("PolygonShape") then
					love.graphics.polygon("fill", body:getWorldPoints(shape:getPoints()))
				else
					love.graphics.line(body:getWorldPoints(shape:getPoints()))
				end
			end
		end
		love.graphics.setColor(1, 1, 1, 1)
	end

	if game.active then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setFont(paintbasic)
		local score = math.floor(game.score)
		local swidth = paintbasic:getWidth(score) / 2
		love.graphics.print(score, WIDTH / 2 - swidth / 2, 460)

		local minutes = math.floor(game.time_left / 60)
		local seconds = math.floor(game.time_left % 60)
		local time = string.format("%02d:%02d", minutes, seconds)
		local twidth = paintbasic:getWidth(time) / 2
		love.graphics.print(time, WIDTH / 2 - twidth, 70)
	else
		--love.graphics.setShader(shader)
		--love.graphics.draw(title, titlex + 2, titley)

		love.graphics.setFont(paintbasic)
		love.graphics.setColor(0.21, 0.77, 0.95, 1)
		local title_text = "Frogcicle!"
		local twidth = paintbasic:getWidth(title_text) * 1.5
		love.graphics.print(title_text, WIDTH / 2 - twidth, 150, 0, 3, 3)

		love.graphics.setFont(paintbasic)
		love.graphics.setColor(1, 1, 1, 1)
		local intro_text = "Press anywhere to start!"
		local iwidth = paintbasic:getWidth(intro_text) / 2
		love.graphics.print(intro_text, WIDTH / 2 - iwidth, 360, 0)

		--love.graphics.setShader()
	end

	push:finish()
end

function makeRect(x, y, width, height)
	local body = love.physics.newBody(world, x, y, "static")
	local shape = love.physics.newRectangleShape(width, height)
	local fixture = love.physics.newFixture(body, shape)
	fixture:setCategory(collision_masks.wall)
end

function saveData()
	local data = {
		bigger = config.bigger,
		debug = config.debug
	}
	local serialize = lume.serialize(data)
	love.filesystem.write(savefile, serialize)
end

function loadData()
	if love.filesystem.getInfo(savefile) then
		local data = lume.deserialize(love.filesystem.read(savefile))
		config.bigger = data.bigger
		config.debug = data.debug
	else
		saveData()
		print("No previous data found. Creating file.")
	end
end

function setupScreen()
	if config.bigger then
		push:setupScreen(WIDTH, HEIGHT, WIDTH * 2, HEIGHT * 2, {
			fullscreen = false,
			resizable = false,
			pixelperfect = true
		})
	else
		push:setupScreen(WIDTH, HEIGHT, WIDTH, HEIGHT, {
			fullscreen = false,
			resizable = false,
			pixelperfect = true
		})
	end
end
