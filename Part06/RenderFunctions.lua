Moses = require 'Libraries/Moses/moses'

RENDER_ORDER = { 
    CORPSE = 1,
    ITEM = 2,
    ACTOR = 3
}


function render_all( entities, gameMap, screenWidth, screenHeight, colors )
    
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

end
