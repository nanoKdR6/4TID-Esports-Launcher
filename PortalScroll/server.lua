ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem(PortalConfig.PortalItem, function(source)
    local player = ESX.GetPlayerFromId(source)
    if player then
        local itemCount = player.getInventoryItem(PortalConfig.PortalItem).count
        if itemCount > 0 then
            TriggerClientEvent("PortalScroll:Warp", source)
        else
            TriggerClientEvent("pNotify:SendNotification", source, {
                text = '<strong class="red-text">ไม่สามารถใช้งานได้</strong>',
                type = "error",
                timeout = 3000,
                layout = "bottomCenter",
                queue = "global"
            })
        end
    end
end)


RegisterServerEvent('PortalScroll:RemoveItem')
AddEventHandler('PortalScroll:RemoveItem', function(item)
    local source = source
    local player = ESX.GetPlayerFromId(source)
    if player then
        player.removeInventoryItem(item, 1)
    end
end)

