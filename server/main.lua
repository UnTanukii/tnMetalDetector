ESX = exports['es_extended']:getSharedObject()

----------------------------
-- Item
----------------------------
Citizen.CreateThread(function()
    ESX.RegisterUsableItem(tnConfig.DetectorItem, function(source)
        TriggerClientEvent('tnMetalDetector:client:toggleDetector', source)
    end)
end)

----------------------------
-- Events
----------------------------
RegisterNetEvent('tnMetalDetector:server:end')
AddEventHandler('tnMetalDetector:server:end', function(zoneId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    local items = tnConfig.Zones[zoneId].items
    local totalChance = 0
    for _, item in ipairs(items) do
        totalChance = totalChance + item.chance
    end

    local chance = math.random(1, totalChance)
    local current = 0
    for _, item in ipairs(items) do
        current = current + item.chance
        if chance <= current then
            if item.name == 'money' then
                xPlayer.addMoney(item.quantity())
            elseif item.name == 'nothing' then
                TriggerClientEvent('tnMetalDetector:client:notify', src, 'error', 'Vous n\'avez rien trouvé d\'intéressant.')
            else
                xPlayer.addInventoryItem(item.name, item.quantity)
            end
            break
        end
    end
end)