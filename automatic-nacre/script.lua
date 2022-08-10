local os = require("os")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/automatic-nacre/settings.cfg")

while true do
    if (settings.debug == true) then
        term.clear()
    end
    for index in pairs(settings.rigs) do
        redstone_dropper = component.proxy(component.get(settings.rigs[index].redstone_dropper_address))
        redstone_dropper_side = settings.rigs[index].redstone_dropper_side
        redstone_collector = component.proxy(component.get(settings.rigs[index].redstone_collector_address))
        redstone_collector_side = settings.rigs[index].redstone_collector_side
        geolyzer = component.proxy(component.get(settings.rigs[index].geolyzer_address))
        geolyzer_side = settings.rigs[index].geolyzer_side
    
        local result_table = geolyzer.analyze(geolyzer_side)
        if (settings.debug == true) then
            term.write(geolyzer.address .. "\n")
            term.write(result_table.name .. "\n")
        end
        if (result_table.name == "wizardry:mana_fluid") then
            if (settings.debug == true) then
                term.write("Dropping gold nugget." .. "\n")
            end
            redstone_dropper.setOutput(redstone_dropper_side, 15)
            os.sleep(0.5)
            redstone_dropper.setOutput(redstone_dropper_side, 0)
        elseif (result_table.name == "wizardry:nacre_fluid") then
            if (settings.debug == true) then
                term.write("Collecting Nacre." .. "\n")
            end
            redstone_collector.setOutput(redstone_collector_side, 15)
            os.sleep(0.5)
            redstone_collector.setOutput(redstone_collector_side, 0)
        end
    end
    os.sleep(0.5)
end