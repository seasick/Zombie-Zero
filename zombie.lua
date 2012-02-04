require "entity"
require "stain"

Zombie = Entity:new(0, 0)

-- update the zombies position
function Zombie:update(deltaTime)
    local zomb = self:attachedTo()
    
    -- the zombies should follow the player wherever hes going
    if zomb:getType() == 'zombie' and zomb:isRemoveable() then
    	self:attachTo(player)
    	zomb = player
    end
    
    local dirX = zomb.x - self.x
    local dirY = zomb.y - self.y
    
    --if dirX == 0 then dirX = 1 end
    --if dirY == 0 then dirY = 1 end
    
    local absDirX = math.abs(dirX)
    local absDirY = math.abs(dirY)
    local sumXY   = absDirX + absDirY
    local oldX    = self.x
    local oldY    = self.y
    
    local newX = self.x + (dirX / absDirX) * absDirX / sumXY * self.speed * 32 * deltaTime * world:getSpeed()
    local newY = self.y + (dirY / absDirY) * absDirY / sumXY * self.speed * 32 * deltaTime * world:getSpeed()
        
    if not world:detectCollision({x = newX, y = newY, size = self.size}, self) then
        self.x = newX
        self.y = newY 
    elseif not world:detectCollision({x = newX, y = self.y, size = self.size}, self) then
        self.x = newX
    elseif not world:detectCollision({x = self.x, y = newY, size = self.size}, self) then
        self.y = newY
    else
        -- zombie cannot move ... where to go?
        
        -- Check wether the player is above/beneath or left/right of the player
        if absDirX > absDirY then
            if not world:detectCollision({x = self.x, y = self.y + 1, size = self.size}, self) then
                self.y = self.y + self.speed * 32 * deltaTime
            elseif not world:detectCollision({x = self.x, y = self.y - 1, size = self.size}, self) then
                self.y = self.y - self.speed * 32 * deltaTime
            end
        else
            if not world:detectCollision({x = self.x + 1, y = self.y, size = self.size}, self) then
                self.x = self.x + self.speed * 32 * deltaTime
            elseif not world:detectCollision({x = self.x - 1, y = self.y, size = self.size}, self) then
                self.x = self.x - self.speed * 32 * deltaTime
            end
        end
    end
end

-- Draw the zombie
function Zombie:draw()
    love.graphics.setColor(150, 150, 150)
    love.graphics.circle("fill", self.x, self.y, self.size, 20)
end

-- Get the type of this object
function Zombie:getType()
    return "zombie"
end

-- Let the zombie die
function Zombie:die()
    love.graphics.setColor(0, 255, 0)
    love.graphics.circle("fill", self.x, self.y, 18, 20)

    self.remove = true
    Highscore:addKill()
end

-- The zombie got hit
function Zombie:hit(damage)
    self.hitpoints = (self.hitpoints or 100) - damage
    if self.hitpoints <= 0 then
        self:die()
    end
    
    local stain = Stain:new(self.x, self.y)
    world:addEntity(stain, true)
end

function Zombie:attachTo(entity)
    self.attachement = entity
end

function Zombie:attachedTo()
    return self.attachement or {x = 0, y = 0}
end