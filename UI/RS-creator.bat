@ECHO off
COLOR 8
TITLE "RS-creator - RESOURCE CREATOR FOR FIVEM - v.1.0
ECHO Type in a name for the folder/resource. 
ECHO.
ECHO Use '\' to choose a new path (different from resources)
ECHO.
ECHO example: existingfolder\yourresourcename
ECHO.
goto inputrsname

:inputrsname
SET /p RSName="Enter the Resource Name: "

ECHO.

ECHO is '%RSName%' right?
SET /p corrected="type in [y/n] "

if %corrected% == n goto inputrsname
if not %corrected% == y echo Your Input is invalid! && goto inputrsname

ECHO.
ECHO The Resource '%RSName%' can be created.
ECHO.
SET /p mode="What Mode do you want to use? Default / ESX / VRP [d/e/v] "

ECHO.
if %mode% == e goto recreate
if %mode% == v goto rvcreate
if not %mode% == d echo invalid Input! && goto inputrsname
goto dftrc


:dftrc
ECHO Press 'ENTER' to start!
PAUSE
ECHO.
ECHO Settings:
ECHO 1x client script, 1x server script, 1x resource script
cd %~dp0/resources/
if exist %RSName% cls && echo %RSName% does already exist! If you continue, files with the same file name will be overwritten! && goto inputrsname
goto rdcreate

:rdcreate
cd %~dp0/resources/
if exist %RSName% ECHO If you continue all existing files will be overwritten! close this batch if you don't want to replace your files! && timeout /t 15
mkdir %RSName%
echo. >%RSName%\client.lua
echo. >%RSName%\server.lua

echo fx_version 'adamant' > %RSName%\fxmanifest.lua

echo game 'gta5' >> %RSName%\fxmanifest.lua

echo. >> %RSName%\fxmanifest.lua

echo client_scripts { >> %RSName%\fxmanifest.lua

echo 	"client.lua" >> %RSName%\fxmanifest.lua

echo } >> %RSName%\fxmanifest.lua

echo. >> %RSName%\fxmanifest.lua

echo server_scripts { >> %RSName%\fxmanifest.lua

echo 	"server.lua" >> %RSName%\fxmanifest.lua

echo } >> %RSName%\fxmanifest.lua

goto end

:recreate
cd %~dp0/resources/
if exist %RSName% ECHO If you continue all existing files will be overwritten! close this batch if you don't want to replace your files! && timeout /t 15
mkdir %RSName%
echo ESX               = nil >%RSName%\client.lua
echo Citizen.CreateThread(function() >>%RSName%\client.lua
echo 	while ESX == nil do >>%RSName%\client.lua
echo 		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) >>%RSName%\client.lua
echo 		Citizen.Wait(1) >>%RSName%\client.lua
echo 	end >>%RSName%\client.lua
echo 		PlayerData = ESX.GetPlayerData() >>%RSName%\client.lua
echo end) >>%RSName%\client.lua
echo. >>%RSName%\client.lua
echo RegisterNetEvent('esx:playerLoaded') >>%RSName%\client.lua
echo AddEventHandler('esx:playerLoaded', function(xPlayer) >>%RSName%\client.lua
echo 	PlayerData = xPlayer >>%RSName%\client.lua
echo end) >>%RSName%\client.lua
echo. >>%RSName%\client.lua
echo RegisterNetEvent('esx:setJob') >>%RSName%\client.lua
echo AddEventHandler('esx:setJob', function(job) >>%RSName%\client.lua
echo 	PlayerData.job = job >>%RSName%\client.lua
echo end) >>%RSName%\client.lua

echo ESX = nil >%RSName%\server.lua
echo. >>%RSName%\server.lua
echo TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) >>%RSName%\server.lua

echo fx_version 'adamant' > %RSName%\fxmanifest.lua

echo game 'gta5' >> %RSName%\fxmanifest.lua

echo. >> %RSName%\fxmanifest.lua

echo client_scripts { >> %RSName%\fxmanifest.lua

echo 	"client.lua" >> %RSName%\fxmanifest.lua

echo } >> %RSName%\fxmanifest.lua

echo. >> %RSName%\fxmanifest.lua

echo server_scripts { >> %RSName%\fxmanifest.lua

echo 	"server.lua" >> %RSName%\fxmanifest.lua

echo } >> %RSName%\fxmanifest.lua

goto end

:rvcreate
cd %~dp0/resources/
if exist %RSName% ECHO If you continue all existing files will be overwritten! close this batch if you don't want to replace your files! && timeout /t 15
mkdir %RSName%
echo TestS = Tunnel.getInterface(""..GetCurrentResourceName().."_server",""..GetCurrentResourceName().."_server") >%RSName%\client.lua
echo vRP = Proxy.getInterface("vRP") >>%RSName%\client.lua

echo local Tunnel = module("vrp", "lib/Tunnel") >%RSName%\server.lua
echo local Proxy = module("vrp", "lib/Proxy") >>%RSName%\server.lua
echo. >>%RSName%\server.lua
echo vRP = Proxy.getInterface("vRP") >>%RSName%\server.lua
echo vRPclient = Tunnel.getInterface("vRP", ""..GetCurrentResourceName().."_server") >>%RSName%\server.lua
echo vRPtest = {} >>%RSName%\server.lua
echo Tunnel.bindInterface(""..GetCurrentResourceName().."_server",vRPtest ) >>%RSName%\server.lua

echo fx_version 'adamant' > %RSName%\fxmanifest.lua

echo game 'gta5' >> %RSName%\fxmanifest.lua

echo. >> %RSName%\fxmanifest.lua

echo client_scripts { >> %RSName%\fxmanifest.lua

echo 	"client.lua" >> %RSName%\fxmanifest.lua

echo } >> %RSName%\fxmanifest.lua

echo. >> %RSName%\fxmanifest.lua

echo server_scripts { >> %RSName%\fxmanifest.lua

echo 	"server.lua" >> %RSName%\fxmanifest.lua

echo } >> %RSName%\fxmanifest.lua

goto end

:end
ECHO Do you want to add a key table to the client?
SET /p xtra="note: The Keys won't matchup always right. [y/n] "
if xtra == n goto end2

cd %~dp0/resources/
echo. >>%RSName%\client.lua
echo Keys = { >>%RSName%\client.lua
echo ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, >>%RSName%\client.lua
echo	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, >>%RSName%\client.lua
echo	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, >>%RSName%\client.lua
echo	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, >>%RSName%\client.lua
echo	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, >>%RSName%\client.lua
echo	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, >>%RSName%\client.lua
echo	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, >>%RSName%\client.lua
echo	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, >>%RSName%\client.lua
echo	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118 >>%RSName%\client.lua
echo } >>%RSName%\client.lua
goto end2

:end2
ECHO Your Resource has been created.
ECHO This Batch will close automaticly
timeout /T 10
exit
