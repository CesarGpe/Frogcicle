function set_globals(mobile)
	----==== GAME VARIABLES ===----
	game = {
		enemy_manager = require("modules.enemy_manager"),
		proj_manager = require("modules.proj_manager"),
		mouse = {x = 0, y = 0},
		cam = {
			obj = require("libs.camera").new(WIDTH / 2, HEIGHT / 2, 2, 0),
			x = 0, y = 0, zoom = 20
		},
		transitioning = false,
		can_click = false,
		active = false,
		menu = true,
		over = false,
		difficulty = 0,
		score = 0,
		frozen_enemies = 0,
		time_left = 2,
		--time_left = 50,
		music_timer = {},
		mobile = false,
	}

	save_data = require("modules.save_data")
	fonts = require("modules.fonts")
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

	-- android rubbish
	if mobile then
		game.mobile = true
		print("YOU'VE DOWNLOADED ME ON YOUR ANDROID DEVICE.")
	end
end
