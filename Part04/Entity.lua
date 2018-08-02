Object = require 'Libraries/classic/classic'

Entity = Object:extend()

function Entity:new( _x, _y, _char, _color )
    self.x = _x
    self.y = _y
    self.char = _char
    self.color = _color
end

function Entity:update( dt )
    
end


function Entity:draw()
    love.graphics.setColor( self.color )
    love.graphics.print( self.char, ( self.x - 1 ) * tileWidth, ( self.y - 1 ) * tileHeight )
end



function Entity:move( dx, dy )
    self.x = self.x + dx
    self.y = self.y + dy 
end
