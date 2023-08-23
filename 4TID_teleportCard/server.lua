ESX						= nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Black_Teleprotcard:removeItem')
AddEventHandler('Black_Teleprotcard:removeItem', function(item)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem(item, 1)
end)

ESX.RegisterUsableItem(Config.Item, function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if xPlayer then
		if xPlayer.getInventoryItem(Config.Item).count > 0 then
			TriggerClientEvent("Black_Teleprotcard:selectPlayer", _source)
        else
			TriggerClientEvent("pNotify:SendNotification", _source, {
                text = '<strong class="red-text">ไม่สามารถใช้งานได้</strong>',
                type = "error",
                timeout = 3000,
                layout = "bottomCenter",
                queue = "global"
            })
		end
	end
end)
