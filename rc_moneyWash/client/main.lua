vRPC = {}
Tunnel.bindInterface("rc_moneyWash",vRPC)
Proxy.addInterface("rc_moneyWash",vRPC)
vRP = Proxy.getInterface("vRP")

HT              = nil
local PlayerData = {}

local user_id = vRP.getUserId({source})
local currentblackMoney = 10000
local currentWashCost = Config.WashingCost

Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)

local isMenuOpen = false

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(4)
    local user_id = vRP.getUserId({source})
	local coords = GetEntityCoords(PlayerPedId())
	local distance = GetDistanceBetweenCoords(coords, Config.MoneyWashingDealer["pos"]["x"], Config.MoneyWashingDealer["pos"]["y"], Config.MoneyWashingDealer["pos"]["z"], true) -- Die Nullen durch die Cords des Markers oder so ersetzten. Alsi da wo der Spieler E drücken kann

	if distance <= 3 then
			if isMenuOpen == false then
                    DrawText3D(Config.MoneyWashingDealer["pos"]["x"], Config.MoneyWashingDealer["pos"]["y"], Config.MoneyWashingDealer["pos"]["z"],"~r~E~w~ - Menu")
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("wefwef", function()
                            local blackmoney = vRP.getInventoryItemAmount({user_id,"dirty_money"})
                            local money = vRP.getMoney({user_id})
                            currentblackMoney = blackmoney
                            currentMoney = money
                            currentWashCost = Config.WashingCost
                        end)
                        Citizen.Wait(500)
                        SetDisplay(not display) -- Aktiviert die UI
						isMenuOpen = true
					end
				end
			end

	end
end)


RegisterNUICallback("exit", function(data) -- index.js ruft diesen Callback auf und dan passiert das was dadrin passiert
    print("UI Closed")
    SetDisplay(false) -- Deaktviert die UI
    isMenuOpen = false
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    print(currentblackMoney)
    SendNUIMessage({
        type = "ui",
        status = bool,
        currentblackMoney = currentblackMoney,
        currentWashCost = currentWashCost,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)







_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

Citizen.CreateThread(function()

    local pedPosition = Config.MoneyWashingDealer["pos"]


            _RequestModel(349680864)
            if not DoesEntityExist(pedPosition["entity"]) then
                pedPosition["entity"] = CreatePed(4, 349680864, pedPosition["x"], pedPosition["y"], pedPosition["z"] -1, pedPosition["h"])
                SetEntityAsMissionEntity(pedPosition["entity"])
                SetBlockingOfNonTemporaryEvents(pedPosition["entity"], true)
                FreezeEntityPosition(pedPosition["entity"], true)
                SetEntityInvincible(pedPosition["entity"], true)
                
		        TaskStartScenarioInPlace(pedPosition["entity"], "WORLD_HUMAN_SMOKING", 0, true);
            end
            SetModelAsNoLongerNeeded(349680864)
end)







-- CREATE BLIPS


Citizen.CreateThread(function()
        local blip = Config.MoneyWashingDealer["pos"]


        if Config.MoneyWashingDealer["showBlip"] == true then

            if blip then
                    blip = AddBlipForCoord(Config.MoneyWashingDealer["pos"]["x"], Config.MoneyWashingDealer["pos"]["y"], Config.MoneyWashingDealer["pos"]["z"])
                    SetBlipSprite(blip, 225)
                    SetBlipDisplay(blip, 4)
                    SetBlipScale(blip, 1.0)
                    SetBlipColour(blip, 46)
                    SetBlipAsShortRange(blip, true)
    
                    BeginTextCommandSetBlipName("moneyWashBlip")
                    AddTextEntry("moneyWashBlip", Config.MoneyWashingDealer["blipName"])
                    EndTextCommandSetBlipName(blip)
                
            end

        end

        
    
end)




RegisterNUICallback("success", function(data) 
    SetDisplay(false) 
    isMenuOpen = false

    TriggerServerEvent("rc_moneyWash:successEvent")
   

    
end)

function DrawText3D(x, y, z, text)
	local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
	local pX, py, pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(0.37, 0.37)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(true)
	SetTextColour(255, 255, 255,215)
	AddTextComponentString(text)
	DrawText(_x, _y)
	local factor = (string.len(text)) / 700
	DrawRect(_x, _y + 0.0150, 0.06 + factor, 0.03, 41, 11, 41, 100)
end