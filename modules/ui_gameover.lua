local ui_gameover = {}

function ui_gameover:load(delay)
	self.text_alpha = 0
	self.new_hs = false

	timer.after(delay, function()
		local t = 2
		local playpos = { x = player.body:getX(), y = player.body:getY() }
		flux.to(playpos, t, { x = WIDTH / 2, y = HEIGHT / 2 }):ease("sineout")
		timer.during(t, function()
			player.body:setX(playpos.x)
			player.body:setY(playpos.y)
		end)

		flux.to(game.cam, t, { zoom = 4 })
		game.waiting = true
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

	touch_controls.joy_enabled = false
	flux.to(touch_controls, 0.6, { alpha = 0 })
end

function ui_gameover:draw()
	love.graphics.setFont(fonts.paintbasic)
	love.graphics.setColor(1, 1, 1, self.text_alpha)

	local rstext = "Press anywhere to respawn."
	local rswidth = fonts.paintbasic:getWidth(rstext)
	love.graphics.print(rstext, player.x + player.offsetx - rswidth / 2, player.y - 30)

	local sctext = "Score: " .. math.floor(game.score)
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

return ui_gameover
