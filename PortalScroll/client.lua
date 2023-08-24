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

RegisterNetEvent('PortalScroll:Warp')
AddEventHandler('PortalScroll:Warp', function()
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
        TriggerServerEvent('PortalScroll:RemoveItem', PortalConfig.PortalItem)
        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_MUSCLE_FLEX", 0, true)

        TriggerEvent("mythic_progbar:client:progress", {
            name = "unique_action_name",
            duration = PortalConfig.PortalTimewarp,
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

                if not destinationCoords then
                    TriggerEvent("pNotify:SendNotification", {
                        text = '<strong class="red-text">ไปเลือกทีมไอสัส</strong>',
                        type = "error",
                        timeout = 3000,
                        layout = "bottomCenter",
                        queue = "global"
                    })
                else
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
            Citizen.Wait(PortalConfig.PortalCooldownwarp)
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
    RequestNamedPtfxAsset('core')
    
    while not HasNamedPtfxAssetLoaded('core') do
        Citizen.Wait(0)
    end
    
    SetPtfxAssetNextCall('core')
    
    local particleEffect = 'ent_dst_elec_fire_sp'
    local scale = 0.1
    local offsetX = 0.00001
    local offsetY = 0.00001
    local offsetZ = 0.0
    local rotationX = 0.0
    local rotationY = 0.0
    local rotationZ = 0.0
    local color = tonumber(0x3779)
    local intensity = 10.0
    local looped = false
    local autoRemove = false
    
    effectnuber1 = StartNetworkedParticleFxNonLoopedOnPedBone(particleEffect, playerPed, scale, offsetX, offsetY, offsetZ, rotationX, rotationY, rotationZ, color, intensity, looped, false, autoRemove)
    effectnuber2 = StartNetworkedParticleFxNonLoopedOnPedBone(particleEffect, playerPed, scale, offsetX, offsetY, offsetZ, rotationX, rotationY, rotationZ, color, intensity, looped, false, autoRemove)
    effectnuber3 = StartNetworkedParticleFxNonLoopedOnPedBone(particleEffect, playerPed, scale, offsetX, offsetY, offsetZ, rotationX, rotationY, rotationZ, color, intensity, looped, false, autoRemove)
end
