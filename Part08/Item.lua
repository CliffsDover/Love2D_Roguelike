Object = require 'Libraries/classic/classic'

Item = Object:extend()

function Item:new( use_function, use_function_args )
    self.use_function = use_function
    self.use_function_args = use_function_args
end
