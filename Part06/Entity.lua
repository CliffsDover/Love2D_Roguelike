Object = require 'Libraries/classic/classic'

Entity = Object:extend()

function Entity:new( _x, _y, _char, _color, _name, _blocks, _fighter, _AI )
    self.x = _x
    self.y = _y
    self.char = _char
    self.color = _color
    self.name = _name
    self.blocks = _blocks or false
    self.fighter = _fighter or nil
    self.AI = _AI or nil
    
    if self.fighter then
        self.fighter.owner = self
    end
    if self.AI then
        self.AI.owner = self   
    end
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

function get_blocking_entities_at_location( entities, x, y )
    for _, e in ipairs( entities ) do
        if e.blocks and e.x == x and e.y ==y then
            return e
        end
    end
    return nil
end

