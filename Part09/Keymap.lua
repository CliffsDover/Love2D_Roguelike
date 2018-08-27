require 'Part09/GameStates'


function BindKeymap( input, keymapState )

    if keymapState == GAME_STATES.PLAYERS_TURN then 
        bind_player_turn_keys( input ) 
    elseif keymapState == GAME_STATES.SHOW_INVENTORY or keymapState == GAME_STATES.DROP_INVENTORY then 
        bind_inventory_keys( input )
    elseif keymapState == GAME_STATES.PLAYER_DEAD then 
        bind_player_dead_keys( input )    
    elseif keymapState == GAME_STATES.TARGETING then 
        bind_targeting_keys( input )        
    end

end


function bind_inventory_keys( input )
    input:unbindAll()
    local key = 'a'
    local keyASCII = string.byte( key )
    for ascii = keyASCII, keyASCII + 25 do
        key = string.char( ascii )
        --print( "binding "..key ) 
        input:bind( key, key )
    end
    
    input:bind( "escape", "escape" )
end

function bind_player_turn_keys( input )
    input:unbindAll()
    input:bind( "up", "up" )
    input:bind( "down", "down" )
    input:bind( "left", "left" )
    input:bind( "right", "right" )
    input:bind( "j", "j" )
    input:bind( "k", "k" )
    input:bind( "h", "h" )
    input:bind( "l", "l" )
    input:bind( "y", "y" )
    input:bind( "u", "u" )
    input:bind( "b", "b" )
    input:bind( "n", "n" )
    input:bind( ".", "wait" )
    input:bind( "mouse1", "mouse1" )
    input:bind( "mouse2", "mouse2" )
    input:bind( "g", "pickup" )
    input:bind( "i", "inventory" )
    input:bind( "d", "drop_inventory" )
    input:bind( "escape", "escape" )
end


function bind_player_dead_keys( input )
    input:unbindAll()
    input:bind( "i", "inventory" )
    input:bind( "escape", "escape" )
end

function bind_targeting_keys( input )
    input:unbindAll()
    input:bind( "mouse1", "confirm" )
    input:bind( "mouse2", "cancel" )
    input:bind( "escape", "escape" )
end
