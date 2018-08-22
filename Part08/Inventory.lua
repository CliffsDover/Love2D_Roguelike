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

function Inventory:use( item_entity, args )
    args = args or {}
    local results = {}
    local item_component = item_entity.item
    if item_component.use_function == nil then
        results[ 'message' ] = Message( item_entity.name.."無法被使用。", COLORS.YELLOW )
    else
        -- merge args?
        for k, v in pairs( item_component.use_function_args ) do
            args[ k ] = v
        end
        
        local item_use_results = item_component.use_function( self.owner, args )
        
        for _, item_use_result in ipairs( item_use_results ) do
            if item_use_result[ 'consumed' ] == true then
                self:remove_item( item_entity )
            end
            
            for k, v in pairs( item_use_result ) do
                results[ k ] = v
            end
            
            --table.insert( results, item_use_result )
        end
        
    end
    return results
end


function Inventory:remove_item( item )
    self.items[ item ] = nil
    local itemIndex = 0
    for _, i in ipairs( self.items ) do
        itemIndex = itemIndex + 1
        if i == item then
            break
        end
    end
    if itemIndex > 0 then table.remove( self.items, itemIndex ) end
end
