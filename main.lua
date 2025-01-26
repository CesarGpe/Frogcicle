require("sounds")
require("player")
require("enemy")
require("timer")

in_trans = false
game_active = false
difficulty = 1

game_timers = {}

world = love.physics.newWorld()
push = require("libs.push")

collision_masks = {
	player = 1,
	enemy = 2,
	wall = 4,
	projectile = 8,
}

local skew_shader = love.graphics.newShader("shader/skew.fs")

local lume = require("libs.lume")
local savefile = "savedata.txt"
local debug = false
local bigger = false

local house = love.graphics.newImage("sprites/house.png")
local housex = WIDTH / 2 - house:getWidth() / 2
local housey = HEIGHT / 2 - house:getHeight() / 2

local title = love.graphics.newImage("sprites/title.png")
local titlex = WIDTH / 2 - title:getWidth() / 2
local titley = HEIGHT / 4 - title:getHeight() / 2

local font = love.graphics.newFont("font/nicopaint.ttf", 40, "mono", 1)

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest", 1)
	love.graphics.setFont(font)
	font:setFilter("nearest")

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
	if not game_active and not clicked then
		clicked = true
		sounds.intro()
		sounds.stop_menu_music()
		timers.oneshot(1.38, function()
			sounds.game_music()
			game_active = true
		end)
	end
end

function love.keypressed(key, scancode, isrepeat)
	if key == "f11" then
		bigger = not bigger
		saveData()
		setupScreen()
	end

	if key == "f1" then
		debug = not debug
		saveData()
	end
	if key == "e" and debug then
		spawnEnemy()
	end
	if key == "r" and debug then
		for i = #enemies, 1, -1 do
			enemies[i]:destroy()
		end
	end
end

local elapsed = 0
local fixed_step = 1 / 60

function love.update(dt)
	mouseX, mouseY = push:toGame(love.mouse.getPosition())
	--skew_shader:send("time", love.timer.getTime())
	--skew_shader:send("screen", {WIDTH, HEIGHT})

	player.update(dt)

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

	for i = #enemies, 1, -1 do
		local e = enemies[i]
		if not e.body:isDestroyed() then
			e:update(dt)
		else
			table.remove(enemies, i)
		end
	end

	timers.miscUpdate(dt)
	--world:update(dt)
	sounds.update()

	elapsed = elapsed + dt
	while elapsed > fixed_step do
		world:update(dt)
		elapsed = elapsed - fixed_step
	end
end

local dproj_sprite = love.graphics.newImage("sprites/ice-break.png")
function love.draw()
	push:start()

	love.graphics.setColor(0.173, 0.18, 0.227, 1)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(house, housex, housey)

	for _, e in pairs(enemies) do
		e:draw_shadow()
	end
	player.draw_shadow()

	local entities = {}
	table.insert(entities, player)
	for _, e in pairs(enemies) do
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

	if debug then
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

	if not game_active then
		love.graphics.setShader(skew_shader)
		love.graphics.draw(title, titlex + 2, titley)
		love.graphics.print("Press anywhere to start!", 345, 380, 0, 0.5, 0.5)
		love.graphics.setShader()
	end

	love.graphics.print(love.timer.getFPS(), 10, 10)

	push:finish()
end

function makeRect(x, y, width, height)
	local body = love.physics.newBody(world, x, y, "static")
	local shape = love.physics.newRectangleShape(width, height)
	local fixture = love.physics.newFixture(body, shape)
	fixture:setCategory(collision_masks.wall)
end

function spawnEnemy()
	local enemy = newEnemy(love.math.random(280, 680), love.math.random(127, 429))
	enemy:load()
end

function saveData()
	local data = {
		bigger = bigger,
		debug = debug
	}
	local serialize = lume.serialize(data)
	love.filesystem.write(savefile, serialize)
end

function loadData()
	local data = {}
	if love.filesystem.getInfo(savefile) then
		data = lume.deserialize(love.filesystem.read(savefile))
		bigger = data.bigger
		debug = data.debug
	else
		saveData()
		print("No previous data found. Creating file.")
	end
end

function setupScreen()
	if bigger then
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
