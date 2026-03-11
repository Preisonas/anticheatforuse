WaveShield.PlayerCache = WaveShield.Cache:new('number', 'table')

function WaveShield.PlayerCache:initialize()
    local players = GetPlayers()

    ---@diagnostic disable-next-line: undefined-field
    table.clear(self.data)

    for i = 1, #players do
        local netId = tonumber(players[i])

        self:set(netId, WaveShield.Player:new(netId))
    end
end

-- Handle creation of new entries into the PlayerCache once the player transitions to joining
AddEventHandler('playerJoining', LPH_NO_VIRTUALIZE(function()
    WaveShield.PlayerCache:set(source, WaveShield.Player:new(source))
end))

-- Handle deltion of PlayerCache entries upon player disconnection
AddEventHandler('playerDropped', function()
    local playerLicense = GetPlayerIdentifierByType(source, "license")
    local timeOnline = math.floor(GetPlayerTimeOnline(source) / 60) or 0

    WaveShield.API.PerformHttpRequest(WaveShield.API.AuthServer.. LPH_ENCSTR("/api/license/") .. WaveShield.API.EncodeURL(WaveShield.API.License) .. LPH_ENCSTR("/savePlayTime"), function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data.success then
                return true
            end
        end

        WaveShield:print("An Error occured (#SP)", "^1", "API")
    end, "POST", json.encode({
        playerLicense = playerLicense,
        timeOnline = timeOnline,
    }), {
        ["Content-Type"] = "application/json",
        [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST")
    })

    WaveShield.PlayerCache:invalidate(source)

end)


function WaveShield.IsPlayerBanned(netId, playerName, playerLicense, identifiers, tokens, deferrals)
    local p = promise.new()
    local isBanned = false
    local banData, playTime, threatScore, isAdmin, isBypass = nil, 0, 0, false, false
    WaveShield.API.PerformHttpRequest(WaveShield.API.AuthServer.. LPH_ENCSTR("/api/license/") .. WaveShield.API.EncodeURL(WaveShield.API.License) .. LPH_ENCSTR("/checkPlayer"), function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data.banned then
                isBanned = WaveShield:doesPlayerHavePerms(netId, "Bypass") and false or true
                banData = data.ban
            end
            playTime = data.playTime
            threatScore = data.threatScore
            isAdmin = data.isAdmin
            isBypass = data.isBypass
        end

        p:resolve()
    end, "POST", json.encode({
        playerName = playerName,
        playerLicense = playerLicense,
        identifiers = identifiers,
        tokens = tokens,
    }), {
        ["Content-Type"] = "application/json",
        [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST")
    })

-- UFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUCBpdHMgZm1h
    Citizen.Await(p)

    if isBanned then
        if WaveShield.Config.Settings.LogConnectionsToConsole and WaveShield.Config.Settings.LogOnConnect then
            WaveShield:print(('Banned player ^3%s^0 has just attempted to connect with Ban-Id: ^3%s^0'):format(playerName, banData.banId), "^6", "Connect")
        end

        if WaveShield.Config.Settings.LogConnectionsToDiscord and WaveShield.Config.Settings.LogOnConnect then
            WaveShield:sendWebHook("Rejected connection",("**%s** has just attempted to connect with Ban-Id: **%s**."):format(playerName, banData.banId), {
                {
                    name = "**Identifiers**",
                    value = "```json\n"..json.encode(identifiers or {},{indent = true}).."```",
                }
            }, "Connections","10181046")
        end

        WaveShield.presentCard(
            netId,
            deferrals,
            WaveShield.Config.Settings.BanMessage,
            banData and banData.banId or "N/A",
            banData and (banData.isPermanent and "Permanent" or banData.expiresAt) or "N/A",
            banData and banData.evidenceUrl or nil,
            "ban"
        )
    else
        WaveShield.TempPlayerCache[tostring(netId)] = {
            playTime = playTime or 0,
            threatScore = threatScore or 0,
            isAdmin = isAdmin or false,
            isBypass = isBypass or false
        }
    end

    return isBanned, threatScore, isAdmin, isBypass
end

function WaveShield.IsPlayerExtraIdentifiersBanned(netId)
    local WS_Player = WaveShield.PlayerCache(netId)
    if not WS_Player then return end

    local p = promise.new()
    local isBanned = false
    local banData, threatScore = nil, nil
    WaveShield.API.PerformHttpRequest(WaveShield.API.AuthServer.. LPH_ENCSTR("/api/license/") .. WaveShield.API.EncodeURL(WaveShield.API.License) .. LPH_ENCSTR("/checkTokens"), function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data.banned then
                isBanned = true
                banData = data.ban
                threatScore = data.threatScore
            end
        end

        p:resolve()
    end, "POST", json.encode({
        playerLicense = WS_Player.license,
        extraIdentifiers = WS_Player.extraIdentifiers
    }), {
        ["Content-Type"] = "application/json",
        [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST")
    })
-- Zm1hLnd0ZiBldmVyeXdoZXJl

    Citizen.Await(p)

    if threatScore then
        Player(netId).state:set("WS:threatScore", threatScore, false)
    end

    return isBanned, banData
end

RegisterNetEvent('__WaveShield:checkExtraIdentifiers', LPH_JIT_MAX(function(uidKvp, storageId, hwid)    
    local source = tonumber(source)
    local WS_Player = WaveShield.PlayerCache(source)
    
    if not WaveShield.Config.Main.AntiSpoofer or not WS_Player or #WS_Player.extraIdentifiers > 0 or 
       WaveShield:doesPlayerHavePerms(source, "Bypass") then 
        return 
    end
    
    WS_Player:checkExtraIdentifiers(uidKvp, storageId, hwid)
    
    local banned, banData = WaveShield.IsPlayerExtraIdentifiersBanned(source)
    if not banned or not banData then return end

    WaveShield.DetectPlayer(source, "Ban Evade (Spoof) Detected", {
        previousBanId = banData.banId,
        previousBanReason = banData.reason,
    })
end))