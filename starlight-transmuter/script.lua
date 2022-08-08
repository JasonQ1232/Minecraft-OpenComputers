local os = require("os")
local component = require("component") 

local settings = dofile("/usr/bin/starlight-transmuter/settings.cfg")

local rs = component.proxy(component.get(settings.redstone_address))
local geo = component.proxy(component.get(settings.geolyzer_address))

while true do
    result_table = geo.analyze(settings.geolyzer_side)
    for block in pairs(settings.whitelist) do
        block_name = settings.whitelist[block]
        if(result_table.name == block_name) then
            rs.setOutput(settings.redstone_side, 15)
            rs.setOutput(settings.redstone_side, 0)
        end
    end
    os.sleep(0.2)
end

