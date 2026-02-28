ESX = exports['es_extended']:getSharedObject()

tnClient = {}

tnClient.GetESX = function()
    return ESX
end

local lastNotifTime = {}
tnClient.Notify = function(type, message, cooldownId)
    if cooldownId then 
        local currentTime = GetGameTimer()
        if currentTime - (lastNotifTime[cooldownId] or 0) < 5000.0 then 
            return 
        end
        lastNotifTime[cooldownId] = currentTime
    end
    ESX.ShowNotification(message, type)
end

tnClient.HelpNotify = function(message)
    ESX.ShowHelpNotification(message)
end

tnClient.ProgressBar = function(message, time)
    exports['t0sic_loadingbar']:StartDelayedFunction(message, time)
end