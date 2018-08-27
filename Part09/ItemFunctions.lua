require 'Part09/GameMessages'
require 'Part09/Colors'

function heal( owner, args )
    local entity = owner
    local amount = args[ 'amount' ]
    
    local results = {}
    
    if entity.fighter.hp == entity.fighter.max_hp then
        results[ 'consumed' ] = false
        results[ 'message' ] = Message( "您已經是滿血狀態了。", COLORS.YELLOW )
    else
        entity.fighter:heal( amount )
        results[ 'consumed' ] = true
        results[ 'message' ] = Message( "您感覺恢復一些精力。", COLORS.GREEN )
    end
    
    return { results }
end


function cast_lightning( caster, args )
    local entities = args[ 'entities' ]
    local gameMap = args[ 'gameMap' ]
    local damage = args[ 'damage' ]
    local maximum_range = args[ 'maximum_range' ]
    
    local results = {}
    
    local target = nil
    local closest_distance = maximum_range + 1
    for _, e in ipairs( entities ) do
        if e ~= caster and e.fighter and gameMap:IsVisible( e.x, e.y ) then
            local distance = caster:distance_to( e )
            
            if distance < closest_distance then
                target = e
                closest_distance = distance
            end
        end
    end
    
    if target then
        results[ 'consumed' ] = true
        results[ 'target' ] = target
        results[ 'message' ] = Message( "一道閃電擊中了"..target.name.."，發出巨大的聲響!造成了"..damage..'點的傷害。' )
        
        local take_damage_result = target.fighter:take_damage( damage )
        for k, v in pairs( take_damage_result ) do results[ k ] = v end
    else
        results[ 'consumed' ] = false
        results[ 'target' ] = nil
        results[ 'message' ] = Message( "在附近並沒有任何的敵人。" )        
    end
    
    return { results }
end


function cast_fireball( caster, args )
    local entities = args[ 'entities' ]
    local gameMap = args[ 'gameMap' ]
    local damage = args[ 'damage' ]
    local radius = args[ 'radius' ]
    local target_x = args[ 'target_x' ]
    local target_y = args[ 'target_y' ]    
    
    local results = {}
    local result = {}
    
    if not gameMap:IsVisible( target_x, target_y ) then
        result[ 'consumed' ] = false
        result[ 'message' ] = Message( "你無法攻擊視野外的目標。", COLORS.YELLOW )
        return { result }
    end
    
    result[ 'consumed' ] = true
    result[ 'message' ] = Message( "一團火球射出並爆炸，相鄰"..radius.."格內的所有事物皆受到了傷害。", COLORS.ORANGE )
    table.insert( results, result )
    
    for _, e in ipairs( entities ) do
        if e:distance( target_x, target_y ) <= radius and e.fighter then
            local result = {}
            result[ 'message' ] = Message( e.name.."被燒灼，造成了"..damage.."點的傷害。", COLORS.ORANGE )
            table.insert( results, result )
                
            local take_damage_result = e.fighter:take_damage( damage )
            table.insert( results, take_damage_result )
        end
    end
    
    return results
end
