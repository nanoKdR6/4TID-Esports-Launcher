ESX = nil
ResourceName = GetCurrentResourceName()
local isPickUp = false
local hold = false
local Objects = 0
local ObjectLists = {}
local isOpenMenu = false
local sell = false
local canPro = false
local getting = true
local Objecton = nil

local remainingTime = 0
local AEDonline = false
local isDead = false
local startWork = false

local PlayerCoords = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent(ResourceName .. 'startevent')
AddEventHandler(ResourceName .. 'startevent', function(time)
    remainingTime = time
end)

RegisterNetEvent(ResourceName .. 'reviveon')
AddEventHandler(ResourceName .. 'reviveon', function()
    AEDonline = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        PlayerCoords = GetEntityCoords(PlayerPedId())
        if remainingTime > 0 then
            remainingTime = remainingTime - 1
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if remainingTime > 0 then
            DrawCountdownText()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if remainingTime > 0 then
            CheckWorkStart()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if remainingTime > 0 then
            DisplayTimerMarker()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isDead then
            HandlePlayerSpawn()
        end
    end
end)

function DrawCountdownText()
    local fontId = RegisterFontId('font4thai')
    SetTextFont(fontId)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 0)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentString("เวลาการฟาร์มวงแดง " .. secondsToClock(remainingTime))
    EndTextCommandDisplayText(0.70, 0.950)
end

function CheckWorkStart()
    if GetDistanceBetweenCoords(PlayerCoords, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, true) < 50 and not startWork then
        TriggerEvent(ResourceName .. 'StartWork', source)
        startWork = true
        Citizen.Wait(500)
    end
end

function DisplayTimerMarker()
    if GetDistanceBetweenCoords(PlayerCoords, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, true) < 200 then
        DrawMarker(1, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 100.5, 100.5, 12.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
    else
        Citizen.Wait(500)
    end
end

function HandlePlayerSpawn()
    Wait(1000)
    if isDead then
        local randomteleport = math.random(1, 2)
        if GetDistanceBetweenCoords(PlayerCoords, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, true) < 100 then
            if AEDonline then
                Wait(60000)
                TeleportPlayer(randomteleport)
                AEDonline = false
            else
                TeleportPlayer(randomteleport)
                AEDonline = false
            end
        else
            AEDonline = false
        end
    end
    isDead = false
end

function TeleportPlayer(teleportIndex)
    local targetCoords = teleportIndex == 1 and Config.Zoneteleport.coords or Config.Zoneteleport.coords2
    SetEntityCoords(PlayerPedId(), targetCoords)
end

function secondsToClock(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor(seconds / 60 % 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

-- Handle player spawning and teleportation
AddEventHandler('playerSpawned', function()
    Wait(1000)
    if isDead then
        local playerCoords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(playerCoords, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, true) < 100 then
            TeleportPlayerOnSpawn()
        end
    end
    isDead = false
end)

function TeleportPlayerOnSpawn()
    if AEDonline then
        Wait(60000)
    end

    local randomTeleport = math.random(1, 2)
    local targetCoords = randomTeleport == 1 and Config.Zoneteleport.coords or Config.Zoneteleport.coords2
    SetEntityCoords(PlayerPedId(), targetCoords)
    AEDonline = false
end

-- Create marker thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        if GetDistanceBetweenCoords(playerCoords, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, true) < 200 then
            DrawMarkerOnPlayerCoords(Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z)
        else
            Citizen.Wait(500)
        end
    end
end)

function DrawMarkerOnPlayerCoords(x, y, z)
    DrawMarker(1, x, y, z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 100.5, 100.5, 12.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
end

-- Main work event handler...
RegisterNetEvent(ResourceName..'StartWork')
AddEventHandler(ResourceName..'StartWork', function()
    if not startWork then
        startWork = true
        ESX.ShowNotification('~g~True')
        MineLoop()
    else
        DeleteObject()
    end
end)

function MineLoop()
    Citizen.CreateThread(function()
        while startWork do
            Citizen.Wait(10)
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            if GetDistanceBetweenCoords(PlayerCoords, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, true) < 100 then
                SpawnObjects()
                Citizen.Wait(500)
            else
                DeleteObject()
                Citizen.Wait(500)
            end
        end
    end)

    Citizen.CreateThread(function()
        while startWork do
            Citizen.Wait(0)
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local nearbyObject, nearbyID

            for i = 1, #ObjectLists, 1 do
                if GetDistanceBetweenCoords(coords, GetEntityCoords(ObjectLists[i]), false) < 2 then
                    nearbyObject, nearbyID = ObjectLists[i], i
                end
            end

            if nearbyObject and IsPedOnFoot(playerPed) and not isPickUp and not hold then
                if not isPickUp then
                    DisplayHelpText("Press ~INPUT_CONTEXT~ to ~g~Mining.~s~")
                end

                if IsControlJustReleased(0, Config.Key['E']) and not isPickUp then
                    if remainingTime > 0 then
                        TriggerEvent(ResourceName..'prop')
                        isPickUp = true
                        Wait(Config.Time)
                        Wait(500)
                    else
                        TriggerEvent("PorNotify:SendNotification", {
                            text = 'Time for mining has expired',
                            type = "error",
                            timeout = 3000,
                            layout = "bottomCenter",
                            queue = "global"
                        })
                    end
                end

                isPickUp = false
            else
                Citizen.Wait(500)
            end
        end
    end)
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Handle pick up
RegisterNetEvent(ResourceName .. 'prop')
AddEventHandler(ResourceName .. 'prop', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    local nearbyObject, nearbyID
    
    for i = 1, #ObjectLists do
        local objectCoords = GetEntityCoords(ObjectLists[i])
        if GetDistanceBetweenCoords(coords, objectCoords, false) < 2 then
            nearbyObject, nearbyID = ObjectLists[i], i
            break
        end
    end
    
    if not hold then
        if nearbyObject then
            HoldPickaxe()
            Citizen.Wait(Config.Time)
            DropPickaxe(nearbyObject, nearbyID)
            canPro = true
            TriggerServerEvent(ResourceName .. 'give')
        else
            TriggerNotification("No nearby object to pick up.")
        end
    else
        TriggerNotification("Please put down the held object first.")
    end
end)

function HoldPickaxe()
    local playerPed = PlayerPedId()
    local boneIndex = GetPedBoneIndex(playerPed, 57005)
    
    HandObject = CreateObject(GetHashKey('prop_tool_pickaxe'), 0.0, 0.0, 0.0, true, true, true)
    AttachEntityToEntity(HandObject, playerPed, boneIndex, 0.16, 0.0, 0.0, 0.0, 20.0, 140.0, true, true, false, true, 1, true)
end

function DropPickaxe(nearbyObject, nearbyID)
    local playerPed = PlayerPedId()
    
    FreezeEntityPosition(playerPed, false)
    ClearPedTasks(playerPed)
    
    ESX.Game.DeleteObject(HandObject)
    PlaceObjectOnGroundProperly(HandObject)
    
    ESX.Game.DeleteObject(nearbyObject)
    table.remove(ObjectLists, nearbyID)
    Objects = Objects - 1
end

function TriggerNotification(message)
    TriggerEvent("PorNotify:SendNotification", {
        text = message,
        type = "error",
        timeout = 3000,
        layout = "bottomCenter",
        queue = "global"
    })
end

-- Main process event handler...
RegisterNetEvent(ResourceName .. 'clear')
AddEventHandler(ResourceName .. 'clear', function()
    if hold then
        ClearHeldObjects()
        maitem = false
        if Config.stress then
            TriggerEvent('esx_status:add', 'stress', Config.count)
        end
        TriggerServerEvent(ResourceName .. 'give')
    else
        TriggerNotification("Please drop the held object first.")
    end
end)

function ClearHeldObjects()
    FreezeEntityPosition(PlayerPedId(), true)
    DetachEntity(fruitspawned, 1, 1)
    DetachEntity(fruitspawned2, 1, 1)
    ESX.Game.DeleteObject(fruitspawned)
    ESX.Game.DeleteObject(fruitspawned2)
    ClearPedSecondaryTask(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    hold = false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if IsControlJustReleased(0, Config.Key['X']) then
            hold = false
            ClearHeldObjects()
        end
    end
end)

Citizen.CreateThread(function()
    local ConfigLocation = Config.Zone
    local blip1 = AddBlipForCoord(ConfigLocation.Pos.x, ConfigLocation.Pos.y, ConfigLocation.Pos.z)
    SetBlipSprite(blip1, ConfigLocation.Blips.Id)
    SetBlipDisplay(blip1, 4)
    SetBlipScale(blip1, ConfigLocation.Blips.Size)
    SetBlipColour(blip1, ConfigLocation.Blips.Color)
    SetBlipAsShortRange(blip1, true)
    AddTextEntry('Mining_Black', Config.Zone.Blips.Text)
    BeginTextCommandSetBlipName("Mining_Black")
    EndTextCommandSetBlipName(blip1)
end)

function GenerateObjectCoords()
    while true do
        Citizen.Wait(1)
        local crabCoordX, crabCoordY = GenerateRandomCoordinates()

        local coordZ = GetCoordZ(crabCoordX, crabCoordY) - 2.0
        local coord = vector3(crabCoordX, crabCoordY, coordZ)

        if ValidateObjectCoord(coord) then
            return coord
        end
    end
end

function GenerateRandomCoordinates()
    math.randomseed(GetGameTimer())
    local modX = math.random(-30, 30)

    Citizen.Wait(100)

    math.randomseed(GetGameTimer())
    local modY = math.random(-30, 30)

    local crabCoordX = Config.Zone.Pos.x + modX
    local crabCoordY = Config.Zone.Pos.y + modY

    return crabCoordX, crabCoordY
end

function TriggerNotification(message)
    TriggerEvent("PorNotify:SendNotification", {
        text = message,
        type = "error",
        timeout = 5000,
        layout = "bottomCenter",
        queue = "global"
    })
end

-- Spawning objects...
function SpawnRandomObjects()
    while Objects < Config.MaxSpawnObjects do
        Citizen.Wait(0)
        local objectCoords = GenerateObjectCoords()

        local availableObjects = {
            "likemod_chest_anim_props",
            "likemod_chest_anim_props"
        }

        local randomObjectIndex = math.random(#availableObjects)
        local randomObjectName = availableObjects[randomObjectIndex]

        ESX.Game.SpawnLocalObject(randomObjectName, vector3(objectCoords.x, objectCoords.y, Config.Zone.Pos.z), function(object)
            PlaceObjectOnGroundProperly(object)
            FreezeEntityPosition(object, true)

            table.insert(ObjectLists, object)
            Objects = Objects + 1
        end)
    end
end

function ValidateObjectPosition(plantCoord)
    if Objects > 0 then
        local isValid = true

        for object in pairs(ObjectLists) do
            if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(object), true) < 5 then
                isValid = false
            end
        end

        local distanceToZoneCenter = GetDistanceBetweenCoords(plantCoord, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, false)
        if distanceToZoneCenter > 50 then
            isValid = false
        end

        return isValid
    else
        return true
    end
end

function GetCoordZ(x, y)
    local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0, 100.0 }

    for height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

        if foundGround then
            return z
        end
    end

    return 43.0
end

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function CleanupObjects()
    startWork = false
    ESX.Game.DeleteObject(Objecton)
    PlaceObjectOnGroundProperly(Objecton)

    for object in pairs(ObjectLists) do
        ESX.Game.DeleteObject(object)
    end

    Citizen.Wait(2000)
    Objects = 0
    ObjectLists = {}
    Citizen.Wait(500)
end

-- Clean up when the resource is stopped
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        CleanupObjects()
    end
end)
