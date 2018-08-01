Object = require 'Libraries/classic/classic'

Tile = Object:extend()

function Tile:new( blocked, blockSight )
    self.blocked = blocked
    if blockSight == nil then blockSight = blocked end
    self.blockSight = blockSight
end

function Tile:update( dt )
    
end


function Tile:draw()
    
end

