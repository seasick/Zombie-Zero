require "entity"

Bullet = Entity:new()

-- Method of creating a new entity
function Bullet:new(orginX, orginY, directionX, directionY, speed, size)
    local new = {
        remove = false,
    }
    setmetatable(new, Bullet)
    self.__index = Bullet
    
    new.orginX, new.orginY, new.directionX, new.directionY = orginX, orginY, directionX, directionY
    
    new.x     = orginX
    new.y     = orginY
    new.speed = speed or 2
    new.size  = size or 3
    
    return new
end

-- Get the type of this entity
function Bullet:getType()
    return "bullet"
end

-- Draw the bullet
function Bullet:draw()
    
    -- a line after the bullet
    love.graphics.setColor(255, 255, 255)
    love.graphics.line(self.x, self.y, self.orginX, self.orginY)
    
    -- the actual bullet
    love.graphics.setColor(228, 198, 0)
    love.graphics.circle("fill", self.x, self.y, self.size, 9)
end

-- Update the bullets position
function Bullet:update(deltaTime)

    local dirX = self.orginX - self.directionX
    local dirY = self.orginY - self.directionY
    local absDirX = math.abs(dirX)
    local absDirY = math.abs(dirY)
    local sumXY   = absDirX + absDirY
    
    self.x = self.x - (dirX / absDirX) * absDirX / sumXY * self.speed * 32 * deltaTime * world:getSpeed()
    self.y = self.y - (dirY / absDirY) * absDirY / sumXY * self.speed * 32 * deltaTime * world:getSpeed()
    
    if world:outOfBoundaries(self.x, self.y) then
        self.remove = true
    end
end

function Bullet:getDamage()
    return 50
end
