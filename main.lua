local DEBUG = false

require "src/player"
require "src/projectile"
require "src/ui"

if DEBUG then
    require "src/debug"
end

local TICKRATE = 1/144

function love.load()
	background = love.graphics.newImage("images/background.png")
    Projectile.spawn({x = 2, y = 2})
end

function love.draw()
	love.graphics.draw(background, 0, 0, 0, 3, 3)
	Player.draw()
    Projectile.draw()
    Ui.draw()
    
    if DEBUG then
        Debug.draw()
    end
end

function love.update()
	Player.update()
    Projectile.update()
end

function love.run()
    if love.math then
        love.math.setRandomSeed(os.time())
    end

    if love.load then love.load(arg) end

    local previous = love.timer.getTime()
    local lag = 0.0
    while true do
        local current = love.timer.getTime()
        local elapsed = current - previous
        previous = current
        lag = lag + elapsed

        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        while lag >= TICKRATE do
            if love.update then love.update(TICKRATE) end
            lag = lag - TICKRATE
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()
            if love.draw then love.draw(lag / TICKRATE) end
            love.graphics.present()
        end
    end
end
