Input = require 'Libraries/Input'
Object = require 'Libraries/classic/classic'
ROT = require 'Libraries/rotLove/rot'

require 'Part05/Entity'
require 'Part05/GameMap'
require 'Part05/input_handlers'
require 'Part05/RenderFunctions'
require 'Part05/GameStates'

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
    
    --npc = Entity( math.floor( screenWidth / 2 ) - 5, math.floor( screenHeight / 2 ), '怪', { 1, 1, 0, 1 } )
        
    entities = { player }
    
    
    
    gameMap = GameMap( mapWidth, mapHeight )
    gameMap:make_map(max_rooms, room_min_size, room_max_size, mapWidth, mapHeight, player, entities, max_monsters_per_room )

    gameMap:initialize_fov()

    fov_recompute = true
    game_states = GAME_STATES.PLAYERS_TURN
end



function love.update( dt )
    local action = handle_keys()
    
    if action then
        
        if action['exit'] == true then
            love.event.quit()
        end
        
        if action['move'] and game_states == GAME_STATES.PLAYERS_TURN then
            local dx = action['move']['x']
            local dy = action['move']['y']
            local destX = player.x + dx
            local destY = player.y + dy
            if not gameMap:is_blocked( player.x + dx, player.y + dy ) then
                local target = get_blocking_entities_at_location( entities, destX, destY )
                if target then
                    print( "你踢了"..target.name.."一腳!" )
                else
                    player:move( dx, dy )
                    fov_recompute = true
                end
            end
            game_states = GAME_STATES.ENEMY_TURN
        end
    end

    if game_states == GAME_STATES.ENEMY_TURN then
        for _, e in ipairs( entities ) do
            if e ~= player then
                print( e.name.."正在思考下一步…" )
            end
        end
        game_states = GAME_STATES.PLAYERS_TURN
    end
    
    --print( mouseX )
    --print( mouseCellX )
end



function love.draw()
    
    if fov_recompute then
        gameMap:recompute_fov()
        fov_recompute = false
    end
    
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



