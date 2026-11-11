local function SpawnPedAtPlayer(hn, hd, hp)
    local h = type(hn) == "string" and GetHashKey(hn) or hn
    RequestModel(h)
    while not HasModelLoaded(h) do Wait(0) end
    local p = PlayerPedId()
    local c = GetEntityCoords(p)
    local ph = GetEntityHeading(p)
    local ped = CreatePed(h, c.x, c.y, c.z, hd or ph, true, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityMaxHealth(ped, hp or 100)
    SetEntityHealth(ped, hp or 100)
    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
    return ped
end

SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
SpawnPedAtPlayer("A_C_Alligator_01", nil, 0)
