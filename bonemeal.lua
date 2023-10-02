--[[
    X Farming Bonemeal. Extends Minetest farming mod with new plants, crops and ice fishing.
    Copyright (C) 2023 SaKeL <juraj.vajda@gmail.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to juraj.vajda@gmail.com
--]]

local S = minetest.get_translator(minetest.get_current_modname())

--- Register craftitem definition - added to minetest.registered_items[name]
minetest.register_craftitem('x_farming:bonemeal', {
    description = S('Bonemeal - use it as a fertilizer for most plants.'),
    inventory_image = 'x_farming_x_bonemeal_bonemeal.png',
    on_use = function(itemstack, user, pointed_thing)
        local result = x_farming.x_bonemeal:on_use(itemstack, user, pointed_thing)
        return result.itemstack
    end,
})

--
-- Crafting
--

minetest.register_craft({
    output = 'x_farming:bonemeal 4',
    recipe = {
        { 'bones:bones' }
    }
})

if minetest.get_modpath('default') then
    minetest.register_craft({
        output = 'x_farming:bonemeal 4',
        recipe = {
            { 'default:coral_skeleton' }
        }
    })
end

if minetest.get_modpath('everness') then
    minetest.register_craft({
        output = 'x_farming:bonemeal 4',
        recipe = {
            { 'everness:coral_skeleton' }
        }
    })
end
