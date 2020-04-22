TILESIZE = 8
SCALING_FACTOR = 4
ANIMATE = require 'anim8'

hitBox = {}
game = false

local enemies = {}
local spawnDelay = 2
local lastSpawn = love.timer.getTime()

local
function checkHit()
    for i, enemy in ipairs(enemies) do
        if hitBox[2] > enemy:left() and
                hitBox[1] < enemy:right() and
                hitBox[4] > enemy:top() and
                hitBox[3] < enemy:bottom() then
            table.remove(enemies, i)
        end
    end
end

function love.load()
    Object = require 'classic'
    require 'player'
    require 'enemy'
    player = Player()
    sprites = love.graphics.newImage('Sprites.png')
    background_menu = love.graphics.newQuad(1, 17, 38, 15, sprites:getDimensions())
    background_menu_text = love.graphics.newQuad(0, 58, 56, 38, sprites:getDimensions())
    background_game = love.graphics.newImage('Background.png')
    width = background_game:getWidth()
    height = background_game:getHeight()
end

function love.update(dt)
    if lastSpawn < love.timer.getTime() then
        lastSpawn = love.timer.getTime() + spawnDelay
        print(TILESIZE * SCALING_FACTOR)
        print(width - 2 * (TILESIZE))
        enemy_demo = Enemy(love.math.random(TILESIZE * SCALING_FACTOR * 2, width * SCALING_FACTOR - 2 * (TILESIZE * SCALING_FACTOR)), love.math.random(TILESIZE * SCALING_FACTOR * 2, height * SCALING_FACTOR - 2 * (TILESIZE * SCALING_FACTOR)))
        table.insert(enemies, enemy_demo)
    end
    if next(hitBox) then
        checkHit()
        hitBox = {}
    end
    if love.keyboard.isDown('up') and not game then
        game = true
    end
    if love.keyboard.isDown('escape') then
        love.event.quit()
    end

    if game then
        player:update(dt)

        for i, enemy in ipairs(enemies) do
            enemy:update(dt)
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(61 / 255, 128 / 255, 38 / 255)
    if game then
        background_game:setFilter('nearest')
        love.graphics.draw(background_game, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 4, 4, width / 2, height / 2)
        player:draw()
        for i, enemy in ipairs(enemies) do
            enemy:draw()
        end
    else
        sprites:setFilter('nearest')
        love.graphics.draw(sprites, background_menu, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 8, 8, 38 / 2, 20, 0, 0)
        love.graphics.draw(sprites, background_menu_text, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 8, 8, 56 / 2, -20, 0, 0)
    end
end


