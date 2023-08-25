ESX = nil
ResourceName = GetCurrentResourceName()
local Objects = 0
local ObjectLists = {}
local IsPickingUp = false
local IsOpenMenu = false
local sell = false
local canpro = false
local hold = false
local startwork = false
local getting = true
isDead = false
Objecton = nil
local AEDonline = false
secondsRemaining = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent(ResourceName..'startevent')
AddEventHandler(ResourceName..'startevent', function(time)
    secondsRemaining = time
end)

RegisterNetEvent(ResourceName..'reviveon')
AddEventHandler(ResourceName..'reviveon', function()
    AEDonline = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        if secondsRemaining > 0 then
            secondsRemaining = secondsRemaining - 1
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        if secondsRemaining > 0 then
            if GetDistanceBetweenCoords(PlayerCoords, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, true) < 50 and not startwork then
                TriggerEvent(ResourceName..'StartWork', source)
                startwork = true
                Citizen.Wait(500)
            end
        end
        if startwork then
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        if secondsRemaining > 0 then
            sleep = 0
            local fontId = RegisterFontId('font4thai')
            SetTextFont(fontId)
            SetTextScale(0.45, 0.45)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            BeginTextCommandDisplayText('STRING')
            AddTextComponentString("เวลาการฟาร์มวงแดง " .. secondsToClock(secondsRemaining))
            EndTextCommandDisplayText(0.70, 0.950)
        end
        Citizen.Wait(sleep)
    end
end)

-- Function to format time as "minutes : seconds"
function secondsToClock(seconds)
    local hours = math.floor(seconds / 3600)
    local mins = math.floor((seconds - hours * 3600) / 60)
    local secs = math.floor(seconds - hours * 3600 - mins * 60)
    return string.format("%02d : %02d", mins, secs)
end

-- Main code execution
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        if secondsRemaining > 0 then
            if GetDistanceBetweenCoords(PlayerCoords, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, true) < 50 and not startwork then
                TriggerEvent(ResourceName..'StartWork', source)
                startwork = true
                Citizen.Wait(500)
            end
        end
        if startwork then
            Citizen.Wait(1000)
        end
    end
end)

-- Event handlers using arrow functions
AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function()
    Wait(1000)
    if isDead then
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(PlayerCoords, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, true) < 100 then
            local randomteleport = math.random(1, 2)
            if AEDonline == true then
                Wait(60000)
                if randomteleport == 1 then
                    SetEntityCoords(PlayerPedId(), Config.Zoneteleport.coords)
                elseif randomteleport == 2 then
                    SetEntityCoords(PlayerPedId(), Config.Zoneteleport.coords2)
                end
                AEDonline = false
            else
                AEDonline = false
                if randomteleport == 1 then
                    SetEntityCoords(PlayerPedId(), Config.Zoneteleport.coords)
                elseif randomteleport == 2 then
                    SetEntityCoords(PlayerPedId(), Config.Zoneteleport.coords2)
                end
            end
        else
            AEDonline = false
        end
    end
    isDead = false
end)

-- Citizen thread using an arrow function
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        if GetDistanceBetweenCoords(PlayerCoords, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, true) < 200 then
            DrawMarker(1, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 100.5, 100.5, 12.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
        else
            Citizen.Wait(500)
        end
    end
end)


-- Work PickedUp On
RegisterNetEvent(ResourceName..'StartWork')
AddEventHandler(ResourceName..'StartWork', function()
    if not startwork then
        startwork = true
        ESX.ShowNotification('~g~True')
        
        Citizen.CreateThread(function()
            while startwork do
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
            while startwork do
                Citizen.Wait(0)
                
                local playerPed = PlayerPedId()
                local coords = GetEntityCoords(playerPed)
                local nearbyObject, nearbyID
                
                for i = 1, #ObjectLists, 1 do
                    if GetDistanceBetweenCoords(coords, GetEntityCoords(ObjectLists[i]), false) < 2 then
                        nearbyObject, nearbyID = ObjectLists[i], i
                    end
                end
                
                if nearbyObject and IsPedOnFoot(playerPed) and not IsPickingUp and not hold then
                    if not IsPickingUp then
                        DisplayHelpText("Press ~INPUT_CONTEXT~ to ~g~Mining.~s~")
                    end
                    
                    if IsControlJustReleased(0, Config.Key['E']) and not IsPickingUp then
                        if secondsRemaining > 0 then
                            TriggerEvent(ResourceName..'prop')
                            IsPickingUp = true
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
                    IsPickingUp = false
                else
                    Citizen.Wait(500)
                end
            end
        end)
    else
        DeleteObject()
    end
end)

function OpenTrashCan()
    TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
    TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, -8.0, -1, 48, 0, false, false, false)
    Wait(Config.Time)
    ClearPedTasks(PlayerPedId())
end

-- PickedUp
RegisterNetEvent(ResourceName..'prop')
AddEventHandler(ResourceName..'prop', function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local nearbyObject, nearbyID
    
    for i = 1, #ObjectLists, 1 do
        if GetDistanceBetweenCoords(coords, GetEntityCoords(ObjectLists[i]), false) < 2 then
            nearbyObject, nearbyID = ObjectLists[i], i
        end
    end
    
    if not hold then
        IsPickingUp = true
        local x, y, z = table.unpack(coords)
        
        FreezeEntityPosition(playerPed, true)
        Object()
        PickedUp()
        Citizen.Wait(Config.Time)
        
        local get_object = GetClosestObjectOfType(coords, 30.0, GetHashKey('prop_tool_pickaxe'), false, false, false)
        SetEntityAsMissionEntity(Objecton, true, true)
        DeleteEntity(Objecton)
        ESX.Game.DeleteObject(HandObject)
        PlaceObjectOnGroundProperly(HandObject)
        ESX.Game.DeleteObject(nearbyObject)
        
        FreezeEntityPosition(playerPed, false)
        ClearPedTasks(playerPed)
        table.remove(ObjectLists, nearbyID)
        Objects = Objects - 1
        Citizen.Wait(100)
        canpro = true
        TriggerServerEvent(ResourceName..'give')
        IsPickingUp = false
    else
        TriggerEvent("PorNotify:SendNotification", {
            text = '<strong class="red-text">Please release the held object first.</strong>',
            type = "error",
            timeout = 3000,
            layout = "bottomCenter",
            queue = "global"
        })
    end
end)

function Object()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local x, y, z = table.unpack(coords)
    local boneIndex = GetPedBoneIndex(playerPed, 57005)
    
    Objecton = CreateObject(GetHashKey('prop_tool_pickaxe'), x, y, z + 0.2,  true,  true, true)
    AttachEntityToEntity(Objecton, playerPed, boneIndex, 0.16, 0.00, 0.00, 410.0, 20.00, 140.0, true, true, false, true, 1, true)
end

-- Process
RegisterNetEvent(ResourceName..'clear')
AddEventHandler(ResourceName..'clear', function()
    if hold then
        FreezeEntityPosition(PlayerPedId(), true)
        DetachEntity(fruitspawned, 1, 1)
        DetachEntity(fruitspawned2, 1, 1)
        ESX.Game.DeleteObject(fruitspawned)
        ESX.Game.DeleteObject(fruitspawned2)
        maitem = false
        ClearPedSecondaryTask(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
        hold = false
        
        if Config.stress then
            TriggerEvent('esx_status:add', 'stress', Config.count)
        end
        
        TriggerServerEvent(ResourceName..'give')
    else
        TriggerEvent("PorNotify:SendNotification", {
            text = '<strong class="red-text">Please put down the item first.</strong>',
            type = "error",
            timeout = 5000,
            layout = "bottomCenter",
            queue = "global"
        })
    end
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        
        if IsControlJustReleased(0, Config.Key['X']) then
            hold = false
            DetachEntity(fruitspawned, 1, 1)
            DetachEntity(fruitspawned2, 1, 1)
            ESX.Game.DeleteObject(fruitspawned)
            ESX.Game.DeleteObject(fruitspawned2)
        end
    end
end)

-- Blip
Citizen.CreateThread(function()
    local ConfigLocation = Config.Zone
    local blip1 = AddBlipForCoord(ConfigLocation.Pos.x, ConfigLocation.Pos.y, ConfigLocation.Pos.z)
    SetBlipSprite(blip1, ConfigLocation.Blips.Id)
    SetBlipDisplay(blip1, 4)
    SetBlipScale(blip1, ConfigLocation.Blips.Size)
    SetBlipColour(blip1, ConfigLocation.Blips.Color)
    SetBlipAsShortRange(blip1, true)
    AddTextEntry('Black_mining', Config.Zone.Blips.Text)
    BeginTextCommandSetBlipName("Black_mining")
    EndTextCommandSetBlipName(blip1)
end)

-- DisplayHelpText
function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- DeleteObject
function DeleteObject()
    startwork = false
    ESX.Game.DeleteObject(Objecton)
    PlaceObjectOnGroundProperly(Objecton)

    for obj in pairs(ObjectLists) do
        ESX.Game.DeleteObject(obj)
    end

    Citizen.Wait(2000)

    for obj in pairs(ObjectLists) do
        ESX.Game.DeleteObject(obj)
    end

    Citizen.Wait(2000)

    for obj in pairs(ObjectLists) do
        ESX.Game.DeleteObject(obj)
        Objects = 0
    end

    Citizen.Wait(500)
end

-- Stop Resource
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for obj in pairs(ObjectLists) do
            ESX.Game.DeleteObject(obj)
        end
    end
end)

-- SpawnObjects
function GenerateObjectCoords() 
    while true do
        Citizen.Wait(1)

        local crabCoordX, crabCoordY

        math.randomseed(GetGameTimer())
        local modX = math.random(-30, 30)

        Citizen.Wait(100)

        math.randomseed(GetGameTimer())
        local modY = math.random(-30, 30)

        crabCoordX = Config.Zone.Pos.x + modX
        crabCoordY = Config.Zone.Pos.y + modY

        local coordZ = GetCoordZ(crabCoordX, crabCoordY) - 2.0
        local coord = vector3(crabCoordX, crabCoordY, coordZ)

        if ValidateObjectCoord(coord) then
            return coord
        end
    end
end

function SpawnObjects()
    while Objects < Config.SpawnObjects do
        Citizen.Wait(0)
        local objectCoords = GenerateObjectCoords()

        local listObject = {
            { Name = "likemod_chest_anim_props" },
            { Name = "likemod_chest_anim_props" }
        }

        local randomStone = math.random(#listObject)

        ESX.Game.SpawnLocalObject(listObject[randomStone].Name, vector3(objectCoords.x, objectCoords.y, Config.Zone.Pos.z), function(object)
            PlaceObjectOnGroundProperly(object)
            FreezeEntityPosition(object, true)

            table.insert(ObjectLists, object)
            Objects = Objects + 1
        end)
    end
end

function ValidateObjectCoord(plantCoord)
    if Objects > 0 then
        local validate = true

        for p in pairs(ObjectLists) do
            if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(p), true) < 5 then
                validate = false
            end
        end

        if GetDistanceBetweenCoords(plantCoord, Config.Zone.Pos.x, Config.Zone.Pos.y, Config.Zone.Pos.z, false) > 50 then
            validate = false
        end

        return validate
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
