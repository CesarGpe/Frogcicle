-- everything for the pause menu, just the pause button is in main.lua
local ui_pause = {
	texty = 150,
	alpha = 0,
}
local pause_sound = love.audio.newSource("assets/sound/pause.ogg", "static")

-- switches the pause screen on and off
function ui_pause:switch()
	game.paused = not game.paused
	if game.paused then
		pause_sound:setVolume(0.25)
		pause_sound:stop()
		pause_sound:play()
		flux.to(sounds, 0.5, { music_volume = 0 })
		flux.to(self, 0.15, { alpha = 1, texty = 250 })
		flux.to(screen, 0.15, { noiselvl = 0.065, glitchlvl = 0.9 })
	else
		flux.to(sounds, 0.15, { music_volume = 0.25 })
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

	love.graphics.setColor(1, 1, 1, self.alpha * 0.35)
	local utext = "Esc to unpause"
	local uwidth = fonts.paintbasic:getWidth(utext)
	love.graphics.print(utext, WIDTH / 2 - uwidth / 2, self.texty + 30)

	love.graphics.setColor(1, 1, 1, 1)
end

return ui_pause
