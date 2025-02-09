love = require("love")

window_init = false
WIDTH = 1280
HEIGHT = 720

function love.conf(t)
	t.identity         = "Frogcicle"
	t.version          = "11.4"
	t.console          = false
	t.externalstorage  = true

	t.window.title     = "Frogcicle!"
	t.window.icon      = "assets/sprites/icon.png"
	t.window.width     = WIDTH
	t.window.height    = HEIGHT
	t.window.minwidth  = 1
	t.window.minheight = 1
end
