
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPclient = Tunnel.getInterface("vRP", "rc_moneyWash") 
vRP = Proxy.getInterface("vRP")

HT = nil

TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)


RegisterNetEvent("rc_moneyWash:successEvent")
AddEventHandler("rc_moneyWash:successEvent", function()
local user_id = vRP.getUserId({source})
local blackmoney = vRP.getInventoryItemAmount({user_id,"dirty_money"})
local tacoersej = true
    if vRP.getInventoryItemAmount({user_id,"dirty_money"}) > 0 then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = ' Du hvidvaskede '..blackmoney..' Sorte Penge ', length = 2500, style = { ['background-color'] = '#4ad066', ['color'] = '#ffffff' } })
        vRP.tryPayment({user_id, Config.WashingCost})
        vRP.giveMoney({user_id, blackmoney})
        vRP.tryGetInventoryItem({user_id,"dirty_money", blackmoney})
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Du har ikke sorte penge på dig', length = 2500, style = { ['background-color'] = '#1e5d76', ['color'] = '#ffffff' } })
    end
end)