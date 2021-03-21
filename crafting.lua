--
-- Crafting recipes & items
--

-- Cocoa
minetest.register_craft( {
	output = "dye:brown",
	recipe = {
		{ "x_farming:cocoa_bean" },
	}
})

minetest.register_craftitem("x_farming:cookie", {
	description = "Cookie" .. "\n" .. minetest.colorize(x_farming.colors.brown, "Hunger: 2"),
	inventory_image = "x_farming_cookie.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft( {
	output = "x_farming:cookie 8",
	recipe = {
		{"farming:wheat", "x_farming:cocoa_bean", "farming:wheat" },
	}
})

minetest.register_craftitem("x_farming:chocolate", {
	description = "Chocolate" .. "\n" .. minetest.colorize(x_farming.colors.brown, "Hunger: 3"),
	inventory_image = "x_farming_chocolate.png",
	on_use = minetest.item_eat(3),
})

minetest.register_craft( {
	output = "x_farming:chocolate",
	recipe = {
		{"", "", "x_farming:cocoa_bean"},
		{"", "x_farming:cocoa_bean", ""},
		{"default:paper", "", ""},
	}
})

-- Soup Bowl
minetest.register_craftitem("x_farming:bowl", {
	description = "Empty Soup Bowl",
	inventory_image = "x_farming_bowl.png",
})

minetest.register_craft({
	output = "x_farming:bowl 3",
	recipe = {
		{"group:wood", "", "group:wood"},
		{"", "group:wood", ""}
	}
})

-- Hog Stew
minetest.register_craftitem("x_farming:hog_stew", {
	description = "Hog Stew" .. "\n" .. minetest.colorize(x_farming.colors.brown, "Hunger: 8"),
	inventory_image = "x_farming_hog_stew.png",
	on_use = minetest.item_eat(8, "x_farming:bowl"),
})

minetest.register_craft({
	output = "x_farming:hog_stew",
	recipe = {
		{"", "mobs:pork_raw", ""},
		{"x_farming:carrot", "x_farming:bakedpotato", "flowers:mushroom_brown"},
		{"", "x_farming:bowl", ""}
	}
})

minetest.register_craft({
	output = "x_farming:hog_stew",
	recipe = {
		{"", "mobs:pork_raw", ""},
		{"x_farming:carrot", "x_farming:bakedpotato", "flowers:mushroom_red"},
		{"", "x_farming:bowl", ""}
	}
})

-- Beetroot
minetest.register_craftitem("x_farming:beetroot_soup", {
	description = "Beetroot Soup" .. "\n" .. minetest.colorize(x_farming.colors.brown, "Hunger: 6"),
	inventory_image = "x_farming_beetroot_soup.png",
	on_use = minetest.item_eat(6, "x_farming:bowl"),
})

minetest.register_craft({
	output = "x_farming:beetroot_soup",
	recipe = {
		{"x_farming:beetroot", "x_farming:beetroot", "x_farming:beetroot"},
		{"x_farming:beetroot", "x_farming:beetroot", "x_farming:beetroot"},
		{"", "x_farming:bowl", ""}
	}
})

-- Carrot
local golden_carrot_desc = "Golden Carrot" .. "\n" .. minetest.colorize(x_farming.colors.brown, "Hunger: 10")

if x_farming.hbhunger ~= nil then
	golden_carrot_desc = golden_carrot_desc .. "\n" .. minetest.colorize(x_farming.colors.red, "Heal: 10")
end

minetest.register_craftitem("x_farming:carrot_golden", {
	description = golden_carrot_desc,
	inventory_image = "x_farming_carrot_golden.png",
	wield_image = "x_farming_carrot_golden.png^[transformR270",
	on_use = minetest.item_eat(10),
})

minetest.register_craft({
	output = "x_farming:carrot_golden",
	recipe = {
		{"default:gold_lump", "default:gold_lump", "default:gold_lump"},
		{"default:gold_lump", "x_farming:carrot", "default:gold_lump"},
		{"default:gold_lump", "default:gold_lump", "default:gold_lump"}
	},
})

-- Coffee
minetest.register_craft( {
	output = "x_farming:coffee_cup",
	recipe = {
		{"vessels:drinking_glass", "x_farming:coffee","bucket:bucket_water"},
	},
	replacements = {{"bucket:bucket_water", "bucket:bucket_empty"}}
})

minetest.register_craft({
	type = "cooking",
	cooktime = 5,
	output = "x_farming:coffee_cup_hot",
	recipe = "x_farming:coffee_cup"
})

-- Corn
minetest.register_craftitem("x_farming:corn_pop", {
	description = "Popped corn" .. "\n" .. minetest.colorize(x_farming.colors.brown, "Hunger: 1"),
	inventory_image = "x_farming_corn_pop.png",
	on_use = minetest.item_eat(1),
})

minetest.register_craft( {
	type = "cooking",
	cooktime = 10,
	output = "x_farming:corn_pop",
	recipe = "x_farming:corn"
})

minetest.register_craft( {
	output = "x_farming:corn_popcorn",
	recipe = {
		{"x_farming:corn_pop", "x_farming:corn_pop","x_farming:corn_pop"},
		{"default:paper", "","default:paper"},
		{"default:paper", "default:paper","default:paper"},
	}
})

-- Melon
local golden_melon_desc = "Golden Melon" .. "\n" .. minetest.colorize(x_farming.colors.brown, "Hunger: 10")

if x_farming.hbhunger ~= nil then
	golden_melon_desc = golden_melon_desc .. "\n" .. minetest.colorize(x_farming.colors.red, "Heal: 10")
end

minetest.register_craftitem("x_farming:golden_melon", {
	description = golden_melon_desc,
	inventory_image = "x_farming_golden_melon.png",
	wield_image = "x_farming_golden_melon.png^[transformR90",
	on_use = minetest.item_eat(10),
})

minetest.register_craft({
	output = "x_farming:golden_melon",
	recipe = {
		{"default:gold_lump", "default:gold_lump", "default:gold_lump"},
		{"default:gold_lump", "x_farming:melon", "default:gold_lump"},
		{"default:gold_lump", "default:gold_lump", "default:gold_lump"}
	},
})

minetest.register_craft({
	output = "x_farming:melon_block",
	recipe = {
		{"x_farming:melon", "x_farming:melon", "x_farming:melon"},
		{"x_farming:melon", "x_farming:melon", "x_farming:melon"},
		{"x_farming:melon", "x_farming:melon", "x_farming:melon"}
	},
})

-- Obsidian Wart
minetest.register_craftitem("x_farming:wart_brick", {
	description = "Wart Brick",
	inventory_image = "x_farming_wart_brick.png",
})

minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "x_farming:wart_brick",
	recipe = "x_farming:obsidian_wart"
})

minetest.register_craft({
	output = "x_farming:wart_block",
	recipe = {
		{"x_farming:obsidian_wart", "x_farming:obsidian_wart", "x_farming:obsidian_wart"},
		{"x_farming:obsidian_wart", "x_farming:obsidian_wart", "x_farming:obsidian_wart"},
		{"x_farming:obsidian_wart", "x_farming:obsidian_wart", "x_farming:obsidian_wart"}
	}
})

minetest.register_craft({
	output = "x_farming:wart_brick_block",
	recipe = {
		{"x_farming:wart_brick", "x_farming:wart_brick", ""},
		{"x_farming:wart_brick", "x_farming:wart_brick", ""}
	}
})

minetest.register_craft({
	output = "x_farming:wart_red_brick_block",
	recipe = {
		{"x_farming:obsidian_wart", "x_farming:wart_brick", ""},
		{"x_farming:wart_brick", "x_farming:obsidian_wart", ""}
	},
})

minetest.register_craft({
	output = "x_farming:wartrack 4",
	recipe = {
		{"x_farming:wart_block", "x_farming:wart_block", ""},
		{"x_farming:wart_block", "x_farming:wart_block", ""}
	},
})

-- Potato
minetest.register_craftitem("x_farming:bakedpotato", {
	description = "Baked Potato" .. "\n" .. minetest.colorize(x_farming.colors.brown, "Hunger: 6"),
	inventory_image = "x_farming_potato_baked.png",
	on_use = minetest.item_eat(6),
})

local poisonouspotato_desc = "Poisonous Potato" .. "\n" .. minetest.colorize(x_farming.colors.brown, "Hunger: -6")

if x_farming.hbhunger ~= nil then
	poisonouspotato_desc = poisonouspotato_desc .. "\n" .. minetest.colorize(x_farming.colors.green, "Poison: 5")
end

minetest.register_craftitem("x_farming:poisonouspotato", {
	description = poisonouspotato_desc,
	inventory_image = "x_farming_potato_poisonous.png",
	on_use = minetest.item_eat(-6),
})

minetest.register_craft({
	type = "cooking",
	cooktime = 10,
	output = "x_farming:bakedpotato",
	recipe = "x_farming:potato"
})

-- Pumpkin
-- pumpkin lantern recipe
minetest.register_craft({
	output = "x_farming:pumpkin_lantern",
	recipe = {
		{"", "", ""},
		{"", "x_farming:pumpkin_block", ""},
		{"", "default:torch", ""}
	},
})

-- crafted item from recipe
minetest.register_craftitem("x_farming:pumpkin_pie", {
	description = "Pumpkin Pie" .. "\n" .. minetest.colorize(x_farming.colors.brown, "Hunger: 6"),
	inventory_image = "x_farming_pumpkin_pie.png",
	on_use = minetest.item_eat(6),
})

-- pumpkin pie crafting recipe
minetest.register_craft({
	output = "x_farming:pumpkin_pie",
	recipe = {
		{"", "", ""},
		{"x_farming:pumpkin_block", "farming:flour", ""},
		{"", "mobs:egg", ""}
	}
})

-- pumpkin as fuel (better than cactus)
minetest.register_craft({
	type = "fuel",
	recipe = "x_farming:pumpkin_block",
	burntime = 20,
})

minetest.register_craft({
	type = "fuel",
	recipe = "x_farming:pumpkin_lantern",
	burntime = 20,
})
