Object = require 'Libraries/classic/classic'

Item = Object:extend()

function Item:new( use_function, use_function_args, targeting, targeting_message )
    self.use_function = use_function
    self.use_function_args = use_function_args
    self.targeting = targeting or false
    self.targeting_message = targeting_message or nil
end
