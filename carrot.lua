--[[
    X Farming. Extends Minetest farming mod with new plants, crops and ice fishing.
    Copyright (C) 2024 SaKeL

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
local minlight = 13
local maxlight = 14

-- carrot
x_farming.register_plant('x_farming:carrot', {
    description = S('Planting Carrot') .. '\n' .. S('Compost chance') .. ': 30%',
    short_description = S('Planting Carrot'),
    paramtype2 = 'meshoptions',
    inventory_image = 'x_farming_carrot_seed.png',
    steps = 8,
    minlight = minlight,
    maxlight = maxlight,
    fertility = { 'grassland' },
    groups = { flammable = 4, compost = 65 },
    place_param2 = 3,
})

-- needed
local carrot_def = {
    description = S('Carrot') .. '\n' .. S('Compost chance') .. ': 65%\n'
        .. minetest.colorize(x_farming.colors.brown, S('Hunger') .. ': 3'),
    short_description = S('Carrot'),
    groups = {
        -- X Farming
        compost = 65,
        -- MCL
        food = 2,
        eatable = 1,
        compostability = 65
    },
    _mcl_saturation = 3.6,
    _mcl_blast_resistance = 0,
}

if minetest.get_modpath('farming') then
    carrot_def.on_use = minetest.item_eat(3)
end

if minetest.get_modpath('mcl_farming') then
    carrot_def.on_place = minetest.item_eat(3)
    carrot_def.on_secondary_use = minetest.item_eat(3)
end

minetest.override_item('x_farming:carrot', carrot_def)

-- Golden carrot
local golden_carrot_def = {
    description = S('Golden Carrot') .. '\n' .. minetest.colorize(x_farming.colors.brown, S('Hunger') .. ': 10'),
    inventory_image = 'x_farming_carrot_golden.png',
    wield_image = 'x_farming_carrot_golden.png',
    groups = {
        -- MCL
        food = 2,
        eatable = 1,
    },
    _mcl_saturation = 14.4,
}

if x_farming.hbhunger ~= nil or x_farming.hunger_ng ~= nil then
    golden_carrot_def.description = golden_carrot_def.description .. '\n' .. minetest.colorize(x_farming.colors.red, S('Heal') .. ': 10')
end

if minetest.get_modpath('farming') then
    golden_carrot_def.on_use = minetest.item_eat(10)
end

if minetest.get_modpath('mcl_farming') then
    golden_carrot_def.on_place = minetest.item_eat(10)
    golden_carrot_def.on_secondary_use = minetest.item_eat(10)
end

minetest.register_craftitem('x_farming:carrot_golden', golden_carrot_def)

---crate
x_farming.register_crate('crate_carrot_3', {
    description = S('Carrot Crate'),
    short_description = S('Carrot Crate'),
    tiles = { 'x_farming_crate_carrot_3.png' },
    _custom = {
        crate_item = 'x_farming:carrot'
    }
})

minetest.register_on_mods_loaded(function()
    local deco_place_on = {}
    local deco_biomes = {}

    -- MTG
    if minetest.get_modpath('default') then
        table.insert(deco_place_on, 'default:dirt_with_grass')
        table.insert(deco_biomes, 'grassland')
    end

    -- Everness
    if minetest.get_modpath('everness') then
        table.insert(deco_place_on, 'everness:dirt_with_coral_grass')
        table.insert(deco_biomes, 'everness:coral_forest')
    end

    -- MCL
    if minetest.get_modpath('mcl_core') then
        table.insert(deco_place_on, 'mcl_core:dirt_with_grass')
        table.insert(deco_biomes, 'Plains')
    end

    if next(deco_place_on) and next(deco_biomes) then
        minetest.register_decoration({
            name = 'x_farming:carrot',
            deco_type = 'simple',
            place_on = deco_place_on,
            sidelen = 16,
            noise_params = {
                offset = -0.1,
                scale = 0.1,
                spread = { x = 50, y = 50, z = 50 },
                seed = 4242,
                octaves = 3,
                persist = 0.7
            },
            biomes = deco_biomes,
            y_max = 31000,
            y_min = 1,
            decoration = {
                'x_farming:carrot_5',
                'x_farming:carrot_6',
                'x_farming:carrot_7',
                'x_farming:carrot_8',
            },
            param2 = 3,
        })
    end
end)
