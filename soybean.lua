--[[
    X Farming. Extends Minetest farming mod with new plants, crops and ice fishing.
    Copyright (C) 2022 SaKeL <juraj.vajda@gmail.com>

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

-- SOYBEAN
farming.register_plant('x_farming:soybean', {
    description = S('Soybean Seed') .. '\n' .. S('Compost chance') .. ': 30%',
    short_description = S('Soybean Seed'),
    paramtype2 = 'meshoptions',
    inventory_image = 'x_farming_soybean_seed.png',
    steps = 7,
    minlight = 13,
    maxlight = default.LIGHT_MAX,
    fertility = { 'grassland' },
    groups = { flammable = 4 },
    place_param2 = 3,
})

-- needed
minetest.override_item('x_farming:soybean', {
    description = S('Soybean') .. '\n' .. S('Compost chance') .. ': 65%',
    short_description = S('Soybean'),
    groups = { compost = 65 }
})

minetest.register_craftitem('x_farming:bottle_soymilk', {
    description = S('Soymilk Bottle'),
    short_description = S('Soymilk Bottle'),
    tiles = { 'x_farming_bottle_soymilk.png' },
    inventory_image = 'x_farming_bottle_soymilk.png',
    wield_image = 'x_farming_bottle_soymilk.png',
    groups = { vessel = 1 },
    sounds = default.node_sound_glass_defaults(),
})

minetest.register_craftitem('x_farming:bottle_soymilk_raw', {
    description = S('Raw Soymilk Bottle'),
    short_description = S('Raw Soymilk Bottle'),
    tiles = { 'x_farming_bottle_soymilk_raw.png' },
    inventory_image = 'x_farming_bottle_soymilk_raw.png',
    wield_image = 'x_farming_bottle_soymilk_raw.png',
    groups = { vessel = 1, dig_immediate = 3, attached_node = 1 },
})

minetest.register_craft({
    type = 'shapeless',
    output = 'x_farming:bottle_soymilk_raw',
    recipe = {
        'x_farming:soybean',
        'x_farming:soybean',
        'x_farming:soybean',
        'x_farming:soybean',
        'x_farming:soybean',
        'x_farming:bottle_water'
    }
})

minetest.register_craft({
    type = 'cooking',
    output = 'x_farming:bottle_soymilk',
    recipe = 'x_farming:bottle_soymilk_raw',
    cooktime = 15,
})

minetest.register_craft({
    type = 'fuel',
    recipe = 'x_farming:soybean',
    burntime = 1,
})

minetest.register_decoration({
    name = 'x_farming:soybean_7',
    deco_type = 'simple',
    place_on = { 'default:dirt_with_grass' },
    sidelen = 16,
    noise_params = {
        offset = -0.1,
        scale = 0.1,
        spread = { x = 50, y = 50, z = 50 },
        seed = 4242,
        octaves = 3,
        persist = 0.7
    },
    biomes = { 'grassland' },
    y_max = 31000,
    y_min = 1,
    decoration = 'x_farming:soybean_7',
    param2 = 3,
})

---crate
x_farming.register_crate('crate_soybean_3', {
    description = S('Soybean Crate'),
    short_description = S('Soybean Crate'),
    tiles = { 'x_farming_crate_soybean_3.png' },
    _custom = {
        crate_item = 'x_farming:soybean'
    }
})
