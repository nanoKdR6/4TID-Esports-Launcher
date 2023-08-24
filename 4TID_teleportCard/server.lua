ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('TeleportCard:RemoveItem')
AddEventHandler('TeleportCard:RemoveItem', function(item)
    local source = source
    local player = ESX.GetPlayerFromId(source)
    if player then
        player.removeInventoryItem(item, 1)
    end
end)

ESX.RegisterUsableItem(TeleportConfig.TeleportItem, function(source)
    local player = ESX.GetPlayerFromId(source)
    if player then
        local itemCount = player.getInventoryItem(TeleportConfig.TeleportItem).count
        if itemCount <= 0 then
            TriggerClientEvent("pNotify:SendNotification", source, {
                text = '<strong class="red-text">ไม่สามารถใช้งานได้</strong>',
                type = "error",
                timeout = 3000,
                layout = "bottomCenter",
                queue = "global"
            })
        else
            TriggerClientEvent("TeleportCard:SelectPlayer", source)
        end
    end
end)
