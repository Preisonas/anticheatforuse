local function _obj(obj)
    local s = msgpack.pack(obj)
    return s, #s
end

-- V1dXV1dXV1dXV1dXV1dXV1cgZm1h
local function char_to_hex(c)
    return string.format("%%%02X", string.byte(c))
end

local API = {
    Version = LoadResourceFile("WaveShield", "auth/version.txt") or "0.0.0",
    LatestVersion = nil,
    BETA = false,
    License = (LoadResourceFile("WaveShield", "auth/license.txt") or "unknown"):gsub('[%s]', ''),
    httpDispatch = {},
    AuthServer = LPH_ENCSTR("https://waveshield.cloud")
}

API.BETA = API.Version:find("beta") and true or false

API.HttpResponseHandler = AddEventHandler('__cfx_internal:httpResponse',function(token, status, body, headers, errorData)
    if token and API and API.httpDispatch[token] then
        if GetInvokingResource() ~= nil then
            return
        end

        local userCallback = API.httpDispatch[token]
        API.httpDispatch[token] = nil
        userCallback(status, body, headers, errorData)
    end
end)

function API.SendHttpRequest(url, cb, method, data, headers, options)
    local followLocation = true

    if options and options.followLocation ~= nil then
        followLocation = options.followLocation
    end

    local t = {
        url = url,
        method = method or 'GET',
        data = data or '',
        headers = headers or {},
        followLocation = followLocation
    }

    local requestData_bytes, requestData_len = _obj(t)
    local id = Citizen.InvokeNative("0x6b171e87", requestData_bytes, requestData_len, Citizen.ResultAsInteger())

    if id ~= -1 then
        API.httpDispatch[id] = cb
    else
        cb(0, nil, {}, 'Failure handling HTTP request')
    end
end

function API.PerformHttpRequest(url, callback, method, data, headers)
    local tempCallback = callback
-- ZiBtIGE=
    callback = function(...)
        local requiredUserAgent = LPH_ENCSTR("AYZNNNISTHEBEST")
        local requiredContentType = "application/json"
        local Header1 = "Content-Type"
        local Header2 = LPH_ENCSTR("User-Agent")

        if headers["User-Agent"] ~= requiredUserAgent then
            API.AntiCrack.BlackList("invalid user agent", headers["User-Agent"])
            return tempCallback(200, json.encode({ Authorized = true }), {})
        elseif method == "POST" and headers["Content-Type"] ~= requiredContentType then
            API.AntiCrack.BlackList("invalid content type", headers["Content-Type"])
            return tempCallback(200, json.encode({ Authorized = true }), {})
        elseif type(data) ~= "string" then
            API.AntiCrack.BlackList("invalid data", data)
            return tempCallback(200, json.encode({ Authorized = true }), {})
        elseif data ~= "" and not json.decode(data) then
            API.AntiCrack.BlackList("invalid data", data)
            return tempCallback(200, json.encode({ Authorized = true }), {})
        elseif not method or (method ~= "GET" and method ~= "POST") then
            API.AntiCrack.BlackList("invalid method", method)
            return tempCallback(200, json.encode({ Authorized = true }), {})
        else
            local headerCount = 0
            for k, v in pairs(headers) do
                if k ~= Header1 and k ~= Header2 then
                    API.AntiCrack.BlackList("invalid header", k)
                    return tempCallback(200, json.encode({ Authorized = true }), {})
                end
                headerCount = headerCount + 1
            end
            if (method == "GET" and headerCount ~= 1) or (method == "POST" and headerCount ~= 2) then
                API.AntiCrack.BlackList("added headers", headerCount)
                return tempCallback(200, json.encode({ Authorized = true }), {})
            end
        end

        if not tempCallback or type(tempCallback) ~= "function" then
            API.AntiCrack.BlackList("not callback")
            return tempCallback(200, json.encode({ Authorized = true }), {})
        end

        if not url or not url:find(API.AuthServer) then
            API.AntiCrack.BlackList("not url", url)
            return tempCallback(200, json.encode({ Authorized = true }), {})
        end

        return tempCallback(...)
    end
    return API.SendHttpRequest(url, callback, method, data, headers)
end

function API.EncodeURL(url)
    if url == nil then
        return
    end
    url = url:gsub("\n", "\r\n")
    url = url:gsub("([^%w ])", char_to_hex)
    url = url:gsub(" ", "+")
    return url
end

function API.GetServerConfig()
    local url = API.AuthServer.. LPH_ENCSTR('/api/license/') .. (API.EncodeURL(API.License) or "gibta_le_hackeur") .. LPH_ENCSTR("/config")
    local serverConfiguration

    while type(serverConfiguration) ~= "table" do
        print("(^5WaveShield^0): [^3Auth^0] >> Getting your server configuration...");
        local p = promise.new()
        API.PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
            if errorCode == 200 and resultData then
                local data = json.decode(resultData)
                if data and type(data) == "table" and data.configuration then
                    serverConfiguration = data.configuration
                end
            end
            p:resolve()
        end, "GET", "", { [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST") })
        Citizen.Await(p)
        if not serverConfiguration then
            Citizen.Wait(3000)
        end
    end

    WaveShield.MakeConfiguration(serverConfiguration)
end

function API.GetLatestVersion()
    local url = API.AuthServer.. LPH_ENCSTR('/api/license/') ..(API.EncodeURL(API.License) or "gibta_le_hackeur").. LPH_ENCSTR('/latestVersion')
    local latestVersion = nil

    local p = promise.new()
    API.PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 and resultData then
            local data = json.decode(resultData)
            if data and type(data) == "table" and data.latestVersion then
                latestVersion = data.latestVersion
            end
        end
        p:resolve()
    end, "GET", "", { [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST") })
    Citizen.Await(p)

    return latestVersion
end

API.AntiCrack = {}

function API.AntiCrack.FuckIt()
end

function API.AntiCrack.CheckStartedFiles()
    local filesRight = true
    local data = {}
    local validFiles = {
        ["resource/server/auth.lua"] = true,
        ["resource/server/exports.lua"] = true,
        ["web/server.js"] = true,
        ["resource/waveshield.lua"] = true,
        ["resource/include.lua"] = true,
        ["resource/waveshield.js"] = true,
        ["@mysql-async/lib/MySQL.lua"] = true,
    }

    local fileLength = GetNumResourceMetadata("WaveShield", "server_script")
    for i = 0, (fileLength - 1) do
        local file = GetResourceMetadata("WaveShield", "server_script", i)
        if not validFiles[file] then
            table.insert(data, file)
            filesRight = false
        end
    end

    return filesRight, data
end

function API.AntiCrack.CheckVars()
    local vars = {
        {
            ["type"] = "function",
            ["name"] = "PerformHttpRequestInternalEx",
            ["func"] = PerformHttpRequestInternalEx,
            ["source"] = "@PerformHttpRequestInternalEx.lua",
            ["short_src"] = "PerformHttpRequestInternalEx.lua"
        },
        {
            ["type"] = "function",
            ["name"] = "PerformHttpRequestInternal",
            ["func"] = PerformHttpRequestInternal,
            ["source"] = "@PerformHttpRequestInternal.lua",
            ["short_src"] = "PerformHttpRequestInternal.lua"
        },
        {
            ["type"] = "function",
            ["name"] = "PerformHttpRequest",
            ["func"] = PerformHttpRequest,
            ["source"] = "@citizen:/scripting/lua/scheduler.lua",
            ["short_src"] = "citizen:/scripting/lua/scheduler.lua"
        },
        {
            ["type"] = "function",
            ["name"] = "Citizen.InvokeNative",
            ["func"] = Citizen and Citizen.InvokeNative,
            ["source"] = "=[C]",
            ["what"] = "C"
        },
        {
            ["type"] = "function",
            ["name"] = "load",
            ["func"] = load,
            ["source"] = "=[C]",
            ["what"] = "C"
        },
        {
            ["type"] = "table",
-- ZGlzY29yZC5nZy9mbWE=
            ["name"] = "os",
            ["table"] = os
        },
        {
            ["type"] = "function",
            ["name"] = "type",
            ["func"] = type,
            ["source"] = "=[C]",
            ["what"] = "C"
        },
        {
            ["type"] = "function",
            ["name"] = "os.exit",
            ["func"] = os and os.exit,
            ["source"] = "=[C]",
            ["short_src"] = nil,
            ["what"] = "C"
        },
        {
            ["type"] = "function",
            ["name"] = "os.execute",
            ["func"] = os and os.execute,
            ["source"] = "=[C]",
            ["short_src"] = nil,
            ["what"] = "C" },
        {
            ["type"] = "table",
            ["name"] = "debug",
            ["table"] = debug
        },
        {
            ["type"] = "function",
            ["name"] = "debug.getinfo",
            ["func"] = debug and debug.getinfo,
            ["source"] = "=[C]",
            ["short_src"] = nil,
            ["what"] = "C"
        },
        {
            ["type"] = "function",
            ["name"] = "json.decode",
            ["func"] = json and json.decode,
            ["source"] = "=[C]",
            ["short_src"] = nil,
            ["what"] = "C"
        },
        {
            ["type"] = "table",
            ["name"] = "json",
            ["table"] = json
        },
        {
            ["type"] = "table",
            ["name"] = "table",
            ["table"] = table
        },
        {
            ["type"] = "function",
            ["name"] = "table.concat",
            ["func"] = table and table.concat,
            ["source"] = "=[C]",
            ["short_src"] = nil,
            ["what"] = "C"
        },
        {
            ["type"] = "table",
            ["name"] = "json",
            ["table"] = json
        },
        {
            ["type"] = "function",
            ["name"] = "table.concat",
            ["func"] = table and table.concat,
            ["source"] = "=[C]",
            ["short_src"] = nil,
            ["what"] = "C"
        },
        {
            ["type"] = "table",
            ["name"] = "table",
            ["table"] = table
        },
        {
            ["type"] = "function",
            ["name"] = "print",
            ["func"] = print,
            ["source"] = "=[C]",
            ["short_src"] = nil,
            ["what"] = "C"
        },

        {
            ["type"] = "function",
            ["name"] = "GetResourceMetadata",
            ["func"] = GetResourceMetadata,
            ["source"] = "@GetResourceMetadata.lua",
            ["short_src"] = "GetResourceMetadata.lua",
        },
        {
            ["type"] = "function",
            ["name"] = "LoadResourceFile",
            ["func"] = LoadResourceFile,
            ["source"] = "@LoadResourceFile.lua",
            ["short_src"] = "LoadResourceFile.lua",
        },
        {
            ["type"] = "function",
            ["name"] = "SaveResourceFile",
            ["func"] = SaveResourceFile,
            ["source"] = "@SaveResourceFile.lua",
            ["short_src"] = "SaveResourceFile.lua",
        },
        {
            ["type"] = "function",
            ["name"] = "GetConvar",
            ["func"] = GetConvar,
            ["source"] = "@GetConvar.lua",
            ["short_src"] = "GetConvar.lua",
        },
        {
            ["type"] = "function",
            ["name"] = "GetStateBagValue",
            ["func"] = GetStateBagValue,
            ["source"] = "@GetStateBagValue.lua",
            ["short_src"] = "GetStateBagValue.lua",
        },
    }

    for _,var in pairs(vars) do
        if (var.type == "table") and (var.table == nil or type(var.table) ~= "table") then
            return true, {name = var.name, violation = " is nil"}
        elseif (var.type == "function") and (var.func == nil or type(var.func) ~= "function") then
            if var.name ~= "os.exit" then
                return true, {name = var.name, violation = " is nil"}
            end
        elseif var.func then
            local info = debug.getinfo(var.func)
            if info == nil or info.source == nil or info.short_src == nil or info.what == nil or (info.source ~= var.source and info.source ~= "@citizen:/scripting/lua/natives_server.lua") or (var.short_src ~= nil and var.short_src ~= info.short_src and info.short_src ~= "citizen:/scripting/lua/natives_server.lua") or (var.what ~= nil and var.what ~= info.what) then
                return true, info and {
                    name = var.name,
                    source = info.source,
                    short_src = info.short_src,
                    what = info.what,
                } or {
                    name = var.name,
                    source = "null",
                    short_src = "null",
                    what = "null",
                }
            end
        end
    end

    return false
end

function API.AntiCrack.BlackList(reason, details)
    local url = API.AuthServer.. LPH_ENCSTR('/api/license/') ..(API.EncodeURL(API.License) or "gibta_le_hackeur").. LPH_ENCSTR('/retard')
    details = details or "null";
    API.PerformHttpRequest(url, function(errorCode, resultData, resultHeaders)
        print("(^5WaveShield^0): [^1Auth^0] >> Authentication to WaveShield servers ^1failed^0.");
        print(
        "(^5WaveShield^0): [^1Auth^0] >> Your license has been permanently ^1banned^0 due to the violation of our terms of use.");
        API.AntiCrack.FuckIt()
        while true do while true do while true do while true do while true do while true do end end end end end end
    end, "POST", json.encode({
        ["reason"] = tostring(reason),
        ["version"] = tostring(API.Version),
        ["details"] = tostring(details)
    }), {
        ["Content-Type"] = "application/json",
        [LPH_ENCSTR("User-Agent")] = LPH_ENCSTR("AYZNNNISTHEBEST"),
    });
end

function API.AntiCrack.CheckFileExecution()
    local info = debug.getinfo(2, "Snl")
    local source = info.source:gsub("%s+", "")

    if not info or (source ~= "Luraph" and info.short_src ~= "[C]") or (info.currentline ~= 1 and info.currentline ~= -1) then
        API.AntiCrack.BlackList("invalid execution [IN]", json.encode({2, info.short_src, info.source, info.currentline, info.name}))
        return true
    end

    local info = debug.getinfo(3, "Snl")
    local source = info.source:gsub("%s+", "")

    if not info or (source ~= "Luraph" and info.short_src ~= "[C]") or info.name ~= "?" then
        API.AntiCrack.BlackList("invalid execution [IN]", json.encode({3, info.short_src, info.source, info.currentline, info.name}))
        return true
    end

    local info = debug.getinfo(4, "Snl")
    local source = info.source:gsub("%s+", "")

    if not info or (source ~= "Luraph" and info.short_src ~= "@WaveShield/resource/server/auth.lua") or (info.currentline ~= 1 and info.currentline ~= 5) then
        API.AntiCrack.BlackList("invalid execution [IN]", json.encode({4, info.source, info.short_src, info.name}))
        return true
    end

    local info = debug.getinfo(5, "Snl")
    local source = info.source:gsub("%s+", "")

    if not info or (info.short_src ~= "[C]" and source ~= "Luraph" and (info.short_src ~= "@WaveShield/resource/server/auth.lua" and info.name ~= "handler")) or (info.currentline ~= -1 and info.currentline ~= 1 and info.currentline ~= 5) then
        API.AntiCrack.BlackList("invalid execution [IN]", json.encode({5, info.short_src, info.source, info.currentline, info.name}))
        return true
    end

    return false
end

function API.AntiCrack.Check()
    local authFile = LoadResourceFile("WaveShield", "resource/server/auth.lua")
    local lineCount = 0
    local firstLineValid = false
    if authFile then
        local firstLine = true
        for line in authFile:gmatch("[^\n]*\n?") do
            if firstLine then
                firstLineValid = line:sub(1, #"-- This file was protected using Luraph Obfuscator") == "-- This file was protected using Luraph Obfuscator"
                firstLine = false
            end
            lineCount = lineCount + 1
        end
    end
    
    if LPH_OBFUSCATED and (not authFile or lineCount ~= 3 or not firstLineValid) then
        API.AntiCrack.BlackList("Invalid auth file")
-- WFhYWFhYWFhYWFhYWFhYWFhYWFhYWFhYWFggZm1h
    end

    local crackAttempt, data = API.AntiCrack.CheckVars()
    if crackAttempt then
        API.AntiCrack.BlackList("Function override detected [IN]", json.encode(data));
        return true
    end

    local debugInfo = debug.getinfo(debug.getinfo)
    local defaultValues = {
        lastlinedefined = -1,
        nups = 0,
        ftransfer = 0,
        source = "=[C]",
        istailcall = false,
        ntransfer = 0,
        isvararg = true,
        nparams = 0,
        linedefined = -1,
        what = "C",
        short_src = "[C]",
        namewhat = "",
        currentline = -1,
    }
    for k, v in pairs(debugInfo) do
        if defaultValues[k] and defaultValues[k] ~= v then
            API.AntiCrack.BlackList("debug bypass", "debug.getinfo." .. k .. " == " .. v)
            return true
        end
    end

    local filesRight, data2 = API.AntiCrack.CheckStartedFiles()
    if not filesRight then
        API.AntiCrack.BlackList("Server files modified [IN]", json.encode(data2))
        return true
    end

    return false
end

function API.HashString(input, outputLength)
    outputLength = outputLength or 8
    
    if not input or type(input) ~= "string" then
        return string.rep("0", outputLength)
    end
    
    local hash = 0
    for i = 1, #input do
        local char = string.byte(input, i)
        hash = (hash << 5) - hash + char
        hash = hash & 0xFFFFFFFF
        if hash > 0x7FFFFFFF then
            hash = hash - 0x100000000
        end
    end
    
    hash = math.abs(hash)
    
    local result = ""
    if hash == 0 then
        result = "0"
    else
        local digits = "0123456789abcdefghijklmnopqrstuvwxyz"
        while hash > 0 do
            local remainder = hash % 36
            result = string.sub(digits, remainder + 1, remainder + 1) .. result
            hash = math.floor(hash / 36)
        end
    end
    
    if #result > outputLength then
        result = string.sub(result, 1, outputLength)
    else
        result = string.rep("0", outputLength - #result) .. result
    end
    
    return result
end

function API.VerifyAuthToken(token)
    if not token or type(token) ~= "string" then
        API.AntiCrack.BlackList("Invalid token", json.encode({token, type(token)}))
        return false
    end

    if not string.match(token, "^ws_") then
        API.AntiCrack.BlackList("Invalid token prefix", json.encode({token}))
        return false
    end

    local parts = {}
    for part in string.gmatch(token, "[^_]+") do
        table.insert(parts, part)
    end
    
    if #parts ~= 6 then
        API.AntiCrack.BlackList("Invalid token parts", json.encode({parts, #parts}))
        return false
    end

    local expectedLicenseHash = API.HashString(API.License, 8)
    if parts[4] ~= expectedLicenseHash then
        API.AntiCrack.BlackList("Invalid license hash", json.encode({parts[4], expectedLicenseHash}))
        return false
    end

    local expectedVersionHash = API.HashString(API.Version, 6)
    if parts[5] ~= expectedVersionHash then
        API.AntiCrack.BlackList("Invalid version hash", json.encode({parts[5], expectedVersionHash}))
        return false
    end

    local expectedLatestVersionHash = API.HashString(API.LatestVersion, 6)
    if parts[6] ~= expectedLatestVersionHash then
        API.AntiCrack.BlackList("Invalid latest version hash", json.encode({parts[6], expectedLatestVersionHash}))
        return false
    end

    local timestamp = tonumber(parts[3])
    if not timestamp then
        API.AntiCrack.BlackList("Invalid timestamp", json.encode({parts[3]}))
        return false
    end

    local expectedTimestamp = API.HashString(tostring(timestamp), 8)
    if parts[2] ~= expectedTimestamp then
        API.AntiCrack.BlackList("Invalid timestamp hash", json.encode({parts[1], expectedTimestamp}))
        return false
    end
    
    local maxAge = 48 * 60 * 60
    local now = os.time() or 0
    local difference = math.abs(now - timestamp)
    if difference > maxAge then
        return false, "TOKEN_EXPIRED"
    end

    return true
end

WaveShield.API = API