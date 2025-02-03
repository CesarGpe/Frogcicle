local gamera = require("libs.gamera").new(0, 0, WIDTH, HEIGHT)
love = require("love")

function set_globals(mobile)
	love.audio.stop()
	love.graphics.setDefaultFilter("nearest", "nearest", 1)

	----==== GAME VARIABLES ===----
	game = {
		camera = gamera,
		cam = {
			x = WIDTH / 2,
			y = HEIGHT / 2,
			ofsx = 0,
			ofsy = 0,
			scale = 2,
			zoom = 0,
			angle = 0,
			trauma = 0,
		},
		transitioning = false,
		can_click = false,
		active = false,
		menu = true,
		over = false,
		difficulty = 0,
		score = 0,
		frozen_enemies = 0,
		time_left = 40,
		elapsed = 0,
		music_timer = {},
		mobile = false
	}

	----==== MODULES & LIBRARIES ===----
	enemy_manager = require("modules.enemy_manager")
	proj_manager = require("modules.proj_manager")
	savefile = require("modules.savefile")
	fonts = require("modules.fonts")
	timer = require("libs.timer")
	push = require("libs.push")
	flux = require("libs.flux")

	----==== PHYSICS VARIABLES ====----
	world = love.physics.newWorld()
	collision_masks = {
		player = 1,
		enemy = 2,
		wall = 4,
		proj = 8,
	}

	-- android rubbish
	if mobile then
		game.mobile = true
	end
end

function math.clamp(val, lower, upper)
	assert(val and lower and upper, "there was an error lol")
	if lower > upper then lower, upper = upper, lower end
	return math.max(lower, math.min(upper, val))
end
