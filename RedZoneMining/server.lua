ESX = nil
ResourceName = GetCurrentResourceName()
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
remainingTime = 0

RegisterServerEvent(ResourceName .. 'give')
AddEventHandler(ResourceName .. 'give', function()
    local player = ESX.GetPlayerFromId(source)
    local item = player.getInventoryItem(Config.ItemName)
    local itemCount = math.random(Config.ItemCount[1], Config.ItemCount[2])

    if item.limit ~= -1 and item.count >= item.limit then
        TriggerClientEvent("pNotify:SendNotification", source, {
            text = '<span class="red-text">กระเป๋าเต็ม</span> ',
            type = "success",
            timeout = 3000,
            layout = "bottomCenter",
            queue = "global"
        })
    else
        if item.limit ~= -1 and (item.count + itemCount) > item.limit then
            player.setInventoryItem(item.name, item.limit)
        else
            player.addInventoryItem(item.name, itemCount)
        end

        if Config.ItemBonus then
            for bonus in pairs(Config.ItemBonus) do
                if math.random(1, 100) <= bonus.Percent then
                    local itemO = player.getInventoryItem(bonus.ItemName)
                    if itemO.limit ~= -1 and itemO.count >= itemO.limit then
                        TriggerClientEvent("pNotify:SendNotification", source, {
                            text = '<span class="red-text">กระเป๋าเต็มเก็บไอเท็มโบนัทไม่ได้</span> ',
                            type = "success",
                            timeout = 3000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
                    else
                        player.addInventoryItem(bonus.ItemName, bonus.ItemCount)
                    end
                end
            end
        end
    end
end)

RegisterServerEvent(ResourceName .. 'reviveon')
AddEventHandler(ResourceName .. 'reviveon', function(target)
    TriggerClientEvent(ResourceName .. 'reviveon', target)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local currentTime = os.date('%X')
        for onlineTime in pairs(Config.TimeOnline) do
            if currentTime == onlineTime.Times then
                StartEvent()
            end
        end
        if remainingTime >= 0 then
            remainingTime = remainingTime - 1
        end
    end
end)

function StartEvent()
    TriggerClientEvent(ResourceName .. 'startevent', -1, Config.TimerStart)
    remainingTime = Config.TimerStart
end

AddEventHandler('esx:playerLoaded', function(_, player)
    TriggerClientEvent(ResourceName .. 'startevent', source, remainingTime)
end)
