Enemy = Object:extend()
local offsetWidth = 0
local offsetHeight = 32
local textureWidth = 8
local textureHeight = 8

function Enemy:new(x, y)
    self.speed = 300
    self.x = x
    self.y = y
    self.spriteSheet = love.graphics.newImage('Sprites.png')
    self.animationGrid = ANIMATE.newGrid(8, 8, self.spriteSheet:getWidth(), self.spriteSheet:getHeight(), 0, 32)
    self.animation = ANIMATE.newAnimation(self.animationGrid('1-4', 1), 0.1)
    self.sprite = love.graphics.newQuad(offsetWidth, offsetHeight, textureWidth, textureHeight, self.spriteSheet:getDimensions())
end

function Enemy:update(dt)
    self.animation:update(dt)
end

function Enemy:draw()
    self.spriteSheet:setFilter('nearest')
    self.animation:draw(self.spriteSheet, self.x, self.y, 0, 4, 4, 8, 8)
end

function Enemy:left()
    return self.x
end

function Enemy:right()
    return self.x + textureWidth
end

function Enemy:top()
    return self.y
end

function Enemy:bottom()
    return self.y + textureHeight
end
