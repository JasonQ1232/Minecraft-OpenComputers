local os = require("os")
local component = require("component")
local term = require("term")
local sides = require("sides")

local settings = dofile("/usr/bin/automatic-power-switch/settings.cfg")

local capacitors = {}
for address in pairs(settings.capacitor_addresses) do
    local capacitor = component.proxy(component.get(settings.capacitor_addresses[address]))
    table.insert(capacitors, capacitor)
end

for capacitor in pairs(capacitors) do
    max_energy = capacitors[capacitor].getMaxEnergyStored()
    cur_energy = capacitors[capacitor].getEnergyStored()
    term.write(capacitors[capacitor].address .. "\n")
    term.write("Max Energy: " .. math.floor(max_energy) .. "\n")
    term.write("Cur Energy: " .. math.floor(cur_energy) .. "\n")
    term.write("Percent: " .. math.floor((cur_energy / max_energy) * 100) .. "% \n")
    term.write("------------------------------------\n")
end

for address in pairs(settings.redstone_addresses) do
    local rs = component.proxy(component.get(settings.redstone_addresses[address]))
    local output = rs.getOutput(sides.top)
    if (output >= 1) then
        term.write("Generators: Online")
    else
        term.write("Generators: Offline")
    end
end