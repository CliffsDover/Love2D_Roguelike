require 'Part09/GameMessages'
Object = require 'Libraries/classic/classic'

BasicMonsterAI = Object:extend()
ConfusedMonsterAI = Object:extend()

function BasicMonsterAI:new()
   
end

function BasicMonsterAI:take_turn( target, gameMap, entities)
    local results = {}
    --print( self.owner.name.."還在想什麼時候輪到自己行動…" ) 
    local monster = self.owner
    if gameMap.tiles[monster.x][monster.y].is_in_fov then
        if monster:distance_to( target ) >= 2 then
            --monster:move_towards( target.x, target.y, gameMap, entities )
            monster:move_astar( target, entities, gameMap )
        elseif target.fighter.hp > 0 then
           -- print( "攻擊!" )
           table.insert( results, monster.fighter:attack( target ) )
        end
            
        
    end
    return results
end

function ConfusedMonsterAI:new( previous_AI, number_of_turns )
    self.previous_AI = previous_AI
    self.number_of_turns = number_of_turns or 10
end

function ConfusedMonsterAI:take_turn( target, gameMap, entities )
    local results = {}
    
    if self.number_of_turns > 0 then
        local random_x = self.owner.x + love.math.random( -1, 1 )
        local random_y = self.owner.y + love.math.random( -1, 1 )
        if ( random_x ~= self.owner.x ) and ( random_y ~= self.owner.y ) then
            self.owner:move_towards( random_x, random_y, gameMap, entities )
        end
        self.number_of_turns = self.number_of_turns - 1
    else
        self.owner.AI = self.previous_AI
        table.insert( results, { message = Message( self.owner.name.."不再迷惑。", COLORS.RED ) } )
    end
    
    return results
end
    

