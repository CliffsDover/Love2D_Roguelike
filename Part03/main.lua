Input = require 'Libraries/Input'
Object = require 'Libraries/classic/classic'
require 'Part03/Entity'
require 'Part03/GameMap'
require 'Part03/input_handlers'
require 'Part03/RenderFunctions'

function love.load()
    io.stdout:setvbuf("no")
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
    
    
    
    gameMap = GameMap( mapWidth, mapHeight )
    gameMap:make_map(max_rooms, room_min_size, room_max_size, mapWidth, mapHeight, player)

    --print( gameMap.tiles[21][16].blocked )
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

    
    --print( mouseX )
    --print( mouseCellX )
end



function love.draw()
    render_all( entities, gameMap, screenWidth, screenHeight, colors )
    
    
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.print( "FPS: " .. love.timer.getFPS(), 0, 0 )
    
    local mouseX, mouseY = love.mouse.getPosition()
    local mouseCellX = math.floor( mouseX / tileWidth ) + 1
    local mouseCellY = math.floor( mouseY / tileHeight ) + 1
    love.graphics.print( mouseCellX .. "," .. mouseCellY, 0, tileHeight )
    
    love.graphics.setColor( 1, 0, 0, 1 )
    love.graphics.rectangle( 'line', ( mouseCellX - 1 ) * tileWidth, ( mouseCellY - 1 ) * tileHeight, tileWidth, tileHeight )
end




