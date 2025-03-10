local projectile = require("entities.proj")
local splash = require("entities.splash")
local manager = {
	projectiles = {},
	splashes = {}
}

function manager:new_proj(x, y, dx, dy, angle)
	local proj = projectile.new(x, y, dx, dy, angle)
	table.insert(self.projectiles, proj)
end

function manager:kill_all()
	for i = #self.projectiles, 1, -1 do
		if not self.projectiles[i].body:isDestroyed() then
			self.projectiles[i]:destroy()
		end
	end
	self.projectiles = {}
end

function manager:update(dt)
	for i = #self.projectiles, 1, -1 do
		local p = self.projectiles[i]
		if not p.body:isDestroyed() then
			local cons = p.body:getContacts()
			if #cons ~= 0 then
				for _, c in pairs(cons) do
					local a, b = c:getFixtures()
					for _, f in pairs({ a, b }) do
						if f:getCategory() == collision_masks.enemy then
							f:getUserData():freeze(p.angle)
							break
						elseif f:getCategory() == collision_masks.wall then
							table.insert(self.splashes, splash.new(p.body:getX(), p.body:getY()))
							break
						end
					end
				end
				sounds.play("ice-hit", 0.25)
				p:destroy()
				table.remove(self.projectiles, i)
			else
				p:update()
			end
		else
			table.remove(self.projectiles, i)
		end
	end

	for i = #self.splashes, 1, -1 do
		local s = self.splashes[i]
		s:update(dt)
		if s.elapsed > 1 then
			s:destroy()
			table.remove(self.splashes, i)
		end
	end
end

return manager
