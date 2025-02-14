require("libs.tesound")
sounds = {
	game_music = love.audio.newSource("assets/sound/game-loop.ogg", "stream"),
	menu_music = love.audio.newSource("assets/sound/lofi-menu.ogg", "stream"),
	death_music = love.audio.newSource("assets/sound/game-over.ogg", "stream"),
	count_score = love.audio.newSource("assets/sound/count-score.ogg", "static"),
	count_end = love.audio.newSource("assets/sound/highscore.ogg", "static"),
	highscore = love.audio.newSource("assets/sound/highscore2.ogg", "static"),
}

-- plays a static sound from a string, or a random sound from a list
function sounds.play(sound, volume, pitch)
	if not sound then return end
	volume = volume or 1
	pitch = pitch or 1
	if type(sound) == "table" then
		local soundlist = {}
		for _, s in pairs(sound) do
			table.insert(soundlist, "assets/sound/" .. s .. ".ogg")
		end
		TEsound.play(soundlist, "static", sound, volume, pitch)
	else
		TEsound.play("assets/sound/" .. sound .. ".ogg", "static", sound, volume, pitch)
	end
end

function sounds.update()
	TEsound.cleanup()
end

function sounds.defreeze()
	TEsound.play({ "assets/sound/ice-crack1.ogg", "assets/sound/ice-crack2.ogg", "assets/sound/ice-crack3.ogg" }, "static", "defreeze", 1, 1)
end

function sounds.df_chime()
	TEsound.play({ "assets/sound/ice-break1.ogg", "assets/sound/ice-break2.ogg", "assets/sound/ice-break3.ogg" }, "static", "df_chime", 0.5, 1)
end