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

-- BARLEY
x_farming.register_plant('x_farming:barley', {
    description = S('Barley Seed') .. '\n' .. S('Compost chance') .. ': 30%',
    short_description = S('Barley Seed'),
    paramtype2 = 'meshoptions',
    inventory_image = 'x_farming_barley_seed.png',
    steps = 8,
    minlight = 13,
    maxlight = 14,
    fertility = { 'grassland' },
    groups = { flammable = 4 },
    place_param2 = 0,
})

-- needed
local override_def = {
    description = S('Barley') .. '\n' .. S('Compost chance') .. ': 50%',
    short_description = S('Barley'),
    groups = {
        -- X Farming
        compost = 50,
        -- MCL
        compostability = 50
    },
    _mcl_blast_resistance = 0,
}

minetest.override_item('x_farming:barley', override_def)

-- Registered before the stairs so the stairs get fuel recipes.
minetest.register_craft({
    type = 'fuel',
    recipe = 'x_farming:barley_stack',
    burntime = 3,
})

if minetest.get_modpath('stairs') then
    do
        local recipe = 'x_farming:barley'
        local groups = { snappy = 3, flammable = 4 }
        local images = { 'x_farming_barley_stack_side.png' }
        local sounds = x_farming.node_sound_leaves_defaults()

        stairs.register_stair('barley_stack', recipe, groups, images, S('Barley Stack Stair'),
            sounds, true)
        stairs.register_stair_inner('barley_stack', recipe, groups, images, '',
            sounds, true, S('Inner Barley Stack Stair'))
        stairs.register_stair_outer('barley_stack', recipe, groups, images, '',
            sounds, true, S('Outer Barley Stack Stair'))
        stairs.register_slab('barley_stack', recipe, groups, images, S('Barley Stack Slab'),
            sounds, true)
    end
end

---crate
x_farming.register_crate('crate_barley_3', {
    description = S('Barley Crate'),
    short_description = S('Barley Crate'),
    tiles = { 'x_farming_crate_barley_3.png' },
    _custom = {
        crate_item = 'x_farming:barley'
    }
})

minetest.register_on_mods_loaded(function()
    local deco_place_on = {}
    local deco_biomes = {}

    -- MTG
    if minetest.get_modpath('default') then
        table.insert(deco_place_on, 'default:dry_dirt_with_dry_grass')
        table.insert(deco_biomes, 'savanna')
    end

    -- Everness
    if minetest.get_modpath('everness') then
        table.insert(deco_place_on, 'everness:dry_dirt_with_dry_grass')
        table.insert(deco_biomes, 'everness:baobab_savanna')
    end

    -- MCL
    if minetest.get_modpath('mcl_core') then
        table.insert(deco_place_on, 'mcl_core:dirt_with_grass')
        table.insert(deco_biomes, 'Savanna')
        table.insert(deco_biomes, 'SavannaM')
    end

    if next(deco_place_on) and next(deco_biomes) then
        minetest.register_decoration({
            name = 'x_farming:barley',
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
                'x_farming:barley_5',
                'x_farming:barley_6',
                'x_farming:barley_7',
                'x_farming:barley_8'
            },
            param2 = 11,
        })
    end
end)
