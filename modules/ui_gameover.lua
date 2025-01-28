local ui_gameover = {
    text_alpha = 0
}

function ui_gameover:load()
    self.text_alpha = 0
    timers.oneshot(1, function() game.can_click = true end)
    game.music_timer = timers.new(2, function()
        sounds.death_music()
        flux.to(ui_gameover, 2.5, { text_alpha = 1 })
    end)
    sounds.stop_game_music()
    game.enemy_manager:kill_everyone()
    game.proj_manager:kill_all()
    game.active = false
    game.over = true
end

function ui_gameover:draw()
    love.graphics.setFont(fonts.paintbasic)
    love.graphics.setColor(0, 0, 0, self.text_alpha)
    local respawn = "Press anywhere to respawn."
    local rwidth = fonts.paintbasic:getWidth(respawn)
    love.graphics.print(respawn, player.x + 12 - rwidth / 2, player.y - 40)
end

return ui_gameover
