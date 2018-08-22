require 'Part09/GameStates'
require 'Part09/RenderFunctions'
require 'Part09/GameMessages'
require 'Part09/Colors'

function kill_player( player )
    player.char = '屍'
    player.color = { 1, 0, 0, 1 }
    
    --return '你死亡了…', GAME_STATES.PLAYER_DEAD
    return Message( '你死亡了…', COLORS.RED ), GAME_STATES.PLAYER_DEAD
end

function kill_monster( monster )
    local death_message = Message( monster.name.."死亡了…", COLORS.ORANGE )
    monster.char = '屍'
    monster.color = { 1, 0, 0, 1 }  
    monster.blocks = false
    monster.fighter = nil
    monster.AI = nil
    monster.name = monster.name.."的屍體"
    monster.render_order = RENDER_ORDER.CORPSE
    return death_message
end


