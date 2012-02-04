Entity = {
    x      = 0,     -- x coordinate where this entitiy is
    y      = 0,     -- y coordinate where this entitiy is
    remove = false, -- is this entity removeable (world will it remove)
    speed  = 10,     -- the speed of the entity when moving
}

-- Method of creating a new entity
function Entity:new(x, y, speed, size)
    local new = {}
    setmetatable(new, self)
    self.__index = self
    
    new.x      = x
    new.y      = y
    new.speed  = speed or 10
    new.size   = size or 8
    new.remove = false
    return new
end

-- Draw the entity on the screen
function Entity:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", self.x, self.y, self.size, 20)
end

-- Update the entities position, facing, whatever
function Entity:update(deltaTime)
    -- TODO update the position
end

-- Is this entity removeable?
function Entity:isRemoveable()
    return self.remove
end

function Entity:getType()
    return "entity"
end

function Entity:isCollidable()
	return true;
end
