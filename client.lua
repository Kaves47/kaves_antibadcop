ESX = nil


Weapons = { --/ https://wiki.rage.mp/index.php?title=Weapons

    "WEAPON_PISTOL",

}

Jobs = { -- Whitelisted jobs

    "police",
    "sheriff",

}


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
    PlayerData = ESX.GetPlayerData()
    
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local player = PlayerPedId()
        if not isPlayerWhitelisted then
            for k,v in pairs(Weapons) do
                local player = PlayerPedId()
                local weapon = GetHashKey(v)
                if HasPedGotWeapon(player, weapon, false) == 1 then
                    RemoveWeaponFromPed(player, weapon)
                end
            end
        end
    end
end)


function refreshPlayerWhitelisted()
	if not ESX.PlayerData then
		return false
	end

	if not ESX.PlayerData.job then
		return false
	end

	for k,v in ipairs(Jobs) do
		if v == ESX.PlayerData.job.name then
			return true
		end
	end

	return false
end

