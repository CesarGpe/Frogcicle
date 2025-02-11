local ui_score = {}

function ui_score:draw()
	local g = screen.glow + 0.01
	love.graphics.setColor(g, g, g, game.score_alpha)

	love.graphics.setFont(fonts.paintbasic)
	local score = "Score: " .. math.floor(game.score)
	local swidth = fonts.paintbasic:getWidth(score)
	love.graphics.print(score, WIDTH / 2 - swidth / 2, HEIGHT - 200)

	local minleft = math.floor(game.time_left / 60)
	local secleft = math.floor(game.time_left % 60)
	--local minpass = math.floor(game.elapsed / 60)
	--local secpass = math.floor(game.elapsed % 60)
	local time = string.format("%02d:%02d", minleft, secleft)
	--local time = string.format("%02d:%02d", minleft, secleft) .. " / " .. string.format("%02d:%02d", minpass, secpass)

	local twidth = fonts.paintbasic:getWidth(time)
	love.graphics.print(time, WIDTH / 2 - twidth / 2, HEIGHT - 536)

	love.graphics.setColor(1, 1, 1, 1)
end

return ui_score
