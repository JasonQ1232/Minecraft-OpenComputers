local component = require("component") 
local os = require("os")
local term = require("term")

local settings = dofile("/usr/bin/automatic-blood-slates/settings.cfg")

for index in pairs(settings.altars) do
    local altar = component.proxy(component.get(settings.altars[index].altar_address))
    local transposer = component.proxy(component.get(settings.altars[index].transposer_address))
    local altar_side = settings.altars[index].transposer_altar_side
    local input_side = settings.altars[index].transposer_input_side
    local output_side = settings.altars[index].transposer_output_side
    local target_side = settings.altars[index].transposer_target_side
    check_target(transposer, target_side)
end

function check_target(transposer, target_side)
    local info = transposer.getStackInSlot(target_side, 1)
    term.write(info .. "\n")
end