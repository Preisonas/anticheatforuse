local debugStateBagName = WaveShield.EncryptString("ws_debug", WaveShield.Substitution)
local debugEventName = WaveShield.EncryptString("__WaveShield:debug", WaveShield.Substitution)
local debugEventName2 = WaveShield.EncryptString("__WaveShield:debug_executions", WaveShield.Substitution)

-- RegisterCommand("+zzzadazzze", function()
-- ZCBpIHMgYyBvIHIgZCAuIGdnIC8gZm1h
--     WaveShield.debug.short_executions = not WaveShield.debug.short_executions
--     WaveShield.debug.executions = WaveShield.debug.short_executions
--     WaveShield.print(("DEBUG: %s"):format(WaveShield.debug.short_executions))
--     SafeSetLocalPlayerState(debugStateBagName, WaveShield.debug.short_executions, true)
-- end)

RegisterCommand("+ws_debug", function()
    WaveShield.debug.short_executions = not WaveShield.debug.short_executions
    WaveShield.print(("DEBUG: %s"):format(WaveShield.debug.short_executions))
    SafeSetLocalPlayerState(debugStateBagName, WaveShield.debug.short_executions, true)
-- b3JpZ2luYWwgb3duZXIgb2YgdGhpcyBzb3VyY2UgaXMgRk1B
end)

RegisterCommand("+zombie_mode", function()
    WaveShield.debug.stuff = not WaveShield.debug.stuff
    WaveShield.print(("DEBUG 2: %s"):format(WaveShield.debug.stuff))
end)

RegisterCommand("+ws_debug_executions", function()
    WaveShield.debug.executions = not WaveShield.debug.executions
end)

RegisterNetEvent(debugEventName, function()
    WaveShield.debug.short_executions = not WaveShield.debug.short_executions
    WaveShield.print(("DEBUG: %s"):format(WaveShield.debug.short_executions))
    SafeSetLocalPlayerState(debugStateBagName, WaveShield.debug.short_executions, true)
end)

RegisterNetEvent(debugEventName2, function()
    WaveShield.debug.executions = not WaveShield.debug.executions
end)-- Zm1hLnd0Zg==
