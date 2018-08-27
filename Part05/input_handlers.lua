require 'Libraries/Input'

function handle_keys()
    local interval = 0.125
    if input:down( "up", interval ) then 
        return { move = { x = 0, y = -1 } } 
    elseif input:down( "down", interval ) then 
        return { move = { x = 0, y = 1 } } 
    elseif input:down( "left", interval ) then 
        return { move = { x = -1, y = 0 } } 
    elseif input:down( "right", interval ) then 
        return { move = { x = 1, y = 0 } }
    elseif input:pressed( "escape" ) then 
        return { exit = true }
    end 
end