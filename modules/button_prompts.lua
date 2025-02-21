local btns = {}

local joyleft = love.graphics.newImage("assets/sprites/joystick-left.png")
local joyright = love.graphics.newImage("assets/sprites/joystick-right.png")
local bumpers = love.graphics.newImage("assets/sprites/bumpers.png")

local wasd = love.graphics.newImage("assets/sprites/wasd.png")
local mouses = love.graphics.newImage("assets/sprites/mouses.png")

function btns.draw()
	if game.gamepad then
		love.graphics.draw(joyleft, 316, 218)
		love.graphics.print(lang.localize("controls", "move"), 336, 220)
		love.graphics.draw(joyright, 316, 236)
		love.graphics.print(lang.localize("controls", "look"), 336, 238)
		love.graphics.draw(bumpers, 316, 254)
		love.graphics.print(lang.localize("controls", "shoot"), 352, 256)
	elseif not game.mobile then
		love.graphics.print(lang.localize("controls", "move") .. ":", 316, 220)
		love.graphics.draw(wasd, 316, 236)
		love.graphics.print(lang.localize("controls", "shoot") .. ":", 320, 264)
		love.graphics.draw(mouses, 320, 280)
	end
end

return btns
