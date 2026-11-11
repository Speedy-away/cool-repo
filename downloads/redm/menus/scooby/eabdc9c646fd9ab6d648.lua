CreateThread(function()
    local powerUp = 100 -- Amount to boost health and stamina
    local playerPed = PlayerPedId()
    local horsePed = GetMount(playerPed)

    if horsePed and horsePed ~= 0 and DoesEntityExist(horsePed) then
        if IsPedOnMount(playerPed) then
            if IsPedSwimming(horsePed) then
                print("Bro, you are swimming, first get out of the water.")
                return
            end

            Citizen.InvokeNative(0xCD181A959CFDD7F4, playerPed, horsePed, -1355254781, GetHashKey("p_cs_syringe01x"), 0)

            local valHP = Citizen.InvokeNative(0x36731AC041289BB1, horsePed, 0)
            local valST = Citizen.InvokeNative(0x36731AC041289BB1, horsePed, 1)

            if not tonumber(valHP) then
                valHP = 0
            end
            if not tonumber(valST) then
                valST = 0
            end

            Citizen.InvokeNative(0xC6258F41D86676E0, horsePed, 0, valHP + powerUp)
            Citizen.InvokeNative(0xC6258F41D86676E0, horsePed, 1, valST + powerUp)
            Citizen.Wait(250)
            Citizen.InvokeNative(0x4AF5A4C7B9157D14, horsePed, 0, (10 * powerUp) + 0.0)
            Citizen.InvokeNative(0x4AF5A4C7B9157D14, horsePed, 1, (10 * powerUp) + 0.0)
            Citizen.InvokeNative(0xF6A7C08DF2E28B28, horsePed, 0, (10 * powerUp) + 0.0)
            Citizen.InvokeNative(0xF6A7C08DF2E28B28, horsePed, 1, (10 * powerUp) + 0.0)
            Citizen.InvokeNative(0xD4EE21B7CC7FD350, horsePed, true)
            Citizen.InvokeNative(0x50C803A4CD5932C5, horsePed, true)
        else 
            print("Your stupid ass is not on a Horse")
        end
    else
        print("Thats not a Horse")
    end
end)