Player = Object:extend()

local spriteOffsetWidth = 2
local spriteOffsetHeight = 0
local textureWidth = 12
local textureHeight = 16

local
function fireProjectile(self)
    self.shooting = true
    self.shotFired = love.timer.getTime() + self.shotDelay
    self.projectile.sound:play()
end

function Player:new()
    self.speed = 300
    self.moving = false
    self.x = love.graphics.getWidth() / 2
    self.y = love.graphics.getHeight() / 2
    self.spriteSheet = love.graphics.newImage('Sprites.png')
    self.playerMovingAnimationGrid = ANIMATE.newGrid(16, 16, self.spriteSheet:getWidth(), self.spriteSheet:getHeight(), 0, 40)
    self.playerMovingAnimation = ANIMATE.newAnimation(self.playerMovingAnimationGrid('1-2', 1), 0.1)
    self.playerStanding = love.graphics.newQuad(0, 0, 16, 16, self.spriteSheet:getDimensions())
    self.attackDown = love.graphics.newQuad(40, 0, 8, 8, self.spriteSheet:getDimensions())
    self.attackUp = love.graphics.newQuad(40, 8, 8, 8, self.spriteSheet:getDimensions())
    self.attackRight = love.graphics.newQuad(48, 0, 8, 8, self.spriteSheet:getDimensions())
    self.attackLeft = love.graphics.newQuad(48, 8, 8, 8, self.spriteSheet:getDimensions())
    self.projectile = {}
    self.projectile.direction = nil
    self.projectile.sprite = nil
    self.shooting = false
    self.shotFired = null
    self.shotDelay = 0.5
    self.projectile.sound = love.audio.newSource('hit.wav', 'static')
end

function Player:update(dt)

    self.moving = false

    -- INPUT
    if love.keyboard.isDown('left') then
        self.moving = true
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown('right') then
        self.moving = true
        self.x = self.x + self.speed * dt
    end
    if love.keyboard.isDown('up') then
        self.moving = true
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown('down') then
        self.moving = true
        self.y = self.y + self.speed * dt
    end

    -- BOUNDING BOX
    if self.x > love.graphics.getWidth() - (TILESIZE * SCALING_FACTOR + textureWidth * SCALING_FACTOR) then
        self.x = love.graphics.getWidth() - (TILESIZE * SCALING_FACTOR + textureWidth * SCALING_FACTOR)
    end
    if self.x < TILESIZE * SCALING_FACTOR then
        self.x = TILESIZE * SCALING_FACTOR
    end
    if self.y > love.graphics.getHeight() - (TILESIZE * SCALING_FACTOR + textureHeight * SCALING_FACTOR) then
        self.y = love.graphics.getHeight() - (TILESIZE * SCALING_FACTOR + textureHeight * SCALING_FACTOR)
    end
    if self.y < TILESIZE * SCALING_FACTOR then
        self.y = TILESIZE * SCALING_FACTOR
    end

    -- SHOOTING
    if self.shooting and love.timer.getTime() > self.shotFired then
        self.shooting = false
    end
    if love.keyboard.isDown('a') and not self.shooting then
        self.projectile.direction = { -40, 0 }
        self.projectile.sprite = self.attackLeft
        hitBox = {self.x - 40, self.x, self.y, self.y + textureHeight * SCALING_FACTOR}
        fireProjectile(self)
    end
    if love.keyboard.isDown('d') and not self.shooting then
        self.projectile.direction = { 40, 0 }
        self.projectile.sprite = self.attackRight
        hitBox = {self.x + textureWidth * SCALING_FACTOR, self.x + textureWidth * SCALING_FACTOR + 40, self.y, self.y + textureHeight * SCALING_FACTOR}
        fireProjectile(self)
    end
    if love.keyboard.isDown('w') and not self.shooting then
        self.projectile.direction = { 0, -40 }
        self.projectile.sprite = self.attackUp
        hitBox = {self.x, self.x + textureWidth * SCALING_FACTOR, self.y - 40, self.y}
        fireProjectile(self)
    end
    if love.keyboard.isDown('s') and not self.shooting then
        self.projectile.direction = { 0, 40 }
        hitBox = {self.x, self.x + textureWidth * SCALING_FACTOR, self.y + textureHeight * SCALING_FACTOR, self.y + textureHeight * SCALING_FACTOR + 40}
        self.projectile.sprite = self.attackDown
        fireProjectile(self)
    end

    self.playerMovingAnimation:update(dt)
end

function Player:draw()
    love.graphics.push()
    self.spriteSheet:setFilter('nearest')

    -- CHARACTER SPRITE / ANIMATION
    if self.moving then
        self.playerMovingAnimation:draw(self.spriteSheet, self.x, self.y, 0, 4, 4, spriteOffsetWidth, spriteOffsetHeight, 0, 0)
    else
        love.graphics.draw(self.spriteSheet, self.playerStanding, self.x, self.y, 0, 4, 4, spriteOffsetWidth, spriteOffsetHeight, 0, 0)
    end

    -- DRAW PROJECTILE
    if self.shooting then
        love.graphics.draw(self.spriteSheet, self.projectile.sprite, self.x + 8 + self.projectile.direction[1], self.y + 16 + self.projectile.direction[2], 0, 4, 4, 0, 0, 0, 0)
    end

    love.graphics.pop()
end
