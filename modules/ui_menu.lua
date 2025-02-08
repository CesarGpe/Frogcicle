local color_wave = love.graphics.newShader("shader/color_wave.fs")
local ui_menu = {}

function ui_menu:load()
	self.alpha = 1
	self.intro_visible = true
	self.titley = (HEIGHT / 2) - 460
	self.introy = (HEIGHT / 2) + 400
	self.blink_timer = ticker.new(0.5, function()
		self:intro_blink()
	end)

	timer.after(0.5, function() game.waiting = true end)
	flux.to(self, 0.6, { titley = self.titley + 360, introy = self.introy - 340 }):ease("elasticout"):delay(0.15)
	flux.to(game.cam, 0.8, { zoom = 3 }):ease("elasticout"):delay(0.15)

	touch_controls.cross.alpha = 0
end

function ui_menu:intro_blink()
	self.intro_visible = not self.intro_visible
	self.blink_timer = ticker.new(0.5, function()
		self:intro_blink()
	end)
end

function ui_menu:start()
	sounds.intro()
	sounds.stop_menu_music()
	game.transitioning = true
	flux.to(self, 5, { titley = self.titley - 360, introy = self.introy + 340, alpha = 0 }):ease("elasticout")

	local e = "backout"
	flux.to(game, 0.6, { score_alpha = 1 }):ease(e)
	flux.to(game.cam, 0.39, { zoom = 3.5 }):ease(e):after(game.cam, 0.3, { zoom = 2.75 }):ease(e)
		:after(game.cam, 0.3, { zoom = 2.25 }):ease(e):after(game.cam, 0.3, { zoom = 2 }):ease(e)

	timer.after(1.38, function()
		enemy_manager:init()
		sounds.game_music()
		game.score = 0
		game.menu = false
		game.active = true
		game.transitioning = false
		flux.to(touch_controls.cross, 0.6, { alpha = 1})
	end)
end

function ui_menu:update(dt)
	if not self.blink_timer.isExpired() then
		self.blink_timer.update(dt)
	end
end

function ui_menu:draw()
	color_wave:send("time", love.timer.getTime())
	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.setShader(color_wave)
	love.graphics.setFont(fonts.poolparty)
	local title_text = "Frogcicle!"
	local fwidth = fonts.poolparty:getWidth(title_text)
	local fheight = fonts.paintbasic:getHeight() / 2
	local rotation = math.sin(love.timer.getTime() * 1.2) * 0.05
	love.graphics.print(title_text, WIDTH / 2, self.titley + fheight, rotation, 2, 2, fwidth / 2, fheight)
	love.graphics.setShader()

	if ui_menu.intro_visible or game.transitioning then
		love.graphics.setFont(fonts.paintbasic)
		local intro_text = "Press anywhere to start!"
		local iwidth = fonts.paintbasic:getWidth(intro_text)
		love.graphics.print(intro_text, WIDTH / 2 - iwidth / 2, self.introy)
	end

	love.graphics.setFont(fonts.paintbasic)
	love.graphics.setColor(1, 1, 1, 0.5 * self.alpha)
	local hstext = "Highscore: " .. savefile.data.highscore
	local iwidth = fonts.paintbasic:getWidth(hstext)
	love.graphics.print(hstext, WIDTH / 2 - iwidth / 2, self.introy + 38)
	love.graphics.setColor(1, 1, 1, 1)
end

return ui_menu
