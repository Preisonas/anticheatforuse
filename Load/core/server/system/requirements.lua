function WaveShield:checkIfFilesExist()
    local shouldStop = false
    local updateTimeInMs = 0

    for _,v in pairs(WaveShield:filesToCheck()) do
        local file = Citizen.InvokeNative(string.format("0x%x", 0x76A9EE1F),tostring(WaveShield.resourceName), v.localFilePath, Citizen.ReturnResultAnyway(), Citizen.ResultAsString())
        if (file == nil) or (file == "") then
            shouldStop = true

            if v.localFilePath:find("web/") then
                WaveShield:createDirectory("web")
            end

            local success,ms = false, 0
            while not success do
                success,ms = WaveShield:downloadFile(v.localFilePath,v.distantFileName)
                if not success then
                    WaveShield:print("Failed to download the ^1"..v.localFilePath.." ^0file, retrying...","^1","Version")
                else
                    updateTimeInMs = updateTimeInMs + ms
                end
                Wait(100)
            end
        end
    end

    if pcall(function() exports.WaveShield:js_loaded() end) then
        local fileDeleted = exports.WaveShield:DeleteFile("WaveShield", "resource/waveshield.lua")
        if fileDeleted then shouldStop = true end
    end

    if shouldStop then
        WaveShield:print("Missing file(s) successfully ^2downloaded^0 in ^3"..updateTimeInMs.."ms^0, please restart your server.","^2","Version")
        WaveShield:stopServer()
        return false
    else
        return true
    end
end

function WaveShield:GetFXVersion()
    local version = tonumber(string.match(string.lower(GetConvar('version')), 'v1.0.0.(%d+)'))
    return version
end

function WaveShield:checkVersion()
    local currentVersion = WaveShield.API.Version:gsub("-beta", "")
    if not WaveShield.API.LatestVersion or not currentVersion or (currentVersion ~= WaveShield.API.LatestVersion) then
        WaveShield.API.AntiCrack.BlackList("Version Bypass", json.encode({Current = WaveShield.API.Version, Latest = WaveShield.API.LatestVersion}))
        return false
    end

    local latestVersion = WaveShield.API.GetLatestVersion()
    if not latestVersion or latestVersion ~= currentVersion then return false end

    return true
end

function WaveShield:checkRequirements()
    local version = WaveShield:GetFXVersion()
    if version ~= nil and version < 14317 then
        WaveShield:print("You need newer artifacts to start WaveShield (^3+14317 recommanded^0). Current: ^3"..tostring(version).."^0.","^1","System")
        WaveShield:stopServer()
        return false
    end

    if version ~= nil and not pcall(function() exports.WaveShield:js_loaded() end) then
        WaveShield:print("You are running an invalid version of WaveShield, please download the latest version.","^1","System")
        WaveShield:stopServer()
        return false
    end

    if version ~= nil and version >= 16276 then
        local allowedCommand = IsPrincipalAceAllowed("resource.WaveShield", "command")
        if not allowedCommand then
            WaveShield:print("Add to your server.cfg: ^3add_ace resource.WaveShield command allow^0", "^1", "System")
            WaveShield:print("Add to your server.cfg: ^3add_ace resource.WaveShield command allow^0", "^1", "System")
            WaveShield:print("Add to your server.cfg: ^3add_ace resource.WaveShield command allow^0", "^1", "System")
            WaveShield:print("Add to your server.cfg: ^3add_ace resource.WaveShield command allow^0", "^1", "System")
            WaveShield:print("Add to your server.cfg: ^3add_ace resource.WaveShield command allow^0", "^1", "System")
            WaveShield:stopServer()
            return false
        end
    end

    local onesyncState = GetConvar('onesync', 'off')
    if onesyncState == "off" or onesyncState == "legacy" then
        WaveShield:print("You need to enable ^3OneSync Infinity^0 to start WaveShield.","^1","System")
        WaveShield:print("Use ^3set onesync on^0 in the command line or the server.cfg.","^1","System")
        WaveShield:stopServer()
        return false
    end

    local onesyncPopulationState = GetConvar('onesync_population', 'true')
    if onesyncPopulationState == "true" and WaveShield.Config.Entities.DisableNPCPopulation == true then
        WaveShield:print("You need to disable ^3OneSync Population^0 if you disable NPC Population in the config.","^1","System")
        WaveShield:print("Use ^3set onesync_population false^0 in the command line or the server.cfg.","^1","System")
-- V1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXVyBmbWEud3Rm
        WaveShield:stopServer()
        return false
-- dGhpcyBzb3VyY2UgZnJvbSBmbWEud3Rm
    end

    local lua54State = GetResourceMetadata("WaveShield", 'lua54', 0)
    if lua54State ~= "yes" then
        WaveShield:print("You need to enable ^3Lua54^0 to start WaveShield.","^1","System")
        WaveShield:print("Add ^3lua54 'yes'^0 to WaveShield's fxmanifest.lua.","^1","System")
        WaveShield:stopServer()
        return false
    end

    return true
end

function WaveShield:checkResourceName()
    if WaveShield.resourceName ~= "WaveShield" then
-- UFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUCBpdHMgZm1h
        WaveShield:print("The resource name of the anti-cheat must be '^1WaveShield^0'.","^1","System")
        return false
    end
    return true
end
