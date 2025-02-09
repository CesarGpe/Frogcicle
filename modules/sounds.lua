require("libs.tesound")
sounds = {}

function sounds.leap()
	TEsound.play("assets/sound/frog-leap.ogg", "static", "leap", 0.6, 1)
end

function sounds.croak()
	TEsound.play("assets/sound/frog-croak.ogg", "static", "croak", 0.6, 1)
end

function sounds.shoot()
	TEsound.play("assets/sound/ice-shot.ogg", "static", "shoot", 0.25, 1)
end

function sounds.hit()
	TEsound.play("assets/sound/ice-hit.ogg", "static", "hit", 0.25, 1)
end

function sounds.freeze()
	TEsound.play("assets/sound/chime.ogg", "static", "freeze", 0.6, 1)
end

function sounds.defreeze()
	TEsound.play({ "assets/sound/ice-crack1.ogg", "assets/sound/ice-crack2.ogg", "assets/sound/ice-crack3.ogg" }, "static", "defreeze", 1, 1)
end

function sounds.df_chime()
	TEsound.play({ "assets/sound/ice-break1.ogg", "assets/sound/ice-break2.ogg", "assets/sound/ice-break3.ogg" }, "static", "df_chime", 0.5, 1)
end

function sounds.intro()
	TEsound.play("assets/sound/game-intro.ogg", "static", "intro", 0.35, 1)
end

local game_music = love.audio.newSource("assets/sound/game-loop.ogg", "stream")
function sounds.game_music()
	game_music:setLooping(true)
	game_music:setVolume(0.25)
	game_music:play()
end

function sounds.stop_game_music()
	game_music:stop()
end

local menu_music = love.audio.newSource("assets/sound/lofi-menu.ogg", "stream")
function sounds.menu_music()
	menu_music:setLooping(true)
	menu_music:setVolume(0.35)
	menu_music:play()
end

function sounds.stop_menu_music()
	menu_music:stop()
end

local death_music = love.audio.newSource("assets/sound/game-over.ogg", "stream")
function sounds.death_music()
	death_music:setLooping(true)
	death_music:setVolume(0.08)
	death_music:play()
end

function sounds.stop_death_music()
	death_music:stop()
end

function sounds.update()
	TEsound.cleanup()
end
