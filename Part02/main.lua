Input = require 'Libraries/Input'
Object = require 'Libraries/classic/classic'
require 'Part02/Entity'
require 'Part02/GameMap'
require 'Part02/input_handlers'
require 'Part02/RenderFunctions'

function love.load()
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    
    love.graphics.setBackgroundColor( 0.125, 0.125, 0.125, 1 )
    love.graphics.setNewFont( "Assets/Fonts/unifont-10.0.07.ttf", tileHeight )
    
    input = Input()
    input:bind( "escape", "escape" )
    input:bind( "up", "up" )
    input:bind( "down", "down" )
    input:bind( "left", "left" )
    input:bind( "right", "right" )
    
    player = Entity( math.floor( screenWidth / 2 ), math.floor( screenHeight / 2 ), '人', { 1, 1, 1, 1 } )
    
    npc = Entity( math.floor( screenWidth / 2 ) - 5, math.floor( screenHeight / 2 ), '怪', { 1, 1, 0, 1 } )
        
    entities = { player, npc }
    
    colors = {
        dark_wall = { 0, 0, 100.0/255.0, 255.0/255.0 },
        dark_ground = { 50.0/255.0, 50.0/255.0, 150/255.0, 255.0/255.0 }
    }
    
    gameMap = GameMap( mapWidth, mapHeight )
end



function love.update( dt )
    local action = handle_keys()
    
    if action then
        
        if action['exit'] == true then
            love.event.quit()
        end
        
        if action['move'] then
            local dx = action['move']['x']
            local dy = action['move']['y']
            if not gameMap:is_blocked( player.x + dx, player.y + dy ) then
                player:move( dx, dy )
            end
            
        end
    end

end



function love.draw()
    render_all( entities, gameMap, screenWidth, screenHeight, colors )
    love.graphics.print( "FPS: " .. love.timer.getFPS(), 0, 0 )
end




