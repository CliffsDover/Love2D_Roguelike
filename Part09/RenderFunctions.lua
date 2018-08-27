Moses = require 'Libraries/Moses/moses'
utf8 = require "Libraries/utf8_simple"
require 'Part09/GameStates'
require 'Part09/Menu'

RENDER_ORDER = { 
    CORPSE = 1,
    ITEM = 2,
    ACTOR = 3
}


function render_all( entities, gameMap, screenWidth, screenHeight, colors, message_log, mouseX, mouseY, game_state )
    
    for y = 1, gameMap.height do
        for x = 1, gameMap.width do
            local visible = gameMap.tiles[x][y].is_in_fov
            local wall = gameMap:is_block_sight( x, y )
            
            if visible then
                if wall then
                    love.graphics.setColor( colors['light_wall'] )
                    love.graphics.rectangle( 'fill', ( x - 1 ) * tileWidth, ( y - 1 ) * tileHeight, tileWidth, tileHeight )
                else
                    love.graphics.setColor( colors['light_ground'] )
                    love.graphics.rectangle( 'line', ( x - 1 ) * tileWidth, ( y - 1 ) * tileHeight, tileWidth, tileHeight )
                end
                gameMap.tiles[x][y].explored = true
            elseif gameMap.tiles[x][y].explored then
                if wall then
                    love.graphics.setColor( colors['dark_wall'] )
                    love.graphics.rectangle( 'fill', ( x - 1 ) * tileWidth, ( y - 1 ) * tileHeight, tileWidth, tileHeight )
                else
                    love.graphics.setColor( colors['dark_ground'] )
                    love.graphics.rectangle( 'line', ( x - 1 ) * tileWidth, ( y - 1 ) * tileHeight, tileWidth, tileHeight )
                end
            end
            
            
        end
        
    end
    
    local entities_in_render_order = Moses.sortBy( entities, 'render_order' ) 
    
    for _, entity in ipairs( entities_in_render_order ) do
        if gameMap.tiles[entity.x][entity.y].is_in_fov then
            entity:draw()
        end
    end


    render_bar( 1, panel_y + 1, bar_width, '精力', player.fighter.hp, player.fighter.max_hp, COLORS.RED, COLORS.DARKEST_RED )
    
    
    
    local y = panel_y + 1
    for _, m in ipairs( message_log.messages ) do
        love.graphics.setColor( m.color )
        love.graphics.print( m.text, message_log.x * tileWidth, y * tileHeight )
        y = y + 1
    end
    
    love.graphics.setColor( COLORS.WHITE )
    love.graphics.print( get_names_under_mouse( mouseX, mouseY, entities, gameMap ), 1 * tileWidth, panel_y * tileHeight )
    
    
    -- render menu
    if game_state == GAME_STATES.SHOW_INVENTORY then
        InventoryMenu( "按下代號來使用物品，或按ESC離開\n", player.inventory, 30, screenWidth, screenHeight )
    elseif game_state == GAME_STATES.DROP_INVENTORY then
        InventoryMenu( "按下代號來丟棄物品，或按ESC離開\n", player.inventory, 30, screenWidth, screenHeight )
    end
    

    
    
end


function render_bar( x, y, total_width, name, value, maximum, bar_color, back_color )
    --print( utf8.len( name ) )
    local bar_width = math.floor( value / maximum * total_width )
    
    love.graphics.setColor( back_color )
    love.graphics.rectangle( 'fill', x * tileWidth, y * tileHeight, total_width * tileWidth, tileHeight )
    
    love.graphics.setColor( bar_color )
    if bar_width > 0 then
    love.graphics.rectangle( 'fill', x * tileWidth, y * tileHeight, bar_width * tileWidth, tileHeight )    
    end
    
    love.graphics.setColor( COLORS.WHITE )
    local bar_title = name..":"..value.."/"..maximum
    --print( bar_title )
    --print( utf8.len( bar_title ) )
    --print( ( 1 + x + math.floor( total_width / 2 ) - math.floor( utf8.len( bar_title ) / 2 ) ) )
    love.graphics.print( bar_title, ( 1 + x + math.floor( total_width / 2 ) - math.floor( utf8.len( bar_title ) / 2 ) ) * tileWidth, y * tileHeight )
 end
 
 
 function get_names_under_mouse( mouseX, mouseY, entities, gameMap )
    local names = ""
    for _, e in ipairs( entities ) do
        if e.x == mouseX and e.y == mouseY and  gameMap.tiles[mouseX][mouseY].is_in_fov then
            if names == "" then
                names = e.name
                if e.fighter then names = names..'('..e.fighter.hp..')' end
            else
                names = names.."，"..e.name
                if e.fighter then names = names..'('..e.fighter.hp..')' end
            end
            
        end
    end
    return names
 end
 
