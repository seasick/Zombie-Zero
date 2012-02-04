require "entity"

Player = Entity:new()

function Player:setWeapon(weapon)
    self.weapon = weapon
end

-- update the players position
function Player:update(deltaTime)
    -- TODO diagonal movement is faster .. that shouldn't be
    local x = 0
    local y = 0
    
    if love.keyboard.isDown("down") or love.keyboard.isDown("s") then
        y = self.speed * deltaTime * 32 * world:getSpeed()
    elseif love.keyboard.isDown("up") or love.keyboard.isDown("w") then
        y = -1 * self.speed * deltaTime * 32 * world:getSpeed()
    end
        
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        x = -1 * self.speed * deltaTime * 32 * world:getSpeed()
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        x = self.speed * deltaTime * 32 * world:getSpeed()
    end
        
    if not world:outOfBoundaries(self.x + x, self.y + y) then
        self.x = self.x + x
        self.y = self.y + y
    elseif not world:outOfBoundaries(self.x + x, self.y) then
        self.x = self.x + x
    elseif not world:outOfBoundaries(self.x, self.y + y) then
        self.y = self.y + y
    end
        
    if self.weapon then
        self.weapon:update(deltaTime)
    end
end

-- The player starts shooting
function Player:startShooting()
    self.shooting = true
end

-- The player stopped shooting
function Player:stopShooting()
    self.shooting = false
end

-- Is the player currently shooting?
function Player:isShooting()
    return self.shooting
end

-- Get the type of this object
function Player:getType()
    return "player"
end