ESX = tnClient.GetESX()

----------------------------
-- Values
----------------------------
local isDetecting = false 
local hasFound = false 
--
local currentZoneId = nil
local searchBlip = nil 
local treasureCoords = nil 
local detectorObject = nil
--
local tnFunctions = {}
local _S = tnConfig.strings

----------------------------
-- Events
----------------------------
RegisterNetEvent('tnMetalDetector:client:toggleDetector')
AddEventHandler('tnMetalDetector:client:toggleDetector', function()
    tnFunctions.CheckZone()
end)

RegisterNetEvent('tnMetalDetector:client:notify')
AddEventHandler('tnMetalDetector:client:notify', function(type, message, cooldownId)
    tnClient.Notify(type, message, cooldownId)
end)

RegisterNetEvent('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if DoesEntityExist(detectorObject) then 
            DetachEntity(detectorObject, true, true)
            DeleteObject(detectorObject)
            detectorObject = nil
        end
    end
end)

----------------------------
-- Utils Functions
----------------------------
tnFunctions.GenerateRandomCoords = function(center, radius)
    local offsetX = math.random(0, radius)
    local offsetY = math.random(0, radius)

    if math.random(1, 2) == 2 then offsetX = -offsetX end
    if math.random(1, 2) == 2 then offsetY = -offsetY end

    return vector3(center.x + offsetX, center.y + offsetY, center.z)
end

tnFunctions.RequestAnimDict = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
end

local lastSoundTime = 0
local soundCooldowns = {
    ['beep_far'] = 1000,
    ['beep_medium'] = 800,
    ['beep_close'] = 500,
    ['beep_very_close'] = 300,
    ['beep_found'] = 100
}
tnFunctions.PlayBeep = function(type)
    local currentTime = GetGameTimer()
    if currentTime - lastSoundTime < soundCooldowns[type] then 
        return 
    end
    SendNUIMessage({
        transactionType = 'playSound',
        transactionFile  = 'beep',
        transactionVolume = tnConfig.soundVolume
    })
    lastSoundTime = currentTime
end


----------------------------
-- Main Functions
----------------------------
tnFunctions.CheckZone = function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local foundZone = false
    for zoneId, zone in pairs(tnConfig.zones) do 
        local distance = #(playerCoords - zone.coords)

        if distance > 50.0 then 
            goto continue
        end
        foundZone = true

        if isDetecting then 
            tnClient.Notify('info', _S['stop_detection'], false)
            tnFunctions.StopDetection()
            return 
        end

        tnFunctions.StartDetection(zoneId, zone)

        Citizen.CreateThread(function()
            while isDetecting do 
                local currentCoords = GetEntityCoords(playerPed)
                local currentDistance = #(currentCoords - zone.coords)

                if currentDistance > zone.radius - 7.0 then 
                    tnClient.Notify('error', _S['near_exit_zone'], 'near_exit')
                    if currentDistance > zone.radius then 
                        tnClient.Notify('error', _S['exit_zone'])
                        tnFunctions.StopDetection()
                    end
                end

                if IsEntityDead(playerPed) then 
                    tnFunctions.StopDetection()
                end

                --[[local _, currentWeaponHash = GetCurrentPedWeapon(playerPed)
                if currentWeaponHash ~= GetHashKey('WEAPON_UNARMED') then 
                    tnClient.Notify('error', _S['switch_weapon'], 'weapon_change')
                    tnFunctions.StopDetection()
                end--]]

                Citizen.Wait(1000)
            end
        end)
        ::continue::
    end

    if not foundZone then 
        tnClient.Notify('error', _S['not_in_zone'], false)
    end
end

tnFunctions.StartDetection = function(zoneId, zone)
    currentZoneId = zoneId
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- Animation & Prop
    tnFunctions.RequestAnimDict(tnConfig.detector.animation[1])
    TaskPlayAnim(playerPed, tnConfig.detector.animation[1], tnConfig.detector.animation[2], 8.0, -8.0, -1, 49, 0, false, false, false)
    detectorObject = CreateObject(GetHashKey(tnConfig.detector.prop), playerCoords.x, playerCoords.y, playerCoords.z + 0.2, true, false, false)
    AttachEntityToEntity(detectorObject, playerPed, GetPedBoneIndex(playerPed, 57005), 0.125, 0.04, 0.0, -90.0, 150.0, 44.0, true, true, false, true, 1, true)

    isDetecting = true

    -- Treasure Coords
    treasureCoords = tnFunctions.GenerateRandomCoords(zone.coords, (zone.radius - 12.0))
    treasureCoords = vector3(treasureCoords.x, treasureCoords.y, 250.0)
    local groundFound, groundZ = GetGroundZFor_3dCoord(treasureCoords.x, treasureCoords.y, treasureCoords.z)
    if groundFound then 
        treasureCoords = vector3(treasureCoords.x, treasureCoords.y, groundZ)
    end

    -- Blip 
    searchBlip = AddBlipForRadius(zone.coords.x, zone.coords.y, zone.coords.z, zone.radius)
    SetBlipColour(searchBlip, 6)
    SetBlipAlpha(searchBlip, 100)

    -- Main While
    Citizen.CreateThread(function()
        while isDetecting do 
            local currentCoords = GetEntityCoords(playerPed)
            local distance = GetDistanceBetweenCoords(currentCoords, treasureCoords, false)

            if distance > 15.0 then 
                tnFunctions.PlayBeep('beep_far')
            elseif distance > 10.0 then 
                tnFunctions.PlayBeep('beep_medium')
            elseif distance > 5.0 then 
                tnFunctions.PlayBeep('beep_close')
            elseif distance > 2.0 then 
                tnFunctions.PlayBeep('beep_very_close')
            else 
                tnFunctions.PlayBeep('beep_found')
                tnClient.HelpNotify(_S['press_to_dig'])

                if IsControlJustPressed(0, 51) then 
                    hasFound = true 
                    tnFunctions.StopDetection()
                end
            end

            Citizen.Wait(0)
        end
    end)
end

tnFunctions.StopDetection = function()
    local playerPed = PlayerPedId()

    isDetecting = false

    if DoesEntityExist(detectorObject) then 
        DetachEntity(detectorObject, true, true)
        DeleteObject(detectorObject)
        detectorObject = nil
    end
    ClearPedTasksImmediately(playerPed)

    if searchBlip then 
        RemoveBlip(searchBlip)
        searchBlip = nil
    end

    if hasFound then 
        TaskStartScenarioInPlace(playerPed, tnConfig.detector.scenario, 0, true)

        FreezeEntityPosition(playerPed, true)

        tnClient.ProgressBar(_S['digging'], tnConfig.diggingTime)

        Citizen.Wait(tnConfig.diggingTime)
        ClearPedTasks(playerPed)
        FreezeEntityPosition(playerPed, false)

        TriggerServerEvent('tnMetalDetector:server:end', currentZoneId)
        hasFound = false
        currentZoneId = nil
        Citizen.Wait(2000)
        tnFunctions.CheckZone()
    else
        currentZoneId = nil
    end
end