local ui_gameover = {
    text_alpha = 0
}

function ui_gameover:load()
    self.text_alpha = 0
    flux.to(game.cam, 4, { x = player.body:getX(), y = player.body:getY() })
    flux.to(game.cam, 2, { zoom = 1 })
    timer.after(1, function() game.can_click = true end)
    game.music_timer = ticker.new(1.5, function()
        sounds.death_music()
        flux.to(ui_gameover, 1, { text_alpha = 1 })
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
    --love.graphics.setColor(0, 0, 0, self.text_alpha)
    local respawn = "Press anywhere to respawn."
    local rwidth = fonts.paintbasic:getWidth(respawn)
    love.graphics.print(respawn, player.x + 12 - rwidth / 2, player.y - 40)
    love.graphics.setColor(1, 1, 1, 1)
end

return ui_gameover
