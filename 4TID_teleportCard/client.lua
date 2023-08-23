ESX = nil
local Haircut = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



RegisterNetEvent('Black_Teleprotcard:selectPlayer')
AddEventHandler('Black_Teleprotcard:selectPlayer', function()
  local ped = GetPlayerPed(-1)
  if not Regencard then
    -- SendNUIMessage({
    --   type = '1', 
    -- })
    TriggerServerEvent('Black_Teleprotcard:removeItem', Config.Item)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_MUSCLE_FLEX", 0, true)
    TriggerEvent("mythic_progbar:client:progress",{
      name = "unique_action_name",
      duration = 30000,
      label = "กำลังวาป",
      useWhileDead = false,
      canCancel = true,

      controlDisables = {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true
      },
    


    }, function(status)
      if not status then
        Regencard = true
        if ESX.GetPlayerData().job.name == 'east' then
          RequestNamedPtfxAsset('scr_rcbarry2')
          while not HasNamedPtfxAssetLoaded('scr_rcbarry2') do
            Citizen.Wait(0)
          end
          SetPtfxAssetNextCall('scr_rcbarry2')
          effect_L_1 = StartNetworkedParticleFxNonLoopedOnPedBone('scr_exp_clown', ped, 0.1, 0.00001, 0.00001, 0.0, 0.0, 0.0, tonumber(0x3779), 1.00, false, false, false)
          Wait(1000)
          SetEntityCoords(ped, vector3(1191.02001953125, -1330.8399658203125, 36.47999954223633))
        elseif ESX.GetPlayerData().job.name == 'north' then
          RequestNamedPtfxAsset('scr_rcbarry2')
          while not HasNamedPtfxAssetLoaded('scr_rcbarry2') do
            Citizen.Wait(0)
          end
          SetPtfxAssetNextCall('scr_rcbarry2')
          effect_L_1 = StartNetworkedParticleFxNonLoopedOnPedBone('scr_exp_clown', ped, 0.1, 0.00001, 0.00001, 0.0, 0.0, 0.0, tonumber(0x3779), 1.00, false, false, false)
          Wait(1000)
          SetEntityCoords(ped, vector3(1366.4000244140625, -739.3300170898438, 68.72000122070312))
        elseif ESX.GetPlayerData().job.name == 'south' then
          RequestNamedPtfxAsset('scr_rcbarry2')
          while not HasNamedPtfxAssetLoaded('scr_rcbarry2') do
            Citizen.Wait(0)
          end
          SetPtfxAssetNextCall('scr_rcbarry2')
          effect_L_1 = StartNetworkedParticleFxNonLoopedOnPedBone('scr_exp_clown', ped, 0.1, 0.00001, 0.00001, 0.0, 0.0, 0.0, tonumber(0x3779), 1.00, false, false, false)
          Wait(1000)
          SetEntityCoords(ped, vector3(-733, -1455.5, 6.6599998474121))
        elseif ESX.GetPlayerData().job.name == 'west' then
          RequestNamedPtfxAsset('scr_rcbarry2')
          while not HasNamedPtfxAssetLoaded('scr_rcbarry2') do
            Citizen.Wait(0)
          end
          SetPtfxAssetNextCall('scr_rcbarry2')
          effect_L_1 = StartNetworkedParticleFxNonLoopedOnPedBone('scr_exp_clown', ped, 0.1, 0.00001, 0.00001, 0.0, 0.0, 0.0, tonumber(0x3779), 1.00, false, false, false)
          Wait(1000)
          SetEntityCoords(ped, vector3(-1638.989990234375, -919.260009765625, 10.35999965667724))
        end
        
      end
    end)
     
  else
    TriggerEvent("pNotify:SendNotification", {
      text = '<strong class="red-text">การ์ดวาปรอเวลา 30 นาที</strong>',
      type = "error",
      timeout = 3000,
      layout = "bottomCenter",
      queue = "global"
    })
  end
end)  							


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if Regencard then
			Citizen.Wait(30*60000)
      Regencard = false
		end
	end
end)