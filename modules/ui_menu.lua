-- manages everything for the title screen
local ui = {}
local wave = love.graphics.newShader("shader/title_wave.fs")

function ui:load()
	self.dress = suit.new()

	self.alpha = 1
	self.intro_visible = true
	self.titley = (HEIGHT / 2) - 460
	self.introy = (HEIGHT / 2) + 400
	self.lang_button = {
		x = 0,
		y = 0,
	}
	self.blink_timer = ticker.new(0.5, function()
		self:intro_blink()
	end)

	timer.after(0.5, function() game.waiting = true end)
	flux.to(self, 0.6, { titley = self.titley + 360, introy = self.introy - 340 }):ease("elasticout"):delay(0.15)
	flux.to(game.cam, 0.8, { zoom = 3 }):ease("elasticout"):delay(0.15)

	ui_gameover.anim = false
	sounds.count_score:stop()
	sounds.highscore:stop()
	sounds.music("menu", 0.35)

	touch_controls.alpha = 0
	touch_controls.joy_enabled = false
end

function ui:intro_blink()
	self.intro_visible = not self.intro_visible
	self.blink_timer = ticker.new(0.5, function()
		self:intro_blink()
	end)
end

function ui:start()
	sounds.play("game-intro", 0.35)
	sounds.music()
	game.cam.trauma = 0.37
	game.transitioning = true
	flux.to(self, 5, { titley = self.titley - 360, introy = self.introy + 340, alpha = 0 }):ease("elasticout")

	local e = "backout"
	flux.to(ui_score.time.color, 0.6, { a = 1 }):ease(e)
	flux.to(ui_score.score.color, 0.6, { a = 1 }):ease(e)
	flux.to(game.cam, 0.39, { zoom = 4 }):ease(e):after(game.cam, 0.3, { zoom = 3.25 }):ease(e)
		:after(game.cam, 0.3, { zoom = 2.5 }):ease(e):after(game.cam, 0.3, { zoom = 2 }):ease(e)

	timer.after(1.38, function()
		enemy_manager:init()
		game.score = 0
		game.menu = false
		game.active = true
		game.transitioning = false
		sounds.music("game", 0.25)

		flux.to(touch_controls, 1, { alpha = 1 })
		touch_controls.joy_enabled = true
	end)
end

function ui:update(dt)
	self.dress:updateMouse(game.coords(love.mouse.getPosition()))
	if not self.blink_timer.isExpired() then
		self.blink_timer.update(dt)
	end
	
	local lang_swap = "English"
	if savefile.data.lang == "en_US" then
		lang_swap = "Español"
	end
	local lang_button = self.dress:Button(lang_swap, 760, self.introy + 16, 90, 40)
	if lang_button.hit then
		if savefile.data.lang == "en_US" then
			savefile.data.lang = "es_MX"
		else
			savefile.data.lang = "en_US"
		end
		savefile:save()
	end
	if lang_button.hovered then
		game.mouse_in_button = true
	end
end

function ui:draw()
	wave:send("time", love.timer.getTime())
	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.setShader(wave)
	love.graphics.setFont(fonts.poolparty)
	local title_text = "Frogcicle!"
	local fwidth = fonts.poolparty:getWidth(title_text)
	local fheight = fonts.paintbasic:getHeight() / 2
	local rotation = math.sin(love.timer.getTime() * 1.2) * 0.05
	love.graphics.print(title_text, WIDTH / 2, self.titley + fheight, rotation, 2, 2, fwidth / 2, fheight)
	love.graphics.setShader()

	if self.intro_visible or game.transitioning then
		love.graphics.setFont(fonts.paintbasic)
		love.graphics.setColor(1, 1, 1, self.alpha)
		local intro_text = lang.localize("main_menu", "start_btn")
		local iwidth = fonts.paintbasic:getWidth(intro_text)
		love.graphics.print(intro_text, WIDTH / 2 - iwidth / 2, self.introy)
	end

	love.graphics.setFont(fonts.paintbasic)
	love.graphics.setColor(1, 1, 1, 0.5 * self.alpha)
	local hstext = lang.localize("general", "highscore") .. savefile.data.highscore
	local iwidth = fonts.paintbasic:getWidth(hstext)
	love.graphics.print(hstext, WIDTH / 2 - iwidth / 2, self.introy + 38)

	self.dress:draw()
end

return ui
