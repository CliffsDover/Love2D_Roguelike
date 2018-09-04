Object = require 'Libraries/classic/classic'
require 'Part09/Colors'
require 'Part09/GameMessages'

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
        
        if item_component.targeting and not( args[ 'target_x' ] or args[ 'target_y' ] ) then
            results[ 'targeting' ] = item_entity
        else
            -- merge args?
            if item_component.use_function_args then
                for k, v in pairs( item_component.use_function_args ) do
                    args[ k ] = v
                end
            end

            local item_use_results = item_component.use_function( self.owner, args )

            for _, item_use_result in ipairs( item_use_results ) do
                if item_use_result[ 'consumed' ] == true then
                    self:remove_item( item_entity )
                end
                
                --for k, v in pairs( item_use_result ) do
                --    results[ k ] = v
                --end
                
                table.insert( results, item_use_result )
            end
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

function Inventory:drop_item( item )
   local result = {}
   local results = {}
   
   item.x = self.owner.x
   item.y = self.owner.y   
   self:remove_item( item )
   result[ 'item_dropped' ] = item
   result[ 'message' ] = Message( "你將"..item.name.."丟到地上。", COLORS.YELLOW )
   table.insert( results, result )
   return results
end

