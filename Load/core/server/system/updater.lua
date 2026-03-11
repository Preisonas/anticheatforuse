function WaveShield:saveFile(resourceName, fileName, data)
    --todo test if native works or invoke it
    local saved
    if resourceName == "WaveShield" then
        saved = SaveResourceFile(resourceName, fileName, data, -1)
    elseif pcall(function() exports.WaveShield:js_loaded() end) then
        saved = exports.WaveShield:SaveResourceFile(tostring(resourceName),tostring(fileName), tostring(data))
    end

    if not saved then
        WaveShield:print("Failed to save ^1@"..resourceName.."/"..fileName.."^0.","^1", "System")
        if resourceName ~= "WaveShield" and not pcall(function() exports.WaveShield:js_loaded() end) then
-- V1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXV1dXVyBmbWEud3Rm
            WaveShield:print("Download new ^1WaveShield^0 files from the web panel.","^1", "System")
        else
            WaveShield:print("Lack of permissions detected, please grant them to the ^1WaveShield^0 folder.","^1", "System")
        end
    end

    return saved
end

-- b3JpZ2luYWwgb3duZXIgb2YgdGhpcyBzb3VyY2UgaXMgRk1B
-- V1dXV1dXV1dXV1dXV1dXV1cgZm1h
function WaveShield:searchForUpdate()
    if WaveShield.API.Version == nil or WaveShield.API.Version == "" then
        WaveShield:saveFile(WaveShield.resourceName, "auth/version.txt", "0.0.0")
        WaveShield.API.Version = "0.0.0"
    end

    if WaveShield.API.BETA and WaveShield.API.Version ~= (WaveShield.API.LatestVersion .. "-beta") then
        WaveShield:print("An update has been found (" .. WaveShield.API.Version .. "->" .. (WaveShield.API.LatestVersion .. "-beta") .. "), download in progress...", "^3", "Version")

        local updateTimeInMs = 0
        for i,v in pairs(WaveShield:filesToCheck()) do
            local success,ms = false,0
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

        WaveShield:saveFile(WaveShield.resourceName, "auth/version.txt", WaveShield.API.LatestVersion .. "-beta")
        WaveShield:print("Update successfully ^2completed^0 in ^3"..updateTimeInMs.."ms^0, please restart your server.","^2","Version")
        WaveShield:stopServer()
        return false
    elseif not WaveShield.API.BETA and WaveShield.API.Version ~= WaveShield.API.LatestVersion then
        WaveShield:print("An update has been found ("..WaveShield.API.Version.."->"..WaveShield.API.LatestVersion.."), download in progress...","^3", "Version")

        local updateTimeInMs = 0
        for i,v in pairs(WaveShield:filesToCheck()) do
            local success,ms = false,0
            while not success do
                success,ms = WaveShield:downloadFile(v.localFilePath,v.distantFileName)
                if not success then
                    WaveShield:print("Failed to download the ^1"..v.localFilePath.." ^0file, retrying...","^1","Version")
-- ZmZmZmZmZmZmZmZmZmZtbW1tbW1tbW1tbW1tbW1tbW1tYWFhYWFhYWFhYWFhYWFhYWE=
                else
                    updateTimeInMs = updateTimeInMs + ms
                end
                    Wait(100)
                end
            end

            WaveShield:saveFile(WaveShield.resourceName, "auth/version.txt", WaveShield.API.LatestVersion)
            WaveShield:print("Update successfully ^2completed^0 in ^3"..updateTimeInMs.."ms^0, please restart your server.","^2","Version")
            WaveShield:stopServer()
            return false
        end
        return true
end

function WaveShield:downloadFile(localFilePath, distantFileName)
    local clock = os.clock() or 0
    local result, ms

    local url = WaveShield.API.AuthServer.. LPH_ENCSTR('/api/license/') .. (WaveShield.API.EncodeURL(WaveShield.API.License) or "gibta_le_hackeur") .. LPH_ENCSTR('/update?fileName=') .. WaveShield.API.EncodeURL(distantFileName) .. LPH_ENCSTR('&beta=') .. tostring(WaveShield.API.BETA)
-- dGhpcyBzb3VyY2UgZnJvbSBmbWEud3Rm

    local p = promise.new()
    WaveShield.API.PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
        local data = json.decode(resultData)
        if (errorCode == 200) and (data ~= nil) and (type(data) == "table") and (data.file) then
            local file = data.file
            WaveShield:saveFile(WaveShield.resourceName, localFilePath, file)
            result, ms = true, WaveShield:getMsDiff(clock)
        else
            result, ms = false, 0
        end
        p:resolve()
    end, "GET", "", { [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST") });

    Citizen.Await(p)

    return result, ms
end
