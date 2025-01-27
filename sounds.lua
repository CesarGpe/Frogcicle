require("libs.tesound")
sounds = {}

function sounds.leap()
    TEsound.play("sound/frog-leap.ogg", "static", "leap", 0.6, 1)
end
function sounds.croak()
    TEsound.play("sound/frog-croak.ogg", "static", "croak", 0.35, 1)
end
function sounds.shoot()
    TEsound.play("sound/freeze-shot.ogg", "static", "shoot", 0.25, 1)
end
function sounds.hit()
    TEsound.play("sound/freeze-hit.ogg", "static", "hit", 0.25, 1)
end
function sounds.freeze()
    TEsound.play("sound/chime.ogg", "static", "freeze", 0.6, 1)
end
function sounds.defreeze()
    TEsound.play({"sound/ice-crack1.ogg", "sound/ice-crack2.ogg", "sound/ice-crack3.ogg"}, "static", "defreeze", 1, 1)
end
function sounds.df_chime()
    TEsound.play({"sound/ice-break1.ogg", "sound/ice-break2.ogg", "sound/ice-break3.ogg"}, "static", "df_chime", 0.5, 1)
end

function sounds.intro()
    TEsound.play("sound/game-intro.ogg", "static", "intro", 0.35, 1)
end
function sounds.game_music()
    local music = love.audio.newSource("sound/game-loop.ogg", "stream")
    music:setLooping(true)
    music:setVolume(0.25)
    music:play()
end

local menu_music = love.audio.newSource("sound/lofi-menu.ogg", "stream")
function sounds.menu_music()
    menu_music:setLooping(true)
    menu_music:setVolume(0.35)
    menu_music:play()
end
function sounds.stop_menu_music()
    menu_music:stop()
end

function sounds.update()
    TEsound.cleanup()
end