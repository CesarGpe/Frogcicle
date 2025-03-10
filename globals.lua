function set_globals(force_mobile)
	love.audio.stop()

	----==== GAME VARIABLES ===----
	game = {
		canvas = love.graphics.newCanvas(WIDTH, HEIGHT),
		bg = { r = 0.173, g = 0.18, b = 0.227, a = 1 },
		crosshair = {
			sprite = love.graphics.newImage("assets/sprites/crosshair.png"),
			x = 0,
			y = 0,
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
		paused = false,
		difficulty = 0,
		score = 0,
		frozen_enemies = 0,
		time_left = 40,
		elapsed = 0,
		gamepad = nil,
		mobile = false,
		tutorial_active = false,
		mouse_in_button = false,
	}

	function game.coords(x, y)
		local ax = (x - love.graphics.getWidth() / 2) / screen.scale + game.canvas:getWidth() / 2
		local ay = (y - love.graphics.getHeight() / 2) / screen.scale + game.canvas:getHeight() / 2
		return ax, ay
	end

	local os = love.system.getOS()
	if force_mobile or os == "Android" or os == "iOS" then
		game.mobile = true
	end

	----==== UI OBJECTS ===----
	touch_controls = require("modules.touch_controls")
	ui_gameover = require("modules.ui_gameover")
	ui_score = require("modules.ui_score")
	ui_pause = require("modules.ui_pause")
	ui_menu = require("modules.ui_menu")

	----==== MODULES & LIBRARIES ===----
	enemy_manager = require("modules.enemy_manager")
	proj_manager = require("modules.proj_manager")
	savefile = require("modules.savefile")
	lang = require("modules.lang_loader")
	sounds = require("modules.sounds")
	ticker = require("modules.ticker")
	screen = require("modules.screen")
	input = require("modules.input")
	fonts = require("modules.fonts")
	timer = require("libs.timer")
	flux = require("libs.flux")
	suit = require("libs.suit")

	----==== TALKIES DIALOGUE SYSTEM ===----
	talkies = require("libs.talkies")
	talkies.offsetx = 290
	talkies.offsety = 100
	talkies.rounding = 12
	talkies.thickness = 6
	talkies.padding = 10
	talkies.textSpeed = "medium"
	talkies.messageBorderColor = {0, 0, 0, 1}
	talkies.messageBackgroundColor = {0, 0, 0, 0.5}
	talkies.talkSound = love.audio.newSource("assets/sound/cirno-talk.ogg", "static")
	talkies.talkSound:setVolume(0.15)

	----==== PHYSICS VARIABLES ====----
	world = love.physics.newWorld()
	collision_masks = {
		player = 1,
		enemy = 2,
		wall = 4,
		proj = 8,
	}

	-- debugging rubbish
	debug1 = 0
	debug2 = 0
end

function math.clamp(val, lower, upper)
	if lower > upper then lower, upper = upper, lower end
	return math.max(lower, math.min(upper, val))
end

function math.mag(x, y)
	return math.sqrt(x * x + y * y)
end

function math.norm(x, y, t)
	t = t or 1
	local m = math.mag(x, y)
	if m > 0 then
		x = (x / m) * t
		y = (y / m) * t
	end
	return x, y
end
