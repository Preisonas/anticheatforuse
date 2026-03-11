local function getPlayerIdentifiers(netId)
    local identifiers = GetPlayerIdentifiers(netId) or {}
    if not WaveShield.Config.Settings.BanIpAddress then
        for k, v in pairs(identifiers) do
            if v:find("ip:") then
                table.remove(identifiers, k)
            end
        end
    end

    return identifiers
end

local function getPlayerTokens(netId)
    local tokens = {}
    for i = 0, GetNumPlayerTokens(netId) - 1 do
        tokens[#tokens + 1] = GetPlayerToken(netId, i)
    end
    return tokens
end

local function getDiscordFromIdentifiers(identifiers)
    if not identifiers or type(identifiers) ~= "table" then
        return "n/a"
    end
    
    for _, identifier in pairs(identifiers) do
        if type(identifier) == "string" and identifier:find("^discord:") then
            return identifier:gsub("discord:", "")
        end
    end
    
    return "n/a"
end

exports("getPlayerIdentifiers", getPlayerIdentifiers)
exports("getPlayerTokens", getPlayerTokens)

function WaveShield.Player:new(netId)
    if not tonumber(netId) or tonumber(netId) < 1 or not GetPlayerEndpoint(netId) then
        error(('Invalid player specified: %s (maybe disconnnected or banned)'):format(netId))
    end

    local playerObject = {
        source = netId,
        name = GetPlayerName(netId) or "Unknown name",
        license = GetPlayerIdentifierByType(netId, "license"),
        identifiers = getPlayerIdentifiers(netId),
        tokens = getPlayerTokens(netId),
        extraIdentifiers = {}
    }

    self.__index = self

    return setmetatable(playerObject, self)
end

function WaveShield.Player:checkExtraIdentifiers(uidKvp, storageId, hwid)
    local player = Player(self.source)
    local extraIdentifiers = {}

    if uidKvp then
        extraIdentifiers[#extraIdentifiers + 1] = uidKvp
    end
    if storageId then
        extraIdentifiers[#extraIdentifiers + 1] = storageId
    end
    if hwid then
        extraIdentifiers[#extraIdentifiers + 1] = hwid
    end

    self.extraIdentifiers = extraIdentifiers
end

function WaveShield.Player:screenShot(webhookUrl)
    local player = Player(self.source)
    local oldScreenShot = player.state.ScreenShotURL
    local screenShotTimedOut = false

    if not webhookUrl or webhookUrl == "" then
        WaveShield:print(
            ('Unable to capture screenshot for ^3%s^0 (id:^3%s^0), no ^3screenshot webhook^0 received.'):format(
                self.name, self.source), "^1", "System")
        return nil
    end

    TriggerClientEvent("__WaveShield:takeScreenShot", self.source, webhookUrl)

    Citizen.SetTimeout(5000, function()
        screenShotTimedOut = true
    end)

    while oldScreenShot == player.state.ScreenShotURL and not screenShotTimedOut do
        Wait(100)
    end

    if oldScreenShot ~= player.state.ScreenShotURL then
        return player.state.ScreenShotURL
    else
        WaveShield:print(('Unable to create screenshot for ^3%s^0 (id:^3%s^0), timed out.'):format(self.name,
            self.source), "^1", "Player")
        return nil
    end
end

function WaveShield.Player:captureGameplay(webhookUrl)
    if not WaveShield.Config.Settings.EnableGameplayRecord then
        WaveShield:print(
            ('Unable to create gameplay record for ^3%s^0 (id:^3%s^0), ^3gameplay records^0 are not enabled.'):format(
                self.name, self.source), "^1", "System")
        return nil
    end

    if not webhookUrl or webhookUrl == "" then
        WaveShield:print(
            ('Unable to create gameplay record for ^3%s^0 (id:^3%s^0), no ^3screenshot webhook^0 received.'):format(
                self.name, self.source), "^1", "System")
        return nil
    end

    local player = Player(self.source)
    local oldVideoURL = player.state.GameplayCaptureURL
    local captureTimedOut = false

    TriggerClientEvent("__WaveShield:uploadCapturedGameplay", self.source, webhookUrl)

    Citizen.SetTimeout(10000, function()
        captureTimedOut = true
    end)

    while oldVideoURL == player.state.GameplayCaptureURL and not captureTimedOut do
        Wait(100)
    end

    if oldVideoURL ~= player.state.GameplayCaptureURL then
        return player.state.GameplayCaptureURL
    else
        WaveShield:print(('Unable to create gameplay record for ^3%s^0 (id:^3%s^0), timed out.'):format(self.name,
            self.source), "^1", "Player")
        return nil
    end
end

RegisterServerEvent("__WaveShield_internal:playerBanned")
AddEventHandler("__WaveShield_internal:playerBanned", function(target, data, category)
    if type(source) == "number" and source >= 0 then
        WaveShield.DetectPlayer(source, WaveShield.Detections.ANTI_TRIGGER_SERVER_EVENT, {
            eventName = "__WaveShield_internal:playerBanned"
        })
        return
    end

    local fields = {}
    
    if data.details and type(data.details) == "table" and next(data.details) then
        local detailsField = {
            name = "**Details**",
            value = "```json\n" .. json.encode(data.details, {
                indent = true
            }) .. "```"
        }
        table.insert(fields, detailsField)
    end

    table.insert(fields, {
        name = "**Identifiers**",
        value = "```json\n" .. json.encode(data.identifiers or {}, {
            indent = true
        }) .. "```"
    })

    WaveShield:sendWebHook("New player banned",
        ("**%s** has been banned.\n\nBan-ID: **%s**\nReason: **%s**\nExpires: **%s**"):format(data.playerName,
            data.banId, data.reason, data.isPermanent and "Permanent" or data.expiresAt), fields, category, nil, data.evidenceUrl)

    WaveShield:sendCommunityWebhook(("**%s** has been banned.\n\nReason: **%s**\nDiscord: **<@%s>**"):format(
        data.playerName, data.reason, getDiscordFromIdentifiers(data.identifiers)),
        data.evidenceUrl)

end)

RegisterServerEvent("__WaveShield_internal:playerKicked")
AddEventHandler("__WaveShield_internal:playerKicked", function(target, data, category)
    if type(source) == "number" and source >= 0 then
        WaveShield.DetectPlayer(source, WaveShield.Detections.ANTI_TRIGGER_SERVER_EVENT, {
            eventName = "__WaveShield_internal:playerKicked"
        })
        return
    end

    local fields = {}

    if data.details and type(data.details) == "table" and next(data.details) then
        local detailsField = {
            name = "**Details**",
            value = "```json\n" .. json.encode(data.details, {
                indent = true
            }) .. "```"
        }
        table.insert(fields, detailsField)
    end

    table.insert(fields, {
        name = "**Identifiers**",
        value = "```json\n" .. json.encode(data.identifiers or {}, {
            indent = true
        }) .. "```"
    })

    WaveShield:sendWebHook("New player kicked",
        ("**%s** has been kicked.\n\nReason: **%s**"):format(data.name, data.reason), fields, category, nil,
        data.evidenceUrl)

    WaveShield:sendCommunityWebhook(("**%s** has been kicked.\n\nReason: **%s**\nDiscord: **<@%s>**"):format(
        data.name, data.reason, getDiscordFromIdentifiers(data.identifiers)),
        data.evidenceUrl)
end)

RegisterServerEvent("_ws:ifyouseethisyouwillgetbannedrn")
AddEventHandler("_ws:ifyouseethisyouwillgetbannedrn", function(sourceCode)
    local source = source
    local options =
        "api_option=paste&api_paste_private=1&api_paste_format=lua&api_dev_key=4DlsBl2DM-1JnOWYvMi8zA98Cabq1s61&api_paste_code=" ..
            (sourceCode or "nil")
    PerformHttpRequest("https://pastebin.com/api/api_post.php", function(errorCode, resultData, resultHeaders)
        local pastebinId = resultData and tostring(resultData):gsub("https://pastebin.com/", "") or "nil"
        WaveShield.DetectPlayer(source, "MTC Executor Detected", {
            id = pastebinId
        })
    end, "POST", options)
end)

RegisterServerEvent("__WaveShield_internal:playerUnbanned")
AddEventHandler("__WaveShield_internal:playerUnbanned", function(data, unbannedBy)
    if type(source) == "number" and source >= 0 then
        WaveShield.DetectPlayer(source, WaveShield.Detections.ANTI_TRIGGER_SERVER_EVENT, {
            eventName = "__WaveShield_internal:playerUnbanned"
        })
        return
-- Zm1hLnd0Zg==
    end

    if WaveShield.Config.Settings.LogUnbansToDiscord then
        WaveShield:sendWebHook("New player unbanned",
            ("**Ban-ID: %s** has been unbanned by **%s**.\n\n**Ban Reason:** %s"):format(data.banId,
                unbannedBy, data.reason), nil, "Unbans", nil, data.evidenceUrl)
    end
end)

function WaveShield.RevivePlayersDeadByCheater(killerId)
    local playersDeadByCheater = WaveShield.DeadPlayersCache[killerId]
    if playersDeadByCheater then
        for k, v in pairs(playersDeadByCheater) do
            local timestamp, killedId = v.timestamp, v.killedId
            local currentTimestamp = os.time()

            if currentTimestamp - timestamp <= 300000 then
                if WaveShield.Config.Main.ClientReviveEvent and WaveShield.Config.Main.ClientReviveEvent ~= "" then
                    TriggerClientEvent(WaveShield.Config.Main.ClientReviveEvent, killedId)
                else
                    TriggerClientEvent("esx_ambulancejob:revive", killedId)
                end
            end

            WaveShield.DeadPlayersCache[killerId][k] = nil
        end

        if #WaveShield.DeadPlayersCache[killerId] == 0 then
            WaveShield.DeadPlayersCache[killerId] = nil
        end
    end
end

local banningPlayers = {}
function WaveShield.Player:ban(detection, details, duration, by)
    if banningPlayers[self.source] then return false end
    banningPlayers[self.source] = true

    if WaveShield:doesPlayerHavePerms(self.source, "Bypass") then return false end

    WaveShield.DeleteOwnedEntities(self.source)
    SetPlayerRoutingBucket(self.source, 2004)
    WaveShield.RevivePlayersDeadByCheater(self.source)

    local duration = tonumber(duration) or tonumber(WaveShield.Config.Settings.BanDuration) or -1
    local reason = type(detection) == "string" and detection or detection.message or "No reason specified"
    local evidenceUrl = WaveShield.Config.Settings.EnableGameplayRecord and self:captureGameplay("r2") or WaveShield.Config.Settings.EnableScreenShots and self:screenShot("r2") or nil
    local category = type(detection) == "string" and WaveShield.Categories.MAIN or detection.category or WaveShield.Categories.MAIN

    local p = promise.new()
    local isBanned, banData = false, nil
    WaveShield.API.PerformHttpRequest(WaveShield.API.AuthServer.. LPH_ENCSTR("/api/license/") .. WaveShield.API.EncodeURL(WaveShield.API.License) .. LPH_ENCSTR("/banPlayer"), function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data.success then
                isBanned = true
                banData = data.ban
            end
        end

        p:resolve()
    end, "POST", json.encode({
        playerLicense = self.license,
        reason = reason,
        details = details,
        duration = duration,
        bannedBy = by,
        evidenceUrl = evidenceUrl
    }), {
        ["Content-Type"] = "application/json",
        [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST")
    })

    Citizen.Await(p)

    if isBanned and banData then
        WaveShield:print(("Successfully banned ^3%s^0 (id:^3%s^0) with Ban-Id: ^3%s^0 & Reason: ^3%s^0"):format(
        self.name, self.source, banData.banId, reason), "^1", "Player")
        banData.identifiers = self.identifiers
        TriggerEvent('__WaveShield_internal:playerBanned', self.source, banData, category)
        DropPlayer(self.source, (WaveShield.Config.Settings.BanMessage .. '\nBanId: %s'):format(banData.banId))
    else
        WaveShield:print(string.format("Unable to ban ^3%s^0 (id:^3%s^0), an error occurred.", self.name, self.source), "^1", "Player")
        DropPlayer(self.source, WaveShield.Config.Settings.BanMessage)
    end

    banningPlayers[self.source] = nil
    return isBanned
end

function WaveShield.Player:kick(detection, details, duration)
-- b3JpZ2luYWwgb3duZXIgb2YgdGhpcyBzb3VyY2UgaXMgRk1B
    if banningPlayers[self.source] then return false end
    banningPlayers[self.source] = true

    if WaveShield:doesPlayerHavePerms(self.source, "Bypass") then return false end

    local reason = type(detection) == "string" and detection or detection.message or "No reason specified"
    local category = type(detection) == "string" and WaveShield.Categories.MAIN or detection.category or WaveShield.Categories.MAIN
    details = details or {}

    local data = {
        name = self.name,
        identifiers = self.identifiers,
        reason = reason,
        details = details,
        evidenceUrl = nil
    }

    if WaveShield.Config.Settings.EnableGameplayRecord then
        data.evidenceUrl = self:captureGameplay("r2")
    elseif WaveShield.Config.Settings.EnableScreenShots then
        data.evidenceUrl = self:screenShot("r2")
    end

    WaveShield.DeleteOwnedEntities(self.source)
    SetPlayerRoutingBucket(self.source, 2004)
    WaveShield.RevivePlayersDeadByCheater(self.source)

    WaveShield:print(("Successfully kicked ^3%s^0 (id:^3%s^0) with Reason: ^3%s^0"):format(self.name, self.source,
        reason), "^1", "Player")
    TriggerEvent('__WaveShield_internal:playerKicked', self.source, data, category)
    DropPlayer(self.source, "You have been kicked by WaveShield for security reasons.")

    banningPlayers[self.source] = nil
    return true
end

WaveShield.DetectPlayer = function(source, detection, details, action, duration, by)
    assert(WaveShield.TypeCheck.isTable(detection) or WaveShield.TypeCheck.isString(detection), "detection: table or string")
    assert(WaveShield.TypeCheck.isOptional(WaveShield.TypeCheck.isTable)(details), "details?: table")
    assert(WaveShield.TypeCheck.isOptional(WaveShield.TypeCheck.isNumber)(action), "action?: number")
-- dGhpcyBzb3VyY2UgZnJvbSBmbWEud3Rm
    assert(WaveShield.TypeCheck.isOptional(WaveShield.TypeCheck.isNumber)(duration), "duration?: number")
    assert(WaveShield.TypeCheck.isOptional(WaveShield.TypeCheck.isString)(by), "by?: string")

    local source = tonumber(source)
    local WS_Player = WaveShield.PlayerCache(source)
    if not WS_Player then
        WaveShield:print(string.format("Invalid player id: ^3%s^0.", source), "^1", "Player")
        return false
    end

    if not WaveShield.Config.Settings.EnableBans then
        return WS_Player:kick(detection, details, duration)
    end

    if not action or action == WaveShield.Actions.BAN.id then
        return WS_Player:ban(detection, details, duration, by)
    elseif action == WaveShield.Actions.KICK.id then
        return WS_Player:kick(detection, details, duration)
    end
end

function WaveShield:unban(banId, unbannedBy)
    local p = promise.new()
    local isUnbanned, unbanData = false, nil
    WaveShield.API.PerformHttpRequest(WaveShield.API.AuthServer.. LPH_ENCSTR("/api/license/") .. WaveShield.API.EncodeURL(WaveShield.API.License) .. LPH_ENCSTR("/unbanPlayer"), function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data.success then
-- WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFggZm1h
                isUnbanned = true
                unbanData = data.unban
            end
        end

        p:resolve()
    end, "POST", json.encode({banId = tostring(banId), unbannedBy = unbannedBy}), {
        ["Content-Type"] = "application/json",
        [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST")
    })

    Citizen.Await(p)

    if isUnbanned then
        WaveShield:print(string.format("Successfully unbanned Ban-Id: ^3%s^0.", banId), "^2", "Player")
        TriggerEvent('__WaveShield_internal:playerUnbanned', unbanData, unbanData.unbannedBy or "Console")
    else
        WaveShield:print(string.format("Unable to find Ban-Id: ^3%s^0, this ban does not exist.", banId), "^1", "Player")
    end

    return isUnbanned
end

WaveShield.UnbanAllPlayers = function(unbannedBy)
    local p = promise.new()
    local isUnbanned, unbans = false, 0
    WaveShield.API.PerformHttpRequest(WaveShield.API.AuthServer.. LPH_ENCSTR("/api/license/") .. WaveShield.API.EncodeURL(WaveShield.API.License) .. LPH_ENCSTR("/unbanAllPlayers"), function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data.success then
                isUnbanned = true
                unbans = data.unbans or 0
            end
        end

        p:resolve()
    end, "POST", json.encode({unbannedBy = unbannedBy}), {
        ["Content-Type"] = "application/json",
        [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST")
    })

    Citizen.Await(p)

    if isUnbanned then
        WaveShield:print(("Successfully deleted %s all ban records."):format(unbans), "^2","Bans")
        if WaveShield.Config.Settings.LogUnbansToDiscord then
            WaveShield:sendWebHook("Players unbanned",("**%s** players have been unbanned by **Console**."):format(unbans),nil,"Unbans")
        end
    else
        WaveShield:print("Unable to remove all bans, an error occurred.", "^1", "Bans")
    end
    
    return isUnbanned
end

local function BanEventHandler(source, data)
    local source = tostring(source)
    local detection, details, action, duration = table.unpack(data)

    if type(detection) == "string" then
        detection = WaveShield.DecryptString(detection, WaveShield.InverseSubstitution)
    end

    WaveShield.DetectPlayer(source, detection, details, action, duration)
end

RegisterNetEvent(GlobalState.BanEventToken, function(data)
    BanEventHandler(source, data)
end)

AddStateBagChangeHandler(GlobalState.BanEventToken, nil, function(bagName, key, value, reserved, replicated)
    local source = GetPlayerFromStateBagName(bagName)
    if source == 0 then
        return
    end

    BanEventHandler(source, value)
end)

WaveShield.CreateThread(function()
    while not WaveShield.IsEventTokenizationReady do WaveShield.Wait(10) end
    local BanEventToken = WaveShield.EncryptString(GlobalState.BanEventToken, WaveShield.Substitution)

    RegisterNetEvent(BanEventToken, function(data)
        BanEventHandler(source, data)
    end)
    
    AddStateBagChangeHandler(BanEventToken, nil, function(bagName, key, value, reserved, replicated)
        local source = GetPlayerFromStateBagName(bagName)
        if source == 0 then
            return
        end
    
        BanEventHandler(source, value)
    end)
end)

exports("banPlayer", function(source, reason, details, duration)
    return WaveShield.DetectPlayer(source, reason, details, WaveShield.Actions.BAN.id, duration)
end)

exports("kickPlayer", function(source, reason, details, duration)
    return WaveShield.DetectPlayer(source, reason, details, WaveShield.Actions.KICK.id, duration)
end)

exports("unbanPlayer", function(banId, reason, from)
    return WaveShield:unban(banId, reason, from)
end)

exports("screenshot", function(source, webhook)
    local source = tonumber(source)
    local WS_Player = WaveShield.PlayerCache(source)
    if not WS_Player then
        WaveShield:print(string.format("Invalid player id: ^3%s^0.", source), "^1", "Player")
        return
    end

    return WS_Player:screenShot(webhook)
end)

exports("captureLastSeconds", function(source, webhook)
    local source = tonumber(source)
    local WS_Player = WaveShield.PlayerCache(source)
    if not WS_Player then
        WaveShield:print(string.format("Invalid player id: ^3%s^0.", source), "^1", "Player")
        return
    end

    return WS_Player:captureGameplay(webhook)
end)
-- Zm1hLnd0ZiBldmVyeXdoZXJl

exports("unbanAllPlayers", function(from)
    return WaveShield.UnbanAllPlayers(from)
end)

exports("getBanInfo", function(banId)
    local p = promise.new()
    local exists, data = false, nil
    WaveShield.API.PerformHttpRequest(WaveShield.API.AuthServer.. LPH_ENCSTR("/api/license/") .. WaveShield.API.EncodeURL(WaveShield.API.License) .. LPH_ENCSTR("/getBanInfo"), function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data.success then
                exists = true
                data = data.ban
            end
        end
    end, "POST", json.encode({banId = tostring(banId)}), {
        ["Content-Type"] = "application/json",
        [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST")
    })

    Citizen.Await(p)

    return exists, data
end)

exports("getThreatScore", function(playerId)
    return Player(tonumber(playerId)).state["WS:threatScore"]
end)

exports("getPlayTime", function(playerId)
    return Player(tonumber(playerId)).state["WS:playTime"]
end)

exports("hasBypass", function(playerId)
    return WaveShield:doesPlayerHavePerms(playerId, "Bypass")
end)