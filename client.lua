local lastSpeed = 0
local crashCooldown = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)

        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local veh = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(veh, -1) == ped then
                local speed = GetEntitySpeed(veh) * 3.6 

                if (lastSpeed - speed) > 40 and speed < lastSpeed and not crashCooldown then
                    TriggerEvent('bigCrashEffect')
                    crashCooldown = true
                    Citizen.SetTimeout(5000, function()
                        crashCooldown = false
                    end)
                end

                lastSpeed = speed
            end
        else
            lastSpeed = 0
        end
    end
end)

RegisterNetEvent('bigCrashEffect')
AddEventHandler('bigCrashEffect', function()
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 1.0)
    PlaySoundFrontend(-1, "Crash", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)
    local startTime = GetGameTimer()
    while GetGameTimer() - startTime < 3000 do
        Citizen.Wait(0)
        DrawRect(0.5, 0.5, 1.0, 1.0, 255, 0, 0, 60)
    end
end)
