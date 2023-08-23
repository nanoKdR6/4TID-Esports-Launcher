ESX                     = nil
Dv_Hunter                   = GetCurrentResourceName()
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
secondsRemaining = 0

RegisterServerEvent(Dv_Hunter..'give')
AddEventHandler(Dv_Hunter..'give', function()
	local xPlayer	= ESX.GetPlayerFromId(source)
	local name		= xPlayer.name
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
			for k,v in pairs(Config.ItemBonus) do
				if math.random(1, 100) <= v.Percent then
					local xItemZ = xPlayer.getInventoryItem(v.ItemName)
					if xItemZ.limit ~= -1 and xItemZ.count >= xItemZ.limit then
						TriggerClientEvent("pNotify:SendNotification", source, {
							text = '<span class="red-text">กระเป๋าเต็มเก็บไอเทมโบนัทไม่ได้</span> ',
							type = "success",
							timeout = 3000,
							layout = "bottomCenter",
							queue = "global"
						}) 
					else
						xPlayer.addInventoryItem(v.ItemName, v.ItemCount)
					end
				end
			end
		end
	end
end)


RegisterServerEvent(Dv_Hunter..'reviveon')
AddEventHandler(Dv_Hunter..'reviveon', function(target)
	TriggerClientEvent(Dv_Hunter..'reviveon', target)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local gettime = os.date('%X')
		for k,v in pairs(Config.Timeonline) do
			if gettime == v.Times then
				start()
			end
		end
		if secondsRemaining >= 0 then
			secondsRemaining = secondsRemaining - 1
		end
    end
end)

function start()
	TriggerClientEvent(Dv_Hunter..'startevent', -1, Config.TimerStart)
	secondsRemaining = Config.TimerStart
end

-- ESX.RegisterUsableItem(Config.ItemWork, function(source)
	-- TriggerClientEvent(Dv_Hunter..'StartWork', source)
-- end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	TriggerClientEvent(Dv_Hunter..'startevent', source, secondsRemaining)

end)