local ui = {}

function ui:start(delay)
	self.sound_pitch = 1
	self.cur_score = 0
	self.target_score = math.floor(game.score)
	self.text_alpha = 0
	self.text_anim = false
	self.new_hs = false
	self.player_twn = {}

	timer.after(delay, function()
		local t = 2
		local playpos = { x = player.body:getX(), y = player.body:getY() }
		self.player_twn = flux.to(playpos, t, { x = WIDTH / 2, y = HEIGHT / 2 }):ease("sineout"):onupdate(function()
			player.body:setX(playpos.x)
			player.body:setY(playpos.y)
		end):oncomplete(function ()
			self.text_anim = true
			game.waiting = true
		end)
		flux.to(game.cam, t, { zoom = 4 })
	end)

	game.music_timer = ticker.new(delay + 0.5, function()
		sounds.death_music:setLooping(true)
		sounds.death_music:setVolume(0.08)
		sounds.death_music:play()
		flux.to(self, 1, { text_alpha = 1 })
	end)

	sounds.die()
	sounds.game_music:stop()
	enemy_manager:kill_everyone()
	proj_manager:kill_all()
	game.active = false
	game.over = true
	player.die()
	ui_score:score_anim()

	touch_controls.joy_enabled = false
	flux.to(touch_controls, 0.6, { alpha = 0 })
end

function ui:update(dt)
	if self.text_anim then
		self.cur_score = self.cur_score + 500 * dt

		sounds.count_score:setLooping(true)
		sounds.count_score:setVolume(0.08)
		sounds.count_score:play()

		if self.cur_score >= self.target_score then
			self.cur_score = self.target_score
			self.text_anim = false
			sounds.highscore:setVolume(0.5)
			sounds.highscore:play()
			sounds.count_score:stop()
		end
	end
end

function ui:draw()
	love.graphics.setFont(fonts.paintbasic)
	love.graphics.setColor(1, 1, 1, self.text_alpha)

	local rstext = "Press anywhere to respawn."
	local rswidth = fonts.paintbasic:getWidth(rstext)
	love.graphics.print(rstext, player.x + player.offsetx - rswidth / 2, player.y - 30)

	local sctext = "Score: " .. math.floor(self.cur_score)
	local scwidth = fonts.paintbasic:getWidth(sctext)
	love.graphics.print(sctext, player.x + player.offsetx - scwidth / 2, player.y + 50)

	if self.new_hs then
		local hstext = "New record!"
		local hswidth = fonts.paintbasic:getWidth(hstext) / 2
		love.graphics.setColor(1, 1, 1, self.text_alpha - 0.5)
		love.graphics.print(hstext, player.x + player.offsetx - hswidth / 2, player.y + 65, 0, 0.5, 0.5)
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return ui
