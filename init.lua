-- Farming Addons
-- by SaKeL

local mod_start_time = minetest.get_us_time()
local path = minetest.get_modpath("x_farming")

dofile(path.."/api.lua")
dofile(path.."/melon.lua")
dofile(path.."/pumpkin.lua")
dofile(path.."/coffee.lua")
dofile(path.."/corn.lua")
dofile(path.."/obsidian_wart.lua")
dofile(path.."/potato.lua")
dofile(path.."/beetroot.lua")
dofile(path.."/carrot.lua")
dofile(path.."/cocoa.lua")
dofile(path.."/seeds.lua")
dofile(path.."/crafting.lua")
dofile(path.."/kiwi_tree.lua")
-- hbhunger
if x_farming.hbhunger ~= nil then
    if hbhunger.register_food ~= nil then
        dofile(path.."/register_hbhunger.lua")
    end
end

if minetest.get_modpath("mobs_npc") then
    dofile(path.."/snow_golem.lua")
end

local mod_end_time = (minetest.get_us_time() - mod_start_time) / 1000000

print ("[Mod] x_farming loaded.. [".. mod_end_time .."s]")
