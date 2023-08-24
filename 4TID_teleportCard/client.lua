ESX = nil
local isCardRegenerating = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('TeleportCard:SelectPlayer')
AddEventHandler('TeleportCard:SelectPlayer', function()
    local playerPed = GetPlayerPed(-1)

    if isCardRegenerating then
        TriggerEvent("pNotify:SendNotification", {
            text = '<strong class="red-text">การ์ดวาปรอเวลา 30 นาที</strong>',
            type = "error",
            timeout = 3000,
            layout = "bottomCenter",
            queue = "global"
        })
    else
        TriggerServerEvent('TeleportCard:RemoveItem', TeleportConfig.TeleportItem)
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_MUSCLE_FLEX", 0, true)

        TriggerEvent("mythic_progbar:client:progress", {
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
                isCardRegenerating = true
                local jobName = ESX.GetPlayerData().job.name
                local destinationCoords = GetDestinationCoordinates(jobName)

                if destinationCoords then
                    LoadParticleEffect(playerPed)
                    Wait(1000)
                    SetEntityCoords(playerPed, destinationCoords)
                end
            end
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isCardRegenerating then
            Citizen.Wait(30 * 60000)
            isCardRegenerating = false
        end
    end
end)

function GetDestinationCoordinates(jobName)
    if jobName == 'east' then
        return vector3(1191.02001953125, -1330.8399658203125, 36.47999954223633)
    elseif jobName == 'north' then
        return vector3(1366.4000244140625, -739.3300170898438, 68.72000122070312)
    elseif jobName == 'south' then
        return vector3(-733, -1455.5, 6.6599998474121)
    elseif jobName == 'west' then
        return vector3(-1638.989990234375, -919.260009765625, 10.35999965667724)
    end
end

function LoadParticleEffect(playerPed)
    RequestNamedPtfxAsset('scr_rcbarry2')
    while not HasNamedPtfxAssetLoaded('scr_rcbarry2') do
        Citizen.Wait(0)
    end
    
    SetPtfxAssetNextCall('scr_rcbarry2')
    effect_L_1 = StartNetworkedParticleFxNonLoopedOnPedBone('scr_exp_clown', playerPed, 0.1, 0.00001, 0.00001, 0.0, 0.0, 0.0, tonumber(0x3779), 1.00, false, false, false)
end
