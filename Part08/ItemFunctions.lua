require 'Part08/GameMessages'
require 'Part08/Colors'

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


