local ui = {}

function ui:load()
	self.time = {
		color = { r = 1, g = 1, b = 1, a = 0 },
		angle = 0,
		scale = 1,
	}
	self.score = {
		color = { r = 1, g = 1, b = 1, a = 0 },
	}
end

function ui:draw()
	love.graphics.setColor(1, 1, 1, self.score.color.a)
	love.graphics.setFont(fonts.paintbasic)
	local score = "Score: " .. math.floor(game.score)
	local swidth = fonts.paintbasic:getWidth(score)
	love.graphics.print(score, WIDTH / 2 - swidth / 2, HEIGHT - 200)

	love.graphics.setColor(self.time.color.r, self.time.color.g, self.time.color.b, self.time.color.a)
	local minleft = math.floor(game.time_left / 60)
	local secleft = math.floor(game.time_left % 60)
	--local minpass = math.floor(game.elapsed / 60)
	--local secpass = math.floor(game.elapsed % 60)
	--local time = string.format("%02d:%02d", minleft, secleft) .. " / " .. string.format("%02d:%02d", minpass, secpass)
	local time = string.format("%02d:%02d", minleft, secleft)
	local twidth = fonts.paintbasic:getWidth(time)
	local theight = fonts.paintbasic:getHeight()
	love.graphics.print(time, WIDTH / 2, HEIGHT - 536, self.time.angle, self.time.scale, self.time.scale, twidth / 2)

	love.graphics.setColor(1, 1, 1, 1)
end

function ui:score_anim()
	flux.to(self.time, 0.15, { angle = 0.2 }):ease("elasticin"):after(self.time, 0.5, { angle = 0 }):ease("elasticout")
	flux.to(self.time.color, 1, { g = 0.5, b = 0.5 }):ease("elasticout")
	flux.to(self.time, 1.5, { scale = 3 }):ease("elasticout")
	flux.to(self.score.color, 0.25, { a = 0 })
end

return ui
