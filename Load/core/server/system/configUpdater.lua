local blockedNetGameEvents = {
    [3002107268] = "NETWORK_GIVE_PICKUP_REWARDS_EVENT",
    [1537535389] = "PLAYER_TAUNT_EVENT",
    [2639765290] = "NETWORK_PLAY_AIRDEFENSE_FIRE_EVENT",
    [1992295566] = "BLOCK_WEAPON_SELECTION",
    [2654380799] = "NETWORK_SPECIAL_FIRE_EQUIPPED_WEAPON",
    [1167173304] = "GIVE_PICKUP_REWARDS_EVENT",
    [935852904] = "RAGDOLL_REQUEST_EVENT",
}

RegisterNetEvent("__WaveShield_internal:configUpdated",function()
    if type(source) == "number" then DropPlayer(source, "Sync error") end

-- V1dXV1dXV1dXV1dXV1dXV1cgZm1h
    WaveShield.Config.Weapons.WhiteListedProjectiles = WaveShield:transformTableValuesInHashKeys(WaveShield.Config.Weapons.WhiteListedProjectiles)

    WaveShield.Config.Explosions.BlackListedExplosions = WaveShield:transformTableValuesInKeys(WaveShield.Config.Explosions.BlackListedExplosions)

    WaveShield.Config.Explosions.WhiteListedParticles = WaveShield:transformTableValuesInHashKeys(WaveShield.Config.Explosions.WhiteListedParticles)
    WaveShield.Config.Explosions.WhiteListedParticles = WaveShield:runAutoWhiteList(WaveShield.Config.Explosions.WhiteListedParticles,"Particles")

    WaveShield.Config.Entities.WhiteListedPeds = WaveShield:transformTableValuesInHashKeys(WaveShield.Config.Entities.WhiteListedPeds)
    WaveShield.Config.Entities.WhiteListedPeds = WaveShield:runAutoWhiteList(WaveShield.Config.Entities.WhiteListedPeds,"Peds")

    WaveShield.Config.Entities.WhiteListedVehicles = WaveShield:transformTableValuesInHashKeys(WaveShield.Config.Entities.WhiteListedVehicles)
    WaveShield.Config.Entities.WhiteListedVehicles = WaveShield:runAutoWhiteList(WaveShield.Config.Entities.WhiteListedVehicles,"Vehicles")

    WaveShield.Config.Entities.BlackListedVehicles = WaveShield:transformTableValuesInHashKeys(WaveShield.Config.Entities.BlackListedVehicles)
    WaveShield.Config.Entities.BlackListedPeds = WaveShield:transformTableValuesInHashKeys(WaveShield.Config.Entities.BlackListedPeds)

    WaveShield.Config.Entities.WhiteListedObjects = WaveShield:transformTableValuesInHashKeys(WaveShield.Config.Entities.WhiteListedObjects)
    WaveShield.Config.Entities.WhiteListedObjects = WaveShield:runAutoWhiteList(WaveShield.Config.Entities.WhiteListedObjects,"Props")

    WaveShield.Config.Entities.PreBlackListedObjects = WaveShield:runAutoBlackList()
    WaveShield.Config.Entities.BlackListedObjects = WaveShield:transformTableValuesInHashKeys(WaveShield.Config.Entities.BlackListedObjects)

    SetConvar("sv_filterRequestControl", "4")
    SetConvar("sv_enableNetworkedPhoneExplosions", "false")
    SetConvar("sv_enableNetworkedSounds", "false")
    SetConvar("sv_enableNetworkedScriptEntityStates", "false")
    SetConvarReplicated("game_sanitizeRagdollEvents", "true")
    -- SetConvarReplicated("sv_protectServerEntities", "true")

    SetConvar("sv_experimentalNetGameEventHandler", "true")

    local allowedCommand = IsPrincipalAceAllowed("resource.WaveShield", "command")
    if allowedCommand then
        local version = WaveShield:GetFXVersion()
        if version and version >= 16276 then
            for eventHash, eventName in pairs(blockedNetGameEvents) do
                ExecuteCommand("block_net_game_event " .. tostring(version >= 16563 and eventName or eventHash))
            end
        end
    end
end)

function WaveShield:ReloadConfiguration()
    WaveShield.API.GetServerConfig()
    --TriggerClientEvent("__WaveShield_internal:configUpdated", -1)
    WaveShield:print("Successfully reloaded the configuration.","^2","Config")
end

exports("ReloadConfiguration", function()
    local invoker = GetInvokingResource()
    if invoker == "WaveShield" then
        WaveShield:ReloadConfiguration()
    end
end)