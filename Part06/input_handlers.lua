require 'Libraries/Input'

function handle_keys()
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
    elseif input:pressed( "escape" ) then 
        return { exit = true }
    end
    
    
    if input:pressed( "mouse1" ) then 
        return { mouse = { left = 1, right = 0 } } 
    elseif input:pressed( "mouse2" ) then 
        return { mouse = { left = 0, right = 1 } }
    end
    
end