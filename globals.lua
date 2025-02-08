love = require("love")

function set_globals(force_mobile)
	love.audio.stop()

	----==== GAME VARIABLES ===----
	game = {
		canvas = love.graphics.newCanvas(WIDTH, HEIGHT),
		bg = { r = 0.173, g = 0.18, b = 0.227, a = 1 },
		crosshair = {
			sprite = love.graphics.newImage("assets/sprites/crosshair.png"),
			scale = 1,
			alpha = 0.75,
			angle = 0,
		},
		cam = {
			x = 0,
			y = 0,
			ofsx = 0,
			ofsy = 0,
			zoom = 0,
			angle = 0,
			trauma = 0,
		},
		transitioning = false,
		waiting = false,
		active = false,
		menu = true,
		over = false,
		difficulty = 0,
		score_alpha = 0,
		score = 0,
		frozen_enemies = 0,
		--time_left = 999999,
		time_left = 40,
		elapsed = 0,
		music_timer = {},
		controller_mode = false,
		gamepad = {},
		mobile = false
	}

	function game.mouse_position()
		local x, y = love.mouse.getPosition()
		local ax = (x - love.graphics.getWidth() / 2) / screen.scale + game.canvas:getWidth() / 2
		local ay = (y - love.graphics.getHeight() / 2) / screen.scale + game.canvas:getHeight() / 2
		return ax, ay
	end

	function game.coords(x, y)
		local ax = (x - love.graphics.getWidth() / 2) / screen.scale + game.canvas:getWidth() / 2
		local ay = (y - love.graphics.getHeight() / 2) / screen.scale + game.canvas:getHeight() / 2
		return ax, ay
	end

	local os = love.system.getOS()
	if force_mobile or os == "Android" or os == "iOS" then
		game.mobile = true
	end

	----==== MODULES & LIBRARIES ===----
	touch_controls = require("modules.touch_controls")
	enemy_manager = require("modules.enemy_manager")
	proj_manager = require("modules.proj_manager")
	savefile = require("modules.savefile")
	screen = require("modules.screen")
	input = require("modules.input")
	fonts = require("modules.fonts")
	timer = require("libs.timer")
	flux = require("libs.flux")

	----==== PHYSICS VARIABLES ====----
	world = love.physics.newWorld()
	collision_masks = {
		player = 1,
		enemy = 2,
		wall = 4,
		proj = 8,
	}
end

function math.clamp(val, lower, upper)
	assert(val and lower and upper, "there was an error lol")
	if lower > upper then lower, upper = upper, lower end
	return math.max(lower, math.min(upper, val))
end

function math.norm(x, y, target)
	target = target or 1
	local mag = math.sqrt(x * x + y * y)
	if mag > 0 then
		x = (x / mag) * target
		y = (y / mag) * target
	end
	return x, y
end

function math.mag(x, y)
	return math.sqrt(x * x + y * y)
end

function math.length(a, b)
	if (b == nil) then
		b = { x = 0, y = 0 }
	end
	local width, height = b.x - a.x, b.y - a.y
	return (width * width + height * height) ^ 0.5
end

function math.dot(ax, ay, bx, by)
	return ax * bx + ay * by
end
