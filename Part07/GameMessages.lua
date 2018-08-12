Object = require 'Libraries/classic/classic'

Message = Object:extend()
MessageLog = Object:extend()

function Message:new( text, color )
    self.text = text
    self.color = color or { 1, 1, 1, 1 }
end

function MessageLog:new( x, width, height )
    self.messages = {}
    self.x = x
    self.width = width
    self.height = height
end

function MessageLog:AddMessage( message )
    local new_message_lines = self:WrapText( message.text )
    for _, m in ipairs( new_message_lines ) do
        if #self.messages == self.height then
            table.remove( self.messages, 1 )
        end
        
        table.insert( self.messages, Message( m, message.color ) )
    end
end


function MessageLog:WrapText( text )
    local ret = {}
    local totalLen = utf8.len( text )
    local index = 1
    for i = 1, totalLen, self.width do
        local s = utf8.sub( text, i, i + self.width - 1 )
        table.insert( ret, s )
    end
    return ret
end