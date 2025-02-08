local ui_score = {}

function ui_score:draw()
	love.graphics.setColor(1, 1, 1, game.score_alpha)

	love.graphics.setFont(fonts.paintbasic)
	local score = "Score: " .. math.floor(game.score)
	local swidth = fonts.paintbasic:getWidth(score)
	love.graphics.print(score, WIDTH / 2 - swidth / 2, HEIGHT - 200)
	--love.graphics.print(score, WIDTH / 2 - swidth / 2, (HEIGHT / 2) + 185)

	local minleft = math.floor(game.time_left / 60)
	local secleft = math.floor(game.time_left % 60)
	--local minpass = math.floor(game.elapsed / 60)
	--local secpass = math.floor(game.elapsed % 60)
	local time = string.format("%02d:%02d", minleft, secleft) --[[.. " / " .. string.format("%02d:%02d", minpass, secpass)]]

	--love.graphics.setColor(0.45 * game.frozen_enemies, 0.75 * game.frozen_enemies, 0.98 * game.frozen_enemies, game.score_alpha)
	love.graphics.setColor(1 - 0.55 * game.frozen_enemies * 0.06, 1 - 0.25 * game.frozen_enemies * 0.06, 1 - 0.02 * game.frozen_enemies * 0.06, game.score_alpha)
	local twidth = fonts.paintbasic:getWidth(time)
	love.graphics.print(time, WIDTH / 2 - twidth / 2, HEIGHT - 536)
	--love.graphics.print(time, WIDTH / 2 - twidth / 2, (HEIGHT / 2) - 190)

	love.graphics.setColor(1, 1, 1, 1)
end

return ui_score
