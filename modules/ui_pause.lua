local ui_pause = {
	texty = 150,
	alpha = 0,
}

function ui_pause:switch(active)
	-- make some sounds or animations idk
	if active then
		sounds.play("pause", 0.25)
		sounds.game_music:pause()
		flux.to(self, 0.15, { alpha = 1, texty = 250 })
		flux.to(screen, 0.15, { noiselvl = 0.06, glitchlvl = 0.9 })
	else
		sounds.game_music:play()
		flux.to(self, 0.15, { alpha = 0, texty = 150 })
		flux.to(screen, 0.15, { noiselvl = 0.012, glitchlvl = 0 })
	end
end

function ui_pause:draw()
	if self.alpha <= 0 then return end

	love.graphics.setColor(0, 0, 0, self.alpha * 0.35)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)

	love.graphics.setColor(1, 1, 1, self.alpha)
	love.graphics.setFont(fonts.paintbasic)
	local ptext = "Game paused."
	local pwidth = fonts.paintbasic:getWidth(ptext)
	love.graphics.print(ptext, WIDTH / 2 - pwidth / 2, self.texty)

	love.graphics.setColor(1, 1, 1, 1)
end

return ui_pause
