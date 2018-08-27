Object = require 'Libraries/classic/classic'
require 'Part09/GameMessages'
require 'Part09/Colors'

Fighter = Object:extend()

function Fighter:new( hp, defense, power )
    self.max_hp = hp
    self.hp = hp
    self.defense = defense
    self.power = power
end

function Fighter:take_damage( amount )
    local results = {}
    self.hp = self.hp - amount
    if self.hp <= 0 then
        results = { dead = self.owner }
        self.hp = 0
    end
    return results
end

function Fighter:attack( target )
    local results
    local damage = self.power - target.fighter.defense
    if damage > 0 then
        --target.fighter:take_damage( damage )
        --print( self.owner.name.."攻擊了"..target.name..",並造成了"..damage.."點傷害。" )
        results = { message = Message( self.owner.name.."攻擊了"..target.name.."，並造成了"..damage.."點傷害。", COLORS.WHITE ) }
        local take_damage_results = target.fighter:take_damage( damage )
        
        if take_damage_results then
            --print( take_damage_results["dead"] )
            for k, v in pairs( take_damage_results ) do
                results[ k ] = v
            end
        end
    else
        --print( self.owner.name.."攻擊了"..target.name..",但並沒有造成傷害。" )
        results = { message = Message( self.owner.name.."攻擊了"..target.name.."，但並沒有造成傷害。", COLORS.WHITE ) }
    end
    return results
end


function Fighter:heal( amount )
    self.hp = self.hp + amount
    if self.hp > self.max_hp then self.hp = self.max_hp end
end


