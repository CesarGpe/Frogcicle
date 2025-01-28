local drawer = {}
local dproj_sprite = love.graphics.newImage("sprites/ice-break.png")

function drawer.draw(enemies, projectiles)
    for _, e in pairs(enemies) do
		e:draw_shadow()
	end
	player.draw_shadow()

	local entities = {}
	table.insert(entities, player)
	for _, e in pairs(enemies) do
		if not e.body:isDestroyed() then
			table.insert(entities, e)
		end
	end
	for _, p in pairs(projectiles) do
		if not p.body:isDestroyed() then
			table.insert(entities, p)
		else
			love.graphics.draw(dproj_sprite, p.x, p.y, 0, 1.35, 1.35, dproj_sprite:getWidth() / 2,
				dproj_sprite:getHeight() / 2)
		end
	end
	table.sort(entities, function(a, b)
		local aY = a.body and a.body:getY() or a.y
		local bY = b.body and b.body:getY() or b.y
		return aY < bY
	end)
	for _, e in pairs(entities) do
		e:draw()
	end
end

return drawer