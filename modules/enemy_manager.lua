require("enemy")

local manager = {
    initialized = false,
    spawnrate = 5,
    enemies = {},
    timer = {}
}

function manager:init()
    self.initialized = true
    self:spawn_enemy()
end

function manager:update(dt)
    if not self.initialized then return end

    self.spawnrate = math.min(5, 5 - game.difficulty)
    if not self.timer.isExpired() and game.active then
        self.timer.update(dt)
    end

    for i = #self.enemies, 1, -1 do
		local e = self.enemies[i]
		if not e.body:isDestroyed() then
			e:update(dt)
		else
			table.remove(self.enemies, i)
		end
	end

    local count = 0
    for _, e in pairs(self.enemies) do
        if e.frozen then
            count = count + 1
        end
    end
    game.frozen_enemies = count
end

function manager:spawn_enemy()
	local enemy = newEnemy(love.math.random(280, 680), love.math.random(127, 429))
	enemy:load()
    sounds.croak()
    table.insert(self.enemies, enemy)
    self.timer = timers.new(self.spawnrate, function()
        self:spawn_enemy()
    end)
end

function manager:debug_spawn()
	local enemy = newEnemy(love.math.random(280, 680), love.math.random(127, 429))
	enemy:load()
    table.insert(self.enemies, enemy)
end

function manager:kill_everyone()
    for i = #self.enemies, 1, -1 do
        self.enemies[i]:delete()
    end
end

return manager