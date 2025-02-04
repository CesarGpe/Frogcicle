WIDTH = 1280
HEIGHT = 720

function love.conf(t)
	t.identity          = "frogcicle"
	t.appendidentity    = false
	t.externalstorage   = true
	t.gammacorrect      = false

	t.window.title      = "Frogcicle!"
	t.window.icon       = "assets/sprites/icon.png"
	t.window.width      = WIDTH
	t.window.height     = HEIGHT
	t.window.fullscreen = false
	t.window.borderless = false
	t.window.resizable  = true
	t.window.minwidth   = 100
	t.window.minheight  = 100
end
