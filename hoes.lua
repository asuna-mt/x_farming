--[[
    X Farming. Extends Minetest farming mod with new plants, crops and ice fishing.
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

x_farming.register_hoe('x_farming:hoe_wood', {
    description = S('Wooden Hoe'),
    inventory_image = 'x_farming_tool_woodhoe.png',
    wield_scale = { x = 2, y = 2, z = 1 },
    max_uses = 30,
    material = 'group:wood',
    groups = { hoe = 1, flammable = 2 },
})

x_farming.register_hoe('x_farming:hoe_stone', {
    description = S('Stone Hoe'),
    inventory_image = 'x_farming_tool_stonehoe.png',
    wield_scale = { x = 2, y = 2, z = 1 },
    max_uses = 90,
    material = 'group:stone',
    groups = { hoe = 1 }
})

local hoe_steel_material

if minetest.get_modpath('default') then
    hoe_steel_material = 'default:steel_ingot'
elseif minetest.get_modpath('mcl_core') then
    hoe_steel_material = 'mcl_core:iron_ingot'
end

if hoe_steel_material then
    x_farming.register_hoe('x_farming:hoe_steel', {
        description = S('Steel Hoe'),
        inventory_image = 'x_farming_tool_steelhoe.png',
        wield_scale = { x = 2, y = 2, z = 1 },
        max_uses = 500,
        material = hoe_steel_material,
        groups = { hoe = 1 }
    })
end
