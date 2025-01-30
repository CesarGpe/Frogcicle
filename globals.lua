local gamera = require("libs.gamera").new(0, 0, WIDTH, HEIGHT)
love = require("love")

function set_globals()
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
		time_left = 50,
		music_timer = {}
	}

	----==== MODULES & LIBRARIES ===----
	enemy_manager = require("modules.enemy_manager")
	proj_manager = require("modules.proj_manager")
	savefile = require("modules.savefile")
	fonts = require("modules.fonts")
	timer = require("libs.timer")
	flux = require("libs.flux")

	----==== PHYSICS VARIABLES ====----
	world = love.physics.newWorld()
	push = require("libs.push")
	collision_masks = {
		player = 1,
		enemy = 2,
		wall = 4,
		projectile = 8,
	}
end

function math.clamp(val, lower, upper)
    assert(val and lower and upper, "there was an error lol")
    if lower > upper then lower, upper = upper, lower end
    return math.max(lower, math.min(upper, val))
end