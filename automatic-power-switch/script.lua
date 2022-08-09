local os = require("os")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/automatic-power-switch/settings.cfg")

local function rs(val)
    for address in pairs(settings.redstone_addresses) do
        local rs = component.proxy(component.get(settings.redstone_addresses[address]))
        rs.setOutput({val, val, val, val, val, val})
    end
end

local capacitors = {}
for address in pairs(settings.capacitor_addresses) do
    local capacitor = component.proxy(component.get(settings.capacitor_addresses[address]))
    table.insert(capacitors, capacitor)
end

local status = {}
local active = false
while true do
    if (settings.debug == true) then
        term.clear()
    end

    for capacitor in pairs(capacitors) do
        max_energy = capacitors[capacitor].getEnergyCapacity()
        cur_energy = capacitors[capacitor].getEnergyStored()
        if (settings.debug == true) then
            term.write(capacitors[capacitor].address .. "\n")
            term.write("Max Energy: " .. math.floor(max_energy) .. "\n")
            term.write("Cur Energy: " .. math.floor(cur_energy) .. "\n")
            term.write("Percent: " .. math.floor((cur_energy / max_energy) * 100) .. "% \n")
            term.write("------------------------------------\n")
        end
        if (cur_energy < (max_energy * 0.40)) then
            table.insert(status, true)
        elseif (cur_energy > (max_energy * 0.80)) then
            table.insert(status, false)
        end
    end

    activate = false
    for i in pairs(status) do
        if (status[i] == true) then
            activate = true
            break
        end
    end

    if (activate) then
        rs(15)
    else
        rs(0)
    end

    if (settings.debug == true) then
        if (activate == true) then
            term.write("Generators: Online")
        else
            term.write("Generators: Offline")
        end
    end

    for i in pairs(status) do
        status[i] = nil
    end

    os.sleep(5)
end