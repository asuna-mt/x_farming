-- name, hunger_change, replace_with_item, poisen, heal, sound

-- beetroot
hbhunger.register_food("x_farming:beetroot", 3)
hbhunger.register_food("x_farming:beetroot_soup", 6, "x_farming:bowl")

-- carrot
hbhunger.register_food("x_farming:carrot", 3)
hbhunger.register_food("x_farming:carrot_golden", 10, nil, nil, 10)

-- coffee
hbhunger.register_food("x_farming:coffee_cup", 4, "vessels:drinking_glass")
hbhunger.register_food("x_farming:coffee_cup_hot", 6, "vessels:drinking_glass", nil, 4)

-- corn
hbhunger.register_food("x_farming:corn_pop", 1)
hbhunger.register_food("x_farming:corn_popcorn", 5)

-- melon
hbhunger.register_food("x_farming:melon", 2)
hbhunger.register_food("x_farming:golden_melon", 10, "", nil, 10)

-- potato
hbhunger.register_food("x_farming:potato", 2)
hbhunger.register_food("x_farming:bakedpotato", 6)
hbhunger.register_food("x_farming:poisonouspotato", -6, nil, 5)

-- pumpkin
hbhunger.register_food("x_farming:pumpkin_pie", 6)

-- hog stew
hbhunger.register_food("x_farming:hog_stew", 8, "x_farming:bowl")

-- cocoa
hbhunger.register_food("x_farming:cookie", 2)
hbhunger.register_food("x_farming:chocolate", 3)
