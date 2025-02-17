local TEsound = require("libs.tesound")
local sounds = {
	count_score = love.audio.newSource("assets/sound/count-score.ogg", "static"),
	count_end = love.audio.newSource("assets/sound/count-end.ogg", "static"),
	highscore = love.audio.newSource("assets/sound/highscore.ogg", "static"),

	active_music = nil,
	music_volume = 1,
	music_tracks = {
		game = love.audio.newSource("assets/sound/game-loop.ogg", "stream"),
		menu = love.audio.newSource("assets/sound/main-menu.ogg", "stream"),
		death = love.audio.newSource("assets/sound/game-over.ogg", "stream"),
		high = love.audio.newSource("assets/sound/new-best.ogg", "stream"),
	},
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

function sounds.music(music, volume, loop)
	volume = volume or 1
	loop = loop or true

	if sounds.active_music then sounds.active_music:pause() end
	if music then
		sounds.music_volume = volume
		sounds.active_music = sounds.music_tracks[music]
		sounds.active_music:setLooping(loop)
		sounds.active_music:setVolume(volume)
		sounds.active_music:play()
	end
end

function sounds.update()
	TEsound.cleanup()
	if sounds.active_music then
		sounds.active_music:setVolume(sounds.music_volume)
	end
end

return sounds
