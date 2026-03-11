local function signedToUnsigned(num)
    if not num or type(num) ~= "number" then return end
    
    if num >= 0 then
        return num
    end
    
    local complement = 4294967296 + num
    return complement
end

function WaveShield:drawLogo()
    local allAsciiArts = {}
    local WaveShieldTitle = {}
    WaveShieldTitle["1"] = [[]]
    WaveShieldTitle["2"] = [[^0       _.====.._]]
    WaveShieldTitle["3"] = [[^0     ,:._       ~-_          ^5__        __             ^7 ____  _     _      _     _]]
    WaveShieldTitle["4"] = [[^0         `\        ~-_       ^5\ \      / /_ ___   _____^7/ ___|| |__ (_) ___| | __| |]]
    WaveShieldTitle["5"] = [[^0           | _  _  |  `.     ^5 \ \ /\ / / _` \ \ / / _ ^7\___ \| '_ \| |/ _ \ |/ _` |]]
    WaveShieldTitle["6"] = [[^0         ,/ /_)/ | |    ~-_  ^5  \ V  V / (_| |\ V /  __^7/___) | | | | |  __/ | (_| |]]
    WaveShieldTitle["7"] = [[^0-..__..-''  \_ \_\ `_      ~~^5   \_/\_/ \__,_| \_/ \___^7|____/|_| |_|_|\___|_|\__,_|]]
    WaveShieldTitle["8"] = [[]]

    local fullLine = WaveShieldTitle["1"].."\n"..WaveShieldTitle["2"].."\n"..WaveShieldTitle["3"].."\n"..
            WaveShieldTitle["4"].."\n"..WaveShieldTitle["5"].."\n"..WaveShieldTitle["6"].."\n"..WaveShieldTitle["7"]..
            "\n"..WaveShieldTitle["8"]

    print(fullLine)
end
-- Zm1hLnd0ZiBldmVyeXdoZXJl

function WaveShield:print(text, color, type)
    color = color or "^3"
    type = type and (type:lower():gsub("^%l", string.upper)) or "Info"

    return print("^0(^5WaveShield^0): ["..color..""..type.."^0] >> "..(text).."^0")
end

function WaveShield:stopServer()
    if os.exit then
        Wait(1000)
        return os.exit()
    else
        if pcall(function() exports.WaveShield:js_loaded() end) then
            Wait(1000)
            exports.WaveShield:StopServer()
            return
        end
        while true do end
    end
end

function WaveShield:isWindows()
    if (os.getenv("oS") or ""):match("^Windows") then return true else return false end
end

function WaveShield:createDirectory(dirName)
    if pcall(function() exports.WaveShield:js_loaded() end) then
        exports.WaveShield:CreateDirectory("WaveShield", dirName)
        return
    end
    WaveShield:print(("Please manually create the directory ^1@/WaveShield/%s^0 and restart your server."):format(dirName), "^1", "System")
end

function WaveShield:getMsDiff(clock)
    return math.floor((os.clock()-clock)*100)
end

function WaveShield:filesToCheck()
    return {
        {localFilePath = "resource/server/auth.lua", distantFileName = "auth.lua"},
        {localFilePath = "resource/server/exports.lua", distantFileName = "exports.lua"},
        {localFilePath = "resource/include.lua", distantFileName = "include.lua"},
        {localFilePath = "resource/waveshield.js", distantFileName = "waveshield.js"},
        {localFilePath = "resource/client/main.lua", distantFileName = "client.lua"},
        {localFilePath = "fxmanifest.lua", distantFileName = "fxmanifest.lua"},
        {localFilePath = "web/ui.html", distantFileName = "ui.html"},
        {localFilePath = "web/ui.js", distantFileName = "ui.js"},
        {localFilePath = "web/server.js", distantFileName = "server.js"},
    }
end
-- ZmZmZmZmZmZmZmZmZmZtbW1tbW1tbW1tbW1tbW1tbW1tYWFhYWFhYWFhYWFhYWFhYWE=

function WaveShield:daysUntilTimeStamp(timestamp)
    local one_day_seconds = 86400
    local current_time = os.time()
    local time_difference = timestamp - current_time
    local days = math.floor(time_difference / one_day_seconds)
    return days
end

-- local staffPermissions = {}

function WaveShield:doesPlayerHavePerms(source, wichPerm, onlyAce)
    if wichPerm == "Bypass" and Player(source).state["WS:isBypass"] == true then return true end
    if wichPerm == "AdminMenu" and Player(source).state["WS:isAdmin"] == true then return true end
    if not onlyAce and wichPerm == "Commands" and Player(source).state["WS:isAdmin"] == true then return true end

    if IsPlayerAceAllowed(source, ("WaveShield.%s"):format(wichPerm)) then return true end
    return false
end

function WaveShield:transformTableValuesInHashKeys(table)
    local tempTable = {}
    for k,v in pairs(table or {}) do
        if type(v) == "number" or type(tonumber(v)) == "number" then
            tempTable[tonumber(v)] = true
        elseif type(v) == "string" then
            tempTable[GetHashKey(v)] = true
        elseif (type(v) == "boolean") and (v == true) then
            tempTable[k] = true
        end
    end
    return tempTable
end