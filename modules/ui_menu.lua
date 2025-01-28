local color_wave = love.graphics.newShader("shader/color_wave.fs")
local ui_menu = {
    intro_visible = true,
    titley = -20,
    introy = 600,
}

function ui_menu:load()
    self.intro_visible = true
    self.show = true
    self.titley = -20
    self.introy = 600

    timers.oneshot(0.5, function() game.can_click = true end)
    timers.oneshot(0.15, function()
        flux.to(ui_menu, 1, { titley = 170, introy = 340 }):ease("cubicout"):oncomplete(intro_blink)
        flux.to(game.cam, 0.25, { zoom = 2 }):ease("sineout")
    end)
end

function intro_blink()
    ui_menu.intro_visible = not ui_menu.intro_visible
    timers.oneshot(0.5, intro_blink)
end

function ui_menu:start()
    sounds.intro()
    sounds.stop_menu_music()
    game.transitioning = true

    flux.to(ui_menu, 1, { titley = -20, introy = 500 }):ease("elasticout")

    local ease = "backout"
    flux.to(game.cam, 0.39, { zoom = 2.5 }):ease(ease)
    timers.oneshot(0.39, function() flux.to(game.cam, 0.3, { zoom = 1.75 }):ease(ease) end)
    timers.oneshot(0.69, function() flux.to(game.cam, 0.3, { zoom = 1.25 }):ease(ease) end)
    timers.oneshot(0.99, function() flux.to(game.cam, 0.3, { zoom = 1 }):ease(ease) end)
    timers.oneshot(0.8, function() game.menu = false end)

    timers.oneshot(1.38, function()
        game.enemy_manager:init()
        sounds.game_music()
        game.score = 0
        game.active = true
        game.transitioning = false
    end)
end

function ui_menu:draw()
    color_wave:send("time", love.timer.getTime())
    love.graphics.setShader(color_wave)
    love.graphics.setFont(fonts.poolparty)
    love.graphics.setColor(1, 1, 1, 1)
    local title_text = "Frogcicle!"
    local fwidth = fonts.poolparty:getWidth(title_text)
    love.graphics.print(title_text, WIDTH / 2 - fwidth, ui_menu.titley, 0, 2, 2)
    love.graphics.setShader()

    if ui_menu.intro_visible then
        love.graphics.setFont(fonts.paintbasic)
        love.graphics.setColor(1, 1, 1, 1)
        local intro_text = "Press anywhere to start!"
        local iwidth = fonts.paintbasic:getWidth(intro_text)
        love.graphics.print(intro_text, WIDTH / 2 - iwidth / 2, ui_menu.introy)
    end
end

return ui_menu
