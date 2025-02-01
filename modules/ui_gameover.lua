local ui_gameover = {}

function ui_gameover:load()
    self.text_alpha = 0
    self.new_hs = false

    timer.after(1, function()
        flux.to(game.cam, 3, { x = player.body:getX(), y = player.body:getY() })
        flux.to(game.cam, 2, { zoom = 1 })
        game.can_click = true
    end)
    game.music_timer = ticker.new(1.5, function()
        sounds.death_music()
        flux.to(self, 1, { text_alpha = 1 })
    end)
    sounds.stop_game_music()
    enemy_manager:kill_everyone()
    proj_manager:kill_all()
    game.active = false
    game.over = true
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
