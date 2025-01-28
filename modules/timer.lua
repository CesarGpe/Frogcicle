timers = {}

-- creates a new timer, needs to be manually ticked
function timers.new(time, callback)
    local expired = false
    local timer = {}

    function timer.update(dt)
        if time < 0 then
            expired = true
            if callback then callback() end
        end
        time = time - dt
    end

    function timer.isExpired()
        return expired
    end

    function timer.getTime()
        return time
    end

    return timer
end

-- creates a "throw-away" timer, ticks with all others of the same type
function timers.oneshot(time, callback)
    local timer = timers.new(time, callback)
    table.insert(timers, timer)
    return timer
end

-- updates all oneshot timers
function timers.miscUpdate(dt)
    for _, t in ipairs(timers) do
        if not t.isExpired() then t.update(dt) end
    end
end
