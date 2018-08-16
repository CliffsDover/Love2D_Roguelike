Input = require 'Libraries/Input'
Object = require 'Libraries/classic/classic'
ROT = require 'Libraries/rotLove/rot'
--utf8 = require "Libraries/utf8"
--utf8 = require "utf8"
utf8 = require "Libraries/utf8_simple"
Moses = require 'Libraries/Moses/moses'


require 'Part08/Entity'
require 'Part08/GameMap'
require 'Part08/input_handlers'
require 'Part08/RenderFunctions'
require 'Part08/GameStates'
require 'Part08/Fighter'
require 'Part08/DeathFunctions'
require 'Part08/GameMessages'
require 'Part08/Inventory'

function love.load()
    io.stdout:setvbuf("no")
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    luaInfo()
    
    love.graphics.setBackgroundColor( 0.125, 0.125, 0.125, 1 )
    love.graphics.setNewFont( "Assets/Fonts/unifont-10.0.07.ttf", tileHeight )
    
    input = Input()
    
    
    local fighter_component = Fighter( 30, 2, 5 )
    local inventory_component = Inventory( 26 )
    player = Entity( math.floor( screenWidth / 2 ), math.floor( screenHeight / 2 ), '主', { 1, 1, 1, 1 }, "林沖", true, RENDER_ORDER.ACTOR, fighter_component, nil, nil, inventory_component )
    
    --npc = Entity( math.floor( screenWidth / 2 ) - 5, math.floor( screenHeight / 2 ), '怪', { 1, 1, 0, 1 } )
        
    entities = { player }
    
    
    
    gameMap = GameMap( mapWidth, mapHeight )
    gameMap:make_map(max_rooms, room_min_size, room_max_size, mapWidth, mapHeight, player, entities, max_monsters_per_room, max_items_per_room )

    gameMap:initialize_fov()

    fov_recompute = true
    game_states = GAME_STATES.PLAYERS_TURN
    previous_game_state = game_states
    
    message_log = MessageLog( message_x, message_width, message_height )
     
end



function love.update( dt )
    local action = handle_keys( game_states )
    local player_turn_results = {}
    
    if action then
        
        if action['exit'] == true then
            if game_states == GAME_STATES.SHOW_INVENTORY then
                game_states = previous_game_state
            else
                love.event.quit()
            end
        end
        
        if action['move'] and game_states == GAME_STATES.PLAYERS_TURN then
            local dx = action['move']['x']
            local dy = action['move']['y']
            local destX = player.x + dx
            local destY = player.y + dy
            if not gameMap:is_blocked( player.x + dx, player.y + dy ) then
                local target = get_blocking_entities_at_location( entities, destX, destY )
                if target and target ~= player then
                    --print( "你踢了"..target.name.."一腳!" )
                    local attack_results = player.fighter:attack( target )
                    table.insert( player_turn_results, attack_results )
                else
                    player:move( dx, dy )
                    fov_recompute = true
                end
            end
            game_states = GAME_STATES.ENEMY_TURN
        end
        
        if action['mouse'] then
            if action['mouse'].left == 1 then
                astarPath = {}
                print( "left" )
                local mouseX, mouseY = love.mouse.getPosition()
                local mouseCellX = math.floor( mouseX / tileWidth ) + 1
                local mouseCellY = math.floor( mouseY / tileHeight ) + 1
                print( mouseCellX .. "," .. mouseCellY )
                --astar=ROT.Path.AStar(mouseCellX, mouseCellY, passableCallback)
            end
            
            if action['mouse'].right == 1 then
                print( 'right' )
                local mouseX, mouseY = love.mouse.getPosition()
                local mouseCellX = math.floor( mouseX / tileWidth ) + 1
                local mouseCellY = math.floor( mouseY / tileHeight ) + 1
                print( mouseCellX .. "," .. mouseCellY )
                --astar:compute(mouseCellX, mouseCellY, astarCallback)
            end
            
        end
        
        if action['pickup'] and game_states == GAME_STATES.PLAYERS_TURN then
            local itemsFound = false
            for _, e in ipairs( entities ) do
                if e.item and e.x == player.x and e.y == player.y then
                    local pickup_results = player.inventory:add_item( e )
                    table.insert( player_turn_results, pickup_results ) 
                    itemsFound = true
                end
            end
            
            if not itemsFound then
                message_log:AddMessage( Message( "這裡沒有任何東西可以撿起。", COLORS.YELLOW ) )
            end
            
        end
        
        if action['show_inventory'] then
            previous_game_state = game_states
            game_states = GAME_STATES.SHOW_INVENTORY
        end
        
        if action['inventory_index'] and previous_game_state ~= GAME_STATES.PLAYER_DEAD and action['inventory_index'] <= #player.inventory.items then
            --previous_game_state = game_states
            --game_states = GAME_STATES.SHOW_INVENTORY
            local item = player.inventory.items[ action['inventory_index'] ]
            print( item.name )
        end
        
    end
    
    for _, r in ipairs( player_turn_results ) do
        local message = r[ "message" ]
        local dead_entity = r[ "dead" ]
        local item_added = r[ "item_added" ]
        if message then message_log:AddMessage( message ) end
        if dead_entity then 
            --print( "We found dead bodies!" ) 
            local message
            local game_states
            if dead_entity == player then
                message, game_states = kill_player( dead_entity )
            else
                message = kill_monster( dead_entity )
            end
            --print( message )
            message_log:AddMessage( message )
        end
        
        if item_added then
            --local itemIndex = Moses.detect( entities, item_added )
            local itemIndex = 0
            for _, e in ipairs( entities ) do
                itemIndex = itemIndex + 1
                if e == item_added then
                    break
                end
            end
            if itemIndex > 0 then table.remove( entities, itemIndex ) end
            game_states = GAME_STATES.ENEMY_TURN
        end
        
    end
    

    if game_states == GAME_STATES.ENEMY_TURN then
        for _, e in ipairs( entities ) do
            if e ~= player then
                --print( e.name.."正在思考下一步…" )
                if e.AI then
                    local enemy_turn_results = e.AI:take_turn( player, gameMap, entities )
                    
                    for _, r in ipairs( enemy_turn_results ) do
                        --print( r["message"] )
                        local message = r[ "message" ]
                        local dead_entity = r[ "dead" ]
                        if message then message_log:AddMessage( message ) end
                        if dead_entity then 
                            --print( "We found dead bodies!" ) 
                            local message
                            if dead_entity == player then
                                message, game_states = kill_player( dead_entity )
                            else
                                message = kill_monster( dead_entity )
                            end
                            --print( message )
                            message_log:AddMessage( message )
                            if game_states == GAME_STATES.PLAYER_DEAD then
                                break
                            end
                        end
                    end
                    
                    if game_states == GAME_STATES.PLAYER_DEAD then
                        break
                    end
                end
            end
        end
        if game_states ~= GAME_STATES.PLAYER_DEAD then
            game_states = GAME_STATES.PLAYERS_TURN
        end
        
    end
    
    --print( mouseX )
    --print( mouseCellX )
end



function love.draw()
    
    if fov_recompute then
        gameMap:recompute_fov()
        fov_recompute = false
    end
    
    local mouseX, mouseY = love.mouse.getPosition()
    local mouseCellX = math.floor( mouseX / tileWidth ) + 1
    local mouseCellY = math.floor( mouseY / tileHeight ) + 1
    
    render_all( entities, gameMap, screenWidth, screenHeight, colors, message_log, mouseCellX, mouseCellY, game_states )
    
    
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.print( "FPS: " .. love.timer.getFPS(), 0, 0 )
    
    local mouseX, mouseY = love.mouse.getPosition()
    local mouseCellX = math.floor( mouseX / tileWidth ) + 1
    local mouseCellY = math.floor( mouseY / tileHeight ) + 1
    love.graphics.print( mouseCellX .. "," .. mouseCellY, 0, tileHeight )
    
    love.graphics.setColor( 1, 0, 0, 1 )
    love.graphics.rectangle( 'line', ( mouseCellX - 1 ) * tileWidth, ( mouseCellY - 1 ) * tileHeight, tileWidth, tileHeight )
    
    if astarPath then
    for _, p in ipairs( astarPath ) do
        love.graphics.circle( 'fill', p[1] * tileWidth - tileWidth / 2, p[2] * tileHeight - tileHeight / 2, 3 )
    end
    end
    
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.print( "HP: "..player.fighter.hp.."/"..player.fighter.max_hp,  tileWidth,  ( screenHeight - 2 ) * tileHeight )
end




function luaInfo()
	local info = "Lua version: " .. _VERSION .. "\n"
	info = info .. "LuaJIT version: "

	if (jit) then
		info = info .. jit.version
	else
		info = info .. "this is not LuaJIT"
	end
    print( info )
end