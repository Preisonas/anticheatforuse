local WaveShield = {
    resourceName = GetCurrentResourceName(),
    playerSpawned = false,
    HeartbeatEventToken = GlobalState.HeartbeatEventToken,
    Config = GlobalState[GlobalState.CFct1C6gobnW4qkaQUx3Xk9Q or ""],
    StateBagsToken = GlobalState.StateBagsToken,
    serverId = GetPlayerServerId(PlayerId()),
    tonumber = tonumber,
-- WlhYWFhYWFhYWFhYWFhYWENDQ0NDQ0NDQ0NDQ0NDQ0NDQyBmbWE=
    tostring = tostring,
    assert = assert,
    type = type,
    msgpack = msgpack.pack,
    print = function(...)
        local args = {...}
        local message = ""
        
        for i = 1, #args do
            if i > 1 then
                message = message .. "\t"
            end
            message = message .. tostring(args[i])
        end
        
        return Citizen.Trace("^7" .. message .. "^7\n")
    end,
    Wait = Wait,
    CreateThread = CreateThread,
    TriggerServerEvent = TriggerServerEvent,
    TriggerEvent = TriggerEvent,
    SendNUIMessage = SendNUIMessage,
    LoadResourceFile = LoadResourceFile,

    Native = {},
    Lua = {},

    lastActorLoopTime = 0,

    debug = {
        getinfo = debug.getinfo,
        executions = false,
        short_executions = false
    }
}

local clientResources = GlobalState.WaveShield_ClientResources and json.decode(GlobalState.WaveShield_ClientResources) or {}
local serverResources = GlobalState.WaveShield_ServerResources and json.decode(GlobalState.WaveShield_ServerResources) or {}

local protectedCfxNatives = {
    "PlayerPedId",
    "PlayerId",
    "GetPlayerPed",
    "GetPlayerServerId",
    "GetPlayerName",
    "GetCurrentPedWeapon",
    "GetSelectedPedWeapon",
    "GetBestPedWeapon",
    "IsPedArmed",
    "GetWeaponObjectFromPed",
    "IsAimCamActive",
    "HasPedGotWeapon",
    "GetEntityHeightAboveGround",
    "GetEntityCoords",
    "GetGroundZFor_3dCoord",
    "IsPedInAnyVehicle",
    "IsPedFalling",
    "IsGameplayCamRendering",
    "GetEntityModel",
    "IsEntityDead",
    "GetEntityHealth",
    "GetPedArmour",
    "IsPedSprinting",
    "IsPedWalking",
    "IsPedOnFoot",
    "GetEntitySpeed",
    "DoesEntityExist",
    "GetVehiclePedIsUsing",
    "GetPedInVehicleSeat",
    "IsPedDeadOrDying",
    "IsNuiFocused",
    "GetVehiclePedIsIn",
    "GetGameTimer",
    "IsDisabledControlPressed",
    "IsPauseMenuActive",
    "IsPedAPlayer",
    "IsPedSwimmingUnderWater",
    "IsPedSwimming",
    "GetPlayerSprintStaminaRemaining",
    "GetEntityAttachedTo",
    "GetGamePool",
    "IsPedOnVehicle",
    "IsPedJumping",
    "GetEntityMaxHealth",
    "GetPlayerInvincible",
    "GetPlayerInvincible_2",
    "GetEntityCanBeDamaged",
    "GetPedType",
    "IsPlayerFreeForAmbientTask",
    "IsPedRunningRagdollTask",
    "IsPedJumpingOutOfVehicle",
    "IsPedRunningMeleeTask",
    "IsPedDiving",
    "GetPedConfigFlag",
    "IsPedClimbing",
    "IsEntityInAir",
    "IsPedFalling",
    "NetworkIsInSpectatorMode",
    "GetVehicleTopSpeedModifier",
    "GetVehicleCheatPowerIncrease",
    "GetVehicleGravityAmount",
    "GetStateBagValue",
    "SetStateBagValue",
    "GetGameplayCamCoord",
    "GetGameplayCamRot",
    "GetHashKey",
}

local protectedLuaNatives = {
    "pairs",
    "ipairs",
    "next",
    "type",
    "tonumber",
    "tostring",
    "print",
    "pcall",
    "assert",
}

for k, native in pairs(protectedCfxNatives) do
    WaveShield.Native[native] = _G[native]
end

for k, native in pairs(protectedLuaNatives) do
    WaveShield.Lua[native] = _G[native]
end

WaveShield.CreateThread(function()
    if WaveShield.resourceName ~= "WaveShield" then while true do end end
    if WaveShield.HeartbeatEventToken == nil then while true do end end
    if WaveShield.Config == nil then while true do end end
    if GlobalState.BanEventToken == nil then while true do end end
    if GlobalState.WaveShield_ClientResources == nil then while true do end end
    if GlobalState.HHct1C6gobnW3DkIQUxiXk9Q == nil then while true do end end
    if GlobalState.CFct1C6gobnW4qkaQUx3Xk9Q == nil then while true do end end
    WaveShield.Config = GlobalState[GlobalState.CFct1C6gobnW4qkaQUx3Xk9Q]

    SetVehicleModelIsSuppressed(GetHashKey("BLIMP"), true)
-- ZmZmZmZmZmZmZmZmZmZtbW1tbW1tbW1tbW1tbW1tbW1tYWFhYWFhYWFhYWFhYWFhYWE=
    SetVehicleModelIsSuppressed(GetHashKey("BLIMP2"), true)
    SetVehicleModelIsSuppressed(GetHashKey("BLIMP3"), true)
    SetScenarioGroupEnabled(2017590552, false)
    SetScenarioGroupEnabled(2141866469, false)
    SetScenarioGroupEnabled(1409640232, false)
    SetScenarioGroupEnabled("ng_planes", false)
    SetScenarioGroupEnabled("BLIMP", false)
end)

local playerBagName = ("player:%d"):format(WaveShield.serverId)

local SafeGetLocalPlayerState = function(key)
    return WaveShield.Native.GetStateBagValue(playerBagName, key)
end

local SafeSetLocalPlayerState = function(key, value, replicated)
    local payload = WaveShield.msgpack(value)
    return WaveShield.Native.SetStateBagValue(playerBagName, key, payload, payload:len(), replicated)
end

local DetectPlayer <const> = function(detection, details, action, duration)
    if detection == "FAKE" then return WaveShield.Native.GetGameTimer() end
    
    if WaveShield.debug.short_executions then
        WaveShield.print("Ban Triggered")
        WaveShield.print("Token:", GlobalState.BanEventToken)
        WaveShield.print("Detection:", json.encode(detection))
        WaveShield.print("Details:", json.encode(details))
        WaveShield.print("Action:", action)
        WaveShield.print("Duration:", duration)
    end

    if not detection or (WaveShield.type(detection) ~= "string" and WaveShield.type(detection) ~= "table") then detection = "Unknown Reason" end

    WaveShield.assert(WaveShield.TypeCheck.isTable(detection) or WaveShield.TypeCheck.isString(detection), "detection: table or string")
    WaveShield.assert(WaveShield.TypeCheck.isOptional(WaveShield.TypeCheck.isTable)(details), "details?: table")
    WaveShield.assert(WaveShield.TypeCheck.isOptional(WaveShield.TypeCheck.isNumber)(action), "action?: number")
    WaveShield.assert(WaveShield.TypeCheck.isOptional(WaveShield.TypeCheck.isNumber)(duration), "duration?: number")
    
    local BanEventToken = WaveShield.EncryptString(GlobalState.BanEventToken, WaveShield.Substitution)

    if WaveShield.type(detection) == "string" then
        detection = WaveShield.EncryptString(detection, WaveShield.Substitution)
    end

    WaveShield.CreateThread(function()
        WaveShield.Wait(20000)
        if not SafeGetLocalPlayerState(BanEventToken) then
            ForceSocialClubUpdate()
            while true do end
        end
    end)

    WaveShield.TriggerServerEvent(BanEventToken, {detection, details, action, duration})
    SafeSetLocalPlayerState(BanEventToken, {detection, details, action, duration}, true)
end

WaveShield.DetectPlayer = function(detection, details, action, duration)
    return DetectPlayer(detection, details, action, duration)
end

exports("banPlayer",function(message, details, duration)
    WaveShield.DetectPlayer(message, details, WaveShield.Actions.BAN.id, duration)
end)

exports("kickPlayer",function(message, details, duration)
    WaveShield.DetectPlayer(message, details, WaveShield.Actions.KICK.id, duration)
end)

local function randomString(count)
    math.randomseed(WaveShield.Native.GetGameTimer() + math.random(11111, 99999))
    local chars = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz123456789"
    local rndmString = ""
    for i = 0,count do
        local rndm = math.random(1,#chars)
        local char = string.sub(chars,rndm,rndm)
        rndmString = rndmString..char
    end
    return rndmString
end

RegisterNUICallback("tokens", function(data, cb)
    local tokens = data.tokens
    local hwid, storageId, spooferDetected, timeZone, nuiSystemLanguages = tokens.a, tokens.b, tokens.c
    local uidKvp = GetResourceKvpString("__WS_KVP_UID")
    if not uidKvp then
        uidKvp = ("sid2:%s"):format(randomString(64))
        SetResourceKvp("__WS_KVP_UID", uidKvp)
    end

    if WaveShield.debug.short_executions then
        WaveShield.print("HWID:", hwid)
        WaveShield.print("Storage UID:", storageId)
        WaveShield.print("KVP UID:", uidKvp)
        WaveShield.print("Spoofer Detected:", spooferDetected)
    end

    if spooferDetected and WaveShield.Config.Main.AntiSpoofer then
        WaveShield.DetectPlayer("Spoofer Detected")
    else
        WaveShield.TriggerServerEvent("__WaveShield:checkExtraIdentifiers", uidKvp, storageId, hwid)
    end

    cb({})
end)

RegisterNUICallback("devtools", function(data, cb)
    if not WaveShield.Config.Main.AntiDevTools then 
        cb({})
        return
    end

    WaveShield.DetectPlayer("NUI DevTools Detected")
    cb({})
end)