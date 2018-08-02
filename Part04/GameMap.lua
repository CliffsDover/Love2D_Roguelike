Object = require 'Libraries/classic/classic'
require 'Part04/Tile'
require 'Part04/Rect'

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
            local tile = Tile( true )
            table.insert( column, tile )
        end
        
        table.insert( tiles, column )
    end
    
    return tiles
end


function GameMap:is_blocked( x, y )
    if self.tiles[x][y].blocked == true then 
        return true 
    else 
        return false
    end
end

function GameMap:is_block_sight( x, y )
    if self.tiles[x][y].block_sight == true then 
        return true 
    else 
        return false 
    end
end

function GameMap:create_room( room )
    --print( "[GameMap:create_room] " .. room.x1 .. "," .. room.y1 .. " " .. room.x2 .. "," .. room.y2 )
    for x = room.x1 + 1, room.x2 - 1 do
        for y = room.y1 + 1, room.y2 - 1 do
            self.tiles[x][y].blocked = false
            self.tiles[x][y].block_sight = false
        end
    end    
end


function GameMap:make_map( max_rooms, room_min_size, room_max_size, map_width, map_height, player )
    --local room1 = Rect( 20, 15, 10, 15 )
    --local room2 = Rect( 35, 15, 10, 15 )

    --self:create_room( room1 )
    --self:create_room( room2 )
    
    --self:create_h_tunnel(25, 40, 23)
    local rooms = {}
    local num_rooms = 0
    
    for r = 1, max_rooms do
        local w = love.math.random( room_min_size, room_max_size )
        local h = love.math.random( room_min_size, room_max_size )
        local x = love.math.random( map_width - w - 1 )
        local y = love.math.random( map_height - h - 1 )
        
        local new_room = Rect( x, y, w, h )
        local isIntersected = false
        for _, other_room in ipairs( rooms ) do
            if new_room:intersect( other_room ) then
                isIntersected = true
                break
            end
        end
        
        if not isIntersected then
            self:create_room( new_room )
            local new_x, new_y = new_room:center()
            if num_rooms == 0 then
                player.x = new_x
                player.y = new_y
            else
                local prev_x, prev_y = rooms[num_rooms]:center()
                if love.math.random( 2 ) == 1 then
                    self:create_h_tunnel( prev_x, new_x, prev_y )
                    self:create_v_tunnel( prev_y, new_y, new_x )
                else
                    self:create_v_tunnel( prev_y, new_y, prev_x )
                    self:create_h_tunnel( prev_x, new_x, new_y )
                end
            end
                
            table.insert( rooms, new_room )
            num_rooms = num_rooms + 1
        end
        
    end
    
end

function GameMap:create_h_tunnel( x1, x2, y )
    for x = math.min( x1, x2 ), math.max( x1, x2 ) do
        --print( "[GameMap:create_h_tunnel] "..x1.." "..x2.." "..x.." "..y )
        self.tiles[x][y].blocked = false
        self.tiles[x][y].block_sight = false
    end
end

function GameMap:create_v_tunnel( y1, y2, x )
    for y = math.min( y1, y2 ), math.max( y1, y2 ) do
        self.tiles[x][y].blocked = false
        self.tiles[x][y].block_sight = false
    end
end

function GameMap:reset_fov()
    for x = 1, mapWidth do
        for y = 1, mapHeight do
            gameMap.tiles[x][y].is_in_fov = false
        end
    end   
end

