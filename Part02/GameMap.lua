Object = require 'Libraries/classic/classic'
require 'Part02/Tile'

GameMap = Object:extend()

function GameMap:new( width, height )
    self.width = width
    self.height = height
    self.tiles = self:initializeTiles()    
end

function GameMap:update( dt )
    
end


function GameMap:draw()
   
end

function GameMap:initializeTiles()
    local tiles = {}
    
    for i = 1, self.width do
        local column = {}
        for i = 1, self.height do
            local tile = Tile( false )
            table.insert( column, tile )
        end
        
        table.insert( tiles, column )
    end
    
    tiles[31][23].blocked = true
    tiles[31][23].block_sight = true
    tiles[32][23].blocked = true
    tiles[32][23].block_sight = true
    tiles[33][23].blocked = true
    tiles[33][23].block_sight = true
    
    return tiles
end


function GameMap:is_blocked( x, y )
    if self.tiles[x][y].blocked then return true else return false end
end



