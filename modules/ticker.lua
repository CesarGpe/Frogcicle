ticker = {}

-- creates a new timer, needs to be stored in a variable and manually ticked
function ticker.new(time, callback)
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
