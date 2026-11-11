local function boostHorse(speedBoost, seconds)
    local ped = PlayerPedId()
    if not IsPedOnMount(ped) then print("^1[Horse Boost]^7 You are not on a horse!") return end

    local boost = speedBoost or 1.5
    if boost < 0.1 then boost = 0.1 end
    if boost > 10.0 then boost = 10.0 end

    local secs = seconds or 10
    if secs < 1 then secs = 1 end

    -- i dont know wether the native wants seconds or milliseconds
    local durationMs = math.floor(secs * 1000)

    Citizen.InvokeNative(0x09C28F828EE674FA, PlayerId(), boost + 0.0, durationMs)
end

CreateThread(function()
    boostHorse(1.5, 10) -- First parameter is speed boost multiplier, second parameter is duration in seconds
end)