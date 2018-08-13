Object = require 'Libraries/classic/classic'
require 'Part08/Colors'
require 'Part08/GameMessages'

Inventory = Object:extend()

function Inventory:new( capacity )
    self.capacity = capacity
    self.items = {}
end

function Inventory:add_item( item )
    local results = {}
    
    if #self.items >= self.capacity then
        results["item_added"] = nil
        results["message"] = Message( "你無法再拿取東西，你的背包已經滿了。", COLORS.YELLOW ) 
    else
        results["item_added"] = item
        results["message"] = Message( "你撿起了"..item.name.."。", COLORS.LIGHT_BLUE ) 
        table.insert( self.items, item )
    end
    
    return results
end
