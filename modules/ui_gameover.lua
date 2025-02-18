-- manages the game over state
local ui = {}
local prt = love.graphics.newImage("assets/sprites/particle.png")
local particles = love.graphics.newParticleSystem(prt, 100)
local funky = {
	sprite = love.graphics.newImage("assets/sprites/cirno-funky.png"),
	anim = nil
}

function ui:start(delay)
	self.cur_score = 0
	self.target_score = math.floor(game.score)
	self.score = {
		color = { r = 1, g = 1, b = 1 },
		scale = 1,
		angle = 0,
		speed = 1,
	}
	self.hs = {
		new = false,
		scale = 1,
	}
	self.alpha = 0
	self.anim = false
	self.anim_over = false
	self.player_twn = {}
	self.rstext = lang.localize("gameover", "respawn")

	timer.after(delay, function()
		local t = 2
		local playpos = { x = player.body:getX(), y = player.body:getY() }
		self.player_twn = flux.to(playpos, t, { x = WIDTH / 2, y = HEIGHT / 2 }):ease("sineout"):onupdate(function()
			player.body:setX(playpos.x)
			player.body:setY(playpos.y)
		end):oncomplete(function()
			if self.target_score ~= 0 then
				self.anim = true
			end
			game.waiting = true
		end)
		flux.to(game.cam, t, { zoom = 4 })
	end)

	sounds.music()
	timer.after(delay + 0.5, function ()
		sounds.music("death", 0.08)
		flux.to(self, 1, { alpha = 1 })
	end)

	sounds.play("die", 0.1)
	enemy_manager:kill_everyone()
	proj_manager:kill_all()
	game.active = false
	game.over = true
	player.die()
	game.time_left = 0
	ui_score:gameover_anim()

	local anim8 = require("libs.anim8")
	local grid = anim8.newGrid(24, 25, funky.sprite:getWidth(), funky.sprite:getHeight())
	funky.anim = anim8.newAnimation(grid("1-8", 1), 0.05)

	particles:setColors(1, 1, 0.85, 1, 1, 1, 1, 0)
	particles:setParticleLifetime(0.5, 1)
	particles:setSpread(10)
	particles:setSpeed(30)

	touch_controls.joy_enabled = false
	flux.to(touch_controls, 0.6, { alpha = 0 })
end

function ui:update(dt)
	particles:update(dt)
	if funky.anim then
		funky.anim:update(dt)
	end

	if self.anim then
		local prev_score = math.floor(self.cur_score)
		local calc_score = self.cur_score + 280 * dt * self.score.speed
		self.cur_score = math.floor(calc_score)
		if prev_score ~= self.cur_score then
			local base = 0.008
			if self.cur_score % 3 == 0 then
				self.score.angle = base * (love.math.random() * 2 - 1) * self.score.speed
				self.score.color.b = 1
				self.score.scale = 1
			elseif self.cur_score % 3 == 1 then
				self.score.angle = 0
				self.score.color.b = 0.5 - self.score.speed * 2
				self.score.scale = 1.065
			elseif self.cur_score % 3 == 2 then
				self.score.angle = -base * (love.math.random() * 2 - 1) * self.score.speed
				self.score.color.b = 1
				self.score.scale = 1
			end
			self.score.speed = self.score.speed + 0.0015
			game.cam.trauma = self.score.speed * 0.05
		end

		sounds.count_score:setLooping(true)
		sounds.count_score:setVolume(0.1)
		sounds.count_score:play()

		if self.cur_score > self.target_score then
			self.cur_score = self.target_score
			self.anim = false
			self.anim_over = true
			sounds.count_end:setVolume(0.25)
			sounds.count_end:play()
			sounds.count_score:stop()

			if self.hs.new then
				sounds.music("high", 0.25)
				sounds.highscore:setVolume(0.5)
				sounds.highscore:play()

				flux.to(self.score.color, 0.15, { b = 0.25 }):ease("elasticin"):after(self.score.color, 0.5, { b = 0.8 })
					:ease("elasticout")
				flux.to(self.score, 0.15, { angle = 0.1 }):ease("elasticin"):after(self.score, 0.5, { angle = 0 }):ease(
					"elasticout")
				flux.to(self.score, 1, { scale = 2 }):ease("elasticout")

				game.cam.trauma = 0.22 * (self.target_score * 0.001)
				local zoom = self.target_score * 0.001
				flux.to(game.cam, 0.1, { zoom = 4 + zoom }):ease("elasticin"):after(game.cam, 0.5, { zoom = 4 })
					:ease("elasticout")

				timer.after(0.12, function()
					particles:emit(70)
				end)
			else
				flux.to(self.score, 0.5, { angle = 0 }):ease("elasticout")
				flux.to(self.score.color, 0.1, { b = 0.25 }):ease("elasticin"):after(self.score.color, 0.5, { b = 0.85 })
					:ease("elasticout")
				flux.to(self.score, 0.1, { scale = 1.15 }):ease("elasticin"):after(self.score, 0.5, { scale = 1 })
					:ease("elasticout")

				game.cam.trauma = 0.1 * (self.target_score * 0.001)
				local zoom = self.target_score * 0.00025
				flux.to(game.cam, 0.1, { zoom = 4 + zoom }):ease("elasticin"):after(game.cam, 0.5, { zoom = 4 })
					:ease("elasticout")

				particles:emit(30)
			end
		end
	end
end

function ui:draw()
	love.graphics.setFont(fonts.paintbasic)
	love.graphics.setColor(1, 1, 1, self.alpha)

	local sctext = lang.localize("general", "score") .. self.cur_score
	local scwidth = fonts.paintbasic:getWidth(sctext)
	local scheight = fonts.paintbasic:getHeight()

	particles:setEmissionArea("borderellipse", scwidth * 0.4 * self.score.scale, scheight * 0.25 * self.score.scale)
	particles:setPosition(player.x + player.offsetx, player.y + 50 + scheight / 2)
	love.graphics.draw(particles)

	local rswidth = fonts.paintbasic:getWidth(self.rstext)
	love.graphics.print(self.rstext, player.x + player.offsetx - rswidth / 2, player.y - 30)

	love.graphics.setColor(self.score.color.r, self.score.color.g, self.score.color.b, self.alpha)
	love.graphics.print(sctext, player.x + player.offsetx, player.y + 50 + scheight / 2, self.score.angle,
		self.score.scale, self.score.scale, scwidth / 2, scheight / 2)

	if self.hs.new and self.anim_over then
		love.graphics.setColor(1, 1, 1, self.alpha - 0.25)
		local hstext = lang.localize("gameover", "new_record")
		local hswidth = fonts.paintbasic:getWidth(hstext)
		love.graphics.print(hstext, player.x + player.offsetx - hswidth / 2, player.y + 72, 0, 1, 1)

		love.graphics.setColor(1, 1, 1, 1)
		funky.anim:draw(funky.sprite, player.x, player.y + 4, 0, player.scale, player.scale)
		self.rstext = lang.localize("gameover", "try_again")
	end

	love.graphics.setColor(1, 1, 1, 1)
end

return ui
