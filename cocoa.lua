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

-- how often node timers for plants will tick, +/- some random value
local function tick(pos)
    minetest.get_node_timer(pos):start(math.random(332, 572))
end

-- how often a growth failure tick is retried (e.g. too dark)
local function tick_again(pos)
    minetest.get_node_timer(pos):start(math.random(80, 160))
end

function x_farming.grow_cocoa_plant(pos, elapsed)
    local node = minetest.get_node(pos)
    local name = node.name
    local def = minetest.registered_nodes[name]

    if not def.next_plant then
        -- disable timer for fully grown plant
        return
    end

    -- check if on jungletree
    local direction = minetest.facedir_to_dir(node.param2)
    local below_pos = vector.add(pos, direction)
    local below = minetest.get_node(below_pos)
    if below.name ~= 'default:jungletree' and below.name ~= 'x_farming:jungle_tree' then
        tick_again(pos)
        return
    end

    -- check light
    local light = minetest.get_node_light(pos)
    if not light or light < def.minlight or light > def.maxlight then
        tick_again(pos)
        return
    end

    -- grow
    minetest.swap_node(pos, { name = def.next_plant, param2 = node.param2 })

    -- new timer needed?
    if minetest.registered_nodes[def.next_plant].next_plant then
        tick(pos)
    end
end

function x_farming.place_cocoa_bean(itemstack, placer, pointed_thing)
    local pt = pointed_thing
    -- check if pointing at a node
    if not pt then
        return itemstack
    end
    if pt.type ~= 'node' then
        return itemstack
    end

    local under = minetest.get_node(pt.under)
    local above = minetest.get_node(pt.above)

    local udef = minetest.registered_nodes[under.name]
    if udef and udef.on_rightclick
        and not (placer and placer:is_player()
        and placer:get_player_control().sneak)
    then
        return udef.on_rightclick(pt.under, under, placer, itemstack, pointed_thing) or itemstack
    end

    local player_name = placer and placer:get_player_name() or ''

    if minetest.is_protected(pt.under, player_name) then
        minetest.record_protection_violation(pt.under, player_name)
        return
    end

    if minetest.is_protected(pt.above, player_name) then
        minetest.record_protection_violation(pt.above, player_name)
        return
    end

    -- return if any of the nodes is not registered
    if not minetest.registered_nodes[under.name] then
        return itemstack
    end
    if not minetest.registered_nodes[above.name] then
        return itemstack
    end

    -- check if NOT pointing at the top/below of the node
    if pt.above.y == pt.under.y - 1
        or pt.above.y == pt.under.y + 1
    then
        return itemstack
    end

    -- check if you can replace the node above the pointed node
    if not minetest.registered_nodes[above.name].buildable_to then
        return itemstack
    end

    -- check if pointing at soil
    if under.name ~= 'default:jungletree' and under.name ~= 'x_farming:jungle_tree' then
        return itemstack
    end

    local direction = vector.direction(pt.above, pt.under)
    local new_param2 = minetest.dir_to_facedir(direction)

    -- add the node and remove 1 item from the itemstack
    minetest.set_node(pt.above, { name = 'x_farming:cocoa_1', param2 = new_param2 })

    tick(pt.above)
    if not minetest.is_creative_enabled(player_name) then
        itemstack:take_item()
    end

    return itemstack
end

-- COCOA
minetest.register_craftitem('x_farming:cocoa_bean', {
    description = S('Cocoa bean') .. ' (' .. S('plant on jungle tree trunk') .. ')'
        .. '\n' .. S('Compost chance') .. ': 65%',
    short_description = S('Cocoa bean'),
    tiles = { 'x_farming_cocoa_bean.png' },
    inventory_image = 'x_farming_cocoa_bean.png',
    wield_image = 'x_farming_cocoa_bean.png',
    groups = { compost = 65 },
    on_place = x_farming.place_cocoa_bean,
})

-- 1
minetest.register_node('x_farming:cocoa_1', {
    description = S('Cocoa') .. ' 1',
    short_description = S('Cocoa') .. ' 1',
    drawtype = 'nodebox',
    tiles = {
        'x_farming_cocoa_top_1.png',
        'x_farming_cocoa_bottom_1.png',
        'x_farming_cocoa_right_1.png',
        'x_farming_cocoa_left_1.png',
        'x_farming_cocoa_front_1.png',
        'x_farming_cocoa_front_1.png'
    },
    use_texture_alpha = 'clip',
    paramtype = 'light',
    sunlight_propagates = true,
    wield_scale = { x = 2, y = 2, z = 2 },
    on_rotate = function(pos, node, user, mode, new_param2)
        return false
    end,
    paramtype2 = 'facedir',
    is_ground_content = false,
    drop = {
        items = {
            { items = { 'x_farming:cocoa_bean' }, rarity = 3 },
        }
    },
    node_box = {
        type = 'fixed',
        fixed = {
            { -0.125, -0.0625, 0.1875, 0.125, 0.25, 0.4375 }, -- fruit
            { 0, 0.25, 0.3125, 0, 0.375, 0.375 }, -- stem_1
            { 0, 0.375, 0.4375, 0, 0.4375, 0.5 }, -- stem_2
            { 0, 0.3125, 0.375, 0, 0.4375, 0.4375 }, -- stem_3
        }
    },
    collision_box = {
        type = 'fixed',
        fixed = {
            { -0.125, -0.0625, 0.1875, 0.125, 0.5, 0.5 },
        },
    },
    selection_box = {
        type = 'fixed',
        fixed = {
            { -0.125, -0.0625, 0.1875, 0.125, 0.5, 0.5 },
        },
    },
    groups = {
        -- MTG
        choppy = 3,
        flammable = 2,
        plant = 1,
        cocoa = 1,
        -- MCL
        handy = 1,
        axey = 1,
        dig_by_water = 1,
        destroy_by_lava_flow = 1,
        dig_by_piston = 1,
        attached_node_facedir = 1,
        -- ALL
        not_in_creative_inventory = 1,
    },
    _mcl_blast_resistance = 3,
    _mcl_hardness = 0.2,
    sounds = x_farming.node_sound_wood_defaults(),
    next_plant = 'x_farming:cocoa_2',
    on_timer = x_farming.grow_cocoa_plant,
    minlight = 13,
    maxlight = 15,
})

-- 2
minetest.register_node('x_farming:cocoa_2', {
    description = S('Cocoa') .. ' 2',
    short_description = S('Cocoa') .. ' 2',
    drawtype = 'nodebox',
    tiles = {
        'x_farming_cocoa_top_2.png',
        'x_farming_cocoa_bottom_2.png',
        'x_farming_cocoa_right_2.png',
        'x_farming_cocoa_left_2.png',
        'x_farming_cocoa_front_2.png',
        'x_farming_cocoa_front_2.png'
    },
    use_texture_alpha = 'clip',
    paramtype = 'light',
    sunlight_propagates = true,
    wield_scale = { x = 1.5, y = 1.5, z = 1.5 },
    on_rotate = function(pos, node, user, mode, new_param2)
        return false
    end,
    paramtype2 = 'facedir',
    is_ground_content = false,
    drop = {
        items = {
            { items = { 'x_farming:cocoa_bean' }, rarity = 2 },
        }
    },
    node_box = {
        type = 'fixed',
        fixed = {
            { -0.1875, -0.1875, 0.0625, 0.1875, 0.25, 0.4375 }, -- fruit
            { 0, 0.25, 0.25, 0, 0.375, 0.375 }, -- stem_1
            { 0, 0.375, 0.375, 0, 0.5, 0.5 }, -- stem_2
            { 0, 0.375, 0.3125, 0, 0.4375, 0.375 }, -- stem_3
        }
    },
    collision_box = {
        type = 'fixed',
        fixed = {
            { -0.1875, -0.1875, 0.0625, 0.1875, 0.5, 0.5 },
        },
    },
    selection_box = {
        type = 'fixed',
        fixed = {
            { -0.1875, -0.1875, 0.0625, 0.1875, 0.5, 0.5 },
        },
    },
    groups = {
        -- MTG
        choppy = 3,
        flammable = 2,
        plant = 1,
        cocoa = 2,
        -- MCL
        handy = 1,
        axey = 1,
        dig_by_water = 1,
        destroy_by_lava_flow = 1,
        dig_by_piston = 1,
        attached_node_facedir = 1,
        -- ALL
        not_in_creative_inventory = 1,
    },
    _mcl_blast_resistance = 3,
    _mcl_hardness = 0.2,
    sounds = x_farming.node_sound_wood_defaults(),
    next_plant = 'x_farming:cocoa_3',
    on_timer = x_farming.grow_cocoa_plant,
    minlight = 13,
    maxlight = 15
})

-- 3
minetest.register_node('x_farming:cocoa_3', {
    description = S('Cocoa') .. ' 3',
    short_description = S('Cocoa') .. ' 3',
    drawtype = 'nodebox',
    tiles = {
        'x_farming_cocoa_top_3.png',
        'x_farming_cocoa_bottom_3.png',
        'x_farming_cocoa_right_3.png',
        'x_farming_cocoa_left_3.png',
        'x_farming_cocoa_front_3.png',
        'x_farming_cocoa_front_3.png'
    },
    use_texture_alpha = 'clip',
    paramtype = 'light',
    sunlight_propagates = true,
    wield_scale = { x = 1.5, y = 1.5, z = 1.5 },
    on_rotate = function(pos, node, user, mode, new_param2)
        return false
    end,
    paramtype2 = 'facedir',
    is_ground_content = false,
    drop = {
        items = {
            { items = { 'x_farming:cocoa_bean' }, rarity = 1 },
            { items = { 'x_farming:cocoa_bean' }, rarity = 2 },
        }
    },
    node_box = {
        type = 'fixed',
        fixed = {
            { -0.25, -0.3125, -0.0625, 0.25, 0.25, 0.4375 },
            { -0.0624999, 0.25, 0.25, 0.0625, 0.375, 0.4375 },
            { -0.0625, 0.375, 0.375, 0.0625, 0.5, 0.5 },
            { -0.0624999, 0.375, 0.3125, 0.0625, 0.4375, 0.375 },
        }
    },
    collision_box = {
        type = 'fixed',
        fixed = {
            { -0.25, -0.3125, -0.0625, 0.25, 0.5, 0.5 },
        },
    },
    selection_box = {
        type = 'fixed',
        fixed = {
            { -0.25, -0.3125, -0.0625, 0.25, 0.5, 0.5 },
        },
    },
    groups = {
        -- MTG
        choppy = 3,
        flammable = 2,
        plant = 1,
        leafdecay = 3,
        leafdecay_drop = 1,
        cocoa = 3,
        -- MCL
        handy = 1,
        axey = 1,
        dig_by_water = 1,
        destroy_by_lava_flow = 1,
        dig_by_piston = 1,
        attached_node_facedir = 1,
        -- ALL
        not_in_creative_inventory = 1,
    },
    _mcl_blast_resistance = 3,
    _mcl_hardness = 0.2,
    sounds = x_farming.node_sound_wood_defaults(),
    minlight = 13,
    maxlight = 15
})

-- replacement LBM for pre-nodetimer plants
minetest.register_lbm({
    name = 'x_farming:start_nodetimer_cocoa',
    nodenames = {
        'x_farming:cocoa_1',
        'x_farming:cocoa_2'
    },
    action = function(pos, node)
        tick_again(pos)
    end,
})

minetest.register_node('x_farming:jungle_with_cocoa_sapling', {
    description = S('Jungle Tree with Cocoa Sapling') .. '\n' .. S('Compost chance') .. ': 30%',
    short_description = S('Jungle Tree with Cocoa Sapling'),
    drawtype = 'plantlike',
    tiles = { 'x_farming_junglesapling.png' },
    inventory_image = 'x_farming_junglesapling.png',
    wield_image = 'x_farming_junglesapling.png',
    paramtype = 'light',
    sunlight_propagates = true,
    walkable = false,
    on_timer = x_farming.grow_jungle_tree,
    selection_box = {
        type = 'fixed',
        fixed = { -4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16 }
    },
    groups = {
        -- MTG
        snappy = 2,
        flammable = 2,
        -- MCL
        plant = 1,
        non_mycelium_plant = 1,
        deco_block = 1,
        dig_by_water = 1,
        dig_by_piston = 1,
        destroy_by_lava_flow = 1,
        compostability = 30,
        -- ALL
        dig_immediate = 3,
        attached_node = 1,
        sapling = 1,
    },
    _mcl_blast_resistance = 0,
    _mcl_hardness = 0,
    sounds = x_farming.node_sound_leaves_defaults(),

    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(300, 1500))
    end,

    on_place = function(itemstack, placer, pointed_thing)
        itemstack = x_farming.sapling_on_place(itemstack, placer, pointed_thing,
            'x_farming:jungle_with_cocoa_sapling',
            -- minp, maxp to be checked, relative to sapling pos
            { x = -3, y = -5, z = -3 },
            { x = 3, y = 31, z = 3 },
            -- maximum interval of interior volume check
            4)

        return itemstack
    end,
})

-- trunk
minetest.register_node('x_farming:jungle_tree', {
    description = S('Jungle Tree'),
    short_description = S('Jungle Tree'),
    tiles = { 'x_farming_jungle_tree_top.png', 'x_farming_jungle_tree_top.png', 'x_farming_jungle_tree.png' },
    paramtype2 = 'facedir',
    is_ground_content = false,
    groups = {
        -- MTG
        choppy = 2,
        oddly_breakable_by_hand = 1,
        -- MCL
        handy = 1,
        axey = 1,
        building_block = 1,
        material_wood = 1,
        fire_encouragement = 5,
        fire_flammability = 5,
        -- ALL
        tree = 1,
        flammable = 2,
    },
    _mcl_blast_resistance = 2,
    _mcl_hardness = 2,
    sounds = x_farming.node_sound_wood_defaults(),

    on_place = minetest.rotate_node
})

-- leaves
minetest.register_node('x_farming:jungle_leaves', {
    description = S('Jungle Tree Leaves') .. '\n' .. S('Compost chance') .. ': 30%',
    short_description = S('Jungle Tree Leaves'),
    drawtype = 'allfaces_optional',
    waving = 1,
    tiles = { 'x_farming_jungleleaves.png' },
    special_tiles = { 'x_farming_jungleleaves.png' },
    paramtype = 'light',
    is_ground_content = false,
    groups = {
        -- MTG
        snappy = 3,
        leafdecay = 3,
        -- MCL
        handy = 1,
        hoey = 1,
        shearsy = 1,
        swordy = 1,
        dig_by_piston = 1,
        fire_encouragement = 30,
        fire_flammability = 60,
        deco_block = 1,
        compostability = 30,
        -- ALL
        flammable = 2,
        leaves = 1,
    },
    _mcl_shears_drop = true,
    _mcl_blast_resistance = 0.2,
    _mcl_hardness = 0.2,
    _mcl_silk_touch_drop = true,
    drop = {
        max_items = 1,
        items = {
            {
                -- player will get sapling with 1/20 chance
                items = { 'x_farming:jungle_with_cocoa_sapling' },
                rarity = 20,
            },
            {
                -- player will get leaves only if he get no saplings,
                -- this is because max_items is 1
                items = { 'x_farming:jungle_leaves' },
            }
        }
    },
    sounds = x_farming.node_sound_leaves_defaults(),

    after_place_node = x_farming.after_place_leaves,
})

-- leafdecay
x_farming.register_leafdecay({
    trunks = { 'x_farming:jungle_tree' },
    leaves = {
        'x_farming:cocoa_3',
        'x_farming:jungle_leaves'
    },
    radius = 2,
})

-- planks
minetest.register_node('x_farming:jungle_wood', {
    description = S('Jungle Wood Planks'),
    short_description = S('Jungle Wood Planks'),
    paramtype2 = 'facedir',
    place_param2 = 0,
    tiles = { 'x_farming_jungle_wood.png' },
    is_ground_content = false,
    groups = {
        -- MTG
        choppy = 2,
        oddly_breakable_by_hand = 2,
        -- Everness
        everness_wood = 1,
        -- MCL
        handy = 1,
        axey = 1,
        building_block = 1,
        material_wood = 1,
        fire_encouragement = 5,
        fire_flammability = 20,
        -- ALL
        flammable = 3,
        wood = 1,
    },
    _mcl_blast_resistance = 3,
    _mcl_hardness = 2,
    sounds = x_farming.node_sound_wood_defaults(),
})

-- Cookie
local cookie_def = {
    description = S('Cookie') .. '\n' .. S('Compost chance') .. ': 85%\n'
        .. minetest.colorize(x_farming.colors.brown, S('Hunger') .. ': 2'),
    inventory_image = 'x_farming_cookie.png',
    groups = {
        -- MTG
        compost = 85,
        -- MCL
        food = 2,
        eatable = 2,
        compostability = 85
    },
}

if minetest.get_modpath('farming') then
    cookie_def.on_use = minetest.item_eat(2)
end

if minetest.get_modpath('mcl_farming') then
    cookie_def.on_place = minetest.item_eat(2)
    cookie_def.on_secondary_use = minetest.item_eat(2)
end

minetest.register_craftitem('x_farming:cookie', cookie_def)

-- Chocolate
local chocolate_def = {
    description = S('Chocolate') .. '\n' .. S('Compost chance') .. ': 65%\n'
        .. minetest.colorize(x_farming.colors.brown, S('Hunger') .. ': 3'),
    inventory_image = 'x_farming_chocolate.png',
    groups = {
        -- MTG
        compost = 65,
        -- MCL
        food = 2,
        eatable = 2,
        compostability = 65
    },
}

if minetest.get_modpath('farming') then
    chocolate_def.on_use = minetest.item_eat(3)
end

if minetest.get_modpath('mcl_farming') then
    chocolate_def.on_place = minetest.item_eat(3)
    chocolate_def.on_secondary_use = minetest.item_eat(3)
end

minetest.register_craftitem('x_farming:chocolate', chocolate_def)

-- Stairs
if minetest.global_exists('stairs') and minetest.get_modpath('stairs') then
    stairs.register_stair_and_slab(
        'jungle_wood',
        'x_farming:jungle_wood',
        { choppy = 2, oddly_breakable_by_hand = 2, flammable = 2 },
        { 'x_farming_jungle_wood.png' },
        'Jungle Wooden Stair',
        'Jungle Wooden Slab',
        x_farming.node_sound_wood_defaults(),
        false
    )
end

if minetest.get_modpath('mcl_stairs') then
    mcl_stairs.register_stair_and_slab(
        'x_farming_jungle_wood',
        'x_farming:jungle_wood',
        { handy = 1, axey = 1, building_block = 1, material_wood = 1, fire_encouragement = 5, fire_flammability = 20, flammable = 3, wood = 1, },
        { 'x_farming_jungle_wood.png' },
        S('Jungle Wooden Stair'),
        S('Jungle Wooden Slab'),
        x_farming.node_sound_wood_defaults(),
        6,
        2,
        S('Double Jungle Wooden Slab'),
        nil
    )
end

-- Crate
x_farming.register_crate('crate_cocoa_bean_3', {
    description = S('Cocoa Bean Crate'),
    short_description = S('Cocoa Bean Crate'),
    tiles = { 'x_farming_crate_cocoa_bean_3.png' },
    _custom = {
        crate_item = 'x_farming:cocoa_bean'
    }
})

minetest.register_on_mods_loaded(function()
    local deco_place_on = {}
    local deco_biomes = {}
    local deco_fill_ratio = 0.025

    -- MTG
    if minetest.get_modpath('default') then
        table.insert(deco_place_on, 'default:dirt_with_rainforest_litter')
        table.insert(deco_biomes, 'rainforest')
    end

    -- Everness
    if minetest.get_modpath('everness') then
        table.insert(deco_place_on, 'everness:dirt_with_grass_1')
        table.insert(deco_biomes, 'everness:bamboo_forest')
        deco_fill_ratio = deco_fill_ratio / 20
    end

    -- MCL
    if minetest.get_modpath('mcl_core') then
        table.insert(deco_place_on, 'mcl_core:dirt_with_grass')
        table.insert(deco_biomes, 'Jungle')
    end

    if next(deco_place_on) and next(deco_biomes) then
        minetest.register_decoration({
            name = 'x_farming:jungle_tree',
            deco_type = 'schematic',
            place_on = deco_place_on,
            sidelen = 80,
            fill_ratio = deco_fill_ratio,
            biomes = deco_biomes,
            y_max = 31000,
            y_min = 1,
            schematic = minetest.get_modpath('x_farming') .. '/schematics/x_farming_jungle_tree_with_cocoa.mts',
            flags = 'place_center_x, place_center_z',
            rotation = '0',
        })
    end
end)
