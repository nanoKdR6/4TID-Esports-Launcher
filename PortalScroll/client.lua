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
        local playerJob = ESX.GetPlayerData().job
        if not playerJob then return end
        
        local jobName = playerJob.name

        if not ShouldTeleport(jobName) then
            TriggerEvent("pNotify:SendNotification", {
                text = '<strong class="red-text">ไปเลือกโรงเรียนไอสัส</strong>',
                type = "error",
                timeout = 3000,
                layout = "bottomCenter",
                queue = "global"
            })
        else
            isCardRegenerating = true
            TeleportPlayer(playerPed, jobName)
        end
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

function ShouldTeleport(jobName)
    return jobName == 'east' or jobName == 'north' or jobName == 'south' or jobName == 'west'
end

function TeleportPlayer(playerPed, jobName)
    local destinationCoords = GetDestinationCoordinates(jobName)

    if not destinationCoords then return end
    
    LoadParticleEffect(playerPed)
    Citizen.Wait(1000)
    SetEntityCoords(playerPed, destinationCoords)

    TriggerServerEvent('TeleportCard:RemoveItem', TeleportConfig.TeleportItem)

    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_MUSCLE_FLEX", 0, true)
    
    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = 30000,
        label = "Teleporting",
        useWhileDead = false,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        },
    })
end

function GetDestinationCoordinates(jobName)
    local destinations = {
        east = vector3(1191.02, -1330.83, 36.48),
        north = vector3(1366.40, -739.33, 68.72),
        south = vector3(-733.0, -1455.5, 6.66),
        west = vector3(-1638.99, -919.26, 10.36)
    }
    
    return destinations[jobName]
end

function LoadParticleEffect(playerPed)
    RequestNamedPtfxAsset('scr_rcbarry2')
    while not HasNamedPtfxAssetLoaded('scr_rcbarry2') do
        Citizen.Wait(0)
    end
    
    SetPtfxAssetNextCall('scr_rcbarry2')
    local effect_L_1 = StartNetworkedParticleFxNonLoopedOnPedBone('scr_exp_clown', playerPed, 0.1, 0.00001, 0.00001, 0.0, 0.0, 0.0, 0x3779, 1.00, false, false, false)
end
