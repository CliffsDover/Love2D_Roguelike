function render_all( entities, gameMap, screenWidth, screenHeight, colors )
    
    for y = 1, gameMap.height do
        for x = 1, gameMap.width do
            local wall = gameMap:is_block_sight( x, y )
            if wall then
                love.graphics.setColor( colors['dark_wall'] )
                love.graphics.rectangle( 'fill', ( x - 1 ) * tileWidth, ( y - 1 ) * tileHeight, tileWidth, tileHeight )
            else
                love.graphics.setColor( colors['dark_ground'] )
                love.graphics.rectangle( 'line', ( x - 1 ) * tileWidth, ( y - 1 ) * tileHeight, tileWidth, tileHeight )
            end
        end
        
    end
    
    
    for _, entity in ipairs( entities ) do
        entity:draw()
    end

end
