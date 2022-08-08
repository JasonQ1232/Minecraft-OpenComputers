local os = require("os")
local sides = require("sides")
local component = require("component")
local term = require("term")

local settings = dofile("/usr/bin/automatic-power-switch/settings.cfg")

local function rs(val)
    for address in pairs(settings.redstone_addresses) do
        local rs = component.proxy(component.get(settings.redstone_addresses[address]))
        rs.setOutput(val)
    end
end

capacitors = {}
for address in pairs(settings.capacitor_addresses) do
    local capacitor = component.proxy(component.get(settings.capacitor_addresses[address]))
    table.insert(capacitor)
end

local capacitors = { capacitorA, capacitorB }
local status = {}

active = false
while true do
    for capacitor in pairs(capacitors) do
        max_energy = capacitors[capacitor].getMaxEnergyStored()
        cur_energy = capacitors[capacitor].getEnergyStored()
        --term.write(capacitor .. " : " .. cur_energy .. "\n")
        if (cur_energy < (max_energy * 0.40)) then
            table.insert(status, true)
            --term.write("true" .. "\n")
        elseif (cur_energy > (max_energy * 0.80)) then
            table.insert(status, false)
            --term.write("false" .. "\n")
        end
    end

    activate = false
    for i in pairs(status) do
        if (status[i] == true) then
            activate = true
            --term.write("activate generator" .. "\n")
            break
        end
    end

    if (activate) then
        rs(15)
    else
        rs(0)
    end

    for i in pairs(status) do
        status[i] = nil
    end

    os.sleep(5)
end