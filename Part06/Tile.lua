Object = require 'Libraries/classic/classic'

Tile = Object:extend()

function Tile:new( blocked, block_sight )
    self.blocked = blocked
    if block_sight == nil then block_sight = blocked end
    self.block_sight = block_sight
    self.is_in_fov = false
    self.explored = false
    self.visibility = 0
end

function Tile:update( dt )
    
end


function Tile:draw()
    
end

