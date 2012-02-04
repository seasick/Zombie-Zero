World = {}

function World:new(orginX, orginY, width, height)
    local new = {
        entities       = {},
        speed          = 1,
        gameIsOver     = false,
        firstGame      = true,
        showTheMessage = true,
        currentMessage = "",
        currentTitle   = "",
        isPaused       = false,
        bulletTime     = 5,
        maxBulletTime  = 5,
    }
    setmetatable(new, self)
    self.__index = self
    
    -- Where do the boundaries start and end
    new.boundaries = {
        ["orginX"] = orginX,
        ["orginY"] = orginY,
        ["width"]  = width,
        ["height"] = height,
    }
    
    return new
end

-- Add an entity to this world
function World:addEntity(entity, atBeginning)
    -- TODO make sure this is an entity
    if atBeginning then
    	table.insert(self.entities, 1, entity)
    else
    	table.insert(self.entities, entity)
    	--self.entities[#self.entities + 1] = entity
    end
    return self
end

-- Sets the player
function World:setPlayer(player)
    self.player = player
    return self
end

-- Get the player
function World:getPlayer()
    return self.player
end

-- Draw the worlds entities
function World:draw()
    love.graphics.setBackgroundColor(20, 20, 20)
    self:drawEntities()
    self:drawBulletTime()
    
    if self.showTheMessage then
        love.graphics.draw(bloodyImage, 0, 0)
        
        love.graphics.setColor(255, 255, 255)
        
        love.graphics.setFont(bloodyFont35)
        love.graphics.printf(self.currentTitle,   0, 150, 800, "center")
        
        love.graphics.setFont(bloodyFont25)
        love.graphics.printf(self.currentMessage, 0, 250, 800, "center")
        
    end
end

-- Update the Worlds entites
function World:update(deltaTime)

    if self.bulletTime <= 0 and not self.isPaused then
        self.speed      = 1
        self.bulletTime = 0.1
    elseif self.speed == 1 and self.bulletTime < 5 then
        self.bulletTime = self.bulletTime + deltaTime
    elseif self.speed ~= 1 and not self.isPaused then
        self.bulletTime = self.bulletTime - deltaTime
    end

    for i,v in ipairs(self.entities) do
        v:update(deltaTime)
        
        if v:isRemoveable() then
            table.remove(self.entities, i)
        else
            local collider = self:detectCollision(v, nil, true)
            if collider and not collider:isRemoveable() then
                -- Check if zombie hits bullet, or bullet hits zombie
                if collider.getType() == "bullet" and v.getType() == "zombie" then
                    
                    -- die, zombie, die!!
                    v:hit(collider:getDamage())
                    collider.remove = true

                elseif collider.getType() == "zombie" and v.getType() == "bullet" then
                    collider:hit(v:getDamage())
                    v.remove = true
                end
                
                -- Check if zombie hits player or player hits zombie
                if (collider.getType() == "player" and v.getType() == "zombie") 
                or (collider.getType() == "zombie" and v.getType() == "player") then
                    world:gameOver()
                end
                
            end
        end
    end
end

-- Draw the entities
function World:drawEntities()
    for i=1, #self.entities do
        self.entities[i]:draw()
    end
end

-- Check if specific coordinates are out of the worlds boundaries
function World:outOfBoundaries(x, y)
    return not (x > self.boundaries.orginX 
        and x < (self.boundaries.orginX + self.boundaries.width) 
        and y > self.boundaries.orginY 
        and y < (self.boundaries.orginY + self.boundaries.height))
end

-- Detect a collision
function World:detectCollision(collider, exclude, biggerBox)
    -- collision detection
    for i, entity in ipairs(self.entities) do
        
        if collider ~= entity and (not exclude or entity ~= exclude) and entity:isCollidable() then
            
            local distance = math.sqrt(
                math.pow(math.abs(collider.x - entity.x), 2)
                + math.pow(math.abs(collider.y - entity.y), 2)
            )
            
            if distance < entity.size + collider.size + (biggerBox and 1 or 0) then
                return entity
            end
        end
    end
    return false
end

-- get the current speed (is needed for bullettime)
function World:getSpeed()
    return self.speed or 1
end

-- toggle the bullettime
function World:toggleBulletTime()
    if world.isPaused then
        return
    end
    
    if self:getSpeed() == 1 and self.bulletTime > 0 then
        self.speed = 0.3
    else
        self.speed = 1
    end
end

-- Adds an specific amount of zombies
function World:addZombies(count, speed, attachToEntity)
    for i=1,count do
        while (true) do
            local x    = math.random() * world.boundaries.width
            local y    = math.random() * world.boundaries.height + 600
            local size = 8
            
            if not self:detectCollision({x = x, y = y, size = size}) then
                local zomb = Zombie:new(
                    x, y, speed, size
                );
                
                -- Check to which entity the zombies should be attached
                if attachToEntity then
                	zomb:attachTo(attachToEntity)
                else
                	zomb:attachTo(player)
            	end
            	
	            world:addEntity(zomb)
	            break
            end
        end
    end
end

-- get the entitiy count
function World:getEntityCount(type)
    if not type then
        return #self.entities
    end
    
    local count = 0
    for i, entity in ipairs(self.entities) do
        if entity.getType and entity.getType() == type then
            count = count + 1
        end
    end
    
    return count
end

function World:removeEntities(entityType)
    for i, entity in ipairs(self.entities) do
        if not entityType or (entity.getType and entity.getType() == entityType) then
            entity.remove = true
        end
    end
end

-- pause the team
function World:pause()
    self.speed    = 0
    self.isPaused = true
end

-- unPause the game
function World:unPause()
    self.speed    = 1
    self.isPaused = false
end

-- the game is over
function World:gameOver()
    self:pause()
    self.gameIsOver = true
    
    local message = "You got " .. Highscore:getKills() .. " zombies killed"
    
    if Highscore:getKills() < 40 then
        message = message .. "\nThats pretty lame ...)"
    elseif Highscore:getKills() < 60 then
        message = message .. "\nYou are doing well ..."
    elseif Highscore:getKills() < 80 then
        message = message .. "\nKeep up the good work ..."
    elseif Highscore:getKills() < 100 then
        message = message .. "\nNice one, dude ..."
    elseif Highscore:getKills() < 120 then
        message = message .. "\nAwsome!!"
    elseif Highscore:getKills() < 140 then
        message = message .. "\nUnstoppable!"
    elseif Highscore:getKills() < 160 then
        message = message .. "\nYou are insane!"
    elseif Highscore:getKills() < 180 then
        message = message .. "\nThats fucking impossible!!!"
    elseif Highscore:getKills() < 200 then
        message = message .. "\nDude, get a life! Thats just a little game xD"
    elseif Highscore:getKills() >= 200 then
        message = message .. "\nSome would say your cheating :)"
    end
    
    self:showMessage(
        "GAME OVER", 
        "Arghhh, Brainz! Eatin' ya brainz makes me a happy zombiee\n\n" 
            .. message
            .. "\n\nStart over with (space)"  
    )
end

-- start the game
function World:startGame()
    Highscore:reset()
    -- need to remove all the zombies
    self:removeEntities("zombie")
    self:removeEntities("bullet")
    
    self.gameIsOver = false
    self:togglePause()
end

-- show the message
function World:showMessage(title, message)
    love.graphics.clear ()
    self.currentMessage = message
    self.currentTitle   = title
    self.showTheMessage = true
end

-- hide the message
function World:hideMessage()
    self.showTheMessage = false
end

-- toggle the pause state
function World:togglePause()
    if self.isPaused then
        self:hideMessage()
        self:unPause()
    else
        self:showMessage("Pause", "Unpause with [space]")
        self:pause()
    end
end

-- Draw the bulletTime indicator 
function World:drawBulletTime()
    if self.isPaused then
        return
    end
    love.graphics.setColor(255, 255, 255, 80)
    love.graphics.rectangle("line", 375, 550, 50, 15)
    love.graphics.rectangle("fill", 375, 550, 50 * self.bulletTime / self.maxBulletTime, 15)
end