require "world"
require "player"
require "zombie"
require "weapon"
require "highscore"
 
function love.conf(t)
    t.title  = "Zombie Game"        -- The title of the window the game is in (string)
    t.author = "Clemens Solar"        -- The author of the game (string)
    
    t.modules.joystick = false
    t.modules.physics  = false
end
    
-- Create the world and load stuff
function love.load()
    love.graphics.setCaption("The Zombie Game")
    
    world  = World:new(0, 0, 800, 600)
    player = Player:new(400, 300, 5)
    
    player.weapon = Weapon:new(0.2, 10)
    
    world:addEntity(player)
        :setPlayer(player)
        
    -- load the font to show some messages
    defaultFont   = love.graphics.newFont(14);
    bloodyFont15  = love.graphics.newFont("ressources/bloody.ttf", 20)
    bloodyFont25  = love.graphics.newFont("ressources/bloody.ttf", 35)
    bloodyFont35  = love.graphics.newFont("ressources/bloody.ttf", 95)
    
    -- bloody image
    bloodyImage   = love.graphics.newImage("ressources/bloody.png")
    bloodStain1   = love.graphics.newImage("ressources/blood_stain1.png")
    bloodStain2   = love.graphics.newImage("ressources/blood_stain2.png")
    bigZomb		  = false
    
    world:pause()
    world:showMessage(
        "Kill the Zombies", 
        "Move with WASD"
            .. "\nShoot with left mouse"
            .. "\nBullettime with right mouse"
            .. "\nStart/Pause with (space)"
    )
end

-- draw the stuff
function love.draw()
    world:draw()
    
    
    love.graphics.setFont(defaultFont)
    -- show the fps
    love.graphics.setColor(255,255,255)
    --love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
    
    -- show the kills
    love.graphics.printf("Round " .. Highscore:getRound(), 600, 10, 200, "right")
    love.graphics.printf("Killed " .. Highscore:getKills() .. " Zombies", 600, 25, 200, "right")
    
end

-- Continous update
function love.update(deltaTime)
	world:update(deltaTime)

    if not world.gameIsOver and world:getEntityCount("zombie") <= 0 then
        Highscore:nextRound()
        world:removeEntities("stain")
        local bigZombie = false
        
        --[[ if Highscore:getRound() == 1 then
        	bigZombie = Zombie:new(
        		399, 500, 3, 20
    		)
        	bigZombie:attachTo(player)
        	world:addEntity(bigZombie)
        end ]]--
        
        world.bulletTime = world.maxBulletTime
        world:addZombies(20, 3 + Highscore:getRound() * 0.5, bigZombie)
                
        if Highscore:getRound() ~= 1 then
	        world:pause()
	        world:showMessage("Round " .. Highscore:getRound(), "When ready, press (space)")
        end
    end
end

-- press the mouse
function love.mousepressed(x, y, button)
    if button == "l" then
        player:startShooting()
    elseif button == "r" then
        world:toggleBulletTime()
    end
end

-- The mouse is released
function love.mousereleased(x, y, button)
    if button == "l" then
        player:stopShooting()
   end
end

-- A key is pressed
function love.keypressed(key, unicode)
    if key == "b" then
        world:toggleBulletTime()
    elseif key == " " then
        if not world.gameIsOver then
            world:togglePause()
        else
            world:startGame()
        end
    end
end