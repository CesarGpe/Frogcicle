-----------------------------
-- TRY TO MAKE VIRTUAL JOY --
-----------------------------

--math functions
local function dist(x1, y1, x2, y2) return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5 end
local vjoy = {}

function vjoy.new(mode, x, y, ray, t, activeRay, joyImg, stickImg)
	local self = {}
	self.mode, self.x, self.y, self.r, self.jImg, self.sImg = mode, x, y, ray, joyImg, stickImg
	self.stickX, self.stickY = self.x, self.y

	self.distance = 0
	self.angle = 0
	self.isDown = false
	self.heldId = nil

	self.originalX, self.originalY = self.x, self.y
	local touchuAngle = 0

	if t ~= nil then
		self.fadeTime = t
	else
		self.fadeTime = .1
	end

	if activeRay ~= nil then
		self.aR = activeRay
	else
		self.aR = 1.8
	end

	self.draw = function(r, g, b, a, dmode, r2, g2, b2, a2)
		r = r or 1
		g = g or 1
		b = b or 1
		a = a or 1

		r2 = r2 or 1
		g2 = g2 or 1
		b2 = b2 or 1
		a2 = a2 or 1

		if dmode == nil then dmode = "line" end

		love.graphics.setColor(r, g, b, a)
		if self.jImg ~= nil then
			local scaling = self.jImg:getWidth() / 2 / self.r
			love.graphics.draw(self.jImg, self.x, self.y, 0, 1 / scaling, 1 / scaling, self.jImg:getWidth() / 2,
				self.jImg:getHeight() / 2)
		else
			love.graphics.circle(dmode, self.x, self.y, self.r)
		end
		love.graphics.setColor(r2, g2, b2, a2)
		if self.sImg ~= nil then
			local scaling = self.sImg:getWidth() / 2 / self.r * 2
			love.graphics.draw(self.sImg, self.stickX, self.stickY, 0, 1 / scaling, 1 / scaling, self.sImg:getWidth() / 2,
				self.sImg:getHeight() / 2)
		else
			love.graphics.circle(dmode, self.stickX, self.stickY, self.r * .5)
		end
		-- love.graphics.reset()
	end

	self.update = function(dt)
		self.distance = dist(self.stickX, self.stickY, self.x, self.y) / self.r
		self.angle = math.atan2(self.y - self.stickY, self.x - self.stickX)

		if not self.isDown then
			self.stickX, self.stickY = self.stickX - ((self.stickX - self.x) / self.fadeTime * dt),
				self.stickY - ((self.stickY - self.y) / self.fadeTime * dt)
		end
	end

	self.pressed = function(id, x, y, dx, dy)
		if dist(x, y, self.x, self.y) < self.r * self.aR and self.heldId == nil then
			self.heldId = id
			self.isDown = true
			if self.mode == "free" then
				self.x, self.y = x, y
				self.stickX, self.stickY = x, y
			elseif self.mode == "fixed" then
				touchuAngle = math.atan2(y - self.y, x - self.x)
				if dist(x, y, self.x, self.y) > self.r then
					self.stickX = self.x + math.cos(touchuAngle) * self.r
					self.stickY = self.y + math.sin(touchuAngle) * self.r
				else
					self.stickX, self.stickY = x, y
				end
			end
		end
	end

	self.released = function(id, x, y, dx, dy)
		if self.heldId == id then
			self.isDown = false
			self.heldId = nil
			if self.mode == "free" then
				self.x, self.y = self.originalX, self.originalY
			end
		end
	end

	self.moved = function(id, x, y, dx, dy)
		if self.heldId == id then
			touchuAngle = math.atan2(y - self.y, x - self.x)
			if dist(x, y, self.x, self.y) > self.r then
				self.stickX = self.x + math.cos(touchuAngle) * self.r
				self.stickY = self.y + math.sin(touchuAngle) * self.r
			else
				self.stickX, self.stickY = x, y
			end
		end
	end

	---------------------------
	--FUNCTIONS TO SET VALUES--
	---------------------------
	self.setFadeTime = function(t)
		self.fadeTime = t
	end

	self.setJoyX = function(x)
		self.x = x
	end

	self.setJoyY = function(y)
		self.y = y
	end

	self.setJoyPosition = function(x, y)
		self.x, self.y = x, y
	end

	self.setActiveRay = function(r)
		self.aR = r
	end

	self.setJoyRay = function(r)
		self.r = r
	end

	self.setJoyImg = function(img)
		self.jImg = img
	end

	self.setStickImg = function(img)
		self.sImg = img
	end

	---------------------------
	--FUNCTIONS TO GET VALUES--
	---------------------------

	self.getAxis = function(dP)
		local decimal_Places
		if dP == nil then
			decimal_Places = 2
		else
			decimal_Places = math.floor(dP)
		end

		local axisX = math.floor((self.stickX - self.x) / self.r * 10 ^ decimal_Places) / 10 ^ decimal_Places
		local axisY = math.floor((self.stickY - self.y) / self.r * 10 ^ decimal_Places) / 10 ^ decimal_Places
		return axisX, -axisY
	end

	self.getX = function(dP)
		local decimal_Places
		if dP == nil then
			decimal_Places = 3
		else
			decimal_Places = math.floor(dP)
		end
		return math.floor((self.stickX - self.x) / self.r * 10 ^ decimal_Places) / 10 ^ decimal_Places
	end

	self.getY = function(dP)
		local decimal_Places
		if dP == nil then
			decimal_Places = 3
		else
			decimal_Places = math.floor(dP)
		end
		return math.floor((self.stickY - self.y) / self.r * 10 ^ decimal_Places) / 10 ^ decimal_Places
	end

	self.getJoyPosition = function()
		return self.x, self.y
	end

	self.getJoyY = function()
		return self.y
	end

	self.getJoyX = function()
		return self.x
	end


	self.getAngle = function()
		return self.angle
	end

	self.getAngleDeg = function()
		return self.angle / math.pi * 180
	end

	self.getAngleGrad = function()
		return self.angle * 200 / math.pi
	end

	self.getActiveRay = function()
		return self.aR * self.r
	end

	self.getRay = function()
		return self.r
	end

	return self
end

return vjoy
