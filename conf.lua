WIDTH = 1280
HEIGHT = 720

function love.conf(t)
	t.identity         = "frogcicle"
	t.appendidentity   = false
	t.externalstorage  = true
	t.gammacorrect     = false

	t.window.title     = "Frogcicle!"
	t.window.icon      = "assets/sprites/icon.png"
	t.window.width     = WIDTH
	t.window.height    = HEIGHT
	t.window.minwidth  = 0
	t.window.minheight = 0
end
