Object = require 'Libraries/classic/classic'

BasicMonsterAI = Object:extend()

function BasicMonsterAI:new()
   
end

function BasicMonsterAI:take_turn()
    print( self.owner.name.."還在想什麼時候輪到自己行動…" )
end


