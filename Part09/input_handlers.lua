require 'Libraries/Input'
require 'Part09/GameStates'
require 'Part09/Keymap'

function handle_keys( gameState )
    if keymapState ~= gameState then
        keymapState = gameState
        BindKeymap( input, keymapState )
    end
    
    if gameState == GAME_STATES.PLAYERS_TURN then
        return handle_player_turn_keys()
    elseif gameState == GAME_STATES.PLAYER_DEAD then
        return handle_player_dead_keys()
    elseif gameState == GAME_STATES.SHOW_INVENTORY or gameState == GAME_STATES.DROP_INVENTORY then
        return handle_inventory_keys()        
    end
        
end


function handle_player_turn_keys()    
    local interval = 0.125
    if input:down( "up", interval ) or input:down( "k", interval ) then 
        return { move = { x = 0, y = -1 } } 
    elseif input:down( "down", interval ) or input:down( "j", interval )then 
        return { move = { x = 0, y = 1 } } 
    elseif input:down( "left", interval ) or input:down( "h", interval ) then 
        return { move = { x = -1, y = 0 } } 
    elseif input:down( "right", interval ) or input:down( "l", interval ) then 
        return { move = { x = 1, y = 0 } }
    elseif input:down( "y", interval ) then 
        return { move = { x = -1, y = -1 } } 
    elseif input:down( "u", interval ) then 
        return { move = { x = 1, y = -1 } } 
    elseif input:down( "b", interval ) then 
        return { move = { x = -1, y = 1 } } 
    elseif input:down( "n", interval ) then 
        return { move = { x = 1, y = 1 } }
    elseif input:down( "wait", interval ) then 
        return { move = { x = 0, y = 0 } }
    elseif input:down( "pickup", interval ) then 
        return { pickup = true }    
    elseif input:down( "inventory", interval ) then 
        return { show_inventory = true }      
    elseif input:down( "drop_inventory", interval ) then 
        return { drop_inventory = true }          
    elseif input:pressed( "escape" ) then 
        return { exit = true }
    end
    
    
    if input:pressed( "mouse1" ) then 
        return { mouse = { left = 1, right = 0 } } 
    elseif input:pressed( "mouse2" ) then 
        return { mouse = { left = 0, right = 1 } }
    end
    
end


function handle_player_dead_keys()
    local interval = 0.125
    if input:down( "inventory", interval ) then 
        return { show_inventory = true }          
    elseif input:pressed( "escape" ) then 
        return { exit = true }
    end
end


function handle_inventory_keys()
    local interval = 0.125
    local startingKey = 'a'
    local startingKeyASCII = string.byte( startingKey )
    
    for ascii = startingKeyASCII, startingKeyASCII + 25 do
        local key = string.char( ascii )
        if input:pressed( key ) then
            --print( ascii - startingKeyASCII )
            return { inventory_index = ascii - startingKeyASCII + 1 }
        end
    end
    
    if input:pressed( "escape" ) then 
        return { exit = true }
    end
    
    return nil
end


