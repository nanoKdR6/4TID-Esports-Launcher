ESX = nil
ResourceName = GetCurrentResourceName()
secondsRemaining = 0

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent(ResourceName..'give')
AddEventHandler(ResourceName..'give', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.getName()
    local xItem = xPlayer.getInventoryItem(Config.itemname)
    local xItemCount = math.random(Config.ItemCount[1], Config.ItemCount[2])

    if xItem.limit ~= -1 and xItem.count >= xItem.limit then
        TriggerClientEvent("pNotify:SendNotification", source, {
            text = '<span class="red-text">กระเป๋าเต็ม</span> ',
            type = "success",
            timeout = 3000,
            layout = "bottomCenter",
            queue = "global"
        })
    else
        if xItem.limit ~= -1 and (xItem.count + xItemCount) > xItem.limit then
            xPlayer.setInventoryItem(xItem.name, xItem.limit)
        else
            xPlayer.addInventoryItem(xItem.name, xItemCount)
        end

        if Config.ItemBonus ~= nil then
            for bonus in pairs(Config.ItemBonus) do
                if math.random(1, 100) <= bonus.Percent then
                    local xItemZ = xPlayer.getInventoryItem(bonus.ItemName)
                    if xItemZ.limit ~= -1 and xItemZ.count >= xItemZ.limit then
                        TriggerClientEvent("pNotify:SendNotification", source, {
                            text = '<span class="red-text">กระเป๋าเต็มเก็บไอเทมโบนัทไม่ได้</span> ',
                            type = "success",
                            timeout = 3000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
                    else
                        xPlayer.addInventoryItem(bonus.ItemName, bonus.ItemCount)
                    end
                end
            end
        end
    end
end)

RegisterServerEvent(ResourceName..'reviveon')
AddEventHandler(ResourceName..'reviveon', function(target)
    TriggerClientEvent(ResourceName..'reviveon', target)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local gettime = os.date('%X')

        for time in pairs(Config.Timeonline) do
            if gettime == time.Times then
                start()
            end
        end

        if secondsRemaining >= 0 then
            secondsRemaining = secondsRemaining - 1
        end
    end
end)

function start()
    TriggerClientEvent(ResourceName..'startevent', -1, Config.TimerStart)
    secondsRemaining = Config.TimerStart
end

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    TriggerClientEvent(ResourceName..'startevent', source, secondsRemaining)
end)
