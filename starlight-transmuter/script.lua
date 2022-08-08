local os = require("os")
local component = require("component") 
local sides = require("sides")

local settings = dofile("/usr/bin/starlight-transmuter/settings.cfg")

local rs = component.proxy(component.get(settings.redstone_address))
local geo = component.proxy(component.get(settings.geolyzer_address))

local whitelist = {
    "gregtech:ore_uranium_0", 
    "minecraft:clay", 
    "minecraft:end_stone", 
    "gregtech:compressed_7", 
    "contenttweaker:sub_block_holder_0",
    "contenttweaker:sub_block_holder_1",
    "contenttweaker:sub_block_holder_3",
    "contenttweaker:sub_block_holder_4",
    "contenttweaker:sub_block_holder_5",
    "contenttweaker:sub_block_holder_6",
    "actuallyadditions:block_crystal_cluster_redstone",
    "actuallyadditions:block_crystal_cluster_lapis",
    "actuallyadditions:block_crystal_cluster_coal",
    "actuallyadditions:block_crystal_cluster_diamond",
    "actuallyadditions:block_crystal_cluster_iron"
}

while true do
    result_table = geo.analyze(settings.geolyzer-side)
    for block in pairs(whitelist) do
        block_name = whitelist[block]
        if(result_table.name == block_name) then
            rs.setOutput(settings.redstone_side, 15)
            rs.setOutput(settings.redstone_side, 0)
        end
    end
    os.sleep(0.2)
end

