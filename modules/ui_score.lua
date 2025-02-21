-- the timer and score display ingame
local ui = {}

local btns = require("modules.button_prompts")
local avatar = love.graphics.newImage("assets/sprites/icon.png")
local prt_sprite = love.graphics.newImage("assets/sprites/particle.png")
local particles = love.graphics.newParticleSystem(prt_sprite, 100)

function ui:load()
	self.score = require("entities.rich_text").new("Score: 0", fonts.paintbasic, WIDTH / 2, HEIGHT - 190)
	self.score.last = 0
	self.time = {
		color = { r = 1, g = 1, b = 1, a = 0 },
		angle = 0,
		scale = 1,
	}

	particles:setColors(0.9, 0.27, 0.27, 1, 1, 1, 1, 0)
	particles:setPosition(WIDTH / 2, HEIGHT / 2 - 152)
	particles:setParticleLifetime(0.5, 1)
	particles:setSpread(10)
	particles:setSpeed(30)
end

function ui:update(dt)
	particles:update(dt)
end

function ui:draw()
	local minleft = math.floor(game.time_left / 60)
	local secleft = math.floor(game.time_left % 60)
	local time = string.format("%02d:%02d", minleft, secleft)
	local twidth = fonts.paintbasic:getWidth(time)
	local theight = fonts.paintbasic:getHeight()

	particles:setEmissionArea("borderellipse", twidth * 1.2, theight * 1.2)
	love.graphics.draw(particles)

	local cur_score = math.floor(game.score)
	if cur_score ~= self.score.last then
		self.score.last = cur_score

		self.score.color.b = 0.65
		flux.to(self.score.color, 0.35, { b = 1 })

		flux.to(self.score, 0.15, { y = HEIGHT - 190 - 4 }):ease("elasticin"):after(self.score, 0.35,
			{ y = HEIGHT - 190 }):ease("elasticout")
		flux.to(self.score, 0.15, { angle = 0.1 * (love.math.random() * 2 - 1) }):ease("elasticin"):after(self.score, 0.5,
			{ angle = 0 }):ease("elasticout")
	end
	self.score.text = lang.localize("general", "score") .. cur_score
	self.score:draw()

	love.graphics.setFont(fonts.paintbasic)
	love.graphics.setColor(self.time.color.r, self.time.color.g, self.time.color.b, self.time.color.a)
	love.graphics.print(time, WIDTH / 2, HEIGHT - 536, self.time.angle, self.time.scale, self.time.scale, twidth / 2)

	btns.draw()

	talkies.draw()
	love.graphics.setColor(1, 1, 1, 0.8)
	love.graphics.draw(avatar, 325, talkies.offsety + 456)
	love.graphics.setColor(1, 1, 1, 1)
end

function ui:gameover_anim()
	flux.to(self.time, 0.15, { angle = 0.2 }):ease("elasticin"):after(self.time, 0.5, { angle = 0 }):ease("elasticout")
	flux.to(self.time.color, 1, { g = 0.5, b = 0.5 }):ease("elasticout")
	flux.to(self.time, 1.5, { scale = 3 }):ease("elasticout")
	flux.to(self.score.color, 0.25, { a = 0 })
	timer.after(0.18, function()
		particles:emit(60)
	end)
end

function ui:start_anim()
	flux.to(self.time, 0.25, { angle = 0.2 }):ease("elasticin"):after(self.time, 0.5, { angle = 0 }):ease("elasticout")
	flux.to(self.time, 0.25, { scale = 2 }):ease("elasticin"):after(self.time, 0.5, { scale = 1 }):ease("elasticout")
	flux.to(self.time.color, 0.25, { b = 0.5 }):ease("elasticin"):after(self.time.color, 0.5, { b = 1 }):ease(
		"elasticout")
end

return ui
