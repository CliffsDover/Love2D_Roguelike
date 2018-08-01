Input = require 'Libraries/Input'
require 'Part01/input_handlers'

function love.load()
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    love.graphics.setBackgroundColor( 0.25, 0.25, 0.25, 1 )
    
    love.graphics.setNewFont( "Assets/Fonts/unifont-10.0.07.ttf", 16 )
    
    playerX = math.floor( screenWidthPixels / 2 )
    playerY = math.floor( screenHeightPixels / 2 )
    
    input = Input()
    input:bind( "escape", "escape" )
    input:bind( "up", "up" )
    input:bind( "down", "down" )
    input:bind( "left", "left" )
    input:bind( "right", "right" )
end



function love.update( dt )
    local action = handle_keys()
    
    if action then
        
        if action['exit'] == true then
            love.event.quit()
        end
        
        if action['move'] then
            local dx = action['move']['x'] * tileWidth
            local dy = action['move']['y'] * tileHeight
            playerX = playerX + dx
            playerY = playerY + dy
        end
    end

end



function love.draw()
    love.graphics.print( "人", playerX, playerY )
end




