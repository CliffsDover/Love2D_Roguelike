require 'Part08/GameMessages'
require 'Part08/Colors'

function Menu( header, options, width, screenWidth, screenHeight )
    if #options > 26 then print( "Cannon have a menu with more than 26 opions" ) end
    local wrappedHeader = WrapText( header, width )
    local headerHeight = #wrappedHeader
    local height = headerHeight + #options
    local x = math.floor( ( screenWidth - width ) / 2 )
    local y = math.floor( ( screenHeight - height ) / 2 )
    
    love.graphics.setColor( COLORS.BLACK )
    love.graphics.rectangle( 'fill', x * tileWidth, y * tileHeight, width * tileWidth, height * tileHeight )
    love.graphics.setColor( COLORS.WHITE )
    love.graphics.rectangle( 'line', x * tileWidth, y * tileHeight, width * tileWidth, height * tileHeight )
    
    love.graphics.setColor( COLORS.WHITE )
    love.graphics.print( header, (x + math.floor( width / 2 ) - math.floor( utf8.len( header ) / 2 ) ) * tileWidth, y * tileHeight )
    
    local optionY = headerHeight
    local letterIndex = string.byte( 'a' )
    for _, optionText in ipairs( options ) do
        local text = "("..string.char( letterIndex )..") "..optionText
        love.graphics.print( text, x * tileWidth, ( y + optionY ) * tileHeight )
        letterIndex = letterIndex + 1
        optionY = optionY + 1
    end
end

function InventoryMenu( header, inventory, inventoryWidth, screenWidth, screenHeight )
    local options = {}
    if #inventory.items == 0 then 
        options = { "物品欄為空的。" }
    else
        for _, i in ipairs( inventory.items ) do
            table.insert( options, i.name )
        end
    end
    Menu( header, options, inventoryWidth, screenWidth, screenHeight )
end
    