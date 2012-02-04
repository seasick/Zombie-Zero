require "bullet"

Weapon = {}

-- Method of creating a new entity
function Weapon:new(timeBetweenShoots, speed)
    local new = {}
    setmetatable(new, self)
    self.__index = self
    
    new.timeBetweenShoots = timeBetweenShoots
    new.timeSinceLastShot = timeBetweenShoots
    new.speed             = speed
    return new
end

function Weapon:update(deltaTime)
    self.timeSinceLastShot = self.timeSinceLastShot + deltaTime

    if self.timeSinceLastShot >= self.timeBetweenShoots and player:isShooting() then
        local orginX = player.x + player.size
        local orginY = player.y + player.size
                
        -- TODO change orgin to be out of the players box
        
        if not world.isPaused then 
	        world:addEntity(
	            Bullet:new(
	                -- where does the bullet orgin from
	                orginX, orginY, 
	                -- where does the bullet go
	                love.mouse.getX(), love.mouse.getY(),
	                -- options 
	                self.speed, 2
	            )
	        )
        end
        
        -- TODO create a bullet
        -- TODO create a lightsource
        self.timeSinceLastShot = 0
    end
end