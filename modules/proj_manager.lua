local manager = {
	projectiles = {}
}

function manager:new_proj(x, y, dx, dy, angle)
	local proj = newProj(x, y, dx, dy, angle)
	proj:load()
	table.insert(self.projectiles, proj)
end

function manager:kill_all()
	for i = #self.projectiles, 1, -1 do
		self.projectiles[i]:destroy()
	end
end

function manager:update()
	for i = #self.projectiles, 1, -1 do
		local p = self.projectiles[i]
		if not p.body:isDestroyed() then
			local cons = p.body:getContacts()
			if #cons ~= 0 then
				for _, c in pairs(cons) do
					local a, b = c:getFixtures()
					for _, f in pairs({ a, b }) do
						if f:getCategory() == collision_masks.enemy then
							f:getUserData():freeze()
							break
						end
					end
				end
				p:destroy()
				sounds.hit()
			else
				p:update()
			end
		else
			table.remove(self.projectiles, i)
		end
	end
end

return manager
