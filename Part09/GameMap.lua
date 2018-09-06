Object = require 'Libraries/classic/classic'
require 'Part09/Tile'
require 'Part09/Rect'
require 'Part09/Fighter'
require 'Part09/AI'
require 'Part09/Colors'
require 'Part09/Item'
require 'Part09/ItemFunctions'
require 'Part09/GameMessages'

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


function GameMap:make_map( max_rooms, room_min_size, room_max_size, map_width, map_height, player, entities, max_monsters_per_room, max_items_per_room )
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
            self:place_entities( new_room, entities, max_monsters_per_room, max_items_per_room )
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
            self.tiles[x][y].is_in_fov = false
        end
    end
end


function lightCalbak(fov, x, y)
    --print( "[lightCalbak] "..(x)..','..(y) )
    if x < 1 or x > mapWidth or y < 1 or y > mapHeight then return true end
    local block_sight = fov.gameMap:is_block_sight( x, y )

    if block_sight then
        return false
    else
        return true
    end
end

function computeCalbak( x, y, r, v)
    --print( "[computeCalbak] "..(x)..','..(y).." "..r.." "..v )

    gameMap.tiles[x][y].is_in_fov = ( v > 0 and true or false )
    gameMap.tiles[x][y].visibility = v
    return
end

function GameMap:recompute_fov()
    self:reset_fov()
    self.fov:compute( player.x, player.y, 5, computeCalbak )
end

function GameMap:initialize_fov()
     --print( gameMap.tiles[21][16].blocked )
    self.fov = ROT.FOV.Precise:new( lightCalbak )
    self.fov.gameMap = self
    --fov=ROT.FOV.Bresenham:new(lightCalbak, {useDiamond=true})
end

function GameMap:place_entities( room, entities, max_monsters_per_room, max_items_per_room )
    num_of_monsters = love.math.random( 0, max_monsters_per_room )
    num_of_items = love.math.random( 0, max_items_per_room )

    for i = 0, num_of_monsters - 1 do
        local x = love.math.random( room.x1 + 1, room.x2 - 1 )
        local y = love.math.random( room.y1 + 1, room.y2 - 1 )
        local foundEmptyCell = false
        for _, e in ipairs( entities ) do
            if not( e.x == x and e.y == y ) then
                foundEmptyCell = true
            end
        end

        if foundEmptyCell then
            local monster
            if love.math.random( 2 ) == 1 then
                local fighter_component = Fighter( 10, 0, 2 )
                local AI_component = BasicMonsterAI()
                monster = Entity( x, y, '怪', COLORS.LIGHTER_LIME , '鼠怪', true, RENDER_ORDER.ACTOR, fighter_component, AI_component )
            else
                local fighter_component = Fighter( 16, 1, 4 )
                local AI_component = BasicMonsterAI()
                monster = Entity( x, y, '妖', COLORS.LIGHTER_GREEN, '蛇妖', true, RENDER_ORDER.ACTOR, fighter_component, AI_component )
            end

            table.insert( entities, monster )
        end
    end

    for i = 0, num_of_items - 1 do
        local x = love.math.random( room.x1 + 1, room.x2 - 1 )
        local y = love.math.random( room.y1 + 1, room.y2 - 1 )
        local foundEmptyCell = false
        for _, e in ipairs( entities ) do
            if not( e.x == x and e.y == y ) then
                foundEmptyCell = true
            end
        end

        if foundEmptyCell then
            local item_chance = love.math.random( 100 )
            local item_component
            local item
            if item_chance < 25 then
                item_component = Item( heal, { amount = 4 } )
                item =  Entity( x, y, '藥', COLORS.LIGHTEST_VIOLET, '藥水', false, RENDER_ORDER.ITEM, nil, nil, item_component )
            elseif item_chance < 50 then
                item_component = Item( cast_fireball, { damage = 12, radius = 3 }, true, Message( "按滑鼠左鍵以選擇目標來發射火球，或按滑鼠右鍵取消。", COLORS.CYAN ) )
                item =  Entity( x, y, '卷', COLORS.RED, '火球卷軸', false, RENDER_ORDER.ITEM, nil, nil, item_component )
            elseif item_chance < 75 then
                item_component = Item( cast_confuse, nil, true, Message( "按滑鼠左鍵以選擇目標來迷惑目標，或按滑鼠右鍵取消。", COLORS.CYAN ) )
                item =  Entity( x, y, '卷', COLORS.PINK, '迷惑卷軸', false, RENDER_ORDER.ITEM, nil, nil, item_component )
            else
                item_component = Item( cast_lightning, { damage = 20, maximum_range = 5 } )
                item =  Entity( x, y, '卷', COLORS.YELLOW, '閃電卷軸', false, RENDER_ORDER.ITEM, nil, nil, item_component )
            end

            table.insert( entities, item )
        end
    end

end

function GameMap:IsVisible( x, y )
    if self.tiles[x][y].is_in_fov then return true else return false end
end
