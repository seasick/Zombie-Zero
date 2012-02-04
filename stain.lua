require "entity"

Stain = Entity:new()

-- Draw the entity on the screen
function Stain:draw()
	love.graphics.draw(bloodStain1, self.x - 25, self.y - 25)
end

function Stain:getType()
	return "stain"
end

function Stain:isCollidable()
	return false;
end

function Stain:update(deltaTime)
	self.age = (self.age or 0) + deltaTime
	if self.age > 3 then
		self.remove = true
	end 
end