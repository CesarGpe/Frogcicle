local ui_score = {}

function ui_score:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(fonts.paintbasic)
    local score = "Score: " .. math.floor(game.score)
    local swidth = fonts.paintbasic:getWidth(score)
    love.graphics.print(score, WIDTH / 2 - swidth / 2, 460)

    local minutes = math.floor(game.time_left / 60)
    local seconds = math.floor(game.time_left % 60)
    local time = string.format("%02d:%02d", minutes, seconds)
    local twidth = fonts.paintbasic:getWidth(time)
    love.graphics.print(time, WIDTH / 2 - twidth / 2, 70)
end

return ui_score
