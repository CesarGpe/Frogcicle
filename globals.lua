----==== GAME VARIABLES ===----
game = {
	transitioning = false,
	active = false,
	difficulty = 0,
    score = 0,
    frozen_enemies = 0,
    time_left = 31
}

----==== PHYSICS VARIABLES ====----
world = love.physics.newWorld()
push = require("libs.push")
collision_masks = {
	player = 1,
	enemy = 2,
	wall = 4,
	projectile = 8,
}