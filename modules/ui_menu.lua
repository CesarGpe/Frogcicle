local color_wave = love.graphics.newShader("shader/color_wave.fs")
local ui_menu = {}

function ui_menu:load()
	self.show = true
	self.intro_visible = true
	self.titley = (HEIGHT / 2) - 460
	self.introy = (HEIGHT / 2) + 400
	self.blink_timer = ticker.new(0.5, function()
		self:intro_blink()
	end)

	timer.after(0.5, function() game.can_click = true end)
	flux.to(ui_menu, 0.6, { titley = self.titley + 360, introy = self.introy - 340 }):ease("elasticout"):delay(0.15)
	flux.to(game.cam, 0.8, { zoom = 1 }):ease("elasticout"):delay(0.15)
end

function ui_menu:intro_blink()
	ui_menu.intro_visible = not ui_menu.intro_visible
	self.blink_timer = ticker.new(0.5, function()
		self:intro_blink()
	end)
end

function ui_menu:start()
	sounds.intro()
	sounds.stop_menu_music()
	game.transitioning = true

	flux.to(ui_menu, 5, { titley = self.titley - 360, introy = self.introy + 340 }):ease("elasticout")
	timer.after(0.8, function() game.menu = false end)

	local e = "backout"
	flux.to(game.cam, 0.39, { zoom = 1.5 }):ease(e):after(game.cam, 0.3, { zoom = 0.75 }):ease(e)
		:after(game.cam, 0.3, { zoom = 0.25 }):ease(e):after(game.cam, 0.3, { zoom = 0 }):ease(e)

	--[[timer.after(0.39, function() flux.to(game.cam, 0.3, { zoom = 0.75 }):ease(ease) end)
	timer.after(0.69, function() flux.to(game.cam, 0.3, { zoom = 0.25 }):ease(ease) end)
	timer.after(0.99, function() flux.to(game.cam, 0.3, { zoom = 0 }):ease(ease) end)]]

	timer.after(1.38, function()
		enemy_manager:init()
		sounds.game_music()
		game.score = 0
		game.active = true
		game.transitioning = false
	end)
end

function ui_menu:update(dt)
	if not self.blink_timer.isExpired() then
		self.blink_timer.update(dt)
	end
end

function ui_menu:draw()
	color_wave:send("time", love.timer.getTime())
	love.graphics.setShader(color_wave)
	love.graphics.setFont(fonts.poolparty)
	love.graphics.setColor(1, 1, 1, 1)
	local title_text = "Frogcicle!"
	local fwidth = fonts.poolparty:getWidth(title_text)
	local fheight = fonts.paintbasic:getHeight() / 2
	love.graphics.print(title_text, WIDTH / 2, ui_menu.titley + fheight, 0, 2, 2, fwidth / 2, fheight)
	--love.graphics.print(title_text, WIDTH / 2 - fwidth, ui_menu.titley, 0, 2, 2)
	love.graphics.setShader()

	if ui_menu.intro_visible or game.transitioning then
		love.graphics.setFont(fonts.paintbasic)
		love.graphics.setColor(1, 1, 1, 1)
		local intro_text = "Press anywhere to start!"
		local iwidth = fonts.paintbasic:getWidth(intro_text)
		love.graphics.print(intro_text, WIDTH / 2 - iwidth / 2, ui_menu.introy)
	end

	love.graphics.setFont(fonts.paintbasic)
	love.graphics.setColor(1, 1, 1, 0.5)
	local hstext = "Highscore: " .. savefile.data.highscore
	local iwidth = fonts.paintbasic:getWidth(hstext)
	love.graphics.print(hstext, WIDTH / 2 - iwidth / 2, ui_menu.introy + 35)
	love.graphics.setColor(1, 1, 1, 1)
end

return ui_menu
