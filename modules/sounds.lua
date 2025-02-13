require("libs.tesound")
sounds = {
	game_music = love.audio.newSource("assets/sound/game-loop.ogg", "stream"),
	menu_music = love.audio.newSource("assets/sound/lofi-menu.ogg", "stream"),
	death_music = love.audio.newSource("assets/sound/game-over.ogg", "stream"),
	count_score = love.audio.newSource("assets/sound/count-score.ogg", "static"),
	highscore = love.audio.newSource("assets/sound/highscore2.ogg", "static"),
}

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

function sounds.die()
	TEsound.play("assets/sound/die.ogg", "static", "die", 0.1, 1)
end

function sounds.pause()
	TEsound.play("assets/sound/pause.ogg", "static", "pause", 0.25, 1)
end

function sounds.update()
	TEsound.cleanup()
end
